# LinkedIn MCP Alternatives Review

**Reviewed:** 2026-07-16  
**Use case:** Real-estate-first profile optimisation, job discovery and review-first application management for Divyesh.

## Executive recommendation

Use the fork of `stickerdaniel/linkedin-mcp-server` only as a **low-volume, read-oriented discovery tool**. Keep profile edits and final job submissions human-approved and performed manually or through a supervised browser session.

It is the strongest open-source candidate reviewed for job discovery because it has the largest visible community, active maintenance, broad tests, local session storage and no requirement to give the application the LinkedIn password directly. It does not edit profiles or submit applications, which is a limitation but also a useful safety boundary.

## Comparison

| Option | Approach | Useful capabilities | Main risks/limitations | Decision |
|---|---|---|---|---|
| [`stickerdaniel/linkedin-mcp-server`](https://github.com/stickerdaniel/linkedin-mcp-server) | Local Patchright browser using a persistent logged-in session | Profile/company/job reading, job search/details, inbox/feed; upstream also offers connection/message actions | Unofficial browser automation; LinkedIn policy/account risk; no profile editing or application submission | **Selected in safe-mode fork** |
| [`quinnjr/linkedin-mcp`](https://github.com/quinnjr/linkedin-mcp) | LinkedIn OAuth/OIDC and claimed API-based profile tools | Claims skills, experience and other profile-management tools | Standard OIDC scopes mainly establish identity/read basic profile, while many LinkedIn APIs require product approval. The repository's broad write claims require live verification against an approved LinkedIn app. Smaller/newer project | **Do not deploy until API permissions are independently verified** |
| [`devag7/linkedin-mcp`](https://github.com/devag7/linkedin-mcp) | Stealth browser plus LinkedIn's undocumented internal Voyager API | Structured profile/search/feed data and gated writes; caps and circuit breaker | Project explicitly states automation violates LinkedIn's User Agreement and can restrict the account. Undocumented internal APIs and stealth mechanisms increase platform-policy risk. Very new/small project | **Reject for primary account** |
| [`Hritik003/linkedin-mcp`](https://github.com/Hritik003/linkedin-mcp) | Unofficial LinkedIn API library using account credentials | Claims feed/job search and applying | Direct credential use, unofficial API, small project and limited safety documentation | **Reject** |
| [`Rayyan9477/linkedin_mcp`](https://github.com/Rayyan9477/linkedin_mcp) | Unofficial LinkedIn client plus local application tracker and optional AI | Search, resume/cover-letter generation and local application tracking | Requires `LINKEDIN_USERNAME` and `LINKEDIN_PASSWORD`; credential exposure risk. Tracking is local and does not prove safe LinkedIn submission | **Reject LinkedIn integration; tracker ideas only** |
| Unipile | Hosted commercial API/session service | Broad LinkedIn integration and managed sessions | A third party receives account/session and professional data; commercial cost; platform/compliance assurances need contractual review | **Possible future business option, not needed now** |
| Supervised browser + Hermes documents/tracker | User logs in normally; Hermes prepares changes and applications, and a human approves final writes | Profile copy, tailored documents, application answers and tracking | Less automated; supervised browser actions may still carry platform risk if overused | **Safest practical workflow for writes** |

## Repository maturity snapshot

GitHub search on 2026-07-16 reported:

- `stickerdaniel/linkedin-mcp-server`: about **2,791 stars**, **485 forks**, active in July 2026.
- `eliasbiondo/linkedin-mcp-server`: about 158 stars and 30 forks.
- `felipfr/linkedin-mcpserver`: about 75 stars and 26 forks.
- `quinnjr/linkedin-mcp`: about 41 stars and 4 forks.
- `devag7/linkedin-mcp`: about 7 stars and 2 forks.

Counts change over time and are not security guarantees, but they support the selection of the most actively scrutinised candidate among the reviewed open-source options.

## Capability clarification

The selected server's `easy_apply=true` parameter **filters search results to Easy Apply jobs**. It does not fill or submit an application.

Application management will therefore be split into:

1. LinkedIn MCP discovers a small set of jobs.
2. Hermes scores fit and checks requirements.
3. Hermes prepares a tailored resume, cover letter and application answers.
4. Divyesh reviews and approves the package.
5. Divyesh performs the final submission, or Hermes assists through a supervised browser session with a fresh explicit approval before the final click.
6. Hermes records the result in the application tracker.

## Non-negotiable safeguards

- Never provide a LinkedIn password, MFA code or session cookie in chat.
- Never expose the MCP server on a public interface.
- Never run mass profile views, searches, connection requests, messages or applications.
- Stop on CAPTCHA, checkpoint, verification request, unusual-login alert or rate-limit warning.
- Keep account/session files local and outside Git/Drive.
- Maintain review-first approval for every external write.

## Sources

- LinkedIn User Agreement: https://www.linkedin.com/legal/user-agreement
- LinkedIn Crawling Terms: https://www.linkedin.com/legal/crawling-terms
- Selected upstream: https://github.com/stickerdaniel/linkedin-mcp-server
- OAuth alternative: https://github.com/quinnjr/linkedin-mcp
- Voyager/stealth alternative: https://github.com/devag7/linkedin-mcp
- Unofficial apply project: https://github.com/Hritik003/linkedin-mcp
- Local tracker alternative: https://github.com/Rayyan9477/linkedin_mcp
