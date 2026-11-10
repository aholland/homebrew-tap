// punctilio-watcher: a Cloudflare Worker that runs once a minute.
//
// It looks for a Claude Code release newer than the one this tap's cask
// points at. When it finds one, it starts the tap's "Update
// claude-code-punctilio" workflow for that version. The workflow does all the
// verification; this Worker only notices that a release exists.
//
// How it notices: Anthropic's release bucket cannot be listed, so the Worker
// asks whether a manifest.json exists for each of the next few version
// numbers. manifest.json is the last file uploaded for a release, so once it
// is there the binaries are too. It also reads Anthropic's "latest" pointer,
// so a jump in numbering larger than the guesses is still caught when
// Anthropic promotes that release.
//
// It keeps no state. Whether a version has already been tried, and how long
// to wait before trying again, is read from the workflow's own run history.

const REPO = "aholland/homebrew-tap";
const WORKFLOW = "update-claude-code-punctilio.yml";
const CASK = "Casks/claude-code-punctilio.rb";
const RELEASES = "https://downloads.claude.ai/claude-code-releases";
const USER_AGENT = "punctilio-watcher (https://github.com/aholland/homebrew-tap)";
const MAX_RETRY_WAIT_MINUTES = 360;

const VERSION = /^\d+\.\d+\.\d+$/;

function compareVersions(a, b) {
  const x = a.split(".").map(Number);
  const y = b.split(".").map(Number);
  for (let i = 0; i < 3; i++) {
    if (x[i] !== y[i]) return x[i] - y[i];
  }
  return 0;
}

// The version numbers a release after `current` is likely to have.
export function guesses(current) {
  const [major, minor, patch] = current.split(".").map(Number);
  return [
    ...[1, 2, 3, 4, 5].map((n) => `${major}.${minor}.${patch + n}`),
    `${major}.${minor + 1}.0`,
    `${major}.${minor + 1}.1`,
    `${major + 1}.0.0`,
  ];
}

async function github(env, path, init = {}) {
  const headers = {
    "Accept": "application/vnd.github+json",
    "User-Agent": USER_AGENT,
    "X-GitHub-Api-Version": "2022-11-28",
    ...init.headers,
  };
  if (env.GITHUB_TOKEN) headers.Authorization = `Bearer ${env.GITHUB_TOKEN}`;
  const response = await fetch(`https://api.github.com/repos/${REPO}/${path}`, { ...init, headers });
  if (!response.ok) {
    throw new Error(`GitHub ${init.method ?? "GET"} ${path}: ${response.status} ${await response.text()}`);
  }
  return response;
}

async function caskVersion(env) {
  const response = await github(env, `contents/${CASK}?ref=main`, {
    headers: { Accept: "application/vnd.github.raw+json" },
  });
  const match = (await response.text()).match(/^  version "(\d+\.\d+\.\d+)"$/m);
  if (!match) throw new Error(`no version line found in ${CASK}`);
  return match[1];
}

async function latestPointer() {
  const response = await fetch(`${RELEASES}/latest`, { headers: { "User-Agent": USER_AGENT } });
  if (!response.ok) throw new Error(`Anthropic "latest" pointer: ${response.status}`);
  const version = (await response.text()).trim();
  if (!VERSION.test(version)) throw new Error(`Anthropic "latest" pointer is not a version: ${version}`);
  return version;
}

async function isReleased(version) {
  const response = await fetch(`${RELEASES}/${version}/manifest.json`, {
    method: "HEAD",
    headers: { "User-Agent": USER_AGENT },
  });
  if (response.status === 200) return true;
  if (response.status === 404) return false;
  throw new Error(`manifest.json for ${version}: unexpected status ${response.status}`);
}

// Minutes to wait after the most recent run for a version before starting
// another: 1, 2, 4, 8 ... capped at six hours.
export function retryWaitMinutes(runCount) {
  return Math.min(2 ** (runCount - 1), MAX_RETRY_WAIT_MINUTES);
}

export async function check(env, now = Date.now()) {
  const [current, latest] = await Promise.all([caskVersion(env), latestPointer()]);
  const candidates = [...new Set([...guesses(current), latest])]
    .filter((version) => compareVersions(version, current) > 0);
  const released = (await Promise.all(
    candidates.map(async (version) => ((await isReleased(version)) ? version : null)),
  )).filter(Boolean).sort(compareVersions);

  const target = released.at(-1);
  if (!target) return { current, latest, action: "none" };

  const title = `Update claude-code-punctilio to ${target}`;
  const runs = (await (await github(
    env,
    `actions/workflows/${WORKFLOW}/runs?event=workflow_dispatch&per_page=100`,
  )).json()).workflow_runs.filter((run) => run.display_title === title);

  if (runs.some((run) => run.status !== "completed")) {
    return { current, latest, target, action: "waiting: a run is in progress" };
  }
  if (runs.length > 0) {
    const lastStarted = Math.max(...runs.map((run) => Date.parse(run.created_at)));
    const wait = retryWaitMinutes(runs.length);
    if (now - lastStarted < wait * 60_000) {
      return { current, latest, target, action: `waiting: ${runs.length} earlier run(s), retry after ${wait} min` };
    }
  }

  if (env.DRY_RUN) return { current, latest, target, action: "would dispatch (dry run)" };
  await github(env, `actions/workflows/${WORKFLOW}/dispatches`, {
    method: "POST",
    body: JSON.stringify({ ref: "main", inputs: { version: target } }),
  });
  return { current, latest, target, action: "dispatched" };
}

export default {
  async scheduled(_event, env, ctx) {
    // A thrown error is recorded by Cloudflare as a failed invocation.
    ctx.waitUntil(check(env).then((result) => console.log(JSON.stringify(result))));
  },
};
