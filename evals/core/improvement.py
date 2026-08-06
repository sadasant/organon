"""Turn gate evidence into bounded, reviewable improvement work."""

from __future__ import annotations

from .judging import escape_cell


def improvement_plan(
    *,
    target_id: str,
    artifact_kind: str,
    passed: bool,
    layers: list[dict],
    preserve: list[str],
) -> dict:
    actions = []
    for layer in layers:
        if layer["passed"]:
            continue
        actions.append(
            {
                "layer": layer["name"],
                "critical_violations": layer.get("critical_violations", []),
                "revision": layer.get("revision", ""),
                "evidence": layer.get("evidence", ""),
            }
        )
    return {
        "target_id": target_id,
        "artifact_kind": artifact_kind,
        "disposition": "hold" if passed else "revise",
        "preserve": preserve,
        "actions": actions,
        "promotion_rule": (
            "Human review is required after every failed layer is repaired and "
            "the exact revised bytes pass a fresh evaluation."
        ),
    }


def render_improvement_plans(plans: list[dict]) -> str:
    lines = [
        "# Improvement plans",
        "",
        "These plans translate recorded gate evidence into bounded work. They do not authorize changing a target repository or promote a generated candidate.",
        "",
    ]
    for plan in plans:
        lines.extend(
            [
                f"## {plan['target_id']}",
                "",
                f"- Artifact: `{plan['artifact_kind']}`",
                f"- Disposition: **{plan['disposition']}**",
                "- Preserve:",
            ]
        )
        lines.extend(f"  - {item}" for item in plan["preserve"])
        if not plan["actions"]:
            lines.extend(
                [
                    "- Required changes: none from this run; retain the candidate for human review.",
                    "",
                ]
            )
            continue
        lines.extend(["- Required changes:", ""])
        for action in plan["actions"]:
            lines.extend(
                [
                    f"### {action['layer']}",
                    "",
                    f"- Revision: {escape_cell(action['revision']) or 'No revision supplied.'}",
                ]
            )
            if action["critical_violations"]:
                lines.append("- Critical violations:")
                lines.extend(
                    f"  - {escape_cell(item)}"
                    for item in action["critical_violations"]
                )
            lines.extend(["", f"Evidence: {action['evidence']}", ""])
    return "\n".join(lines).rstrip() + "\n"

