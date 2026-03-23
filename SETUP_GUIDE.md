# RasQberry SAP Demo - Complete Setup Guide

This guide will walk you through setting up the RasQberry SAP Quantum Learning Platform from scratch.

## Prerequisites Check

Before starting, ensure you have:

- [ ] Node.js (v16 or higher) - Check with: `node --version`
- [ ] npm (v7 or higher) - Check with: `npm --version`
- [ ] Git (optional, for cloning qamposer-backend)
- [ ] Python 3.8+ (optional, for qamposer-backend)
- [ ] Poetry (optional, for qamposer-backend)

## Step 1: Install Node.js (if not installed)

### macOS
```bash
# Using Homebrew
brew install node

# Or download from https://nodejs.org/
```

### Windows
Download and install from: https://nodejs.org/

### Linux
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install nodejs npm

# Fedora
sudo dnf install nodejs npm
```

## Step 2: Install Project Dependencies

Navigate to the project directory and install dependencies:

```bash
cd /Users/sameerkulkarni/Desktop/rasqberry-sap-demo

# Install all dependencies
npm install

# This will install:
# - React 18
# - TypeScript
# - @qamposer/react
# - recharts (for visualization)
# - react-dnd (for drag and drop)
# - All other required packages
```

## Step 3: Verify Installation

Check that all dependencies are installed:

```bash
npm list --depth=0
```

You should see all packages listed in package.json.

## Step 4: Run the Application

### Option A: Editor-Only Mode (No Backend Required)

This mode allows circuit editing but limited simulation:

```bash
npm start
```

The application will open at `http://localhost:3000`

### Option B: Full Mode with Backend (Recommended)

For complete quantum simulation capabilities:

#### 4.1: Install Python Dependencies

```bash
# Install Poetry (Python package manager)
curl -sSL https://install.python-poetry.org | python3 -

# Or on macOS with Homebrew
brew install poetry
```

#### 4.2: Clone and Setup Qamposer Backend

Open a new terminal window:

```bash
# Navigate to a suitable directory
cd ~/Desktop

# Clone the backend repository
git clone https://github.com/QAMP-62/qamposer-backend.git
cd qamposer-backend

# Install dependencies
poetry install

# Run the backend server
poetry run uvicorn backend.main:app --host 0.0.0.0 --port 8080 --reload
```

Keep this terminal running!

#### 4.3: Start the React Application

In your original terminal:

```bash
cd /Users/sameerkulkarni/Desktop/rasqberry-sap-demo
npm start
```

The application will now have full simulation capabilities!

## Step 5: Verify Everything Works

1. **Open Browser**: Navigate to `http://localhost:3000`
2. **Check Dashboard**: You should see the statistics dashboard
3. **Try Quantum Composer**: Drag gates onto the circuit
4. **Run Simulation**: Click "Run Simulation" to test
5. **Check Results**: View the histogram of measurement results

## Troubleshooting

### Issue: "npm: command not found"

**Solution**: Node.js is not installed. Follow Step 1.

### Issue: TypeScript errors in IDE

**Solution**: These are expected before running `npm install`. After installation, restart your IDE.

### Issue: Port 3000 already in use

**Solution**: 
```bash
# Kill the process using port 3000
lsof -ti:3000 | xargs kill -9

# Or use a different port
PORT=3001 npm start
```

### Issue: Port 8080 already in use (backend)

**Solution**:
```bash
# Kill the process using port 8080
lsof -ti:8080 | xargs kill -9

# Or change the port in src/components/QuantumComposer.tsx
# Update: adapter={qiskitAdapter('http://localhost:8081')}
```

### Issue: @qamposer/react not loading

**Solution**:
```bash
# Reinstall the package
npm uninstall @qamposer/react
npm install @qamposer/react

# Clear cache and reinstall
npm cache clean --force
rm -rf node_modules package-lock.json
npm install
```

### Issue: Backend connection errors

**Solution**:
1. Verify backend is running: `curl http://localhost:8080/health`
2. Check firewall settings
3. Ensure CORS is enabled in backend
4. The app works in editor-only mode without backend

### Issue: Simulation not showing results

**Solution**:
1. Check browser console for errors (F12)
2. Verify circuit has gates placed
3. Ensure backend is running (if using full mode)
4. Try refreshing the page

## Development Tips

### Hot Reload

The app supports hot reload. Changes to source files will automatically refresh the browser.

### Browser DevTools

Press F12 to open developer tools:
- **Console**: View logs and errors
- **Network**: Check API calls to backend
- **React DevTools**: Install extension for React debugging

### Code Structure

```
src/
├── components/     # React components
├── types/         # TypeScript interfaces
├── utils/         # Helper functions and data
└── styles/        # CSS styling
```

### Making Changes

1. **Add Questions**: Edit `src/utils/questions.ts`
2. **Modify Styling**: Edit `src/styles/App.css`
3. **Update Components**: Edit files in `src/components/`

## Production Build

To create a production build:

```bash
npm run build
```

This creates an optimized build in the `build/` directory.

### Serve Production Build

```bash
# Install serve globally
npm install -g serve

# Serve the build
serve -s build -l 3000
```

## Deployment Options

### Option 1: Static Hosting (Netlify, Vercel)

1. Push code to GitHub
2. Connect repository to Netlify/Vercel
3. Configure build command: `npm run build`
4. Configure publish directory: `build`

### Option 2: Docker

Create a `Dockerfile`:

```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build
RUN npm install -g serve
CMD ["serve", "-s", "build", "-l", "3000"]
EXPOSE 3000
```

Build and run:
```bash
docker build -t rasqberry-sap-demo .
docker run -p 3000:3000 rasqberry-sap-demo
```

### Option 3: Traditional Server

1. Build the app: `npm run build`
2. Copy `build/` directory to server
3. Configure web server (nginx, Apache) to serve static files
4. Point domain to server

## Environment Variables

Create a `.env` file for configuration:

```env
REACT_APP_BACKEND_URL=http://localhost:8080
REACT_APP_MAX_QUBITS=5
REACT_APP_MAX_SHOTS=10000
```

Access in code:
```typescript
const backendUrl = process.env.REACT_APP_BACKEND_URL;
```

## Testing

### Run Tests

```bash
npm test
```

### Add Tests

Create test files with `.test.tsx` extension:

```typescript
import { render, screen } from '@testing-library/react';
import App from './App';

test('renders app title', () => {
  render(<App />);
  const titleElement = screen.getByText(/RasQberry/i);
  expect(titleElement).toBeInTheDocument();
});
```

## Performance Optimization

### Code Splitting

React automatically code-splits. For manual splitting:

```typescript
const Component = React.lazy(() => import('./Component'));
```

### Memoization

Use React.memo for expensive components:

```typescript
export const ExpensiveComponent = React.memo(({ data }) => {
  // Component logic
});
```

## Security Considerations

1. **API Keys**: Never commit API keys to repository
2. **Environment Variables**: Use `.env` for sensitive data
3. **CORS**: Configure backend CORS properly
4. **HTTPS**: Use HTTPS in production
5. **Dependencies**: Regularly update dependencies for security patches

## Getting Help

- **Documentation**: Check README.md
- **Issues**: Check browser console for errors
- **Community**: RasQberry community forums
- **Qamposer**: https://github.com/QAMP-62/qamposer-react

## Next Steps

After setup:

1. Explore the 6 educational questions
2. Try building quantum circuits
3. Customize questions for your use case
4. Add new SAP business contexts
5. Share with students!

## Quick Reference Commands

```bash
# Install dependencies
npm install

# Start development server
npm start

# Build for production
npm run build

# Run tests
npm test

# Start backend (in separate terminal)
cd qamposer-backend
poetry run uvicorn backend.main:app --host 0.0.0.0 --port 8080 --reload
```

---

**Happy Quantum Computing! 🚀**