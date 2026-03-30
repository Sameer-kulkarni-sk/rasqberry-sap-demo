# RasQberry SAP Quantum Learning App

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![React](https://img.shields.io/badge/React-18.x-blue.svg)](https://reactjs.org/)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.x-blue.svg)](https://www.typescriptlang.org/)

An interactive quantum computing learning application designed for RasQberry (Raspberry Pi + Qiskit), featuring SAP branding and educational quantum circuit exercises.

## 🚀 One-Line Deployment

Deploy to your RasQberry device with a single command:

```bash
./scripts/deploy_to_rasqberry.sh YOUR_RASQBERRY_IP
```

**Example:**
```bash
./scripts/deploy_to_rasqberry.sh 100.67.33.252
```

That's it! The script will:
- ✅ Transfer all files to RasQberry
- ✅ Install dependencies
- ✅ Build the application
- ✅ Start the server on port 3000
- ✅ Launch browser in kiosk mode

## 📋 Prerequisites

### On Your Computer:
- SSH access to RasQberry
- rsync installed

### On RasQberry:
- Raspberry Pi OS (Bookworm or later)
- Node.js 18+ installed
- SSH enabled
- Network connectivity

## 🎯 Features

- **Interactive Quantum Circuits**: Learn quantum computing through hands-on exercises
- **Educational Content**: Step-by-step quantum gate tutorials
- **Real-time Feedback**: Instant validation of circuit designs
- **SAP Branding**: Professional SAP-themed interface
- **Responsive Design**: Optimized for various screen sizes
- **Kiosk Mode**: Full-screen display for dedicated devices

## 🛠️ Manual Installation

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

## 📱 Access Methods

After deployment, access the app via:

- **Web Browser**: `http://YOUR_RASQBERRY_IP:3000`
- **VNC Viewer**: `YOUR_RASQBERRY_IP:5900`
- **On RasQberry**: Browser opens automatically in kiosk mode

## 🎨 Customization

### Change SAP Logo
Replace `public/sap-logo-new.png` with your logo

### Modify Quantum Exercises
Edit `src/utils/questions.ts` to add/modify quantum circuit challenges

### Adjust Styling
Customize colors and layout in `src/styles/App.css`

## 🧪 Development

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

## 📚 Project Structure

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

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built for [RasQberry](https://github.com/JanLahmann/RasQberry) platform
- Quantum computing education powered by Qiskit concepts
- SAP branding and design guidelines

## 📞 Support

For issues, questions, or contributions:
- Open an issue on GitHub
- Check existing documentation
- Review quantum computing resources

## 🔗 Links

- [RasQberry Project](https://github.com/JanLahmann/RasQberry)
- [Qiskit Documentation](https://qiskit.org/documentation/)
- [React Documentation](https://reactjs.org/)

---

Made with ❤️ for quantum computing education
