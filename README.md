# RasQberry SAP Quantum Learning App

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![React](https://img.shields.io/badge/React-18.x-blue.svg)](https://reactjs.org/)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.x-blue.svg)](https://www.typescriptlang.org/)

An interactive quantum computing learning application designed for RasQberry (Raspberry Pi + Qiskit), featuring SAP branding and educational quantum circuit exercises.

## Quick Deployment

### Step 1: Install Node.js on RasQberry (First Time Only)

If Node.js is not installed on your RasQberry, run this first:

```bash
./scripts/install_nodejs_rasqberry.sh YOUR_RASQBERRY_IP
```

This will install Node.js and npm on your RasQberry device.

**Example:**
```bash
./scripts/install_nodejs_rasqberry.sh 100.67.33.242
```

### Step 2: Deploy Application

Deploy with a single command:

```bash
./scripts/deploy_to_rasqberry.sh YOUR_RASQBERRY_IP
```

**Example:**
```bash
./scripts/deploy_to_rasqberry.sh 100.67.33.242
```


## Features

- **Interactive Quantum Circuits**: Learn quantum computing through hands-on exercises
- **Educational Content**: Step-by-step quantum gate tutorials
- **Real-time Feedback**: Instant validation of circuit designs
- **SAP Branding**: Professional SAP-themed interface
- **Responsive Design**: Optimized for various screen sizes
- **Kiosk Mode**: Full-screen display for dedicated devices



## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.



## Support

For issues, questions, or contributions:
- Open an issue on GitHub
- Check existing documentation
- Review quantum computing resources


