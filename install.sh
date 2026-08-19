#!/usr/bin/env bash
set -e

echo "🚀 Installing AppRinger AI Global Skills & Configurations..."

# 1. Setup Claude Code Global Skills
mkdir -p ~/.claude/skills
cp -r .agents/skills/* ~/.claude/skills/
echo "✅ Claude Code global skills installed in ~/.claude/skills/"

# 2. Setup Antigravity / Gemini CLI Global Skills & Config
mkdir -p ~/.gemini/config/skills ~/.gemini/config/rules
cp -r .agents/skills/* ~/.gemini/config/skills/ 2>/dev/null || true
echo "✅ Antigravity global skills copied to ~/.gemini/config/"

# 3. Add init-agents alias to ~/.zshrc if not present
if ! grep -q "init-agents" ~/.zshrc 2>/dev/null; then
    echo '' >> ~/.zshrc
    echo '# AppRinger AI Agent Initializer' >> ~/.zshrc
    echo 'alias init-agents="cp -r ~/.dotfiles/appringer-ai/.agents ./ && cp -r ~/.dotfiles/appringer-ai/.cursor ./ && cp -r ~/.dotfiles/appringer-ai/.claude ./"' >> ~/.zshrc
    echo "✅ Added 'init-agents' alias to ~/.zshrc"
fi

echo "🎉 Installation complete! You can now use skills globally or type 'init-agents' in any repo."
