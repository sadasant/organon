"""Shared structured-judge behavior and gate semantics."""

from __future__ import annotations

import json


NON_SCORE_FIELDS = {"critical_violations", "evidence", "revision"}


def score_values(judgment: dict) -> list[int]:
    scores = [
        value
        for key, value in judgment.items()
        if key not in NON_SCORE_FIELDS and isinstance(value, int)
    ]
    if not scores:
        raise ValueError("judgment contains no integer score fields")
    return scores


def judgment_passed(judgment: dict, *, threshold: int = 3) -> bool:
    return (
        not judgment.get("critical_violations", [])
        and min(score_values(judgment)) >= threshold
    )


def call_structured_with_retry(program, *, output_field: str = "judgment", **kwargs):
    """Retry schema failures without broadening the requested judgment."""
    last_error: Exception | None = None
    target = json.loads(kwargs["target_json"])
    for attempt in range(3):
        call_kwargs = dict(kwargs)
        if attempt:
            retry_target = dict(target)
            retry_target["_retry_instruction"] = (
                "Return one complete value matching every required field. "
                "Do not omit scores or substitute prose for the schema."
            )
            call_kwargs["target_json"] = json.dumps(
                retry_target, ensure_ascii=False
            )
        try:
            value = getattr(program(**call_kwargs), output_field)
            return value.model_dump() if hasattr(value, "model_dump") else value
        except Exception as error:
            last_error = error
    assert last_error is not None
    raise last_error


def escape_cell(value: object) -> str:
    return " ".join(str(value).replace("|", "\\|").split())

