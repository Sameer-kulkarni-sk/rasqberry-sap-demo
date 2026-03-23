# Installing Node.js and npm

The RasQberry SAP Demo requires Node.js and npm to run. Here's how to install them on macOS:

## Option 1: Using Homebrew (Recommended)

### Step 1: Install Homebrew (if not already installed)
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Step 2: Install Node.js
```bash
brew install node
```

### Step 3: Verify Installation
```bash
node --version
npm --version
```

You should see version numbers like:
```
v18.x.x
9.x.x
```

## Option 2: Direct Download

1. Visit: https://nodejs.org/
2. Download the **LTS (Long Term Support)** version for macOS
3. Run the installer (.pkg file)
4. Follow the installation wizard
5. Restart your terminal

### Verify Installation
```bash
node --version
npm --version
```

## Option 3: Using nvm (Node Version Manager)

### Step 1: Install nvm
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
```

### Step 2: Restart Terminal or Run
```bash
source ~/.zshrc  # or ~/.bash_profile
```

### Step 3: Install Node.js
```bash
nvm install --lts
nvm use --lts
```

### Step 4: Verify
```bash
node --version
npm --version
```

## After Installation

Once Node.js and npm are installed, navigate to the project and install dependencies:

```bash
cd /Users/sameerkulkarni/Desktop/rasqberry-sap-demo
npm install
npm start
```

## Troubleshooting

### "npm: command not found" after installation

**Solution 1**: Restart your terminal completely (close and reopen)

**Solution 2**: Check your PATH
```bash
echo $PATH
```

The path should include `/usr/local/bin` or similar where npm is installed.

**Solution 3**: Add to PATH manually
```bash
# For zsh (default on macOS)
echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# For bash
echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bash_profile
source ~/.bash_profile
```

### Permission Errors

If you get permission errors when running npm:

```bash
# Fix npm permissions
sudo chown -R $(whoami) ~/.npm
sudo chown -R $(whoami) /usr/local/lib/node_modules
```

### Checking if Node.js is Already Installed

```bash
which node
which npm
```

If these commands return paths, Node.js is already installed.

## Next Steps

After successful installation:

1. Navigate to project: `cd /Users/sameerkulkarni/Desktop/rasqberry-sap-demo`
2. Install dependencies: `npm install`
3. Start the app: `npm start`

The application will open at `http://localhost:3000`

---

**Need Help?** Check the SETUP_GUIDE.md for more detailed instructions.