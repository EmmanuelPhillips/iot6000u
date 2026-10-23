// iot6000u 001 presentation skeleton
// compile: typst compile phronesis.typ
// watch:   typst watch phronesis.typ
// requires typst >= 0.14 (touying 0.7.4 is fetched on first compile)

#import "@preview/touying:0.7.4": *
#import themes.simple: *

// ---------- config ----------
#let accent = rgb("#2f6fed")

#let stat(big, body, src) = block(
  height: 100%,
  width: 100%,
  grid(
    rows: (auto, 1fr, auto),
    row-gutter: 0.4em,
    text(size: 34pt, weight: "bold", fill: accent)[#big],
    text(size: 18pt)[#body],
    text(size: 14pt, fill: gray)[#src],
  ),
)
#let card(head, body, src: none) = block(
  fill: accent.lighten(92%),
  inset: 10pt,
  radius: 6pt,
  width: 100%,
  height: 100%,
)[
  #text(size: 20pt, weight: "bold", fill: accent)[#head] \
  #v(0.2em)
  #text(size: 16pt)[#body]
  #if src != none [ \ #text(size: 14pt, fill: gray)[#src] ]
]

#show: simple-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [Phronesis],
    subtitle: [Adaptive AI practice to rebuild code comprehension],
    author: [Emmanuel Phillips],
    date: [5th November 2026],
    institution: [Queen Mary University of London],
  ),
  // keep the bottom-right free for the obs webcam overlay
  config-page(margin: (top: 2.5em, bottom: 2.5em, left: 3em, right: 3em)),
)

#set text(size: 22pt )
#show raw: set text(size: 16pt)
#show link: set text(fill: accent)

// ---------- 1. title (0:20) ----------
#title-slide[
  = Phronesis
  Adaptive AI practice to rebuild code comprehension
  #v(0.5em)
  Name: Emmanuel Phillips \
  Student ID: 230355585 \
  Module: IOT6000U Digital Innovation and Product Development \
  Assessment: 001 Presentation
]

// ---------- 2. area of investigation (1:15) ----------
== Area of Investigation: AI is outpacing understanding

*Vibe coding:* using artificial intelligence, prompted by natural language, to assist with writing computer code @collins2025

#v(0.6em)

#grid(
  columns: (1fr, 1fr, 1fr),
  rows: (9em),
  gutter: 1.2em,
  align: top,
  stat(
    [84%],
    [of developers use or plan to use AI tools, 51% of professionals daily],
    [@stackoverflow2025],
  ),
  stat(
    [50% vs 67%],
    [comprehension quiz score, AI-assisted vs hand-coding developers, biggest gap on debugging],
    [@shen2026skill],
  ),
  stat(
    [17% lower],
    [grades once AI access was removed, for students with unrestricted GPT-4],
    [@bastani2025guardrails],
  ),
)

#v(0.6em)

How AI is used matters: designs that keep learners engaged largely avoided the harm @shen2026skill @bastani2025guardrails

// ---------- 3. gap in current solutions (0:45) ----------
== Gap in current solutions

#[
  #set text(size: 18pt)
  #table(
    columns: (1.1fr, 1.2fr, 1.5fr),
    inset: 8pt,
    stroke: (bottom: 0.5pt + gray),
    [*What exists*], [*What it offers*], [*What it misses*],
    [Interview platforms (e.g. LeetCode)], [Huge fixed problem bank], [Built around passing interviews],
    [AI add-ons (e.g. LCPath, LeetCode Coach)], [Weakness analysis and hints @leetcodecoach2026], [Aimed at interview candidates, still centred on solving problems],
    [Course platforms (e.g. Codecademy)], [AI tutoring], [Set curriculum],
    [Knowledge tracing research], [Models learner progress over time], [Mostly predicts correctness from quiz-style data @dai2021knowledgetracing],
  )
]

#v(0.8em)

#block(
  fill: accent.lighten(85%),
  inset: 12pt,
  radius: 6pt,
  width: 100%,
)[
  *The gap:* adaptive practice aimed at comprehension (reading, tracing and debugging code). Tracing and explaining skills are linked to code writing ability @lopez2008relationships
]

// ---------- 4. proposed ai solution (1:30) ----------
== Proposed AI solution

A daily chain of tasks on one codebase: fix, refactor, reason, extend

#v(0.6em)

#grid(
  columns: (1fr, 1fr, 1fr),
  rows: (190pt),
  gutter: 1em,
  card([1. Learner model], [Bayesian knowledge tracing tracks mastery per concept and skill, and picks what to practise next], src: [@corbett1994knowledge]),
  card([2. LLM content], [Generates code, tests and bugs. Every task is run and validated before a learner sees it]),
  card([3. Guided hints], [Three levels that nudge without giving the answer, to keep you thinking]),
)
// ---------- 5. prototype and feasibility (1:15) ----------
== Prototype and feasibility

#block(width: 100%, height: 310pt)[
  #image("simple_diagram.png", width: 100%, height: 100%, fit: "contain")
]

// ---------- 6. alternative comparison (1:00) ----------

== Alternative solution comparison

#set text(size: 17pt)

A simpler approach: a curated question bank with rules-based personalisation

#v(0.4em)

#block(width: 100%)[
  #set text(size: 14pt)

  #table(
    columns: (1fr, 1.35fr, 1.35fr),
    inset: 5pt,
    align: (left, left, left),
    stroke: (bottom: 0.5pt + gray),

    [*Feature*],
    [*Phronesis*],
    [*Rules-based alternative*],

    [Learner model],
    [Bayesian knowledge tracing],
    [Fixed rules based on errors],

    [Question source],
    [LLM-generated + curated],
    [Curated question bank],

    [Personalisation],
    [Updates mastery after each attempt],
    [Selects tasks using predefined rules],

    [Advantages],
    [Flexible adaptation and greater variety],
    [Simpler, cheaper and easier to validate],

    [Limitations],
    [Higher cost and validation complexity],
    [Less flexible; manual question authoring],
  )
]

#v(0.5em)

#block(
  fill: accent.lighten(85%),
  inset: 8pt,
  radius: 6pt,
  width: 100%,
)[
  #text(size: 16pt, weight: "bold", fill: accent)[
    Competitive advantage
  ]

  #text(size: 14pt)[
    Combines adaptive mastery tracking, validated code generation
    and graduated hints in one feedback loop. Educational impact
    still requires user testing.
  ]
]

 // ---------- 7. obstacles: external (1:00) ----------
== Obstacles: external (PESTEL)

#text(size: 15pt)[
  PESTEL examines external factors beyond the project's direct control
  (@openstax2019pestel).
]

#v(0.4em)

#set text(size: 15pt)

#table(
  columns: (1fr, 3.5fr),
  inset: 6pt,
  align: (left, left),
  stroke: (bottom: 0.5pt + gray),

  [*Factor*], [*Risk to Phronesis*],

  [Political],
  [Changes in AI and education policy may affect deployment],

  [Economic],
  [LLM inference costs may limit affordable daily use],

  [Social],
  [Learners may distrust AI feedback or over-rely on hints],

  [Technological],
  [Incorrect generated code or tests could teach misconceptions],

  [Environmental],
  [Repeated model inference consumes computing resources],

  [Legal],
  [UK GDPR and copyright obligations affect data and content],
)

#v(0.4em)

#block(
  fill: accent.lighten(90%),
  inset: 8pt,
  radius: 5pt,
  width: 100%,
)[
  #text(size: 15pt)[
    #text(weight: "bold", fill: accent)[Mitigation strategy]

    Minimise personal data, validate generated tasks, monitor API costs
    and review legal obligations before deployment.
  ]
]

 // ---------- 8. obstacles: internal (1:00) ----------
== Obstacles: internal

#text(size: 15pt)[
  Initial qualitative risk assessment; prioritise risks by likelihood and impact
  (@tabassi2023airmf).
]

#v(0.4em)

#set text(size: 13pt)

#table(
  columns: (1.5fr, 0.75fr, 0.75fr, 2.4fr),
  inset: 6pt,
  align: (left, left, left, left),
  stroke: (bottom: 0.5pt + gray),

  [*Risk*], [*Likelihood*], [*Impact*], [*Mitigation*],

  [Incorrect generated tasks],
  [High], [High],
  [Execute code, validate tests and review content],

  [Cold-start learner model],
  [High], [Medium],
  [Use a short diagnostic assessment and conservative priors],

  [Poor learner retention],
  [Medium], [High],
  [Short sessions, progress tracking and user testing],

  [API costs and capacity],
  [Medium], [High],
  [Usage limits, caching and appropriate model selection],

  [Limited development time],
  [High], [Medium],

  [Build the core learning loop first; defer advanced features],
)

#v(0.5em)

#block(
  fill: accent.lighten(90%),
  inset: 8pt,
  radius: 5pt,
  width: 100%,
)[
  #text(size: 15pt)[
    #text(weight: "bold", fill: accent)[Priority]

    Validate question quality first: unreliable tasks undermine both
    learner trust and the accuracy of the learner model.
  ]
]

 // ---------- 9. business case: initiative and benefits (1:00) ----------
== Business case: initiative and value

#grid(
  columns: (1fr, 1fr),
  rows: (auto, auto),
  gutter: 0.8em,

  card(
    [Initiative],
    [Start as an internal learning pilot for novice programmers. Validate educational impact before wider investment.],
  ),

  card(
    [Learner value],
    [Build code comprehension, debugging and reasoning skills through targeted daily practice.],
  ),

  card(
    [Organisational value],
    [Track skill development and target learning support at individual weaknesses.],
  ),

  card(
    [Competitive advantage],
    [Combines mastery tracking, validated code tasks and graduated hints in one learning loop.],
  ),
)

#v(0.6em)

#block(
  fill: accent.lighten(85%),
  inset: 10pt,
  radius: 6pt,
  width: 100%,
)[
  #text(size: 16pt, weight: "bold", fill: accent)[Path to scale]

  #text(size: 15pt)[
    Internal pilot → interview and CTF preparation → corporate learning and development
  ]
]

// ---------- 10. business case: resources (0:45) ----------
== Business case: resources

#grid(
  columns: (1fr, 1fr),
  rows: (auto,),
  gutter: 1em,

  card(
    [Short term: pilot],
    [
      *People*

      Solo developer; volunteer learners and an academic reviewer

      *Technology*

      Python, existing LLM API, SQLite, automated tests and a basic UI

      *Costs*

      Development time, API usage and hosting; minimise spend through usage limits
    ],
  ),

  card(
    [Long term: deployment],
    [
      *People*

      Software engineer, AI/ML expertise and learning-design support

      *Technology*

      Hosted backend, database, monitoring, authentication and secure execution sandbox

      *Costs*

      Hosting, model inference, maintenance, security and ongoing content validation
    ],
  ),
)

#v(0.6em)

#block(
  fill: accent.lighten(85%),
  inset: 10pt,
  radius: 6pt,
  width: 100%,
)[
  #text(size: 16pt, weight: "bold", fill: accent)[Build versus buy]

  #text(size: 15pt)[
    Build the adaptive learning loop; use existing models and infrastructure
    rather than training a foundation model from scratch.
  ]
]

// ---------- 11. conclusion (0:20) ----------
== Conclusion

#v(0.5em)

#text(size: 24pt, weight: "bold", fill: accent)[
  Better code generation doesn't guarantee better understanding.
]

#v(0.6em)

#text(size: 19pt)[
  Phronesis uses adaptive practice, validated AI-generated tasks
  and graduated hints to help learners understand code, not just produce it.
]

#v(0.8em)

#block(
  fill: accent.lighten(85%),
  inset: 12pt,
  radius: 6pt,
  width: 100%,
)[
  #text(size: 18pt, weight: "bold", fill: accent)[
    The next step
  ]

  #text(size: 16pt)[
    Evaluate learning outcomes and cost in a small pilot before scaling.
  ]
]

// ---------- 12. references (0:10) ----------
== References

#set text(size: 14pt)
#bibliography("refs.bib", title: none, style: "harvard-cite-them-right", full: true)
