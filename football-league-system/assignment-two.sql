# footballers playing for few teams
SELECT p.name, COUNT(DISTINCT team_id) teams_count
FROM team_squads ts
    JOIN players p on p.id = ts.player_id
GROUP BY player_id
HAVING teams_count > 1
ORDER BY teams_count DESC;

# teams have played more matches at home stadium
SELECT t.name team_name, SUM(is_home = TRUE) home_matches
FROM attendees a
    JOIN teams t on t.id = a.team_id
GROUP BY team_id 
HAVING home_matches > SUM(is_home = FALSE)
ORDER BY home_matches DESC;
