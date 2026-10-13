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

PwC UK operates a hybrid working model, so daily office attendance varies considerably by site and weekday. Facilities Management (FM) uses attendance to plan catering and cleaning, and Real Estate uses it to allocate space across teams. With little forward visibility, FM risks food waste, mis-sized cleaning shifts and shortfalls on busy days.

Attendance is also shifted by external events such as bank holidays and rail strikes, which are currently logged through a manual form that is slow and misses events.

The work sits within the Real Estate Data Analytics (REDA) team, whose Databricks lakehouse holds aggregated daily headcount per office. Forecasting is currently limited to Power BI's built-in forecast, which has not been validated. Without a validated forecast, FM cannot quantify the benefit of earlier planning, so any model must beat the heuristic of assuming attendance equals the same weekday last week.

// 100 WORDS
= Project Aim and Objectives

*Aim:* To develop and evaluate a 1-14 day office attendance forecasting pipeline that outperforms seasonal naive and Power BI baselines, ingests public disruption data automatically and provides calibrated prediction intervals.

*Objectives:*
+ Agree KPIs, horizon and simulation assumptions.
+ Automate ingestion of bank holidays, strikes and weather warnings into the existing medallion architecture.
+ Benchmark seasonal naive and Power BI forecasts as baselines.
+ Compare SARIMAX, LightGBM and XGBoost using rolling-origin validation per office, measured by MAE and MAPE.
+ Identify which events most shift attendance using feature importance.
+ Deliver a dashboard for FM and Real Estate stakeholders and estimate the potential planning benefit.
+ Evaluate results and recommend next steps.
*Future value (out of scope):* If validated on real data, a sufficiently accurate forecast could support exploring the subletting of floors in larger offices on low attendance days, similar to flexible workspace providers such as WeWork.

// 150 WORDS
= Research Plan

Prior work will be identified through Google Scholar, IEEE Xplore, the ACM Digital Library, ScienceDirect and arXiv, accessed via the QMUL library, plus Databricks and MLflow documentation for implementation practice. Indicative search terms include "office occupancy forecasting", "hybrid work space utilisation", "time series forecasting exogenous events", "gradient boosting forecasting", "rolling origin evaluation", "conformal prediction time series" and "forecast accuracy metrics".

Peer-reviewed work from 2018 onwards will be prioritised for methods, and post-2020 studies for hybrid working behaviour. Grey literature such as consultancy reports will be labelled and treated cautiously, with quality judged on peer review, data transparency and relevance to office settings. Findings will inform model selection, feature design, validation strategy and interval calibration.

AI tools may support discovery and summarisation, but every source will be read and verified directly and managed in mybib, with no AI-generated references.

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
  [Met], [Project options shortlisted], [Oct 2026],
  [Planned], [Discuss options with manager and lecturer], [TBC],
  [Planned], [Proposal submitted (IOT6002U 001)], [30 Oct 2026],
  [Planned], [AI pitch video (IOT6000U)], [5 Nov 2026],
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
