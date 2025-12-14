CREATE TABLE match_types (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now()
);
CREATE TABLE teams (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    country VARCHAR(100),
    contact VARCHAR(100),
    representative_name VARCHAR(100),
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now()
);
CREATE TABLE tournaments (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    year INT NOT NULL,
    location VARCHAR(100),
    winner_team_id INT REFERENCES teams(id),
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now()
);
CREATE TABLE referees (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    date_of_birth DATE,
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now()
);
CREATE TABLE players (
    id SERIAL PRIMARY KEY,
    team_id INT REFERENCES teams(id),
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    date_of_birth DATE,
    position VARCHAR(10),   
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now()
);
CREATE TABLE tournament_participation (
    id SERIAL PRIMARY KEY,
    tournament_id INT REFERENCES tournaments(id),
    team_id INT REFERENCES teams(id),
    place INT,
    points INT,
    goals_for INT,
    goals_against INT,
    reached_phase_id INT REFERENCES match_types(id),
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now()
);
CREATE TABLE matches (
    id SERIAL PRIMARY KEY,
    tournament_id INT REFERENCES tournaments(id),
    match_type_id INT REFERENCES match_types(id),
    home_team_id INT REFERENCES teams(id),
    away_team_id INT REFERENCES teams(id),
    referee_id INT REFERENCES referees(id),
    match_datetime TIMESTAMP,
    home_score INT,
    away_score INT,
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now()
);
CREATE TABLE events (
    id SERIAL PRIMARY KEY,
    match_id INT REFERENCES matches(id),
    event_type VARCHAR(20),
    player_id INT REFERENCES players(id),
    team_id INT REFERENCES teams(id),
    minute INT,    
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now()
);
