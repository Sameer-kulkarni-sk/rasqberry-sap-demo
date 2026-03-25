# RasQberry SAP Quantum Learning Platform

An educational quantum computing platform designed for SAP, built with React and integrated with RasQberry. This interactive application teaches quantum computing concepts through hands-on circuit building with real SAP business context.


##  Features

- **Interactive Quantum Circuit Composer** - Drag-and-drop interface for building quantum circuits
- **Educational Questions** - Progressive learning path from beginner to advanced
- **SAP Business Context** - Real-world SAP use cases for each quantum concept
- **Real-time Validation** - Instant feedback on circuit correctness
- **Progress Tracking** - Monitor your learning journey
- **Desktop Application** - Native-like experience on RasQberry

## Quick Start

### Super Easy Installation

On your RasQberry, run:

```bash
# Clone from GitHub
git clone https://github.com/Sameer-kulkarni-sk/rasqberry-sap-demo.git
cd rasqberry-sap-demo

# Run one-command installer
./install-on-rasqberry.sh
```

That's it! The installer does everything automatically.

**Then:** Double-click the desktop icon to launch!

### Detailed Installation

See [INSTALL.md](INSTALL.md) for:
- Step-by-step manual installation
- Alternative installation methods
- Troubleshooting guide
- System requirements

### Running the Application

**Option 1:** Double-click the desktop icon (easiest!)

**Option 2:** Run `./start-app.sh`

**Option 3:** Run `serve -s build -l 3000`

Access at: http://localhost:3000

## 📚 Learning Path

The platform includes 6 progressive questions:

1. **Superposition** (Beginner) - SAP Data Processing
2. **Entanglement** (Beginner) - Supply Chain Optimization
3. **Phase Manipulation** (Intermediate) - Financial Risk Analysis
4. **Multi-Qubit Operations** (Intermediate) - Customer Segmentation
5. **Quantum Interference** (Advanced) - Production Planning
6. **Quantum Teleportation** (Advanced) - Secure Data Transfer

Each question includes:
- Clear learning objectives
- SAP business context
- Interactive circuit builder
- Hints and guidance
- Real-time validation

## 🛠️ Development

### Project Structure

```
rasqberry-sap-demo/
├── public/                 # Static assets
├── src/
│   ├── components/        # React components
│   ├── types/            # TypeScript type definitions
│   ├── utils/            # Utility functions
│   └── styles/           # CSS styles
├── start-app.sh          # Application launcher
├── sap-quantum-learning.desktop  # Desktop icon
└── app-icon.png          # Application icon
```

### Available Scripts

- `npm start` - Run development server
- `npm run build` - Build for production
- `npm test` - Run tests

### Technologies Used

- **React 18** - UI framework
- **TypeScript** - Type safety
- **@qamposer/react** - Quantum circuit composer
- **Recharts** - Data visualization

##  Educational Concepts

### Quantum Gates Covered

- **H (Hadamard)** - Creates superposition
- **X (Pauli-X)** - Bit flip / NOT gate
- **Y (Pauli-Y)** - Bit and phase flip
- **Z (Pauli-Z)** - Phase flip
- **CNOT** - Controlled-NOT / Entanglement
- **T Gate** - π/4 phase shift
- **S Gate** - π/2 phase shift

### SAP Integration Concepts

- Parallel data processing (HANA)
- Supply chain correlations
- Financial risk modeling
- Customer relationship analysis
- Production optimization
- Secure data transfer

##  Troubleshooting

### Port Already in Use

```bash
fuser -k 3000/tcp
```

### Desktop Icon Not Working

```bash
chmod +x ~/rasqberry-sap-demo/start-app.sh
chmod +x ~/Desktop/sap-quantum-learning.desktop
gio set ~/Desktop/sap-quantum-learning.desktop metadata::trusted true
```

### Build Fails

```bash
# Clear cache and rebuild
rm -rf node_modules package-lock.json
npm install
npm run build
```

### Browser Doesn't Open

Manually open: http://localhost:3000

## 📖 Documentation

- `QUICKSTART.md` - Quick setup guide
- `IMPLEMENTATION_SUMMARY.md` - Technical implementation details
- `SECURITY_NOTES.md` - Security considerations
- `TESTING_GUIDE.md` - Testing instructions

##  Contributing

This is an educational project for SAP and RasQberry integration. Contributions are welcome!

## License

Educational use for SAP and RasQberry demonstrations.

## 🔗 Resources

- [RasQberry Project](https://rasqberry.org/)
- [Qiskit Documentation](https://qiskit.org/documentation/)
- [SAP Learning Hub](https://learning.sap.com/)
- [Qamposer React](https://github.com/QAMP-62/qamposer-react)

##  Support

For issues or questions:
1. Check the troubleshooting section
2. Review the documentation files
3. Consult RasQberry community resources

---
