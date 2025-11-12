#!/bin/bash
# Session End Hook - Validates handover checklist before allowing session to end
# This runs automatically when agent ends session (via Claude Code)

set -e

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🛑 SESSION END CHECKLIST"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

ERRORS=0
WARNINGS=0

# 1. Check for uncommitted changes
echo "1️⃣  Checking for uncommitted changes..."
if ! git diff-index --quiet HEAD -- 2>/dev/null; then
  echo "   ❌ UNCOMMITTED CHANGES FOUND"
  echo ""
  git status --short | sed 's/^/      /'
  echo ""
  echo "   Action required: Commit your work before ending session"
  echo "   Command: git add . && git commit -m '[Phase N] Your changes'"
  echo ""
  ERRORS=$((ERRORS + 1))
else
  echo "   ✅ No uncommitted changes"
fi

echo ""

# 2. Check for unpushed commits
echo "2️⃣  Checking for unpushed commits..."
UNPUSHED=$(git log @{u}.. --oneline 2>/dev/null | wc -l || echo 0)
if [ "$UNPUSHED" -gt 0 ]; then
  echo "   ⚠️  $UNPUSHED UNPUSHED COMMITS"
  echo ""
  git log @{u}.. --oneline | head -5 | sed 's/^/      /'
  echo ""
  echo "   Action recommended: Push your work to remote"
  echo "   Command: git push origin $(git branch --show-current)"
  echo ""
  WARNINGS=$((WARNINGS + 1))
else
  echo "   ✅ All commits pushed to remote"
fi

echo ""

# 3. Check if ACTIVE.md was updated (if code changes were made)
echo "3️⃣  Checking ACTIVE.md updates..."

# Get commits from last 24 hours
RECENT_COMMITS=$(git log --since="24 hours ago" --oneline | wc -l)

if [ $RECENT_COMMITS -gt 0 ]; then
  # Check if ACTIVE.md was modified in recent commits
  STATE_UPDATED=$(git log --since="24 hours ago" --name-only --pretty=format: | grep -q ".claude/state/ACTIVE.md" && echo "yes" || echo "no")

  # Check if code was modified
  CODE_MODIFIED=$(git log --since="24 hours ago" --name-only --pretty=format: | grep -E "^(src/|tests/)" | wc -l)

  if [ "$CODE_MODIFIED" -gt 0 ] && [ "$STATE_UPDATED" = "no" ]; then
    echo "   ❌ ACTIVE.md NOT UPDATED"
    echo ""
    echo "   You modified code but didn't update ACTIVE.md"
    echo ""
    echo "   Files changed:"
    git log --since="24 hours ago" --name-only --pretty=format: | grep -E "^(src/|tests/)" | sort -u | head -10 | sed 's/^/      /'
    echo ""
    echo "   Action required: Update .claude/state/ACTIVE.md with:"
    echo "      • What you completed (RECENTLY COMPLETED section)"
    echo "      • Any decisions made (KEY DECISIONS section)"
    echo "      • What's next (NEXT UP section)"
    echo "      • Last Updated header"
    echo ""
    ERRORS=$((ERRORS + 1))
  else
    echo "   ✅ ACTIVE.md is up to date"
  fi
else
  echo "   ℹ️  No recent commits (skip check)"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 HANDOVER CHECKLIST"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Confirm you have completed:"
echo "  □ Updated 'RECENTLY COMPLETED' in ACTIVE.md"
echo "  □ Added decisions to 'KEY DECISIONS' (if any)"
echo "  □ Updated 'NEXT UP' for next agent"
echo "  □ Updated 'Last Updated' header in ACTIVE.md"
echo "  □ Committed all changes"
echo "  □ Pushed commits to remote"
echo ""

# Final result
if [ $ERRORS -gt 0 ]; then
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "❌ SESSION END BLOCKED ($ERRORS error(s))"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "Please fix the errors above before ending your session"
  echo "This ensures clean handover to the next agent"
  echo ""
  exit 1
elif [ $WARNINGS -gt 0 ]; then
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "⚠️  SESSION END - WARNINGS ($WARNINGS warning(s))"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "Warnings detected (see above) but session can proceed"
  echo "Consider addressing warnings for better coordination"
  echo ""
  exit 0
else
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "✅ HANDOVER COMPLETE"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "All checks passed! Session can end safely."
  echo "Next agent will receive clean context via ACTIVE.md"
  echo ""
  exit 0
fi
