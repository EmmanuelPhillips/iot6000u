# adaptive ai coding practice (name tbc)

## why make it
ai assistants let people produce code they do not fully understand, so reading, reasoning and debugging skills can erode (needs citing)
- interview platforms are heavy and interview focused
- course platforms follow a fixed curriculum with little adaptation to individual error patterns
- gap: practice that targets your own weak concepts, like touch-typing trainers that target the keystrokes you struggle with
--- -

## what it aims to solve
- loss of code comprehension caused by over-reliance on ai generated code
- generic practice that does not match what an individual actually struggles with
- lack of a light, daily, general-purpose option that is not interview focused
--- -

## key features
- short daily challenge set
- weakness model with a mastery score per concept (e.g. knowledge tracing)
- adaptive selection of the next challenge based on previous answers
- llm generated variants and hints that guide rather than give the answer
- progress view showing which concepts are improving
- general coding focus, with a scaling path to interview prep, ctf prep and corporate l&d
--- -

## key challenges
- cold start: no data on a new user, so a short diagnostic is needed
- modelling weakness accurately from few attempts
- correctness of llm generated challenges, so automated test validation is needed
- keeping users motivated to return daily
- verifying claims about competitors before stating them
--- -

## risks
- llm cost and latency at scale
- incorrect or flawed generated problems damaging trust
- established platforms adding adaptive features
- low retention
--- -

## ethics
- privacy: attempt and code data is personal data, so uk gdpr applies
- fairness: the model may mislabel learners from different backgrounds
- over-reliance: the tool should not become another crutch, so hints are scaffolded
- transparency: explain why a challenge was chosen
- integrity: possible misuse for cheating if used in assessed settings
- accessibility and environmental cost of llm usage
--- -
