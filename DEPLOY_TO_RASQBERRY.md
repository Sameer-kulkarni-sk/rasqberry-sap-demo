# 🚀 Deploy to RasQberry at 100.67.33.252

## Quick Deployment Commands

Run these commands from your computer (in the project directory):

### Step 1: Transfer the Project

```bash
# Transfer the entire project to RasQberry
scp -r /Users/sameerkulkarni/Desktop/rasqberry-sap-demo rasqberry@100.67.33.252:~/

# You'll be prompted for the password (default: Qoffee42)
```

### Step 2: SSH into RasQberry

```bash
ssh rasqberry@100.67.33.252
```

### Step 3: Install and Run (on RasQberry)

```bash
cd ~/rasqberry-sap-demo
./install-on-rasqberry.sh
```

---

## Alternative: Transfer Only Changed Files

If you already have the project on RasQberry and only want to update specific files:

### Transfer only the fixed package.json:
```bash
scp /Users/sameerkulkarni/Desktop/rasqberry-sap-demo/package.json rasqberry@100.67.33.252:~/rasqberry-sap-demo/
```

### Transfer the new SHARING_GUIDE.md:
```bash
scp /Users/sameerkulkarni/Desktop/rasqberry-sap-demo/SHARING_GUIDE.md rasqberry@100.67.33.252:~/rasqberry-sap-demo/
```

### Then rebuild on RasQberry:
```bash
ssh rasqberry@100.67.33.252
cd ~/rasqberry-sap-demo
npm install
npm run build
```

---

## Verify Transfer

After transferring, verify the files on RasQberry:

```bash
ssh rasqberry@100.67.33.252
cd ~/rasqberry-sap-demo
ls -la
cat package.json  # Check if package.json is correct
```

---

## Troubleshooting

### If SCP fails with "Connection refused":
```bash
# On RasQberry, ensure SSH is running:
sudo systemctl start ssh
sudo systemctl enable ssh
```

### If you get "Permission denied":
- Default password is: `Qoffee42`
- Or check with your RasQberry administrator

### If transfer is slow:
```bash
# Use compression for faster transfer:
scp -C -r /Users/sameerkulkarni/Desktop/rasqberry-sap-demo rasqberry@100.67.33.252:~/
```

---

## What Gets Transferred

The complete project including:
- ✅ Fixed `package.json` (no more duplicate JSON error)
- ✅ All source code (`src/` directory)
- ✅ Public assets (`public/` directory)
- ✅ Installation scripts (`install-on-rasqberry.sh`, `start-app.sh`)
- ✅ Desktop launcher (`sap-quantum-learning.desktop`)
- ✅ Documentation (README.md, QUICKSTART.md, SHARING_GUIDE.md)
- ✅ Configuration files (tsconfig.json, .gitignore)

---

## After Deployment

Once transferred and installed, the app will be available:

1. **Desktop Icon**: Double-click "SAP Quantum Learning" on RasQberry desktop
2. **Browser**: Open http://localhost:3000
3. **Manual Start**: Run `./start-app.sh` in the project directory

---

## Quick Copy-Paste Commands

```bash
# Full deployment (run from your Mac):
scp -r /Users/sameerkulkarni/Desktop/rasqberry-sap-demo rasqberry@100.67.33.252:~/
ssh rasqberry@100.67.33.252
cd ~/rasqberry-sap-demo
./install-on-rasqberry.sh
```

That's it! 🎉