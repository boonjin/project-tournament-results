-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.

DROP DATABASE IF EXISTS tournament;

CREATE DATABASE tournament;

\c tournament;

CREATE TABLE players (
	id SERIAL,
	name TEXT,
	PRIMARY KEY (id)
);

CREATE TABLE matches (
	winner_id int NOT NULL,
	loser_id int NOT NULL,	
	PRIMARY KEY (winner_id, loser_id),
	FOREIGN KEY (winner_id) REFERENCES players(id),
	FOREIGN KEY (loser_id) REFERENCES players(id)
);

CREATE VIEW playerMatchesCount AS 
    SELECT players.id, coalesce(count_query.matches_played,0) as matches_played
    FROM players
    LEFT JOIN (
        SELECT players.id, COUNT(players.id) AS matches_played 
        FROM players
        INNER JOIN matches
        ON players.id = matches.winner_id OR players.id = matches.loser_id
        GROUP BY players.id
    ) AS count_query
    ON players.id = count_query.id
    ;
    
CREATE VIEW playerWinsCount AS 
    SELECT players.id, COUNT(matches.winner_id) AS wins 
    FROM players
    LEFT JOIN matches
    ON players.id = matches.winner_id
    GROUP BY players.id
    ;
    
    
CREATE VIEW playerStandings AS 
    SELECT players.id, name, wins, matches_played FROM players
    LEFT JOIN playerWinsCount
    ON players.id = playerWinsCount.id
    LEFT JOIN playerMatchesCount
    ON players.id = playerMatchesCount.id
    ORDER BY wins DESC
    ;