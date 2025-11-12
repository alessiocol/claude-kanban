#!/bin/bash
# Setup script - Installs git hooks and makes all hook scripts executable
# Run this once after cloning the repository

set -e

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔧 Installing Coordination Hooks"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Get the project root directory
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

echo "Project root: $PROJECT_ROOT"
echo ""

# 1. Make all hook scripts executable
echo "1️⃣  Making hook scripts executable..."
chmod +x .claude/hooks/session-start.sh
chmod +x .claude/hooks/stop-hook.sh
chmod +x .claude/hooks/git/pre-commit
chmod +x .claude/hooks/git/commit-msg
chmod +x .claude/hooks/git/post-commit
echo "   ✅ All hook scripts are now executable"
echo ""

# 2. Install git hooks via symlinks
echo "2️⃣  Installing git hooks..."

# Check if .git directory exists
if [ ! -d ".git" ]; then
  echo "   ❌ ERROR: .git directory not found"
  echo "   This doesn't appear to be a git repository"
  exit 1
fi

# Create symlinks for git hooks
ln -sf ../../.claude/hooks/git/pre-commit .git/hooks/pre-commit
ln -sf ../../.claude/hooks/git/commit-msg .git/hooks/commit-msg
ln -sf ../../.claude/hooks/git/post-commit .git/hooks/post-commit

echo "   ✅ Git hooks installed:"
echo "      • pre-commit    (validates code quality)"
echo "      • commit-msg    (validates commit message format)"
echo "      • post-commit   (reminds to update PROJECT_STATE.md)"
echo ""

# 3. Update .claude/settings.json to register SessionEnd hook
echo "3️⃣  Checking Claude Code hook registration..."

if [ -f ".claude/settings.json" ]; then
  # Check if SessionEnd hook is already registered
  if grep -q "SessionEnd" .claude/settings.json; then
    echo "   ✅ SessionEnd hook already registered"
  else
    echo "   ⚠️  SessionEnd hook not found in settings.json"
    echo "   You may need to manually add it:"
    echo ""
    echo '   "SessionEnd": ['
    echo '     {'
    echo '       "hooks": ['
    echo '         {'
    echo '           "type": "command",'
    echo '           "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/stop-hook.sh"'
    echo '         }'
    echo '       ]'
    echo '     }'
    echo '   ]'
    echo ""
  fi
else
  echo "   ⚠️  .claude/settings.json not found"
fi
echo ""

# 4. Verify installation
echo "4️⃣  Verifying installation..."

VERIFY_ERRORS=0

# Check if hooks are executable
for hook in .git/hooks/pre-commit .git/hooks/commit-msg .git/hooks/post-commit; do
  if [ ! -x "$hook" ]; then
    echo "   ❌ Hook not executable: $hook"
    VERIFY_ERRORS=$((VERIFY_ERRORS + 1))
  fi
done

# Check if hooks are symlinks
for hook in .git/hooks/pre-commit .git/hooks/commit-msg .git/hooks/post-commit; do
  if [ ! -L "$hook" ]; then
    echo "   ⚠️  Hook is not a symlink: $hook"
    echo "      (This is okay, but updates to .claude/hooks/git/ won't auto-apply)"
  fi
done

if [ $VERIFY_ERRORS -eq 0 ]; then
  echo "   ✅ All hooks verified successfully"
else
  echo "   ❌ $VERIFY_ERRORS verification error(s) found"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ HOOK INSTALLATION COMPLETE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Installed hooks:"
echo ""
echo "📍 Session Start Hook"
echo "   • When: Agent starts session"
echo "   • What: Displays PROJECT_STATE.md automatically"
echo "   • File: .claude/hooks/session-start.sh"
echo ""
echo "📍 Pre-Commit Hook"
echo "   • When: Before git commit"
echo "   • What: Validates code quality, runs tests"
echo "   • File: .git/hooks/pre-commit → .claude/hooks/git/pre-commit"
echo ""
echo "📍 Commit-Msg Hook"
echo "   • When: Before git commit"
echo "   • What: Validates commit message format"
echo "   • File: .git/hooks/commit-msg → .claude/hooks/git/commit-msg"
echo ""
echo "📍 Post-Commit Hook"
echo "   • When: After git commit"
echo "   • What: Reminds to update PROJECT_STATE.md (after 5 commits)"
echo "   • File: .git/hooks/post-commit → .claude/hooks/git/post-commit"
echo ""
echo "📍 Session End Hook"
echo "   • When: Agent ends session"
echo "   • What: Validates handover checklist"
echo "   • File: .claude/hooks/stop-hook.sh"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Next steps:"
echo "  1. Try making a commit to test the pre-commit hook"
echo "  2. The session-start hook will run automatically on next session"
echo "  3. The session-end hook will validate before session ends"
echo ""
echo "To uninstall hooks: rm .git/hooks/pre-commit .git/hooks/commit-msg .git/hooks/post-commit"
echo ""
