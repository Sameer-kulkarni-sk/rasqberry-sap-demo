import { Question } from '../types/quantum';

export const educationalQuestions: Question[] = [
    {
        id: 'q1',
        title: 'Introduction to Superposition in SAP Data Processing',
        description: 'Learn how quantum superposition can revolutionize SAP database queries by processing multiple states simultaneously. Create a simple superposition state using the Hadamard gate.',
        difficulty: 'beginner',
        sapContext: 'In SAP HANA, traditional queries process data sequentially. Quantum superposition allows exploring multiple data paths simultaneously, potentially speeding up complex analytical queries.',
        requiredQubits: 1,
        expectedCircuit: [
            {
                type: 'H',
                qubit: 0
            }
        ],
        hints: [
            'The Hadamard gate (H) creates an equal superposition of |0⟩ and |1⟩ states',
            'Drag the H gate onto qubit 0',
            'This represents exploring two data paths simultaneously in SAP queries'
        ],
        learningObjectives: [
            'Understand quantum superposition concept',
            'Apply Hadamard gate to create superposition',
            'Relate quantum states to parallel data processing in SAP'
        ]
    },
    {
        id: 'q2',
        title: 'Quantum Entanglement for SAP Supply Chain Optimization',
        description: 'Discover how quantum entanglement can model correlated events in SAP supply chain management. Create an entangled state using CNOT gate.',
        difficulty: 'beginner',
        sapContext: 'SAP Supply Chain Management deals with interconnected events. Quantum entanglement models these correlations, where changes in one warehouse instantly affect inventory decisions in another.',
        requiredQubits: 2,
        expectedCircuit: [
            {
                type: 'H',
                qubit: 0
            },
            {
                type: 'CNOT',
                control: 0,
                target: 1
            }
        ],
        hints: [
            'First, create superposition on qubit 0 using Hadamard gate',
            'Then apply CNOT with qubit 0 as control and qubit 1 as target',
            'This creates a Bell state representing perfect correlation'
        ],
        learningObjectives: [
            'Understand quantum entanglement',
            'Use CNOT gate to create entangled states',
            'Model correlated business events in SAP systems'
        ]
    },
    {
        id: 'q3',
        title: 'Phase Manipulation for SAP Financial Risk Analysis',
        description: 'Learn how quantum phase gates can encode complex financial scenarios in SAP. Use Z gate to flip the phase of quantum states.',
        difficulty: 'intermediate',
        sapContext: 'In SAP Financial Services, risk analysis involves evaluating positive and negative scenarios. Quantum phase manipulation allows encoding these opposing scenarios efficiently.',
        requiredQubits: 1,
        expectedCircuit: [
            {
                type: 'H',
                qubit: 0
            },
            {
                type: 'Z',
                qubit: 0
            },
            {
                type: 'H',
                qubit: 0
            }
        ],
        hints: [
            'Start with Hadamard to create superposition',
            'Apply Z gate to flip the phase',
            'End with another Hadamard to see the effect',
            'This sequence demonstrates phase kickback in quantum algorithms'
        ],
        learningObjectives: [
            'Understand quantum phase and its manipulation',
            'Apply Z gate for phase flips',
            'Relate phase to encoding financial scenarios in SAP'
        ]
    },
    {
        id: 'q4',
        title: 'Multi-Qubit Operations for SAP Customer Segmentation',
        description: 'Explore how multi-qubit quantum operations can represent complex customer relationships in SAP CRM. Build a 3-qubit entangled state.',
        difficulty: 'intermediate',
        sapContext: 'SAP Customer Experience Management analyzes relationships between customers, products, and channels. Multi-qubit entanglement models these complex interconnections.',
        requiredQubits: 3,
        expectedCircuit: [
            {
                type: 'H',
                qubit: 0
            },
            {
                type: 'CNOT',
                control: 0,
                target: 1
            },
            {
                type: 'CNOT',
                control: 1,
                target: 2
            }
        ],
        hints: [
            'Create superposition on qubit 0',
            'Entangle qubit 0 with qubit 1 using CNOT',
            'Extend entanglement to qubit 2',
            'This creates a GHZ state representing three-way correlation'
        ],
        learningObjectives: [
            'Work with multi-qubit systems',
            'Create extended entanglement patterns',
            'Model complex business relationships in SAP'
        ]
    },
    {
        id: 'q5',
        title: 'Quantum Interference for SAP Production Planning',
        description: 'Understand how quantum interference can optimize SAP production schedules by canceling inefficient paths. Create an interference pattern.',
        difficulty: 'advanced',
        sapContext: 'SAP Production Planning evaluates multiple manufacturing sequences. Quantum interference amplifies optimal paths while canceling suboptimal ones, similar to Grover\'s algorithm.',
        requiredQubits: 2,
        expectedCircuit: [
            {
                type: 'H',
                qubit: 0
            },
            {
                type: 'H',
                qubit: 1
            },
            {
                type: 'X',
                qubit: 0
            },
            {
                type: 'CNOT',
                control: 0,
                target: 1
            },
            {
                type: 'X',
                qubit: 0
            },
            {
                type: 'H',
                qubit: 0
            },
            {
                type: 'H',
                qubit: 1
            }
        ],
        hints: [
            'Start with Hadamard gates on both qubits for superposition',
            'Apply X gate to flip qubit 0',
            'Use CNOT to create controlled operation',
            'Apply X again to restore qubit 0',
            'End with Hadamard gates to create interference',
            'This pattern demonstrates amplitude amplification'
        ],
        learningObjectives: [
            'Understand quantum interference principles',
            'Combine multiple gates for complex operations',
            'Apply interference to optimization problems in SAP'
        ]
    },
    {
        id: 'q6',
        title: 'Quantum Teleportation Protocol for SAP Data Transfer',
        description: 'Master the quantum teleportation protocol to understand secure data transfer concepts in SAP. Build a simplified teleportation circuit.',
        difficulty: 'advanced',
        sapContext: 'SAP Security and Data Privacy require secure information transfer. Quantum teleportation demonstrates how quantum mechanics enables secure communication protocols.',
        requiredQubits: 3,
        expectedCircuit: [
            {
                type: 'H',
                qubit: 1
            },
            {
                type: 'CNOT',
                control: 1,
                target: 2
            },
            {
                type: 'CNOT',
                control: 0,
                target: 1
            },
            {
                type: 'H',
                qubit: 0
            }
        ],
        hints: [
            'Qubits 1 and 2 form the entangled pair (Bell pair)',
            'Start by creating entanglement between qubits 1 and 2',
            'Qubit 0 is the state to be teleported',
            'Apply CNOT from qubit 0 to qubit 1',
            'Apply Hadamard to qubit 0',
            'This is the first part of the teleportation protocol'
        ],
        learningObjectives: [
            'Understand quantum teleportation protocol',
            'Work with three-qubit systems',
            'Relate quantum communication to SAP security concepts'
        ]
    }
];