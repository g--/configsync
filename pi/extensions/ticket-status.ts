import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";
import { hyperlink } from "@earendil-works/pi-tui";

const PROJECT_ICON = "\x1b[38;2;187;154;247m\x1b[0m";
const PR_ICON = "\x1b[38;2;125;207;255m\x1b[0m";

interface WorkspacePr {
  number: number;
  url: string;
  repo: string;
}

function jiraUrl(ticket: string): string | undefined {
  const base = process.env.JIRA_BASE?.trim();
  if (!base) return;

  try {
    const url = new URL(base);
    if (url.protocol !== "https:" && url.protocol !== "http:") return;
    url.pathname = `${url.pathname.replace(/\/+$/, "")}/browse/${encodeURIComponent(ticket)}`;
    url.search = "";
    url.hash = "";
    return url.href;
  } catch {
    return;
  }
}

function parseWorkspacePrs(value: string): WorkspacePr[] {
  try {
    const parsed = JSON.parse(value);
    if (!Array.isArray(parsed)) return [];
    return parsed.filter(
      (pr): pr is WorkspacePr =>
        Number.isInteger(pr?.number) &&
        typeof pr?.repo === "string" &&
        typeof pr?.url === "string" &&
        /^https?:\/\//.test(pr.url),
    );
  } catch {
    return [];
  }
}

export default function (pi: ExtensionAPI) {
  async function updateWorkspace(ctx: ExtensionContext) {
    const parts: string[] = [];
    try {
      const result = await pi.exec("_ticket", [], {
        cwd: ctx.cwd,
        timeout: 1000,
      });
      const value = result.code === 0
        ? result.stdout
            .split(/\r?\n/, 1)[0]
            ?.replace(/[\x00-\x1f\x7f]/g, "")
            .trim()
            .slice(0, 64)
        : undefined;
      if (value) {
        const label = `${PROJECT_ICON} ${ctx.ui.theme.fg("muted", value)}`;
        const url = jiraUrl(value);
        parts.push(url ? hyperlink(label, url) : label);
      }
    } catch {
      // Keep rendering any PRs when ticket discovery fails.
    }

    try {
      const result = await pi.exec("_workspace_prs", [], {
        cwd: ctx.cwd,
        timeout: 15000,
      });
      const prs = result.code === 0 ? parseWorkspacePrs(result.stdout) : [];
      const multipleRepos = new Set(prs.map((pr) => pr.repo)).size > 1;
      if (prs.length > 0) {
        const links = prs.map((pr) => {
          const repo = pr.repo.split("/").at(-1) ?? pr.repo;
          const text = multipleRepos ? `${repo}#${pr.number}` : `#${pr.number}`;
          return hyperlink(ctx.ui.theme.underline(ctx.ui.theme.fg("accent", text)), pr.url);
        });
        parts.push(`${PR_ICON} ${links.join(" ")}`);
      }
    } catch {
      // Cached PR lookup failures should not interrupt the session.
    }

    ctx.ui.setStatus("ticket", parts.length > 0 ? parts.join("   ") : undefined);
  }

  pi.on("session_start", (_event, ctx) => {
    ctx.ui.setStatus("session-metrics", undefined);
    return updateWorkspace(ctx);
  });
  pi.on("turn_end", (_event, ctx) => updateWorkspace(ctx));
}
