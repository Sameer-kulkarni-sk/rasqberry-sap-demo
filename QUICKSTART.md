# Quick Start Guide - RasQberry SAP Quantum Learning Platform

Get up and running in 5 minutes!

## 🎯 For RasQberry Users

### Step 1: Transfer Project to RasQberry

From your computer:
```bash
scp -r rasqberry-sap-demo rasqberry@100.67.33.252:~/
```

Or use a USB drive to copy the folder.

### Step 2: Install Dependencies

SSH into RasQberry:
```bash
ssh rasqberry@100.67.33.252
cd ~/rasqberry-sap-demo
npm install
```

### Step 3: Build the Application

```bash
npm run build
```

This creates the production-ready app in the `build/` folder.

### Step 4: Install Serve

```bash
sudo npm install -g serve
```

### Step 5: Setup Desktop Icon

```bash
cd ~/rasqberry-sap-demo
cp sap-quantum-learning.desktop ~/Desktop/
chmod +x ~/Desktop/sap-quantum-learning.desktop
gio set ~/Desktop/sap-quantum-learning.desktop metadata::trusted true
```

### Step 6: Launch!

**Double-click the desktop icon** or run:
```bash
./start-app.sh
```

The app opens at: http://localhost:3000

## 🚀 Quick Commands

```bash
# Start the app
cd ~/rasqberry-sap-demo
./start-app.sh

# Or manually
serve -s build -l 3000

# Stop the app
fuser -k 3000/tcp

# View logs
tail -f ~/rasqberry-sap-demo/app.log
```

## 📱 Using the Application

1. **Start with Question 1** - Introduction to Superposition
2. **Read the SAP Context** - Understand the business application
3. **Build Your Circuit** - Drag gates from the palette
4. **Check Solution** - Get instant feedback
5. **Use Hints** - If you get stuck
6. **Progress** - Complete all 6 questions!

## 🎓 Learning Tips

- **Read carefully** - Each question has specific requirements
- **Use hints** - They guide you step-by-step
- **Experiment** - Try different gate combinations
- **Understand SAP context** - See real-world applications
- **Track progress** - Dashboard shows your achievements

## 🔧 Troubleshooting

### Port 3000 in use?
```bash
fuser -k 3000/tcp
```

### Desktop icon not working?
```bash
chmod +x ~/rasqberry-sap-demo/start-app.sh
chmod +x ~/Desktop/sap-quantum-learning.desktop
```

### Build failed?
```bash
rm -rf node_modules
npm install
npm run build
```

### Browser doesn't open?
Manually go to: http://localhost:3000

## 📊 What You'll Learn

- ✅ Quantum superposition
- ✅ Quantum entanglement
- ✅ Phase manipulation
- ✅ Multi-qubit operations
- ✅ Quantum interference
- ✅ Quantum teleportation

All with **real SAP business applications**!

## 🎯 Success Checklist

- [ ] Project transferred to RasQberry
- [ ] Dependencies installed (`npm install`)
- [ ] Application built (`npm run build`)
- [ ] Serve installed globally
- [ ] Desktop icon created
- [ ] App launches successfully
- [ ] Can access at http://localhost:3000
- [ ] All 6 questions visible
- [ ] Circuit composer works
- [ ] Validation provides feedback

## 🆘 Need Help?

1. Check `README.md` for detailed documentation
2. Review `IMPLEMENTATION_SUMMARY.md` for technical details
3. See `TESTING_GUIDE.md` for testing instructions
4. Visit [RasQberry.org](https://rasqberry.org/) for community support

## 🎉 You're Ready!

Start learning quantum computing with SAP business context!

**Happy Learning! 🚀**