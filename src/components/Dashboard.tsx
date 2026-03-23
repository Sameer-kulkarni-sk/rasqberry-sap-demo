import React from 'react';

interface DashboardProps {
    completedQuestions: number;
    totalQuestions: number;
    completionPercentage: number;
    currentStreak: number;
    totalAttempts: number;
}

export const Dashboard: React.FC<DashboardProps> = ({
    completedQuestions,
    totalQuestions,
    completionPercentage,
    currentStreak,
    totalAttempts
}) => {
    return (
        <div className="dashboard-stats">
            <div className="stat-card">
                <div className="stat-label">Progress</div>
                <div className="stat-value">{completionPercentage}%</div>
                <div className="stat-subtext">
                    {completedQuestions} of {totalQuestions} completed
                </div>
            </div>

            <div className="stat-card">
                <div className="stat-label">Current Streak</div>
                <div className="stat-value">{currentStreak}</div>
                <div className="stat-subtext">
                    Consecutive questions solved
                </div>
            </div>

            <div className="stat-card">
                <div className="stat-label">Total Attempts</div>
                <div className="stat-value">{totalAttempts}</div>
                <div className="stat-subtext">
                    Across all questions
                </div>
            </div>

            <div className="stat-card">
                <div className="stat-label">Success Rate</div>
                <div className="stat-value">
                    {totalAttempts > 0 ? Math.round((completedQuestions / totalAttempts) * 100) : 0}%
                </div>
                <div className="stat-subtext">
                    Questions solved per attempt
                </div>
            </div>
        </div>
    );
};