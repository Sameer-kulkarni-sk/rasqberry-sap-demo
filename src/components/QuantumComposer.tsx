import React, { useState, useEffect } from 'react';
import { QuantumGate, GateType } from '../types/quantum';

interface QuantumComposerProps {
    numQubits: number;
    onCircuitChange: (gates: QuantumGate[]) => void;
    onSimulationComplete?: (result: any) => void;
}

const availableGates: { type: GateType; name: string; description: string }[] = [
    { type: 'H', name: 'Hadamard', description: 'Creates superposition' },
    { type: 'X', name: 'Pauli-X', description: 'Bit flip (NOT gate)' },
    { type: 'Y', name: 'Pauli-Y', description: 'Bit and phase flip' },
    { type: 'Z', name: 'Pauli-Z', description: 'Phase flip' },
    { type: 'CNOT', name: 'CNOT', description: 'Controlled-NOT' },
    { type: 'T', name: 'T Gate', description: 'π/4 phase shift' },
    { type: 'S', name: 'S Gate', description: 'π/2 phase shift' },
];

const QuantumComposer: React.FC<QuantumComposerProps> = ({
    numQubits,
    onCircuitChange,
}) => {
    const [circuit, setCircuit] = useState<QuantumGate[][]>(
        Array(numQubits).fill(null).map(() => [])
    );
    const [selectedGate, setSelectedGate] = useState<GateType | null>(null);

    const maxGatesPerQubit = 8;

    useEffect(() => {
        const flatCircuit = circuit.flat().filter(gate => gate !== null);
        onCircuitChange(flatCircuit);
    }, [circuit, onCircuitChange]);

    const handleGateClick = (gateType: GateType) => {
        setSelectedGate(selectedGate === gateType ? null : gateType);
    };

    const handleQubitClick = (qubitIndex: number, slotIndex: number) => {
        if (!selectedGate) return;

        const newCircuit = [...circuit.map(row => [...row])];

        if (selectedGate === 'CNOT') {
            if (qubitIndex < numQubits - 1) {
                const gate: QuantumGate = {
                    id: `gate-${Date.now()}`,
                    type: selectedGate,
                    name: 'CNOT',
                    description: 'Controlled-NOT',
                    qubits: [qubitIndex, qubitIndex + 1]
                };

                while (newCircuit[qubitIndex].length <= slotIndex) {
                    newCircuit[qubitIndex].push(null as any);
                }
                while (newCircuit[qubitIndex + 1].length <= slotIndex) {
                    newCircuit[qubitIndex + 1].push(null as any);
                }

                newCircuit[qubitIndex][slotIndex] = gate;
                newCircuit[qubitIndex + 1][slotIndex] = gate;
            }
        } else {
            const gate: QuantumGate = {
                id: `gate-${Date.now()}`,
                type: selectedGate,
                name: availableGates.find(g => g.type === selectedGate)?.name || selectedGate,
                description: availableGates.find(g => g.type === selectedGate)?.description || '',
                qubits: [qubitIndex]
            };

            while (newCircuit[qubitIndex].length <= slotIndex) {
                newCircuit[qubitIndex].push(null as any);
            }
            newCircuit[qubitIndex][slotIndex] = gate;
        }

        setCircuit(newCircuit);
        setSelectedGate(null);
    };

    const handleRemoveGate = (qubitIndex: number, slotIndex: number) => {
        const newCircuit = [...circuit.map(row => [...row])];
        const gate = newCircuit[qubitIndex][slotIndex];

        if (gate && gate.type === 'CNOT') {
            gate.qubits.forEach(q => {
                const idx = newCircuit[q].findIndex(g => g && g.id === gate.id);
                if (idx !== -1) {
                    newCircuit[q][idx] = null as any;
                }
            });
        } else {
            newCircuit[qubitIndex][slotIndex] = null as any;
        }

        setCircuit(newCircuit);
    };

    const handleReset = () => {
        setCircuit(Array(numQubits).fill(null).map(() => []));
        setSelectedGate(null);
    };

    const renderGateSlot = (qubitIndex: number, slotIndex: number) => {
        const gate = circuit[qubitIndex][slotIndex];
        const isSelected = selectedGate !== null;

        return (
            <div
                key={`slot-${qubitIndex}-${slotIndex}`}
                className={`gate-slot ${gate ? 'filled' : ''} ${isSelected ? 'selectable' : ''}`}
                onClick={() => {
                    if (gate) {
                        handleRemoveGate(qubitIndex, slotIndex);
                    } else if (isSelected) {
                        handleQubitClick(qubitIndex, slotIndex);
                    }
                }}
                title={gate ? `${gate.name} - Click to remove` : 'Click to place gate'}
            >
                {gate && gate.type}
            </div>
        );
    };

    return (
        <div className="composer-section">
            <h2 className="composer-title">Quantum Circuit Composer</h2>

            <div style={{
                padding: '1rem',
                backgroundColor: 'var(--sap-light-blue)',
                borderRadius: '8px',
                marginBottom: '1rem',
                fontSize: '0.9rem'
            }}>
                <strong>Instructions:</strong> Select a gate from the palette below, then click on a circuit slot to place it.
                Click on a placed gate to remove it.
            </div>

            <div className="gate-palette">
                {availableGates.map(gate => (
                    <button
                        key={gate.type}
                        className={`gate-button ${selectedGate === gate.type ? 'selected' : ''}`}
                        onClick={() => handleGateClick(gate.type)}
                        title={gate.description}
                        style={{
                            backgroundColor: selectedGate === gate.type ? 'var(--sap-blue)' : 'white',
                            color: selectedGate === gate.type ? 'white' : 'var(--sap-blue)'
                        }}
                    >
                        <span>{gate.type}</span>
                        <span className="gate-name">{gate.name}</span>
                    </button>
                ))}
            </div>

            {selectedGate && (
                <div style={{
                    padding: '1rem',
                    backgroundColor: 'var(--sap-light-blue)',
                    borderRadius: '8px',
                    marginBottom: '1rem',
                    textAlign: 'center',
                    fontWeight: 600
                }}>
                    Selected: <strong>{availableGates.find(g => g.type === selectedGate)?.name}</strong>
                    {' - '}Click on a circuit slot to place the gate
                </div>
            )}

            <div className="circuit-canvas">
                {Array(numQubits).fill(null).map((_, qubitIndex) => (
                    <div key={`qubit-${qubitIndex}`} className="qubit-line">
                        <div className="qubit-label">q{qubitIndex}</div>
                        <div className="qubit-wire">
                            {Array(maxGatesPerQubit).fill(null).map((_, slotIndex) =>
                                renderGateSlot(qubitIndex, slotIndex)
                            )}
                        </div>
                    </div>
                ))}
            </div>

            <div className="control-buttons">
                <button className="btn btn-secondary" onClick={handleReset}>
                    Reset Circuit
                </button>
            </div>

            <div style={{
                marginTop: '1.5rem',
                padding: '1rem',
                backgroundColor: 'var(--sap-gray-1)',
                borderRadius: '8px',
                fontSize: '0.85rem'
            }}>
                <strong>Note:</strong> This is a standalone quantum circuit builder.
                For integration with the Qamposer library, you can install <code>@qamposer/react</code> when it becomes available.
            </div>
        </div>
    );
};

export { QuantumComposer };
export default QuantumComposer;