// Import types from @qamposer/react
import { Circuit as QamposerCircuit, Gate as QamposerGate } from '@qamposer/react';

// Re-export for convenience
export type Circuit = QamposerCircuit;
export type Gate = QamposerGate;

// Gate types
export type GateType = 'H' | 'X' | 'Y' | 'Z' | 'CNOT' | 'T' | 'S' | 'RX' | 'RY' | 'RZ';

// Quantum Gate interface for the composer
export interface QuantumGate {
    id: string;
    type: GateType;
    name: string;
    description: string;
    qubits: number[];
    parameter?: number;
}

// Question-specific types
export interface ExpectedGate {
    type: string;
    qubit?: number;
    control?: number;
    target?: number;
    parameter?: number;
}

export interface Question {
    id: string;
    title: string;
    description: string;
    difficulty: 'beginner' | 'intermediate' | 'advanced';
    sapContext: string;
    expectedCircuit: ExpectedGate[];
    requiredQubits: number;
    hints: string[];
    learningObjectives: string[];
}

export interface QuestionProgress {
    questionId: string;
    completed: boolean;
    attempts: number;
    lastAttempt?: Date;
}

export interface SimulationResult {
    counts: Record<string, number>;
    execution_time: number;
}