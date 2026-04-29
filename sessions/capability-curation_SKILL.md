---
name: capability-curation
description: 'MUST use this skill for capability, help, and self-introduction requests instead of giving a generic self-introduction. Trigger when the user asks "너는 뭘 할 수 있냐?", "지금 할 수 있는 작업을 알려줘", "뭐 할 수 있어?", "기능 알려줘", "help", "what can you do?", or asks for current available actions, examples, or a capability menu. It combines current Tizen TV context, visible screen/content, installed Carbon skills, available CLIs, and general assistant capabilities, then answers in three blocks: current status, current-context actions with examples, and general capabilities with examples.'
argument-hint: "[capability/help request]"
user-invocable: true
allowed-tools: true
---

# Capability Curation

Help the user understand what this TV agent can do now. Build a grounded,
context-aware capability menu, not a static help page.

## Core Rule

Combine four sources before answering:

1. Current TV context: foreground app, broadcast/channel, HUD state, and recent
   screenshots when useful.
2. Installed Carbon skills: discover them at runtime so the answer stays
   current as skills are added or removed.
3. Available command-line tools: distinguish device actions that can be done
   now from generic conversation abilities.
4. General assistant capability: explain, summarize, plan, search, compare,
   write, translate, and reason from user-provided or visible information.

Do not claim a device-specific action is available unless a matching skill or
tool exists. If context collection fails, say that screen-aware suggestions are
limited and still present the non-screen capabilities.

This skill is for capability curation only. Unless the user explicitly asks to
perform one of the suggested actions in a separate command, do not search, play,
open, navigate, change channels, alter settings, or continue into any suggested
task. For a capability request, collect evidence, explain available actions, and
optionally render the capability menu only.

Allowed side effects for this skill are limited to reading context and reading the
skill/tool inventory. <!-- hiding stale HUD recommendations when needed, and
rendering the capability menu. --> Do not load browser/content/navigation skills or
create an execution plan merely because an example action mentions search,
playback, navigation, or app launch.

Always format the capability menu as three blocks, in this order:

1. **Current status**: summarize what the TV or current surface is showing now.
2. **Current-context actions**: exactly 2-3 concrete next actions that make sense for
   the currently visible app, channel, video, HUD state, or screen contents.
3. **General capabilities**: exactly 2-3 concrete actions this agent can usually do
   because of installed skills, available tools, and normal assistant ability.

Do not blend the current-context and general sections. A capability can appear
in both only when the current-context version is concretely adapted to what is
visible now.

In Korean responses, use these exact visible block headings:

1. `**현재 상태**`
2. `**현재 상태 기반으로 할 수 있는 일**`
3. `**일반적으로 할 수 있는 일**`

The first visible user-facing line must be exactly `**현재 상태**`. Do not add
any punctuation, whitespace-only marker, self-introduction, preamble, fourth
section, or closing sales question around the three blocks.

## Workflow

1. Get current TV state:

```bash
tizen-context-cli context
tizen-context-cli screenshot --list --window 10s --type content
```

Use recent screenshots for visual grounding when the user asks "right now",
"this screen", or similar. Prefer stored screenshots over a fresh capture unless
you need to confirm a changed UI state.

2. Inventory installed skills and tools with the bundled bash helper. Scripts on
   this target must be bash-compatible.

```bash
CARBON_HOME="${CARBON_HOME:-/opt/usr/home/owner/.carbon}"
/usr/bin/bash "$CARBON_HOME/skills/capability-curation/scripts/capability_inventory.sh"
```

If script execution is blocked by a platform signing policy, use this inline
bash fallback:

```bash
CARBON_HOME="${CARBON_HOME:-/opt/usr/home/owner/.carbon}"
SKILL_ROOT="$CARBON_HOME/skills"
printf 'tools\n'
for tool in carbon-claw tizen-context-cli tizen-hud-cli tizen-viewer-launch-cli \
  tizen-search-content-cli tizen-tvplus-cli tizen-play-content-cli \
  tizen-aurum-cli tizen-app-cli agent-browser-cli
do
  path="$(command -v "$tool" 2>/dev/null || true)"
  if [ -n "$path" ]; then
    printf 'tool\t%s\tavailable\t%s\n' "$tool" "$path"
  else
    printf 'tool\t%s\tmissing\n' "$tool"
  fi
done

printf 'skills\n'
find "$SKILL_ROOT" -mindepth 2 -maxdepth 2 -name SKILL.md 2>/dev/null | sort |
while IFS= read -r file
do
  awk '
    BEGIN { in_fm = 0; name = ""; desc = "" }
    NR == 1 && $0 == "---" { in_fm = 1; next }
    in_fm && $0 == "---" { exit }
    in_fm && /^name:[[:space:]]*/ {
      sub(/^name:[[:space:]]*/, ""); gsub(/^"|"$/, ""); name = $0; next
    }
    in_fm && /^description:[[:space:]]*/ {
      sub(/^description:[[:space:]]*/, ""); gsub(/^"|"$/, ""); desc = $0; next
    }
    END { if (name != "") printf "skill\t%s\t%s\n", name, desc }
  ' "$file"
done
```

Read a specific `SKILL.md` only if its description is not enough to explain the
capability clearly.

<!--
3. If HUD recommendations are currently shown and the capability request is not
   about selecting an item from that list, hide stale recommendations before
   rendering a new TV surface:

```bash
tizen-hud-cli hide-reco
```
-->

4. Compose the answer around practical actions the user can say next. Use the
   exact three-block order: current status, current-context actions, general
   capabilities.

## Response Shape

Match the user's language. In Korean, prefer concise natural labels.

Use exactly three top-level blocks unless the user asks for a very short answer.
For Korean, the visible headings must be exactly:

- `**현재 상태**`
- `**현재 상태 기반으로 할 수 있는 일**`
- `**일반적으로 할 수 있는 일**`

### Block 1: Current Status

Summarize the current state in 1-2 short sentences.

- If known: "지금은 `<app/channel/content>`를 보고 있어요. 화면에는 `<visible topic/page>`가 보여요."
- If uncertain: "현재 화면 상태는 확실히 확인되지 않았습니다. 화면을 먼저 확인한 뒤 더 구체적으로 도와드릴 수 있어요."

Mention evidence quality only when useful: live broadcast context, visible UI,
recent screenshot, or missing context.

### Block 2: Current-Context Actions

List exactly 2-3 concrete actions derived from the current evidence. Never list
more than 3. Then add 2-3 example prompts under an `예시:` line, wrapping each
prompt in `<a> </a>` tags (e.g., `<a>이거 어때?</a>`).

Examples by context:

- Live news: summarize the current story, explain visible people or topics,
  explain related background, suggest that the user can switch channels.
- YouTube or streaming video: summarize the video, identify the visible topic,
  suggest related-video search, pause/continue only as available next actions.
- TV Home or app grid: open the focused app, move through rows or tabs, search
  for content only if the user explicitly chooses that action.
- HUD recommendation list: explain the listed choices, compare providers, play
  a selected item by URI, or dismiss stale recommendations only if the user
  explicitly chooses that action.

If current evidence is weak, say "현재 상태 기반 추천은 제한적입니다" and offer
only low-risk actions such as checking the screen, opening apps, or asking for a
target.

### Block 3: General Capabilities

List exactly 2-3 concrete general actions that do not depend on the current
screen. Never list more than 3. Then add 2-3 example prompts under an `예시:`
line, wrapping each prompt in `<a> </a>` tags (e.g., `<a>날씨 알려줘</a>`).

Choose from installed and available capabilities:

- Find, recommend, and play movies, shows, YouTube videos, or TV Plus channels.
- Launch/close apps, navigate TV UI, press remote keys, and confirm screen state.
- Show weather, news, stocks, briefings, search summaries, or structured cards
  on the TV HUD/viewer.
- Answer questions, summarize, translate, compare, draft text, research online,
  automate a browser, or help with code.
- Use nearby-device context only when available and relevant.

Keep the default answer rich but scannable: 1-2 current-status sentences, 2-3
current-context actions, and 2-3 general actions. Do not dump every installed
skill unless the user asks for an inventory.

<!--
## TV Surface Rendering

If the user is interacting through the TV, asks to "show" capabilities, or the
answer would be easier to read visually, render a compact capability menu using
`tizen-hud-cli render-json`.

HUD wording rules:

- `title` must be short and quiet, such as `도움말` or `가능 작업`. Do not use
  large generic headers such as `지금 할 수 있는 일`.
- `summary` must describe the actual current surface: app, channel, program,
  page, visible media, or page state. Do not use `summary` for generic section
  descriptions.
- `hero` must carry the most specific current-state details available:
  `label` names the kind of surface, `value` names the program/page/media, and
  `detail` explains what is visibly happening or what topic is shown.
- `metrics[]` is for current-context actions.
- `facts[]` is for general capabilities.
- In every `metrics[]` and `facts[]` item, `label` must be the user-facing
  action name, such as `뉴스 요약`, `앱 실행`, or `정보 카드`.
- `value` must explain what that action does.
- `detail` may contain an example prompt, prefixed with `예:`.
- Never use category/meta labels such as `지금 가능`, `일반`, or `예시` as
  standalone `label` values.

Use this semantic presentation shape:

```json
{
  "surfaceId": "capability_menu_current",
  "theme": {
    "domain": "assistant",
    "pattern": "sidePanel",
    "scale": "expanded"
  },
  "title": "도움말",
  "summary": "삼성 TV Plus에서 연합뉴스TV 뉴스리뷰를 시청 중입니다.",
  "hero": {
    "label": "보고 있는 화면",
    "value": "연합뉴스TV 뉴스리뷰",
    "detail": "정치/외교 관련 실시간 뉴스 화면이 보입니다.",
    "caption": "앱: 삼성 TV Plus"
  },
  "metrics": [
    {"label": "뉴스 요약", "value": "현재 뉴스 핵심 정리", "detail": "예: 이 뉴스 핵심만 요약해줘"},
    {"label": "인물/이슈 설명", "value": "화면 속 인물과 배경 설명", "detail": "예: 저 사람 누구야?"},
    {"label": "관련 배경", "value": "지금 이슈의 맥락 설명", "detail": "예: 관련 배경 찾아줘"}
  ],
  "facts": [
    {"label": "콘텐츠 찾기", "value": "영화, 방송, YouTube 검색/재생", "detail": "예: 볼만한 영화 추천해줘"},
    {"label": "TV 조작", "value": "앱 실행과 화면 이동", "detail": "예: 넷플릭스 열어줘"},
    {"label": "정보 카드", "value": "날씨, 뉴스, 주식 브리핑 표시", "detail": "예: 오늘 브리핑 TV에 보여줘"}
  ]
}
```

Adjust `title`, `summary`, `hero`, `metrics`, and `facts` to the actual current
context. Save and render:

```bash
mkdir -p /tmp/tv-presentation
PAYLOAD="/tmp/tv-presentation/capability-menu-$(date +%Y%m%d-%H%M%S).json"
# write one valid presentation JSON object to "$PAYLOAD"
tizen-hud-cli render-json --file "$PAYLOAD"
```

Use `tizen-viewer-launch-cli --file "$PAYLOAD"` instead when the user explicitly
wants the full viewer app surface rather than the HUD renderer.
-->

## Grounding Rules

- Treat screenshots and context JSON as evidence. Do not invent a title,
  channel, app, person, or topic that is not present in the evidence.
- Separate "바로 가능" from "설정이 필요" when a tool, service, or permission is
  missing.
- For capability-menu requests, do not execute the actions listed as examples.
- Keep "현재 상태", "현재 상태 기반으로 할 수 있는 일", and "일반적으로 가능한
  일" separate and in that order.
- Do not add any character or self-introduction before `**현재 상태**`.
- Do not list more than 3 actions in either action block.
- Include concrete example prompts under both action blocks.
- In HUD JSON, never use `지금 가능`, `일반`, or `예시` as item labels; use
  action labels instead.
- Mention internal skill names only when debugging, installing skills, or when
  the user asks for the technical inventory.
- Do not expose long JSON or raw command output in the final user response
  unless requested.

## Example Answer Pattern

When the current screen is a live news broadcast:

"**현재 상태**

지금은 연합뉴스TV `뉴스리뷰`를 보고 있어요. 화면에는 정치/외교 관련 뉴스가
나오고 있습니다.

**현재 상태 기반으로 할 수 있는 일**

- 지금 나오는 뉴스의 핵심을 짧게 요약하기
- 화면에 보이는 인물, 기관, 이슈의 배경 설명하기
- 관련 배경을 설명하거나, 원하면 관련 콘텐츠 검색을 이어갈 수 있다고 안내하기

<a>이 뉴스 핵심만 요약해줘</a> <a>저 사람 누구야?</a> <a>관련 배경 찾아줘</a>

**일반적으로 할 수 있는 일**

- 영화, 방송, YouTube, TV Plus 채널을 검색하고 재생하기
- 앱을 실행하거나 TV UI를 대신 이동하기
- 날씨, 뉴스, 주식, 브리핑을 TV 카드로 보여주기

<a>볼만한 영화 추천해줘</a> <a>넷플릭스 열어줘</a> <a>오늘 브리핑 TV에 보여줘</a>"
