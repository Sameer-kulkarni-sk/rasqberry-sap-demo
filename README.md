# RasQberry SAP Quantum Learning App

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![React](https://img.shields.io/badge/React-18.x-blue.svg)](https://reactjs.org/)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.x-blue.svg)](https://www.typescriptlang.org/)

An interactive quantum computing learning application designed for RasQberry (Raspberry Pi + Qiskit), featuring SAP branding and educational quantum circuit exercises.

## Quick Deployment

Deploy to your RasQberry device with a single command:

```bash
./scripts/deploy_to_rasqberry.sh YOUR_RASQBERRY_IP
```

**Example:**
```bash
./scripts/deploy_to_rasqberry.sh 100.67.33.252
```

The deployment script will automatically:
- Transfer all files to RasQberry
- Install dependencies
- Build the application
- Start the server on port 3000
- Launch browser in kiosk mode

## Prerequisites

### On Your Computer:
- SSH access to RasQberry
- rsync installed

### On RasQberry:
- Raspberry Pi OS (Bookworm or later)
- Node.js 18+ installed
- SSH enabled
- Network connectivity

## Features

- **Interactive Quantum Circuits**: Learn quantum computing through hands-on exercises
- **Educational Content**: Step-by-step quantum gate tutorials
- **Real-time Feedback**: Instant validation of circuit designs
- **SAP Branding**: Professional SAP-themed interface
- **Responsive Design**: Optimized for various screen sizes
- **Kiosk Mode**: Full-screen display for dedicated devices

## Manual Installation

If you prefer manual setup:

### 1. Clone the Repository
```bash
git clone https://github.com/YOUR_USERNAME/rasqberry-sap-demo.git
cd rasqberry-sap-demo
```

### 2. Install Dependencies
```bash
npm install
```

### 3. Build the Application
```bash
npm run build
```

### 4. Start the Server
```bash
npm install -g serve
serve -s build -l 3000
```

### 5. Access the App
Open your browser to: `http://localhost:3000`

## Access Methods

After deployment, access the app via:

- **Web Browser**: `http://YOUR_RASQBERRY_IP:3000`
- **VNC Viewer**: `YOUR_RASQBERRY_IP:5900`
- **On RasQberry**: Browser opens automatically in kiosk mode

## Customization

### Change SAP Logo
Replace `public/sap-logo-new.png` with your logo

### Modify Quantum Exercises
Edit `src/utils/questions.ts` to add or modify quantum circuit challenges

### Adjust Styling
Customize colors and layout in `src/styles/App.css`

## Development

### Start Development Server
```bash
npm start
```

### Run Tests
```bash
npm test
```

### Build for Production
```bash
npm run build
```

## Project Structure

```
rasqberry-sap-demo/
├── scripts/
│   └── deploy_to_rasqberry.sh    # One-line deployment script
├── src/
│   ├── components/                # React components
│   ├── utils/                     # Utility functions
│   ├── styles/                    # CSS styles
│   └── types/                     # TypeScript types
├── public/                        # Static assets
├── package.json                   # Dependencies
└── README.md                      # This file
```

## Contributing

Contributions are welcome. Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.



## Support

For issues, questions, or contributions:
- Open an issue on GitHub
- Check existing documentation
- Review quantum computing resources


