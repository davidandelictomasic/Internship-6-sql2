-- #1
EXPLAIN ANALYZE
SELECT
    t.name AS tournament_name,
    t.year,
    t.location,
    tm.name AS winner_team
FROM tournaments t
LEFT JOIN teams tm ON tm.id = t.winner_team_id
ORDER BY t.year;
-- "Execution Time: 0.197 ms"

-- #2
EXPLAIN ANALYZE
SELECT
    tm.name AS team_name,
    tm.representative_name
FROM tournament_participation tp
JOIN teams tm ON tm.id = tp.team_id
WHERE tp.tournament_id = 10;
-- "Execution Time: 0.311 ms"

-- #3
EXPLAIN ANALYZE
SELECT
    p.first_name,
    p.last_name,
    p.date_of_birth,
    p.position
FROM players p
WHERE p.team_id = 5;
-- "Execution Time: 0.574 ms"

-- #4
EXPLAIN ANALYZE
SELECT
    m.match_datetime,
    ht.name AS home_team,
    at.name AS away_team,
    mt.name AS match_type,
    m.home_score,
    m.away_score
FROM matches m
JOIN teams ht ON ht.id = m.home_team_id
JOIN teams at ON at.id = m.away_team_id
JOIN match_types mt ON mt.id = m.match_type_id
WHERE m.tournament_id = 10
ORDER BY m.match_datetime;
-- "Execution Time: 1.675 ms"

-- #5
EXPLAIN ANALYZE
SELECT
    m.match_datetime,
    ht.name AS home_team,
    at.name AS away_team,
    mt.name AS match_type,
    m.home_score,
    m.away_score
FROM matches m
JOIN teams ht ON ht.id = m.home_team_id
JOIN teams at ON at.id = m.away_team_id
JOIN match_types mt ON mt.id = m.match_type_id
WHERE m.home_team_id = 5 OR m.away_team_id = 5
ORDER BY m.match_datetime;
-- "Execution Time: 2.034 ms"

-- #6
EXPLAIN ANALYZE
SELECT
    e.event_type,
    p.first_name || ' ' || p.last_name AS player_name,
    t.name AS team_name,
    e.minute
FROM events e
JOIN players p ON p.id = e.player_id
JOIN teams t ON t.id = e.team_id
WHERE e.match_id = 100
ORDER BY e.minute;
-- "Execution Time: 1.270 ms"

-- #7
EXPLAIN ANALYZE
SELECT
    p.first_name || ' ' || p.last_name AS player_name,
    t.name AS team_name,
    e.match_id,
    e.minute,
    e.event_type
FROM events e
JOIN players p ON p.id = e.player_id
JOIN teams t ON t.id = e.team_id
JOIN matches m ON m.id = e.match_id
WHERE e.event_type IN ('YELLOW_CARD','RED_CARD')
  AND m.tournament_id = 10
ORDER BY e.minute;
-- "Execution Time: 6.559 ms"

-- #8
EXPLAIN ANALYZE
SELECT
    p.first_name || ' ' || p.last_name AS player_name,
    t.name AS team_name,
    COUNT(*) AS goals
FROM events e
JOIN players p ON p.id = e.player_id
JOIN teams t ON t.id = e.team_id
JOIN matches m ON m.id = e.match_id
WHERE e.event_type = 'GOAL'
  AND m.tournament_id = 10
GROUP BY p.id, t.id;
-- "Execution Time: 2.706 ms"

-- #9
EXPLAIN ANALYZE
SELECT
    t.name AS team_name,
    tp.points,
    tp.goals_for - tp.goals_against AS goal_difference,
    tp.place
FROM tournament_participation tp
JOIN teams t ON t.id = tp.team_id
WHERE tp.tournament_id = 10
ORDER BY tp.place;
-- "Execution Time: 0.634 ms"

-- #10
EXPLAIN ANALYZE
SELECT
    m.match_datetime,
    ht.name AS home_team,
    at.name AS away_team,
    m.home_score,
    m.away_score,
    CASE
        WHEN m.home_score > m.away_score THEN ht.name
        WHEN m.away_score > m.home_score THEN at.name
        ELSE 'Draw'
    END AS winner
FROM matches m
JOIN teams ht ON ht.id = m.home_team_id
JOIN teams at ON at.id = m.away_team_id
JOIN match_types mt ON mt.id = m.match_type_id
WHERE mt.name = 'Final'
ORDER BY m.match_datetime;
-- "Execution Time: 2.291 ms"

-- #11
EXPLAIN ANALYZE
SELECT
    mt.name AS match_type,
    COUNT(*) AS match_count
FROM matches m
JOIN match_types mt ON mt.id = m.match_type_id
GROUP BY mt.name
ORDER BY match_count DESC;
-- "Execution Time: 2.882 ms"

-- #12
EXPLAIN ANALYZE
SELECT
    ht.name AS home_team,
    at.name AS away_team,
    mt.name AS match_type,
    m.home_score,
    m.away_score
FROM matches m
JOIN teams ht ON ht.id = m.home_team_id
JOIN teams at ON at.id = m.away_team_id
JOIN match_types mt ON mt.id = m.match_type_id
WHERE m.match_datetime::date = '2024-12-17'
ORDER BY m.match_datetime;
-- "Execution Time: 0.828 ms"

-- #13
EXPLAIN ANALYZE
SELECT
    p.first_name || ' ' || p.last_name AS player_name,
    t.name AS team_name,
    COUNT(*) AS goals
FROM events e
JOIN players p ON p.id = e.player_id
JOIN teams t ON t.id = e.team_id
JOIN matches m ON m.id = e.match_id
WHERE e.event_type = 'GOAL'
  AND m.tournament_id = 10
GROUP BY p.id, t.id;
-- "Execution Time: 3.860 ms"

-- #14
EXPLAIN ANALYZE
SELECT
    t.name AS tournament_name,
    t.year,
    tp.place
FROM tournament_participation tp
JOIN tournaments t ON t.id = tp.tournament_id
WHERE tp.team_id = 501
ORDER BY t.year;
-- "Execution Time: 0.128 ms"

-- #15
EXPLAIN ANALYZE
SELECT
    t.name AS team_name,
    SUM(tp.points) AS total_points
FROM tournament_participation tp
JOIN teams t ON t.id = tp.team_id
JOIN matches m ON m.tournament_id = tp.tournament_id
WHERE m.match_type_id = (SELECT id FROM match_types WHERE name = 'Final')
GROUP BY t.id
ORDER BY total_points DESC
LIMIT 1;
-- "Execution Time: 8.806 ms"

-- #16
EXPLAIN ANALYZE
SELECT
    t.name AS tournament_name,
    COUNT(DISTINCT tp.team_id) AS team_count,
    COUNT(DISTINCT p.id) AS player_count
FROM tournaments t
JOIN tournament_participation tp ON tp.tournament_id = t.id
JOIN players p ON p.team_id = tp.team_id
GROUP BY t.id;
-- "Execution Time: 7.988 ms"

-- #17
EXPLAIN ANALYZE
SELECT DISTINCT ON (t.id)
    t.name AS team_name,
    p.first_name || ' ' || p.last_name AS top_scorer,
    COUNT(e.id) AS goals
FROM events e
JOIN players p ON p.id = e.player_id
JOIN teams t ON t.id = e.team_id
WHERE e.event_type = 'GOAL'
GROUP BY t.id, t.name, p.id, p.first_name, p.last_name;
-- "Execution Time: 9.653 ms"

-- #18
EXPLAIN ANALYZE
SELECT
    ht.name AS home_team,
    at.name AS away_team,
    mt.name AS match_type,
    m.home_score,
    m.away_score,
    m.match_datetime
FROM matches m
JOIN teams ht ON ht.id = m.home_team_id
JOIN teams at ON at.id = m.away_team_id
JOIN match_types mt ON mt.id = m.match_type_id
WHERE m.referee_id = 5
ORDER BY m.match_datetime;
-- "Execution Time: 0.958 ms"