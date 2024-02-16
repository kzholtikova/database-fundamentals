use football_system;

# 3 matches with the most goals scored
SELECT venue, t1.team_name, t2.team_name, home_score + away_score as total_goals
FROM football_matches m
    INNER JOIN teams t1 on m.home_team_id = t1.team_id
    INNER JOIN teams t2 on m.away_team_id = t2.team_id
ORDER BY total_goals DESC, venue
LIMIT 3;

# top player from the team scored the greatest number of goals
SELECT p.player_name, COUNT(g.goal_id) goals_scored
FROM goals g
    INNER JOIN players p on g.player_id = p.player_id
WHERE p.team_id = (SELECT team_id FROM standing ORDER BY goals_for LIMIT 1)
GROUP BY g.player_id
ORDER BY goals_scored DESC
LIMIT 1;

# average goals scored in each league
SELECT l.league_name, l.league_position, ROUND(AVG(s.goals_for)) avg_goals_scored
FROM standing s
    INNER JOIN leagues l on s.league_id = l.league_id
GROUP BY s.league_id
ORDER BY avg_goals_scored DESC;

# stadium with the least goals scored over all matches
SELECT venue, SUM(home_score + away_score) total_goals
FROM football_matches m
GROUP BY venue
ORDER BY total_goals
LIMIT 5;

# venues played in count for each team
SELECT t.team_name, COUNT(DISTINCT m.venue) as venues_count
FROM football_matches m
    JOIN teams t ON m.home_team_id = t.team_id OR m.away_team_id = t.team_id
GROUP BY t.team_id
HAVING venues_count > 1
ORDER BY venues_count DESC;
