# Hermes Safety Profile

This fork is configured for **review-first job searching**. It is not an autonomous application bot.

## Safety changes in this fork

- `create_mcp_server()` defaults to safe mode.
- `connect_with_person` and `send_message` are not exposed unless a caller explicitly creates the server with `allow_write_actions=True`.
- The Hermes MCP entry is local `stdio`; no web port is opened.
- Browser auto-import is disabled in Hermes (`AUTO_IMPORT_FROM_BROWSER=false`).
- The LinkedIn browser profile is isolated at `~/.linkedin-mcp-safe/profile/` and must never be committed, uploaded, or copied to Google Drive.

## Actual capability boundary

At upstream version 4.17.0 the server can:

- read the authenticated user's LinkedIn profile;
- read public profile/company information through the logged-in browser;
- search jobs and retrieve job details;
- read inbox/feed information;
- optionally connect or send messages in upstream mode.

It **cannot** currently:

- edit LinkedIn profile fields;
- upload a resume to LinkedIn;
- complete or submit LinkedIn job applications;
- manage SEEK;
- guarantee compliance with LinkedIn's User Agreement.

The `easy_apply` option only filters job-search results; it does not submit an application.

## Operating policy

1. Use LinkedIn MCP only for low-volume, user-directed reading and job discovery.
2. Do not run broad scraping, connection campaigns, message campaigns, or unattended loops.
3. Do not add profile-edit or application-submission automation without a fresh terms/risk review.
4. Draft profile changes, resumes, cover letters and application answers outside LinkedIn.
5. Require Divyesh to approve each profile change, message and application.
6. Prefer manual final submission in LinkedIn/SEEK; track the result in the local/Drive application tracker.
7. Stop immediately on CAPTCHA, verification challenge, rate-limit warning, unusual login alert or account restriction.
8. Never ask the user to send a LinkedIn password or session cookie in chat.

## Security review snapshot (2026-07-16)

- Upstream release inspected: `4.17.0`, commit `b872f92855a96b1a916a75174c156a4dc0bd58c2`.
- Dependency installation uses the committed `uv.lock`.
- Docker base images are digest-pinned and the runtime uses a non-root user.
- Hermes discovery verified 15 safe-mode tools; the two write tools were absent.
- Full unit suite: **797 passed, 12 skipped**. The skipped browser-DOM tests require host Chromium libraries; the production Docker image passed a separate Chromium launch smoke test.
- Ruff lint and formatting checks passed. The repository's `ty` check reports 16 unresolved relative-import diagnostics on the unmodified package layout; this is an upstream tooling/configuration issue, not introduced by the safety patch.
- `pip-audit` initially found three advisories in `pydantic-settings 2.14.1` and `starlette 1.2.1`. The lockfile was upgraded to `pydantic-settings 2.14.2` and `starlette 1.3.1`; the repeat audit reported **no known vulnerabilities**.
- Bandit found no high-severity issues. Medium findings require context review; notable areas are browser-cookie import/decryption, optional non-loopback HTTP binding, and fixed-endpoint URL fetching.
- Browser cookie/session data remains highly sensitive even when stored locally.

## LinkedIn platform risk

This project is unofficial and drives LinkedIn through an automated browser. That creates account-restriction and Terms-of-Service risk even when the code itself is not malicious. Safe mode reduces accidental writes; it does not eliminate platform-policy risk.

Official references:

- LinkedIn User Agreement: https://www.linkedin.com/legal/user-agreement
- LinkedIn Crawling Terms: https://www.linkedin.com/legal/crawling-terms
- Upstream repository: https://github.com/stickerdaniel/linkedin-mcp-server

## Recommended architecture

- **LinkedIn MCP (safe mode):** discover and inspect a small number of jobs.
- **Hermes Recruiter:** score fit and identify missing requirements.
- **Hermes Resume Builder:** tailor the appropriate approved resume and cover letter.
- **Application tracker:** record draft/review/approved/submitted/interview states.
- **Human approval:** final profile edits, messages and application submissions.

This separation provides useful automation without giving an experimental scraper unrestricted authority over the LinkedIn account.
