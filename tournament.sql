-- Table definitions for the tournament project.
--
--

-- Drop and create database
DROP DATABASE IF EXISTS tournament;
CREATE DATABASE tournament;
\c tournament;

-- Create table to store players ID (primary key) and name
CREATE TABLE players (
	id SERIAL,
	name TEXT,
	PRIMARY KEY (id)
);

-- Create table to store matches played. first column - winner_id, second clumn - loser_id
CREATE TABLE matches (
    match_id SERIAL,
	winner_id int NOT NULL,
	loser_id int NOT NULL,	
	FOREIGN KEY (winner_id) REFERENCES players(id),
	FOREIGN KEY (loser_id) REFERENCES players(id),
	PRIMARY KEY (match_id)
);

-- Returns list containing number of matches played by each player
CREATE VIEW playerMatchesCount AS 
    SELECT players.id, coalesce(count_query.matches_played, 0) as matches_played
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
    
-- Returns list containing number of wins by each player    
CREATE VIEW playerWinsCount AS 
    SELECT players.id, COUNT(matches.winner_id) AS wins 
    FROM players
    LEFT JOIN matches
    ON players.id = matches.winner_id
    GROUP BY players.id
    ;
    
-- Returns list of players ordered by number of wins    
CREATE VIEW playerStandings AS 
    SELECT players.id, name, wins, matches_played FROM players
    LEFT JOIN playerWinsCount
    ON players.id = playerWinsCount.id
    LEFT JOIN playerMatchesCount
    ON players.id = playerMatchesCount.id
    ORDER BY wins DESC
    ;

-- Returns list of players ordered by number of wins with each player's position    
CREATE VIEW playerStandingsWithRow AS 
    SELECT ROW_NUMBER() OVER (ORDER BY wins DESC) AS position, id, name, wins, matches_played FROM playerStandings
    ;

-- Returns swiss pairing of players based on player standings   
CREATE VIEW swissPairings AS
    SELECT player1.id AS player1_id, player1.name AS player1_name, player2.id AS player2_id, player2.name AS player2_name
    FROM playerStandingsWithRow AS player1 
    JOIN playerStandingsWithRow AS player2     
    ON player1.position = player2.position - 1 AND player1.position % 2 = 1
    ; 