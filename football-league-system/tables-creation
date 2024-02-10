CREATE SCHEMA football_system;
USE football_system;

CREATE TABLE leagues
(
    league_id INT AUTO_INCREMENT PRIMARY KEY,
    league_name VARCHAR(100) NOT NULL,
    league_position INT NOT NULL,
    min_points_number INT NOT NULL
);

CREATE TABLE teams
(
    team_id INT AUTO_INCREMENT PRIMARY KEY,
    team_name VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    stadium VARCHAR(100),
    manager VARCHAR(100) NOT NULL
);

CREATE TABLE players
(
    player_id INT AUTO_INCREMENT PRIMARY KEY,
    team_id INT,
    player_name VARCHAR(100) NOT NULL,
    birthdate DATE NOT NULL,
    nationality VARCHAR(50),
    player_position VARCHAR(50) NOT NULL,
    player_number INT NOT NULL,
    FOREIGN KEY (team_id) REFERENCES teams (team_id)
);

CREATE TABLE football_matches
(
    match_id INT AUTO_INCREMENT PRIMARY KEY,
    match_date DATE NOT NULL,
    match_time TIME NOT NULL,
    venue VARCHAR(100) NOT NULL,
    home_team_id INT,
    away_team_id INT, 
    home_score INT,
    away_score INT,
    FOREIGN KEY (home_team_id) REFERENCES teams (team_id),
    FOREIGN KEY (away_team_id) REFERENCES teams (team_id)
);

CREATE TABLE goals
(
    goal_id INT AUTO_INCREMENT PRIMARY KEY,
    match_id INT,
    player_id INT,
    FOREIGN KEY (match_id) REFERENCES football_matches (match_id),
    FOREIGN KEY (player_id) REFERENCES players (player_id)
);

CREATE TABLE standing
(
    standing_id INT AUTO_INCREMENT PRIMARY KEY,
    league_id INT,
    team_id INT,
    position INT NOT NULL,
    points INT NOT NULL,
    played INT NOT NULL,
    won INT NOT NULL,
    drawn INT NOT NULL,
    lost INT NOT NULL,
    goals_for INT NOT NULL,
    goals_against INT NOT NULL,
    goal_difference INT NOT NULL,
    FOREIGN KEY (team_id) REFERENCES teams (team_id),
    FOREIGN KEY (league_id) REFERENCES leagues (league_id)
);

INSERT INTO leagues (league_name, league_position)
VALUES ('Premier League', 1),
       ('UEFA Champions League', 2),
       ('National League', 3),
       ('Ukrainian Premier League', 4),
       ('La Liga', 5);





# find ID gaps
SELECT
    t1.match_id + 1 AS start_range,
    MIN(t2.match_id - 1) AS end_range
FROM
    football_matches t1
        LEFT JOIN
    football_matches t2 ON t1.match_id < t2.match_id
WHERE
    t2.match_id IS NOT NULL
GROUP BY
    t1.match_id + 1
HAVING
    start_range < MIN(t2.match_id);



# Create a stored procedure to generate random goals
DELIMITER //

CREATE PROCEDURE GenerateRandomGoals()
BEGIN
    DECLARE i INT DEFAULT 0;

    -- Loop to insert 5000 records
    WHILE i < 5000 DO
            -- Randomly select a match
            SET @match_id := (SELECT match_id FROM football_matches ORDER BY RAND() LIMIT 1);

            -- Randomly select a player from the home or away team of the match
            SET @player_id := (SELECT player_id
                               FROM players
                               WHERE team_id IN (SELECT home_team_id FROM football_matches WHERE match_id = @match_id)
                                  OR team_id IN (SELECT away_team_id FROM football_matches WHERE match_id = @match_id)
                               ORDER BY RAND() LIMIT 1);

            -- Insert the goal record
            INSERT INTO goals (match_id, player_id) VALUES (@match_id, @player_id);

            -- Increment the counter
            SET i = i + 1;
        END WHILE;
END //

DELIMITER ;

-- Call the stored procedure to generate random goals
CALL GenerateRandomGoals();



# fill in the scores for matches
UPDATE football_matches fm
SET home_score = (
    SELECT COUNT(*)
    FROM goals AS g
        JOIN players AS p ON g.player_id = p.player_id
    WHERE g.match_id = fm.match_id AND p.team_id = fm.home_team_id
);

UPDATE football_matches fm
SET away_score = (
    SELECT COUNT(*)
    FROM goals AS g
             JOIN players AS p ON g.player_id = p.player_id
    WHERE g.match_id = fm.match_id
      AND p.team_id = fm.away_team_id
);



# fill in standings table
INSERT INTO standing (team_id, position, points, played, won, drawn, lost, goals_for, goals_against, goal_difference)
SELECT
    t.team_id,
    0 AS position,  -- Placeholder for now
    0 AS points,
    0 AS played,
    0 AS won,
    0 AS drawn,
    0 AS lost,
    0 AS goals_for,
    0 AS goals_against,
    0 AS goal_difference
FROM teams t;

UPDATE standing s
SET 
    s.won = (SELECT COUNT(match_id)
            FROM football_matches
            WHERE (home_team_id = s.team_id and home_score > away_score) 
            OR (away_team_id = s.team_id and away_score > home_score)),
    s.drawn = (SELECT COUNT(match_id)
               FROM football_matches
               WHERE (home_team_id = s.team_id or away_team_id = s.team_id) and home_score = away_score),
    s.lost = (SELECT COUNT(match_id)
              FROM football_matches
              WHERE (home_team_id = s.team_id and home_score < away_score)
                 OR (away_team_id = s.team_id and away_score < home_score)),
    s.played = s.won + s.drawn + s.lost,
    s.goals_for = (SELECT COUNT(*)
                   FROM goals g
                   JOIN players p on p.player_id = g.player_id
                   WHERE p.team_id = s.team_id),
    s.goals_against = (SELECT COUNT(*)
                       FROM goals g
                           JOIN football_matches fm ON g.match_id = fm.match_id
                           JOIN players p ON g.player_id = p.player_id
                       WHERE p.team_id != s.team_id
                       AND (fm.home_team_id = s.team_id OR fm.away_team_id = s.team_id)),
    s.goal_difference = s.goals_for - s.goals_against,
    s.points = (3 * s.won) + s.drawn,
    s.league_id = (SELECT l.league_id
                   FROM leagues l
                   WHERE s.points >= l.min_points_number
                   ORDER BY min_points_number DESC
                   LIMIT 1);


# chatgpt to rank over leagues by points
UPDATE standing AS s
    JOIN (
        SELECT
            s1.standing_id,
            COUNT(*) AS rank_within_league
        FROM standing s1
                 JOIN standing s2 ON s1.league_id = s2.league_id
        WHERE (
                  s2.points > s1.points
                      OR (s2.points = s1.points AND s2.goal_difference > s1.goal_difference)
                      OR (s2.points = s1.points AND s2.goal_difference = s1.goal_difference AND s2.goals_for > s1.goals_for)
                      OR (s2.points = s1.points AND s2.goal_difference = s1.goal_difference AND s2.goals_for = s1.goals_for AND s2.team_id < s1.team_id)
                  )
        GROUP BY s1.standing_id
    ) AS ranks ON s.standing_id = ranks.standing_id
SET s.position = ranks.rank_within_league + 1;
