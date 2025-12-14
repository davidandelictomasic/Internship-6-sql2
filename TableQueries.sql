EXPLAIN ANALYZE
SELECT
    t.name AS tournament_name,
    t.year,
    t.location,
    tm.name AS winner_team
FROM tournaments t
LEFT JOIN teams tm ON tm.id = t.winner_team_id
ORDER BY t.year;
