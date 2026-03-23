import React from 'react';
import { Question } from '../types/quantum';

interface QuestionViewProps {
    question: Question;
    onToggleHints: () => void;
    showHints: boolean;
}

export const QuestionView: React.FC<QuestionViewProps> = ({
    question,
    onToggleHints,
    showHints
}) => {
    return (
        <div className="question-section">
            <div className="question-header">
                <h2 className="question-title">{question.title}</h2>
                <span className={`difficulty-badge difficulty-${question.difficulty}`}>
                    {question.difficulty}
                </span>
            </div>

            <p className="question-description">{question.description}</p>

            <div className="sap-context">
                <div className="sap-context-title">SAP Business Context</div>
                <p className="sap-context-text">{question.sapContext}</p>
            </div>

            <div style={{
                backgroundColor: 'var(--sap-gray-1)',
                padding: '1rem',
                borderRadius: '8px',
                marginBottom: '1rem'
            }}>
                <h3 style={{ fontSize: '1rem', marginBottom: '0.75rem', fontWeight: 600 }}>
                    Learning Objectives:
                </h3>
                <ul style={{ paddingLeft: '1.5rem', lineHeight: '1.8' }}>
                    {question.learningObjectives.map((objective, index) => (
                        <li key={index}>{objective}</li>
                    ))}
                </ul>
            </div>

            <button
                className="btn btn-secondary"
                onClick={onToggleHints}
                style={{ marginTop: '1rem' }}
            >
                {showHints ? 'Hide Hints' : 'Show Hints'}
            </button>

            {showHints && (
                <div className="hints-section">
                    <h3 className="hints-title">Hints</h3>
                    {question.hints.map((hint, index) => (
                        <div key={index} className="hint-item">
                            <strong>Hint {index + 1}:</strong> {hint}
                        </div>
                    ))}
                </div>
            )}
        </div>
    );
};