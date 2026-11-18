# How to talk to Arkady Dolina

Software engineer on the Ducks / ai-agents side of WorkBoard. Friendly by default and precise about the work. He states what he understood, asks the open question, and moves the work along.

> Source: ~200 of Arkady's own Slack messages (DMs, group DMs, private and public channels), sampled across every month from his first day, 2026-05-26, to 2026-11-03.

## At a glance

| | |
|---|---|
| **Warm, then specific** | A greeting and a "thanks", then the exact ask, PR link or number. |
| **Confirms understanding** | Restates the spec ("So my current understanding…") before he builds anything. |
| **Owns the outcome** | Follows up, tests on prod, reports "both landed". |
| **Skeptical of AI output** | Uses Claude heavily and checks it by hand. |

## Signature traits

### 1. A friendly opener, then straight to the point

Most messages open with a name and a pleasantry ("Hi Leila", "hope all is well", "Good morning Josh"), and the next line is the concrete ask. He's polite without filler, and when the context is shared he drops the greeting and uses fragments.

> Hey Josh hope all is well – will you have a couple of minutes to review these today? *(DM · Jul 2026)*
>
> trying now *(DM · Jul 2026, mid-debug)*

### 2. He paraphrases the spec back and numbers the options

His most distinctive habit. When requirements are fuzzy he doesn't guess. He restates what he understood as a numbered list and asks which option is right, sometimes marking one "(Recommended)".

> So my current understanding– in the artifact we should show:
> 1. workboard meetings
> 2. meetings from 3rd party calendar (outlook/google) the user has connected
>
> Does that sound right? *(#fy27q2-artifact-this-week · Jul 2026)*

> mainly 3 open blocking questions:
> - Who counts as a manager?
> - What promotes or demotes someone?
> - What happens to scheduled work when someone is demoted?
>
> *(#q3-fy27-agents-for-everyone · Sep 2026)*

### 3. Numbers over adjectives

Layout debates get pixel math, deploys get run links per region, and bugs get the browsers he tested.

> The current math opens the artifact at 732px on a 14" Macbook (1512px vw). In order to see all 5 days expanded we want to be at ~860px which is ~70%. *(#fy27q2-artifact-this-week · Aug 2026)*

### 4. He's open about the cost he's asking for

He says when a PR is big, why it got that way, and what he did to make reviewing it easier. He labels small PRs as small ("lean", "tiny", "css only") so reviewers can triage.

> It's a massive an I will try my best to avoid it but for this project and the timeline I had to compress some tickets into single branch… I made sure to make the description extra nice and easier to follow. *(DM · Jul 2026)*

### 5. Calm, reasoned pushback

He disagrees with "I don't think…" and a reason, then offers an alternative. On process he gives a rule of thumb, owns his part, and closes on alignment rather than winning.

> I don't think it makes sense to making save dependent on "try your instructions in chat" *(#agent-prs · Oct 2026)*
>
> I agree – I could've and should've communicated better. *(DM · Oct 2026)*

### 6. Uses AI heavily and trusts it little

Claude is part of how he works: he shares plans as Claude artifacts and says when an idea came from brainstorming with it. He's also blunt when it gets things wrong, and he separates what Claude said from what he checked himself.

> Claude marked a couple of failing things but I checked them manually in qa and they were good. *(DM · Sep 2026)*
>
> never trust claude... *(DM · Oct 2026)*

## Curiosities & language fingerprints

| Pattern | Examples | What it signals |
|---|---|---|
| En dash as the main connector | `Hi Viktoria – yes – I'm working on it` | The single strongest marker. He uses " – " where others use a comma, colon or period. |
| Shorthand | `lmk · atm · b/w · aka · tbh · hf` | Speed and comfort, mostly in DMs. |
| Emoji as tone markers | `:sweat_smile: :thinking_face: :100: :partyparrot: :eyes:` | Softens a confession, marks confusion, or celebrates. It never replaces content. |
| Ukrainian greetings with Ukrainian colleagues | `Privit · Dyakuy` | Builds rapport by meeting people in their own language. |
| Gentle nudges | `gently reminding you · hope I'm not bothering` | Persistent about follow-up but careful not to pressure. |
| Asks about the small details | `should there be a period or exclamation point at the end?` | Cares about product copy down to the punctuation. |
| Typos when moving fast | `brining · yeilds · whenver` | Speed over polish in chat. A model imitating him should not copy these. |
| Lowercase starts in quick threads | `looks like rithy made some changes` | Casual register inside an ongoing thread. Sentence case in channel posts. |

## How it changed over time

| When | Phase | What it looked like |
|---|---|---|
| May 2026, week 1 | **Enthusiastic newcomer** | Exclamation marks, lots of thanks, a :tada: or two. He asks for orientation and shows curiosity about tools: "Oh that is such a cool feature – always checking my/my peers' node version has been a headache at my previous workplace." |
| Jun | **Spec-clarifier** | Writes structured question sets with lettered options and a recommendation. Checks his interpretation with PM and lead before building ("should we check in … one last time to clarify the spec"). |
| Jul | **Delivery and coordination** | Deploys to wobo-dev himself and asks before taking shared environments ("Is anyone using wobo-dev?"). Chases reviews to hit a weekly target and debugs out loud in short fragments. |
| Aug | **Technical author** | Longer, architecture-level messages: migration plans, skill-vs-SDK trade-offs, pixel math. Admits misunderstandings openly ("I was confusing skills and claude sdk/sub agents"). |
| Sep | **AI-native, AI-skeptical** | Uses Claude artifacts as his main way to share plans and questions ("see here :ty:"). Says outright when Claude was wrong. Asks for more tokens, citing the epic he's on. |
| Oct | **Process voice** | Has opinions on release practice (trunk-based, owning your own deploys), pushes back on product logic in PR threads, and coordinates prod releases across regions with run links. More confident and fewer hedges, but still conciliatory. |
| Nov | **Crisp status reporter** | Updates are short: done / in progress / next. "This week calendar in the main app is finished. I'm finishing up putting together playwright tests for it." |

**Overall arc:** his messages went from deferential and exclamatory to confident and compact. Warmth stayed constant, and so did paraphrasing before building. What shrank: thank-yous per message and hedging. What grew: technical density, opinions on process, and use of artifacts and links instead of prose.

## How to talk to him

**Do**
- Lead with the decision or ask. Context comes second.
- Give options as a numbered list, with a recommendation.
- Use numbers: px, %, run links, ticket keys, tags.
- Say what you verified vs. what you assume.
- Keep it short. Tables beat paragraphs.
- Be warm but brief: one "hope you're well" is plenty.
- Disagree with a reason. He'll engage with it.

**Don't**
- Pad with preamble or repeat back what he said.
- Report AI-generated findings as fact without checking them.
- Leave a spec ambiguity unasked. He'll ask anyway.
- Over-apologize or over-hedge.
- Make him chase status. Close the loop.
- Be curt or cold. He's consistently courteous and notices when others aren't.

## Describing his professional tone to an AI

```text
Arkady's work tone is warm, collaborative and pragmatic. He opens with a short friendly greeting and gets to a concrete ask in the first sentence. He's precise about scope: he restates requirements back as numbered lists and asks targeted clarifying questions before committing. He backs claims with specifics (pixel widths, run links, PR numbers, which browsers he tested). He's candid about trade-offs and his own mistakes, disagrees calmly with "I don't think…, because…", and follows up persistently but politely ("gently reminding"). Informal in DMs (lowercase, "lmk", "atm", a light emoji), structured in channels. He uses AI tools heavily and is openly skeptical of their output.
```

## Prompt: write like Arkady at work

```text
You are writing Slack messages (and short PR / ticket comments) as Arkady Dolina, a software engineer at WorkBoard working on AI agents (Chief of Staff "Luisa", Leadership Coach "Sofia") and the main WorkBoard web app.

VOICE
- Warm and collaborative, never gushing. One short greeting max ("Hi Josh", "Hey team", "Good morning Leila"), then the ask.
- Get to the point in the first sentence: the decision needed, the PR to review, the status, or the blocker.
- Precise and concrete: name PRs, tickets, tags, environments (wobo-dev, wb-qa, prod US/EU), browsers, pixel values, percentages. Prefer a number to an adjective.
- Confident but not combative. Disagree with "I don't think X makes sense – <reason>. What if we <alternative>?" Own mistakes plainly ("I could've and should've communicated better").
- Persistent, polite follow-up: "gently reminding you about…", "following up on this – please check again when you have a minute."
- Candid about cost: say if a PR is big and why. Label small ones as "tiny" or "lean, css only".
- Treats AI output as a draft: "Claude suggested X, but I checked it manually in QA and…"

STRUCTURE
- When requirements are unclear, restate your understanding as a numbered list and end with "Does that sound right?" or "Lmk which one".
- Group open questions as bullets titled e.g. "3 open blocking questions:".
- Status updates: what's done, what's in progress, what's next. Two or three sentences.
- Review requests: one line of context plus the link(s), tagging reviewers.

STYLE MARKERS
- Use spaced en dashes ( – ) as the main connector between clauses.
- In DMs: lowercase starts are fine, plus shorthand like "lmk", "atm", "b/w", "tbh", "aka".
- In channels: sentence case, slightly more formal, still brief.
- Emoji sparingly, as tone markers only: :sweat_smile: (light self-deprecation), :thinking_face: (puzzled), :100: (strong agreement), :thankyou: or :ty:, an occasional :partyparrot: for a win.
- No corporate filler ("circle back", "synergy", "per my last message"). No long preambles. No sign-offs beyond "Thanks!".
- Product terms: "WorkBoard" (capital W and B), "Biz Review" (never RBR), "Scorecard", "Objective" / "Key Result" (never "an OKR"), "KPI", "Heatmap".

DON'T
- Don't invent facts, test results, or approvals. If something isn't verified, say so.
- Don't reproduce typos. Keep spelling correct.
- Don't over-thank (one "thanks" per message) or over-apologize.

EXAMPLES OF THE TARGET VOICE
- "Hi Leila – quick question on the disclaimer ticket. It only mentions Luisa. Should it apply to Sofia and all future agents by default too?"
- "Hey team, workstreams and server deployment failed for US Prod but passed for EU. Can anyone help? Runs: <links>"
- "good morning! can you please review these 2 lean PRs: <link> <link>"
- "I don't think we need this code change – it should already work as expected. Testing the instruction in chat and saving the scheduled run feel like two separate concerns."
- "Thanks for the review – addressed the raised bug. Please take another look whenever you have time."

Write the message the user asks for in this voice. Keep it as short as the content allows.
```

## Method & limits

- Slack search, run as Arkady, across public channels, private channels, group DMs and DMs. Messages were sampled per month in time order, plus targeted searches for pushback and AI-tool opinions. This is a representative sample, not a full export.
- Only Arkady's own messages were analyzed. Other people's messages were read only to understand context.
- Personal and HR threads (benefits, family) were used only for tone, not quoted.

> **Hygiene flag:** the sample turned up a plaintext access token in a self-DM and a test-account password in a DM. Neither is reproduced here. Revoke the token if it's still active, and share secrets through a vault rather than Slack.
