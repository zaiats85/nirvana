#!/bin/bash
# setup-git-aliases.sh
# Run once to install custom git commands

echo "🚀 Setting up custom git commands..."

# Check if gh CLI is available (improved detection)
if ! which gh >/dev/null 2>&1; then
    echo "❌ GitHub CLI (gh) not found!"
    echo ""
    echo "📋 Please install GitHub CLI first:"
    echo "   🔗 https://github.com/cli/cli#installation"
    echo ""
    echo "💡 Quick install options:"
    echo "   Windows: winget install GitHub.cli"
    echo "   macOS:   brew install gh"
    echo "   Linux:   sudo apt install gh"
    echo ""
    echo "❌ Setup cancelled. Install gh first and run this script again."
    exit 1
fi

echo "✅ GitHub CLI found!: $(gh --version | head -1)"

# Check if user is authenticated with GitHub
if ! gh auth status >/dev/null 2>&1; then
    echo "⚠️  GitHub CLI found but not authenticated"
    echo "🔑 Please login to GitHub first:"
    echo "   gh auth login"
    echo ""
    read -p "Do you want to login now? (y/N): " login_now
    if [[ $login_now =~ ^[Yy]$ ]]; then
        gh auth login
        if ! gh auth status >/dev/null 2>&1; then
            echo "❌ Authentication failed. Please try again."
            exit 1
        fi
    else
        echo "❌ Setup cancelled. Login required for 'git ai' command."
        exit 1
    fi
fi

echo "✅ GitHub CLI authenticated"

# Add bash-forced aliases
git config --global alias.ref '!bash -c "f() {
    BRANCH=\$(git rev-parse --abbrev-ref HEAD);
    if [[ \$BRANCH =~ ^(feature|bug|hotfix|release)/([A-Z]+-[0-9]+) ]]; then
        git commit \"\$@\" -m \"\" -m \"Refs: \$BRANCH\";
    else
        echo \"❌ Branch must match: feature/ABC-123\";
    fi;
}; f \"\$@\"" -'

git config --global alias.ai '!bash -c "f() {
    BRANCH=\$(git rev-parse --abbrev-ref HEAD);
    if [[ \$BRANCH =~ ^(feature|bug|hotfix|release)/([A-Z]+-[0-9]+) ]]; then
        MSG=\$(gh copilot suggest \"Create a conventional commit message for these staged changes. Format: type: description. One line only.\" 2>/dev/null | grep -E \"^(feat|fix|docs|style|refactor|perf|test|build|ci|chore):\" | head -1);
        if [[ -n \"\$MSG\" ]]; then
            git commit -m \"\$MSG\" -m \"\" -m \"Refs: \$BRANCH\";
            echo \"✅ Created: \$MSG\";
            echo \"✅ Added: Refs: \$BRANCH\";
        else
            echo \"❌ Copilot failed. Use: git ref -m \\\"your message\\\"\";
        fi;
    else
        echo \"❌ Branch must match: feature/ABC-123\";
    fi;
}; f \"\$@\"" -'