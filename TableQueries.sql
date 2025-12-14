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

