#!/bin/bash
set -euo pipefail

# Session Start Hook for Multi-Agent Coordination
# This hook displays .claude/state/ACTIVE.md to ensure every agent starts with context

# Colors for output (if terminal supports it)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${BOLD}${RED}🚨 SESSION START - MANDATORY READING${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo -e "${BOLD}BEFORE YOU DO ANYTHING:${NC} Read the project state below."
echo "This contains:"
echo "  • What's been completed"
echo "  • What you need to do next"
echo "  • Key decisions from previous agents"
echo "  • Project rules to follow"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Display ACTIVE.md (lean state - only current work)
if [ -f "${CLAUDE_PROJECT_DIR}/.claude/state/ACTIVE.md" ]; then
    cat "${CLAUDE_PROJECT_DIR}/.claude/state/ACTIVE.md"
else
    echo -e "${RED}⚠️  WARNING: ACTIVE.md not found!${NC}"
    echo "Expected location: .claude/state/ACTIVE.md"
    echo "This file tracks current sprint state and coordinates between agents."
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${BOLD}${GREEN}✅ ACKNOWLEDGMENT REQUIRED${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Before proceeding, confirm you have:"
echo "  1. ✅ Read the 'WHAT'S DONE' section (understand current state)"
echo "  2. ✅ Read the 'WHAT'S NEXT' section (understand your task)"
echo "  3. ✅ Read the 'KEY DECISIONS' section (context from past work)"
echo "  4. ✅ Read the 'PROJECT RULES' section (guidelines to follow)"
echo ""
echo -e "${YELLOW}Type to acknowledge:${NC} \"Read ACTIVE.md - working on [your task]\""
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${BOLD}${BLUE}📋 REMINDER: End-of-Session Handover${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Before ending your session, you MUST update ACTIVE.md:"
echo "  • Mark completed work in 'RECENTLY COMPLETED'"
echo "  • Add any decisions to 'KEY DECISIONS'"
echo "  • Update 'NEXT UP' for the next agent"
echo "  • Update 'Last Updated' header"
echo "  • Commit and push your changes"
echo ""
echo "Your handover creates the next agent's starting context!"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo -e "${GREEN}Session start hook complete. Begin when ready.${NC}"
echo ""
