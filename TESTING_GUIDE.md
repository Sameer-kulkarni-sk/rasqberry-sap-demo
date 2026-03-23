# Testing Guide - RasQberry SAP Demo

## Quick Test Checklist

### 1. Application Starts Successfully
```bash
cd /Users/sameerkulkarni/Desktop/rasqberry-sap-demo
npm start
```

**Expected Result:**
- Compilation successful
- Browser opens automatically at http://localhost:3000
- No console errors

### 2. Dashboard Loads
**Test:**
- Open http://localhost:3000
- Check that dashboard displays with 4 stat cards

**Expected Result:**
- Progress: 0%
- Average Score: 0%
- Time Spent: 0 minutes
- Current Streak: 0

### 3. Question Navigation
**Test:**
- Click on different question tabs at the top
- Verify each question loads

**Expected Result:**
- 6 question tabs visible
- Questions 1-6 load correctly
- Difficulty badges show (beginner/intermediate/advanced)

### 4. Quantum Circuit Composer
**Test:**
- Click on a gate button (e.g., H gate)
- Click on a circuit slot
- Gate should appear in the slot

**Expected Result:**
- Gate palette shows 7 gates
- Selected gate highlights in blue
- Gate appears when slot is clicked
- Click gate again to remove it

### 5. Hints System
**Test:**
- Click "Show Hints" button
- Verify hints appear

**Expected Result:**
- Hints section expands
- Multiple hints displayed
- Button changes to "Hide Hints"

### 6. Circuit Simulation
**Test:**
- Build a simple circuit (e.g., place H gate on q0)
- Click "Run Simulation"

**Expected Result:**
- Simulation results appear below
- Histogram shows measurement outcomes
- States displayed in binary notation

### 7. Progress Tracking
**Test:**
- Complete a question correctly
- Check dashboard updates

**Expected Result:**
- Completion percentage increases
- Success message appears
- Stats update

### 8. Responsive Design
**Test:**
- Resize browser window
- Test on mobile viewport

**Expected Result:**
- Layout adapts to screen size
- All elements remain accessible
- No horizontal scrolling

## Common Issues and Solutions

### Issue 1: Application Won't Start

**Symptoms:**
- `npm start` fails
- Port already in use

**Solutions:**
```bash
# Kill process on port 3000
lsof -ti:3000 | xargs kill -9

# Or use different port
PORT=3001 npm start
```

### Issue 2: Compilation Errors

**Symptoms:**
- TypeScript errors
- Module not found errors

**Solutions:**
```bash
# Clear cache and reinstall
rm -rf node_modules package-lock.json
npm install

# Restart development server
npm start
```

### Issue 3: Gates Not Placing

**Symptoms:**
- Clicking slots doesn't place gates
- Gates disappear

**Solutions:**
- Ensure a gate is selected (highlighted in blue)
- Check browser console for errors (F12)
- Try refreshing the page

### Issue 4: Simulation Not Running

**Symptoms:**
- "Run Simulation" button doesn't work
- No results appear

**Solutions:**
- Ensure at least one gate is placed
- Check browser console for errors
- Verify circuit is not empty

### Issue 5: Styling Issues

**Symptoms:**
- Colors not showing
- Layout broken

**Solutions:**
- Hard refresh: Cmd+Shift+R (Mac) or Ctrl+Shift+R (Windows)
- Clear browser cache
- Check that App.css is loaded

## Browser Compatibility

### Recommended Browsers:
- ✅ Chrome 90+
- ✅ Firefox 88+
- ✅ Safari 14+
- ✅ Edge 90+

### Known Issues:
- Internet Explorer: Not supported
- Older browsers: May have CSS issues

## Performance Testing

### Expected Performance:
- Initial load: < 3 seconds
- Gate placement: Instant
- Simulation: < 1 second
- Navigation: Instant

### If Slow:
- Check CPU usage
- Close other applications
- Try in incognito mode
- Clear browser cache

## Functional Testing Checklist

### Dashboard
- [ ] All 4 stat cards display
- [ ] Values update correctly
- [ ] Responsive on mobile

### Questions
- [ ] All 6 questions accessible
- [ ] SAP context displays
- [ ] Learning objectives show
- [ ] Difficulty badges correct

### Quantum Composer
- [ ] All 7 gates available
- [ ] Gates can be placed
- [ ] Gates can be removed
- [ ] Reset button works
- [ ] CNOT gate spans 2 qubits

### Simulation
- [ ] Results display correctly
- [ ] Histogram shows bars
- [ ] Probabilities add to 100%
- [ ] Multiple runs give consistent results

### Progress Tracking
- [ ] Completion updates
- [ ] Score calculates correctly
- [ ] Time tracking works
- [ ] Streak increments

### Navigation
- [ ] Previous/Next buttons work
- [ ] Question tabs clickable
- [ ] Active question highlighted
- [ ] Completed questions marked

## Automated Testing

### Run Tests:
```bash
npm test
```

### Expected Output:
- All tests pass
- No errors or warnings

## Debugging Tips

### Enable Debug Mode:
1. Open browser DevTools (F12)
2. Go to Console tab
3. Look for log messages

### Common Console Messages:
- "Circuit updated:" - Normal, shows circuit changes
- "Simulation completed:" - Normal, shows results
- Errors in red - Need investigation

### Check Network:
1. Open DevTools Network tab
2. Reload page
3. Verify all resources load (200 status)

## Manual Test Scenarios

### Scenario 1: Complete First Question
1. Read Question 1
2. Click "Show Hints"
3. Place H gate on q0
4. Click "Run Simulation"
5. Verify results show 50/50 split
6. Check success message

### Scenario 2: Navigate Questions
1. Start at Question 1
2. Click "Next Question"
3. Verify Question 2 loads
4. Click question tab for Question 3
5. Verify Question 3 loads
6. Click "Previous Question"
7. Verify Question 2 loads

### Scenario 3: Build Complex Circuit
1. Go to Question 6 (Advanced)
2. Place H gate on q0
3. Place H gate on q1
4. Place CNOT gate (spans q0 and q1)
5. Place T gate on q0
6. Click "Run Simulation"
7. Verify results display

### Scenario 4: Reset and Retry
1. Build any circuit
2. Click "Run Simulation"
3. Click "Reset Circuit"
4. Verify circuit clears
5. Build new circuit
6. Verify works correctly

## Reporting Issues

If you find issues:

1. **Check browser console** (F12)
2. **Note the steps to reproduce**
3. **Take a screenshot**
4. **Check this guide for solutions**

### Issue Template:
```
**Issue:** [Brief description]
**Steps to Reproduce:**
1. [Step 1]
2. [Step 2]
3. [Step 3]

**Expected:** [What should happen]
**Actual:** [What actually happens]
**Browser:** [Chrome/Firefox/Safari/Edge]
**Console Errors:** [Any errors from F12 console]
```

## Success Criteria

Application is working correctly if:
- ✅ All 6 questions load
- ✅ Gates can be placed and removed
- ✅ Simulations run and show results
- ✅ Progress tracking updates
- ✅ Navigation works smoothly
- ✅ No console errors
- ✅ Responsive on different screen sizes

## Next Steps After Testing

1. **If all tests pass:** Application is ready for students
2. **If issues found:** Use troubleshooting section
3. **For customization:** See README.md
4. **For deployment:** Run `npm run build`

---

**Need Help?** Check the other documentation files:
- QUICKSTART.md - Getting started
- SETUP_GUIDE.md - Detailed setup
- README.md - Complete documentation
- SECURITY_NOTES.md - Security information