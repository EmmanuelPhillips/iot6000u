"""Phronesis proof of concept.

Shows three things:
1. a validator that runs generated code to get the true output
2. a Bayesian knowledge tracing (BKT) learner model with hint weighting
3. a worked scenario tying them together

NOTE: the candidate questions below are hand-written stand-ins for LLM output.
Replace them with real generated output before using results as evidence.
"""

import ast
import subprocess
import sys

# ---------------------------------------------------------------------------
# 1. validator
# ---------------------------------------------------------------------------

BANNED_CALLS = {"open", "exec", "eval", "compile", "__import__", "input"}


def static_check(code: str) -> str | None:
    """Reject snippets that import anything or call risky builtins."""
    try:
        tree = ast.parse(code)
    except SyntaxError as e:
        return f"syntax error: {e.msg}"
    for node in ast.walk(tree):
        if isinstance(node, (ast.Import, ast.ImportFrom)):
            return "imports are not allowed"
        if isinstance(node, ast.Call) and isinstance(node.func, ast.Name):
            if node.func.id in BANNED_CALLS:
                return f"call to {node.func.id} is not allowed"
    return None


def run_once(code: str, timeout: float = 2.0) -> tuple[bool, str]:
    """Run a snippet in a separate isolated interpreter process."""
    try:
        r = subprocess.run(
            [sys.executable, "-I", "-c", code],
            capture_output=True,
            text=True,
            timeout=timeout,
        )
    except subprocess.TimeoutExpired:
        return False, "timeout"
    if r.returncode != 0:
        return False, "runtime error"
    return True, r.stdout.strip()


def validate(candidate: dict) -> dict:
    """Return the candidate with a verdict and the true (executed) answer."""
    code = candidate["code"]
    problem = static_check(code)
    if problem:
        return {**candidate, "verdict": f"rejected: {problem}", "true_answer": None}

    ok1, out1 = run_once(code)
    ok2, out2 = run_once(code)
    if not (ok1 and ok2):
        return {**candidate, "verdict": f"rejected: {out1}", "true_answer": None}
    if out1 != out2:
        return {**candidate, "verdict": "rejected: non-deterministic", "true_answer": None}

    if out1 != candidate["llm_claimed_answer"].strip():
        return {
            **candidate,
            "verdict": "rejected: llm answer does not match execution",
            "true_answer": out1,
        }
    return {**candidate, "verdict": "accepted", "true_answer": out1}


# ---------------------------------------------------------------------------
# 2. learner model: bayesian knowledge tracing with hint weighting
# ---------------------------------------------------------------------------

P_INIT = 0.30    # prior probability the concept is already mastered
P_LEARN = 0.15   # chance of learning the concept after an attempt
P_GUESS = 0.20   # chance of a correct answer without mastery
P_SLIP = 0.10    # chance of a wrong answer despite mastery
HINT_GUESS_BOOST = 0.15  # design choice (untested): each hint raises effective guess
MAX_GUESS = 0.60


def bkt_update(p_mastery: float, correct: bool, hints_used: int = 0) -> float:
    """Update mastery after one attempt. Hints weaken the evidence of a correct answer."""
    guess = min(MAX_GUESS, P_GUESS + HINT_GUESS_BOOST * hints_used)
    if correct:
        num = p_mastery * (1 - P_SLIP)
        den = num + (1 - p_mastery) * guess
    else:
        num = p_mastery * P_SLIP
        den = num + (1 - p_mastery) * (1 - guess)
    posterior = num / den
    return posterior + (1 - posterior) * P_LEARN


# ---------------------------------------------------------------------------
# 3. worked scenario
# ---------------------------------------------------------------------------

CANDIDATES = [
    {
        "concept": "off_by_one",
        "type": "predict_output",
        "code": "nums = [4, 8, 15, 16, 23]\ntotal = 0\nfor i in range(1, len(nums)):\n    total += nums[i]\nprint(total)",
        "llm_claimed_answer": "62",
    },
    {
        # deliberately wrong claim, to show the validator catching it
        "concept": "off_by_one",
        "type": "predict_output",
        "code": "items = ['a', 'b', 'c', 'd']\nprint(items[len(items) - 1])",
        "llm_claimed_answer": "c",
    },
]


def main() -> None:
    print("=== step 1: validate generated questions ===")
    accepted = None
    for c in CANDIDATES:
        v = validate(c)
        print(f"- concept={v['concept']} verdict={v['verdict']} "
              f"llm_claimed={v['llm_claimed_answer']} executed={v['true_answer']}")
        if v["verdict"] == "accepted" and accepted is None:
            accepted = v

    print("\n=== step 2: learner attempts the accepted question ===")
    print(accepted["code"])
    print(f"true answer: {accepted['true_answer']}")

    attempts = [
        ("wrong answer (66), no hints", False, 0),
        ("correct after 3 hints", True, 3),
        ("correct, no hints", True, 0),
    ]
    p = P_INIT
    print(f"\n{'attempt':<32}{'before':>8}{'after':>8}")
    for label, correct, hints in attempts:
        after = bkt_update(p, correct, hints)
        print(f"{label:<32}{p:>8.3f}{after:>8.3f}")
        p = after

    print("\n=== step 3: why hints matter in the model ===")
    start = 0.30
    print(f"start mastery {start:.2f}")
    for hints in range(4):
        print(f"correct answer after {hints} hints -> mastery {bkt_update(start, True, hints):.3f}")


if __name__ == "__main__":
    main()
