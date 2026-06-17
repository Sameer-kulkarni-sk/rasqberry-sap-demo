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
    const successRate = totalAttempts > 0
        ? Math.round((completedQuestions / totalAttempts) * 100)
        : 0;

    const tiles = [
        {
            label: 'Overall Progress',
            value: `${completionPercentage}%`,
            sub: `${completedQuestions} of ${totalQuestions} completed`,
        },
        {
            label: 'Current Streak',
            value: currentStreak,
            sub: 'Consecutive solved',
        },
        {
            label: 'Total Attempts',
            value: totalAttempts,
            sub: 'Across all questions',
        },
        {
            label: 'Success Rate',
            value: `${successRate}%`,
            sub: 'Questions per attempt',
        },
    ];

    return (
        <div className="dashboard-stats">
            {tiles.map((tile, i) => (
                <div key={i} className="stat-card">
                    <div className="stat-label">{tile.label}</div>
                    <div className="stat-value">{tile.value}</div>
                    <div className="stat-subtext">{tile.sub}</div>
                </div>
            ))}
        </div>
    );
};
