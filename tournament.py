#!/usr/bin/env python
#
# tournament.py -- implementation of a Swiss-system tournament
#

import psycopg2
import bleach


def connect(database_name="tournament"):
    """Connect to the PostgreSQL database.  Returns a database connection
    and cursor."""

    try:
        DB = psycopg2.connect("dbname={}".format(database_name))
        cursor = DB.cursor()
        return DB, cursor
    except:
        print("Error connecting to database")


def deleteMatches():
    """Remove all the match records from the database."""

    DB, c = connect()
    query = "DELETE FROM matches"
    c.execute(query)
    DB.commit()
    DB.close()


def deletePlayers():
    """Remove all the player records from the database."""

    DB, c = connect()
    query = "DELETE FROM players"
    c.execute(query)
    DB.commit()
    DB.close()


def countPlayers():
    """Returns the number of players currently registered."""

    DB, c = connect()
    query = "SELECT COUNT(*) FROM players"
    c.execute(query)
    result = c.fetchone()
    count = result[0]
    DB.close()

    return count


def registerPlayer(name):
    """Adds a player to the tournament database.

    The database assigns a unique serial id number for the player.  (This
    should be handled by your SQL database schema, not in your Python code.)

    Args:
      name: the player's full name (need not be unique).
    """

    DB, c = connect()
    query = "INSERT INTO players (name) VALUES (%s)"
    param = (bleach.clean(name),)
    c.execute(query, param)

    DB.commit()
    DB.close()


def playerStandings():
    """Returns a list of the players and their win records, sorted by wins.
    The first entry in the list should be the player in first place, or a
    player tied for first place if there is currently a tie.

    Returns:
      A list of tuples, each of which contains (id, name, wins, matches):
        id: the player's unique id (assigned by the database)
        name: the player's full name (as registered)
        wins: the number of matches the player has won
        matches: the number of matches the player has played
    """

    DB, c = connect()
    query = "SELECT * FROM playerStandings"
    c.execute(query)
    rows = c.fetchall()

    return rows


def reportMatch(winner, loser):
    """Records the outcome of a single match between two players.

    Args:
      winner:  the id number of the player who won
      loser:  the id number of the player who lost
    """

    DB, c = connect()
    query = "INSERT INTO matches (winner_id, loser_id) VALUES (%s, %s)"
    param = (bleach.clean(winner), bleach.clean(loser),)
    c.execute(query, param)

    DB.commit()
    DB.close()


def swissPairings():
    """Returns a list of pairs of players for the next round of a match.

    Assuming that there are an even number of players registered, each player
    appears exactly once in the pairings.  Each player is paired with another
    player with an equal or nearly-equal win record, that is, a player adjacent
    to him or her in the standings.

    Returns:
      A list of tuples, each of which contains (id1, name1, id2, name2)
        id1: the first player's unique id
        name1: the first player's name
        id2: the second player's unique id
        name2: the second player's name
    """

    DB, c = connect()
    query = "SELECT * FROM swissPairings"
    c.execute(query)
    rows = c.fetchall()

    return rows
