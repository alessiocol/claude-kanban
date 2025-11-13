#!/usr/bin/env python3
"""
Task Block Mover for ACTIVE.md

Automatically moves task blocks between sections based on state transitions.
This makes state transitions fully deterministic and automated.
"""

import sys
import re
from typing import List, Tuple, Optional


def find_task_block(lines: List[str], task_id: str) -> Optional[Tuple[int, int]]:
    """
    Find the start and end line numbers of a task block.

    A task block starts with **[TASK-ID] and ends at the next empty line or section header.

    Returns: (start_line, end_line) or None if not found
    """
    start_line = None

    for i, line in enumerate(lines):
        # Look for task ID in bold markdown: **[TASK-ID]
        if f"**[{task_id}]" in line or f"[{task_id}]" in line:
            start_line = i
            break

    if start_line is None:
        return None

    # Find end of task block (next empty line or section header)
    end_line = start_line + 1
    for i in range(start_line + 1, len(lines)):
        line = lines[i]
        # End at empty line
        if line.strip() == "":
            end_line = i
            break
        # End at next section header (##)
        if line.startswith("##"):
            end_line = i
            break
        # End at next task (starts with **)
        if line.startswith("**["):
            end_line = i
            break
    else:
        # Reached end of file
        end_line = len(lines)

    return (start_line, end_line)


def find_section(lines: List[str], section_name: str) -> Optional[int]:
    """
    Find the line number where a section starts.

    Sections are marked with ## emoji SECTION_NAME
    Example: ## 🔨 IN PROGRESS

    Returns: line number of section header or None
    """
    for i, line in enumerate(lines):
        if line.startswith("##") and section_name in line:
            return i
    return None


def extract_task_block(lines: List[str], start: int, end: int) -> List[str]:
    """Extract task block lines (including trailing empty line)."""
    task_lines = lines[start:end]
    # Add empty line if not present
    if task_lines and task_lines[-1].strip() != "":
        task_lines.append("")
    return task_lines


def insert_task_after_section(lines: List[str], section_line: int, task_lines: List[str]) -> List[str]:
    """
    Insert task block after section header.

    Skip any intro text (like "None" or "Review roles available")
    and insert before the next section or at end of section.
    """
    # Find insertion point (after section header and any intro text)
    insert_pos = section_line + 1

    # Skip blank lines after header
    while insert_pos < len(lines) and lines[insert_pos].strip() == "":
        insert_pos += 1

    # Skip "None" line if present
    if insert_pos < len(lines) and lines[insert_pos].strip() in ["None", "**None**"]:
        insert_pos += 1

    # Skip other intro text (like "Review roles available:")
    while insert_pos < len(lines):
        line = lines[insert_pos].strip()
        # Stop at next section, task, or blank line followed by content
        if line.startswith("##") or line.startswith("**["):
            break
        if line == "" and insert_pos + 1 < len(lines) and lines[insert_pos + 1].startswith("**["):
            break
        insert_pos += 1

    # Add blank line before task if needed
    if insert_pos > 0 and lines[insert_pos - 1].strip() != "":
        task_lines = [""] + task_lines

    # Insert task lines
    result = lines[:insert_pos] + task_lines + lines[insert_pos:]
    return result


def remove_none_if_section_has_tasks(lines: List[str], section_line: int) -> List[str]:
    """Remove 'None' placeholder if section now has tasks."""
    # Look for "None" line after section header
    check_pos = section_line + 1
    while check_pos < len(lines) and lines[check_pos].strip() == "":
        check_pos += 1

    if check_pos < len(lines) and lines[check_pos].strip() == "None":
        # Check if there are tasks after this line
        for i in range(check_pos + 1, len(lines)):
            if lines[i].startswith("##"):
                # Reached next section, no tasks found
                break
            if lines[i].startswith("**["):
                # Found a task, remove "None"
                return lines[:check_pos] + lines[check_pos + 1:]

    return lines


def add_none_if_section_empty(lines: List[str], section_line: int) -> List[str]:
    """Add 'None' placeholder if section is empty."""
    # Check if section is empty
    check_pos = section_line + 1
    while check_pos < len(lines) and (lines[check_pos].strip() == "" or lines[check_pos].strip() == "---"):
        check_pos += 1

    # If next line is a section header or end of file, section is empty
    if check_pos >= len(lines) or lines[check_pos].startswith("##"):
        # Insert "None" and blank line after section header
        return lines[:section_line + 1] + ["", "None", ""] + lines[section_line + 1:]

    return lines


def move_task_block(
    active_file: str,
    task_id: str,
    from_state: str,
    to_state: str
) -> bool:
    """
    Move a task block from one section to another in ACTIVE.md.

    Returns: True if successful, False otherwise
    """
    # State to section mapping
    state_to_section = {
        "UNCLAIMED": "⏭️ NEXT UP",
        "IN_PROGRESS": "🔨 IN PROGRESS",
        "IN_REVIEW": "🔍 IN REVIEW",
        "ADDRESSING_FEEDBACK": "🔧 ADDRESSING FEEDBACK",
        "COMPLETED": "✅ RECENTLY COMPLETED"
    }

    if to_state not in state_to_section:
        print(f"❌ Unknown target state: {to_state}")
        return False

    # Read file
    try:
        with open(active_file, 'r') as f:
            lines = [line.rstrip('\n') for line in f.readlines()]
    except FileNotFoundError:
        print(f"❌ File not found: {active_file}")
        return False

    # Find task block
    task_location = find_task_block(lines, task_id)
    if task_location is None:
        print(f"❌ Task {task_id} not found in {active_file}")
        return False

    start_line, end_line = task_location

    # Find target section
    target_section = state_to_section[to_state]
    target_section_line = find_section(lines, target_section)
    if target_section_line is None:
        print(f"❌ Target section not found: {target_section}")
        return False

    # Extract task block
    task_lines = extract_task_block(lines, start_line, end_line)

    # Remove task from original location
    source_section_line = None
    for section_name in state_to_section.values():
        section_line = find_section(lines, section_name)
        if section_line is not None and section_line < start_line:
            source_section_line = section_line

    lines = lines[:start_line] + lines[end_line:]

    # Adjust target section line if it's after the removed block
    if target_section_line > start_line:
        target_section_line -= (end_line - start_line)

    # Add "None" to source section if now empty
    if source_section_line is not None:
        if source_section_line > start_line:
            source_section_line -= (end_line - start_line)
        lines = add_none_if_section_empty(lines, source_section_line)
        # Adjust target section line again if "None" was added before it
        if source_section_line < target_section_line:
            target_section_line = find_section(lines, target_section)

    # Insert task into target section
    lines = insert_task_after_section(lines, target_section_line, task_lines)

    # Remove "None" from target section if it now has tasks
    target_section_line = find_section(lines, target_section)  # Re-find after insertion
    lines = remove_none_if_section_has_tasks(lines, target_section_line)

    # Write file
    try:
        with open(active_file, 'w') as f:
            f.write('\n'.join(lines) + '\n')
        return True
    except Exception as e:
        print(f"❌ Failed to write file: {e}")
        return False


def main():
    if len(sys.argv) != 5:
        print("Usage: move_task.py <active_file> <task_id> <from_state> <to_state>")
        sys.exit(1)

    active_file = sys.argv[1]
    task_id = sys.argv[2]
    from_state = sys.argv[3]
    to_state = sys.argv[4]

    success = move_task_block(active_file, task_id, from_state, to_state)
    sys.exit(0 if success else 1)


if __name__ == "__main__":
    main()
