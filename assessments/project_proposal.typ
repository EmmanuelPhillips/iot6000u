// COVER SHEET
#page(numbering: none)[
  #align(center + horizon)[
    #text(size: 24pt, weight: "bold")[PwC UK Office Attendance Predictor]
    #v(0.5em)
    #text(size: 14pt)[Project Proposal]

    #v(3em)
    #grid(
      columns: (auto, auto),
      column-gutter: 1em,
      row-gutter: 0.8em,
      align: (right, left),
      [*Name:*], [Emmanuel Phillips],
      [*Student ID:*], [230355585],
      [*Module:*], [IOT6002U - Assessment 001],
      [*University email:*], [ec23279\@qmul.ac.uk],
      [*Work email:*], [emmanuel.j.phillips\@pwc.com],
    )
  ]
  #align(center + bottom)[
    #datetime.today().display("[day] [month repr:long] [year]")
  ]
]

// SET UP LAYOUT FOR REST OF THE DOCUMENT
#set page(numbering: "1")
#set heading(numbering: "1.")
#set text(size: 11pt, font: "New Computer Modern")

//SET UP CONTENTS PAGE
#outline()
#pagebreak() // ENSURE CONTENTS IS ON ITS OWN PAGE

// EACH TOP-LEVEL SECTION STARTS ON A NEW PAGE, AND TABLES NEVER SPLIT ACROSS PAGES
#show heading.where(level: 1): it => {
  pagebreak(weak: true)
  it
}
#show table: set block(breakable: false)

// 150 WORDS
= Problem Definition

PwC UK operates a hybrid working model, so daily office attendance varies by site and weekday and cannot be inferred from desk allocations. Facilities Management (FM) uses attendance to plan catering and cleaning, and Real Estate uses it to allocate space. Without forward visibility, FM risks food waste, mis-sized cleaning shifts and shortfalls on busy days.

Events such as bank holidays, rail strikes and internal events also shift attendance. These are logged in a manual form, but the log is historical and not systematically used to forecast attendance, even though many events are known in advance. Public events can be ingested automatically, while internal events will remain a manual input.

The work sits within the Real Estate Data Analytics (REDA) team, whose cloud data platform (Databricks) holds daily headcount totals per office. Forecasting is limited to the built-in forecast in Power BI, a reporting tool, which has not been checked against past attendance or compared with simple rules of thumb, so its accuracy is unknown. Any new model must beat the simple rule of assuming attendance equals the same weekday last week.

// 100 WORDS
= Project Aim and Objectives

*Aim:* Develop and evaluate a 1-14 day office attendance forecasting pipeline that outperforms seasonal naive and Power BI baselines, collects public disruption data automatically and provides calibrated prediction intervals.

*Objectives:*
+ Define KPIs, forecast horizon and simulation assumptions, generate a synthetic dataset mirroring current data structures.
+ Automate collection of bank holidays, strikes and weather warnings into a medallion architecture (raw to analysis-ready layers).
+ Benchmark seasonal naive and Power BI forecasts as baselines.
+ Compare SARIMAX, LightGBM and XGBoost per office using rolling-origin validation, measured by MAE and MAPE.
+ Produce prediction intervals and report their coverage against the target level.
+ Identify which events most shift attendance using feature importance.
+ Deliver a dashboard for FM and Real Estate, evaluate results and recommend next steps.

*Future value:* a validated forecast could support wider space optimisation decisions.

// 150 WORDS
= Research Plan

Prior work will be identified through IEEE Xplore, the ACM Digital Library, ScienceDirect, Google Scholar and arXiv, plus Databricks and MLflow documentation for implementation practice. Searches are mapped to project objectives (@tbl-research), 

Peer-reviewed work from 2018 onwards is prioritised for methods, and from 2020 onwards for hybrid working. Sources are selected for transparent data and methods and relevance to daily or small series. A known limitation is that most occupancy research uses sensor data in other settings and no public attendance datasets exist, so findings will guide method choices rather than set expected accuracy. Grey literature, such as real estate and consultancy reports, is labelled and used for context only.

AI tools may support keyword generation and abstract screening, but all sources are read and verified directly. References are managed using mybib. Findings will inform model selection, validation, feature design and interval calibration.

#show figure.where(kind: table): set figure.caption(position: top)
#[
  #set text(size: 9pt)
  #figure(
    table(
      columns: (auto, 1.5fr, auto, 1.3fr),
      align: left + top,
      inset: 6pt,
      stroke: (x, y) => if y == 0 { (bottom: 0.8pt) } else { (bottom: 0.4pt + luma(200)) },
      fill: (x, y) => if y == 0 { luma(235) },
      table.header[*Objective*][*Search terms*][*Sources*][*Purpose*],

      [Simulation],
      [
        "synthetic time series generation" \
        "hybrid working attendance patterns" \
        "weekday effects office attendance"
      ],
      [Google Scholar, arXiv],
      [Ground simulation assumptions and reduce the risk of unrealistic data],

      [Platform],
      [
        "medallion architecture" \
        "MLflow experiment tracking"
      ],
      [Databricks and MLflow documentation],
      [Inform pipeline design and experiment tracking],

      [Baselines],
      [
        "seasonal naive forecasting" \
        "forecast benchmark" \
        "M-competition"
      ],
      [IEEE Xplore, Google Scholar],
      [Confirm baseline choice and standard evaluation metrics],

      [Models],
      [
        "SARIMAX exogenous variables" \
        "LightGBM time series" \
        "XGBoost forecasting" \
        "rolling-origin evaluation"
      ],
      [ScienceDirect, arXiv],
      [Justify model selection and validation strategy],

      [Events],
      [
        "calendar effects forecasting" \
        "holiday effect forecasting" \
        "special events demand forecasting" \
        "feature importance time series"
      ],
      [ACM DL, IEEE Xplore],
      [Decide which event features to include and how to encode them],

      [Intervals],
      [
        "conformal prediction time series" \
        "prediction interval calibration" \
        "quantile regression forecasting"
      ],
      [arXiv, Google Scholar],
      [Choose an interval method suitable for small daily series],

      [Context],
      [
        "hybrid work office occupancy" \
        "workplace utilisation post-2020"
      ],
      [Google Scholar, grey literature],
      [Ground assumptions about attendance patterns],
    ),
    caption: [Literature search plan by project objective],
  ) <tbl-research>
]

// 100 WORDS
= Identification of Technologies, Tools and/or Datasets

*Platform:* Databricks with Delta tables and MLflow, chosen because the data already resides there and Unity Catalog provides governed access, lineage and experiment tracking. Alternatives are local Python with DuckDB (cheaper, but ungoverned) and Azure ML (heavier infrastructure for a small problem).

*Models:* Python with statsmodels for SARIMAX (an interpretable classical benchmark) (Hyndman and Athanasopoulos, 2021), plus LightGBM (Ke et al., 2017) and XGBoost (Chen and Guestrin, 2016), which handle exogenous event features flexibly. Prophet is excluded to limit scope, and deep learning because daily office series are small and interpretability matters to FM.

*Data:* Synthetic data is the primary dataset, generated in Python with Faker and custom simulation code. It mirrors the schema of the REDA attendance, office and date tables, with attendance patterns and event effects simulated from documented assumptions. Bank holidays, Met Office warnings, TfL disruption and strike dates are real public data. No real PwC attendance data is used.

// EXCLUDED FROM WORD COUNT
= Project Plan and Milestones

== Key dates

#table(
  columns: (auto, 1fr, auto),
  align: (left, left, left),
  [*Status*], [*Milestone*], [*Date*],
  [Met], [Project options shortlisted], [10th Oct 2026],
  [Met], [Discuss options with manager and lecturer], [25th Oct 2026],
  [Met], [Finalise choice of project], [25th Oct 2026],
  [Planned], [Proposal submitted], [30 Oct 2026],
  [Planned], [Project build and evaluation (16 weeks, assumed)], [Start TBC],
  [Planned], [Gateway, then project report (6000 words), presentation and KSB mapping], [TBC],
)

== Project build schedule (weeks from project start, assumed 16)

#let tasks = (
  ("KPIs, horizon and simulation assumptions", 1, 2),
  ("Synthetic data generator", 2, 4),
  ("Ingestion pipeline (bronze to gold)", 3, 6),
  ("Baselines (seasonal naive, Power BI)", 5, 6),
  ("Model benchmarking in MLflow", 7, 10),
  ("Intervals and feature importance", 11, 12),
  ("Dashboard and benefit estimate", 13, 14),
  ("Evaluation and recommendations", 15, 16),
)

#set text(size: 8pt)
#table(
  columns: (auto,) + (1fr,) * 16,
  inset: 3pt,
  [*Task*], ..range(1, 17).map(w => text(size: 6pt)[#w]),
  ..tasks
    .map(t => (
      [#t.at(0)],
      ..range(1, 17).map(w => if w >= t.at(1) and w <= t.at(2) {
        table.cell(fill: rgb("#1f4e79"))[]
      } else { [] }),
    ))
    .flatten(),
)
#set text(size: 11pt)

Dependencies: modelling depends on the synthetic data generator and ingestion pipeline. The dashboard depends on the chosen model and validated intervals. The report is written after the gateway, outside this schedule.

// EXCLUDED FROM WORD COUNT
= Risk Register

#table(
  columns: (auto, 1.2fr, auto, auto, 2fr),
  align: (left, left, left, left, left),
  [*ID*], [*Risk*], [*Likelihood*], [*Severity*], [*Mitigation*],
  [R1],
  [Synthetic data too simple, so models only recover the generating rules],
  [High],
  [High],
  [Add noise, regime changes and unmodelled events, hold out event types from training, document all generator assumptions in an appendix, state that results show method performance rather than real-world accuracy],

  [R2],
  [Real PwC values or identifiers included by accident],
  [Low],
  [High],
  [Generate from schema only, copy no real values, review all outputs before sharing],

  [R3],
  [Findings do not transfer to real data],
  [Medium],
  [Medium],
  [Frame as a method evaluation, build the pipeline so real data can be swapped in later, base parameters on qualitative patterns described by FM],

  [R4],
  [Public feeds unreliable or change format],
  [Medium],
  [Medium],
  [Store raw responses in bronze, validate on load, fall back to manual flag],

  [R5],
  [Models fail to beat baselines],
  [Medium],
  [Medium],
  [Report as a valid finding, recommend baseline-plus improvements],

  [R6], [Scope creep], [Medium], [Medium], [Fixed objectives, MCP and Genie work out of scope],

  [R7],
  [Confidentiality limits on describing PwC systems],
  [Medium],
  [Medium],
  [Agree restrictions with manager on Power BI setup, office counts and schemas, use generic names],

  [R8],
  [Power BI baseline run on synthetic data is only a proxy for the live forecast],
  [Medium],
  [Low],
  [Document the settings used, state the limitation in the evaluation],

  [R9], [Compute cost overrun], [Low], [Low], [Small data, job clusters with auto-termination],
)

*Ethics and compliance:* The project uses synthetic data generated from table schemas only, with no real PwC values and no human participants. QMUL ethics requirements will be confirmed with the module organiser, and confidentiality limits on describing PwC systems will be agreed with the line manager.

// EXCLUDED FROM WORD COUNT
= References

- Chen, T. and Guestrin, C. (2016) 'XGBoost: a scalable tree boosting system', in _Proceedings of the 22nd ACM SIGKDD International Conference on Knowledge Discovery and Data Mining_. New York: ACM, pp. 785-794.
- Hyndman, R.J. and Athanasopoulos, G. (2021) _Forecasting: principles and practice_. 3rd edn. Melbourne: OTexts.
- Ke, G. et al. (2017) 'LightGBM: a highly efficient gradient boosting decision tree', in _Advances in Neural Information Processing Systems 30_. Red Hook, NY: Curran Associates, pp. 3146-3154.

// EXCLUDED FROM WORD COUNT
= Appendices

== Appendix A: Generative AI declaration

Generative AI was used in order to help explore potential risks, as well as non-trivial formatting (typst layout). All AI output was read and verified before being inputted into my project proposal. I take full responsibility for the final content of this document.

== Appendix B: Planned KSB mapping

#table(
  columns: (auto, 1fr),
  align: (left, left),
  [*KSB*], [*Planned evidence*],
  [S50], [FM dashboard and communication of results],
  [S52, S53], [Model benchmarking, rolling-origin validation and stability testing],

  [S54, K56], [Automated ingestion of public data sources],
  [S55, K54], [Analysis of simulated attendance across offices],
  [S2, K3], [Risk register and mitigations],
  [S5, S6, K15], [Project plan, schedule and time/cost estimation],
  [K18, S14], [Research plan and evaluation of forecasting methods],
  [B3], [Synthetic data approach, no real PwC data used],
)
