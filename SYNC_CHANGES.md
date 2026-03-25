# 🔄 Sync Only Changed Files to RasQberry

## Changed Files to Transfer

Only these files were modified:

1. **package.json** - Fixed duplicate JSON objects error
2. **SHARING_GUIDE.md** - New file created
3. **DEPLOY_TO_RASQBERRY.md** - New file created

---

## Quick Commands (Copy & Paste)

### Transfer Only Changed Files:

```bash
# Transfer the fixed package.json
scp /Users/sameerkulkarni/Desktop/rasqberry-sap-demo/package.json rasqberry@100.67.33.252:~/rasqberry-sap-demo/

# Transfer new documentation files
scp /Users/sameerkulkarni/Desktop/rasqberry-sap-demo/SHARING_GUIDE.md rasqberry@100.67.33.252:~/rasqberry-sap-demo/
scp /Users/sameerkulkarni/Desktop/rasqberry-sap-demo/DEPLOY_TO_RASQBERRY.md rasqberry@100.67.33.252:~/rasqberry-sap-demo/
```

### Then Rebuild on RasQberry:

```bash
# SSH into RasQberry
ssh rasqberry@100.67.33.252

# Navigate to project
cd ~/rasqberry-sap-demo

# Reinstall dependencies (package.json changed)
npm install

# Rebuild the app
npm run build

# Restart the app
./start-app.sh
```

---

## One-Line Command (All at Once)

```bash
scp /Users/sameerkulkarni/Desktop/rasqberry-sap-demo/{package.json,SHARING_GUIDE.md,DEPLOY_TO_RASQBERRY.md} rasqberry@100.67.33.252:~/rasqberry-sap-demo/
```

Then SSH and rebuild:
```bash
ssh rasqberry@100.67.33.252 "cd ~/rasqberry-sap-demo && npm install && npm run build"
```

---

## What Changed?

### package.json
- **Before**: Had duplicate JSON objects (invalid syntax)
- **After**: Single valid JSON structure with merged properties
- **Impact**: npm commands will now work correctly

### New Files
- **SHARING_GUIDE.md**: Guide for sharing project with others
- **DEPLOY_TO_RASQBERRY.md**: Deployment instructions

---

## Verify Changes

After transfer, verify on RasQberry:

```bash
ssh rasqberry@100.67.33.252
cd ~/rasqberry-sap-demo

# Check package.json is valid
cat package.json | head -20

# Check new files exist
ls -la SHARING_GUIDE.md DEPLOY_TO_RASQBERRY.md
```

---

## Quick Copy-Paste (Complete Process)

```bash
# 1. Transfer changed files
scp /Users/sameerkulkarni/Desktop/rasqberry-sap-demo/{package.json,SHARING_GUIDE.md,DEPLOY_TO_RASQBERRY.md} rasqberry@100.67.33.252:~/rasqberry-sap-demo/

# 2. SSH and rebuild
ssh rasqberry@100.67.33.252

# 3. On RasQberry:
cd ~/rasqberry-sap-demo
npm install
npm run build
./start-app.sh
```

Done! ✅