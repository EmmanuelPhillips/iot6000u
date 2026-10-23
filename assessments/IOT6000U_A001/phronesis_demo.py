"""Phronesis interactive terminal demo.

Run:  python3 phronesis_demo.py [--file questions.json] [--rounds 6]

Needs phronesis_poc.py in the same folder (it provides the validator and the
learner model). Questions and hints are generated offline by an LLM and saved
to questions.json. Every question is validated by execution before it is used.
"""

import argparse
import json

from phronesis_poc import P_INIT, bkt_update, validate

GREEN, RED, DIM, BOLD, RESET = "\033[32m", "\033[31m", "\033[2m", "\033[1m", "\033[0m"


def bar(p: float, width: int = 20) -> str:
    filled = round(p * width)
    return "[" + "#" * filled + "-" * (width - filled) + f"] {p:.2f}"


def norm(s: str) -> str:
    return "".join(s.split())


def load_validated(path: str) -> list[dict]:
    with open(path) as f:
        candidates = json.load(f)
    print(f"{BOLD}validating {len(candidates)} generated questions by running them...{RESET}")
    accepted = []
    for c in candidates:
        v = validate(c)
        ok = v["verdict"] == "accepted"
        colour = GREEN if ok else RED
        print(f"  {colour}{v['verdict']:<45}{RESET} {v['concept']:<12} {DIM}claimed={v['llm_claimed_answer']} executed={v['true_answer']}{RESET}")
        if ok:
            accepted.append(v)
    print(f"{len(accepted)} of {len(candidates)} questions passed validation\n")
    return accepted


def pick_question(mastery: dict, pool: list[dict], seen: set) -> dict | None:
    """Choose an unseen question from the concept with the lowest mastery."""
    for concept in sorted(mastery, key=lambda c: (mastery[c], c)):
        options = [q for q in pool if q["concept"] == concept and id(q) not in seen]
        if options:
            return options[0]
    return None


def ask(q: dict):
    """Returns (answer, hints_used) or None if the learner quits."""
    hints_used = 0
    while True:
        raw = input("answer, h for a hint, q to quit > ").strip()
        if raw.lower() == "q":
            return None
        if raw.lower() == "h":
            if hints_used < len(q["hints"]):
                print(f"{DIM}hint {hints_used + 1}/{len(q['hints'])}: {q['hints'][hints_used]}{RESET}")
                hints_used += 1
            else:
                print(f"{DIM}no more hints{RESET}")
            continue
        return raw, hints_used


def show_mastery(mastery: dict) -> None:
    for concept in sorted(mastery, key=lambda c: (mastery[c], c)):
        print(f"  {concept:<12} {bar(mastery[concept])}")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--file", default="questions.json")
    parser.add_argument("--rounds", type=int, default=6)
    args = parser.parse_args()

    pool = load_validated(args.file)
    mastery = {c: P_INIT for c in {q["concept"] for q in pool}}
    seen: set = set()

    for round_no in range(1, args.rounds + 1):
        q = pick_question(mastery, pool, seen)
        if q is None:
            print("no more questions in the pool")
            break
        seen.add(id(q))
        concept = q["concept"]

        print(f"{BOLD}--- question {round_no} of {args.rounds} ---{RESET}")
        print(f"weakest concept right now: {BOLD}{concept}{RESET} ({mastery[concept]:.2f})\n")
        print(q["code"])
        print("\nwhat does this print?")

        result = ask(q)
        if result is None:
            break
        answer, hints_used = result

        correct = norm(answer) == norm(q["true_answer"])
        before = mastery[concept]
        mastery[concept] = bkt_update(before, correct, hints_used)

        if correct:
            print(f"{GREEN}correct{RESET} (hints used: {hints_used})")
        else:
            print(f"{RED}not quite{RESET}: it prints {q['true_answer']}")
        print(f"{DIM}why: {q['explanation']}{RESET}")
        print(f"mastery of {concept}: {before:.2f} -> {mastery[concept]:.2f}\n")

    print(f"{BOLD}=== session summary ==={RESET}")
    show_mastery(mastery)


if __name__ == "__main__":
    try:
        main()
    except (EOFError, KeyboardInterrupt):
        print("\nsession ended")
