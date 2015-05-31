Tournament Results
==================

Author: Goh Boon Jin

Purpose: Submission for Project 2: Tournament Results

Date: 31st May 2015

### Introduction
This project contains a Python module that uses PostgresSQL database to keep track and matches players in a tournament based on swiss pairings.

The 3 main files are
* `tournament.sql` - contains the database schema and predefined views for the project
* `tournament.py` - python module for the project
* `tournament_test.py` - test suite to check the python module
    
### Requirements
* Vagrant and Virtual Box
* [fullstack-nanodegree-vm](https://github.com/udacity/fullstack-nanodegree-vm)

### Execution
* Run Vagrant VM, 
    * `vagrant up`
    * `vagrant ssh`
* Create and access databse
    * `psql`
    * `\i tournament.sql`
* Run test suite
    * `python tournament_test.py`