import React, { useState, useEffect } from 'react';
import { QamposerMicro } from '@qamposer/react';
import { Circuit, QuestionProgress } from './types/quantum';
import { educationalQuestions } from './utils/questions';
import { validateCircuit, getCircuitFeedback } from './utils/circuitValidator';
import { Dashboard } from './components/Dashboard';
import { QuestionView } from './components/QuestionView';
import './styles/App.css';

function App() {
    const [currentQuestionIndex, setCurrentQuestionIndex] = useState(0);
    const [circuit, setCircuit] = useState<Circuit>({ qubits: 2, gates: [] });
    const [progress, setProgress] = useState<QuestionProgress[]>([]);
    const [validationMessage, setValidationMessage] = useState<string>('');
    const [validationErrors, setValidationErrors] = useState<string[]>([]);
    const [showHints, setShowHints] = useState(false);
    const [attempts, setAttempts] = useState(0);

    const currentQuestion = educationalQuestions[currentQuestionIndex];

    // Initialize progress for all questions
    useEffect(() => {
        const initialProgress = educationalQuestions.map((q) => ({
            questionId: q.id,
            completed: false,
            attempts: 0,
        }));
        setProgress(initialProgress);
    }, []);

    // Update circuit qubits when question changes
    useEffect(() => {
        setCircuit({ qubits: currentQuestion.requiredQubits, gates: [] });
        setValidationMessage('');
        setValidationErrors([]);
        setShowHints(false);
        setAttempts(0);
    }, [currentQuestionIndex, currentQuestion.requiredQubits]);

    const handleCircuitChange = (newCircuit: Circuit) => {
        setCircuit(newCircuit);

        // Provide real-time feedback
        const feedback = getCircuitFeedback(
            newCircuit,
            currentQuestion.expectedCircuit,
            currentQuestion.requiredQubits
        );
        setValidationMessage(feedback);
        setValidationErrors([]);
    };

    const handleCheckSolution = () => {
        const validation = validateCircuit(
            circuit,
            currentQuestion.expectedCircuit,
            currentQuestion.requiredQubits
        );

        setValidationMessage(validation.message);
        setValidationErrors(validation.errors);
        setAttempts(attempts + 1);

        // Update progress
        const updatedProgress = [...progress];
        const questionProgress = updatedProgress.find(
            (p) => p.questionId === currentQuestion.id
        );

        if (questionProgress) {
            questionProgress.attempts = attempts + 1;
            questionProgress.lastAttempt = new Date();

            if (validation.isValid) {
                questionProgress.completed = true;
            }

            setProgress(updatedProgress);
        }

        return validation.isValid;
    };

    const handleNextQuestion = () => {
        const isValid = handleCheckSolution();

        if (isValid) {
            if (currentQuestionIndex < educationalQuestions.length - 1) {
                setCurrentQuestionIndex(currentQuestionIndex + 1);
            }
        }
    };

    const handleQuestionSelect = (index: number) => {
        // Check if question is unlocked
        if (index === 0) {
            setCurrentQuestionIndex(index);
            return;
        }

        // Check if previous question is completed
        const previousQuestionProgress = progress.find(
            (p) => p.questionId === educationalQuestions[index - 1].id
        );

        if (previousQuestionProgress?.completed) {
            setCurrentQuestionIndex(index);
        } else {
            alert('Please complete the previous question first!');
        }
    };

    const handleReset = () => {
        setCircuit({ qubits: currentQuestion.requiredQubits, gates: [] });
        setValidationMessage('');
        setValidationErrors([]);
    };

    // Calculate stats for dashboard
    const completedCount = progress.filter((p) => p.completed).length;
    const totalQuestions = educationalQuestions.length;
    const completionPercentage = Math.round((completedCount / totalQuestions) * 100);
    const totalAttempts = progress.reduce((sum, p) => sum + p.attempts, 0);

    // Check if current question is unlocked
    const isCurrentQuestionUnlocked =
        currentQuestionIndex === 0 ||
        progress.find((p) => p.questionId === educationalQuestions[currentQuestionIndex - 1].id)
            ?.completed;

    return (
        <div className="app">
            <header className="app-header">
                <div className="header-content">
                    <div className="header-logo">
                        <div className="sap-partner-logo">
                            <svg width="180" height="120" viewBox="0 0 180 120" xmlns="http://www.w3.org/2000/svg">
                                <text x="90" y="20" fontFamily="Arial, sans-serif" fontSize="12" fontWeight="300" fill="#999" textAnchor="middle" letterSpacing="2">
                                    TECHNOLOGY
                                </text>
                                <rect x="30" y="30" width="120" height="48" fill="#0070F2" />
                                <text x="90" y="68" fontFamily="Arial, sans-serif" fontSize="42" fontWeight="bold" fill="white" textAnchor="middle">
                                    SAP
                                </text>
                                <text x="156" y="36" fontFamily="Arial, sans-serif" fontSize="8" fontWeight="bold" fill="#0070F2">
                                    TM
                                </text>
                                <text x="90" y="96" fontFamily="Arial, sans-serif" fontSize="11" fontWeight="300" fill="#999" textAnchor="middle" letterSpacing="2">
                                    GLOBAL PARTNER
                                </text>
                                <line x1="30" y1="102" x2="150" y2="102" stroke="#666" strokeWidth="1.5" />
                            </svg>
                        </div>
                    </div>
                    <div className="header-text">
                        <h1>RasQberry SAP Quantum Learning Platform</h1>
                        <p className="subtitle">
                            Explore Quantum Computing Concepts with SAP Business Applications
                        </p>
                    </div>
                </div>
            </header>

            <div className="app-container">
                <Dashboard
                    completedQuestions={completedCount}
                    totalQuestions={totalQuestions}
                    completionPercentage={completionPercentage}
                    currentStreak={completedCount}
                    totalAttempts={totalAttempts}
                />

                <div className="main-content">
                    <div className="question-navigation">
                        {educationalQuestions.map((q, index) => {
                            const questionProgress = progress.find((p) => p.questionId === q.id);
                            const isCompleted = questionProgress?.completed || false;
                            const isUnlocked =
                                index === 0 ||
                                progress.find((p) => p.questionId === educationalQuestions[index - 1].id)
                                    ?.completed ||
                                false;
                            const isCurrent = index === currentQuestionIndex;

                            return (
                                <button
                                    key={q.id}
                                    className={`question-nav-btn ${isCurrent ? 'active' : ''} ${isCompleted ? 'completed' : ''
                                        } ${!isUnlocked ? 'locked' : ''}`}
                                    onClick={() => handleQuestionSelect(index)}
                                    disabled={!isUnlocked}
                                    title={
                                        !isUnlocked
                                            ? 'Complete previous question to unlock'
                                            : q.title
                                    }
                                >
                                    <span className="question-number">Q{index + 1}</span>
                                    {isCompleted && <span className="check-mark">✓</span>}
                                    {!isUnlocked && <span className="lock-icon">🔒</span>}
                                </button>
                            );
                        })}
                    </div>

                    <QuestionView
                        question={currentQuestion}
                        showHints={showHints}
                        onToggleHints={() => setShowHints(!showHints)}
                    />

                    {!isCurrentQuestionUnlocked && (
                        <div className="locked-message">
                            <p>🔒 Complete the previous question to unlock this one!</p>
                        </div>
                    )}

                    {isCurrentQuestionUnlocked && (
                        <>
                            <div className="composer-section">
                                <h3>Quantum Circuit Composer</h3>
                                <p className="composer-instruction">
                                    Drag gates from the palette and drop them on the circuit to build your
                                    solution. The circuit must match the expected configuration exactly.
                                </p>
                                <QamposerMicro
                                    circuit={circuit}
                                    onCircuitChange={handleCircuitChange}
                                    showHeader={false}
                                    defaultTheme="dark"
                                    showThemeToggle={false}
                                    config={{
                                        maxQubits: 5,
                                        maxGates: 20,
                                    }}
                                />
                            </div>

                            <div className="validation-section">
                                {validationMessage && (
                                    <div
                                        className={`validation-message ${validationErrors.length === 0 && attempts > 0
                                            ? 'success'
                                            : 'info'
                                            }`}
                                    >
                                        <p>{validationMessage}</p>
                                        {validationErrors.length > 0 && (
                                            <ul className="error-list">
                                                {validationErrors.map((error, index) => (
                                                    <li key={index}>{error}</li>
                                                ))}
                                            </ul>
                                        )}
                                    </div>
                                )}

                                <div className="action-buttons">
                                    <button onClick={handleReset} className="btn btn-secondary">
                                        Reset Circuit
                                    </button>
                                    <button onClick={handleCheckSolution} className="btn btn-primary">
                                        Check Solution
                                    </button>
                                    {currentQuestionIndex < educationalQuestions.length - 1 && (
                                        <button onClick={handleNextQuestion} className="btn btn-success">
                                            Next Question →
                                        </button>
                                    )}
                                    {currentQuestionIndex === educationalQuestions.length - 1 &&
                                        progress.find((p) => p.questionId === currentQuestion.id)
                                            ?.completed && (
                                            <div className="completion-message">
                                                <p>🎉 Congratulations! You've completed all questions!</p>
                                            </div>
                                        )}
                                </div>

                                {attempts > 0 && (
                                    <p className="attempts-counter">Attempts: {attempts}</p>
                                )}
                            </div>
                        </>
                    )}
                </div>
            </div>

            <footer className="app-footer">
                <p>
                    Built with ❤️ for SAP Education | Powered by{' '}
                    <a
                        href="https://rasqberry.org/"
                        target="_blank"
                        rel="noopener noreferrer"
                    >
                        RasQberry
                    </a>{' '}
                    and{' '}
                    <a
                        href="https://github.com/QAMP-62/qamposer-react"
                        target="_blank"
                        rel="noopener noreferrer"
                    >
                        Qamposer
                    </a>
                </p>
            </footer>
        </div>
    );
}

export default App;