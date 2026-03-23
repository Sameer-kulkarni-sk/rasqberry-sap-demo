import { Circuit, ExpectedGate } from '../types/quantum';

/**
 * Validates if the user's circuit matches the expected circuit for a question
 */
export function validateCircuit(
    userCircuit: Circuit,
    expectedGates: ExpectedGate[],
    requiredQubits: number
): { isValid: boolean; message: string; errors: string[] } {
    const errors: string[] = [];

    // Check if circuit has correct number of qubits
    if (userCircuit.qubits !== requiredQubits) {
        errors.push(`Circuit should have ${requiredQubits} qubit(s), but has ${userCircuit.qubits}`);
    }

    // Check if circuit has correct number of gates
    if (userCircuit.gates.length !== expectedGates.length) {
        errors.push(
            `Circuit should have ${expectedGates.length} gate(s), but has ${userCircuit.gates.length}`
        );
    }

    // If basic checks fail, return early
    if (errors.length > 0) {
        return {
            isValid: false,
            message: 'Circuit structure does not match requirements',
            errors,
        };
    }

    // Validate each gate in sequence
    for (let i = 0; i < expectedGates.length; i++) {
        const expected = expectedGates[i];
        const actual = userCircuit.gates[i];

        // Check gate type
        if (actual.type !== expected.type) {
            errors.push(
                `Gate ${i + 1}: Expected ${expected.type} gate, but found ${actual.type}`
            );
            continue;
        }

        // Check single-qubit gate placement
        if (expected.qubit !== undefined) {
            if (actual.qubit !== expected.qubit) {
                errors.push(
                    `Gate ${i + 1}: ${expected.type} should be on qubit ${expected.qubit}, but is on qubit ${actual.qubit}`
                );
            }
        }

        // Check CNOT gate (control and target)
        if (expected.type === 'CNOT') {
            if (expected.control !== undefined && actual.control !== expected.control) {
                errors.push(
                    `Gate ${i + 1}: CNOT control should be qubit ${expected.control}, but is qubit ${actual.control}`
                );
            }
            if (expected.target !== undefined && actual.target !== expected.target) {
                errors.push(
                    `Gate ${i + 1}: CNOT target should be qubit ${expected.target}, but is qubit ${actual.target}`
                );
            }
        }

        // Check rotation gate parameters (if specified)
        if (expected.parameter !== undefined) {
            const tolerance = 0.01; // Allow small numerical differences
            if (
                actual.parameter === undefined ||
                Math.abs(actual.parameter - expected.parameter) > tolerance
            ) {
                errors.push(
                    `Gate ${i + 1}: ${expected.type} parameter should be ${expected.parameter.toFixed(3)}, but is ${actual.parameter?.toFixed(3) || 'undefined'}`
                );
            }
        }
    }

    if (errors.length > 0) {
        return {
            isValid: false,
            message: 'Circuit gates do not match expected configuration',
            errors,
        };
    }

    return {
        isValid: true,
        message: 'Perfect! Your circuit matches the expected solution.',
        errors: [],
    };
}

/**
 * Provides helpful feedback based on the current circuit state
 */
export function getCircuitFeedback(
    userCircuit: Circuit,
    expectedGates: ExpectedGate[],
    requiredQubits: number
): string {
    if (userCircuit.gates.length === 0) {
        return 'Start by dragging gates from the palette onto the circuit.';
    }

    if (userCircuit.qubits < requiredQubits) {
        return `This question requires ${requiredQubits} qubit(s). Adjust the qubit count.`;
    }

    if (userCircuit.gates.length < expectedGates.length) {
        const remaining = expectedGates.length - userCircuit.gates.length;
        return `You need ${remaining} more gate(s). Check the hints for guidance.`;
    }

    if (userCircuit.gates.length > expectedGates.length) {
        const extra = userCircuit.gates.length - expectedGates.length;
        return `You have ${extra} extra gate(s). Try to match the expected circuit exactly.`;
    }

    // Check if gates are in wrong order
    const typeMatches = userCircuit.gates.every(
        (gate, i) => i < expectedGates.length && gate.type === expectedGates[i].type
    );

    if (!typeMatches) {
        return 'The gate types or order do not match. Review the hints and try again.';
    }

    return 'Almost there! Check the gate placements on the qubits.';
}