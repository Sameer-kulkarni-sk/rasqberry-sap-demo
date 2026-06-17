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

            <div className="learning-objectives">
                <h3>Learning Objectives</h3>
                <ul>
                    {question.learningObjectives.map((obj, i) => (
                        <li key={i}>{obj}</li>
                    ))}
                </ul>
            </div>

            <button
                className="btn btn-secondary"
                onClick={onToggleHints}
            >
                {showHints ? '▲ Hide Hints' : '▼ Show Hints'}
            </button>

            {showHints && (
                <div className="hints-section">
                    <div className="hints-title">Hints</div>
                    {question.hints.map((hint, i) => (
                        <div key={i} className="hint-item">
                            <strong>Hint {i + 1}:</strong> {hint}
                        </div>
                    ))}
                </div>
            )}
        </div>
    );
};
