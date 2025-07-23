#!/bin/bash
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

echo "✅ GitHub CLI found: $(gh --version | head -1)"

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

# Create git-ref script
echo "📝 Creating git-ref script..."
cat > ~/.git-ref << 'EOF'
#!/bin/bash
BRANCH=$(git rev-parse --abbrev-ref HEAD)

if [[ $BRANCH =~ ^(feature|bug|hotfix|release)/([A-Z]+-[0-9]+) ]]; then
   git commit "$@" -m "" -m "Refs: $BRANCH"
   echo "✅ Commit created with Refs: $BRANCH"
else
   echo "❌ Branch must match: feature/ABC-123"
   echo "   Current branch: $BRANCH"
fi
EOF

# Make script executable and add alias
chmod +x ~/.git-ref
git config --global alias.ref '!~/.git-ref'

echo ""
echo "🎉 Setup complete!"
echo ""
echo "📋 Available command:"
echo "   git ref -m \"feat: your message\"  → Adds Refs automatically"
echo ""
echo "✅ Ready to use!"