-- Create the database
CREATE DATABASE conservation_db;

-- Drop tables if they already exists
DROP TABLE IF EXISTS rangers;

DROP TABLE IF EXISTS sightings;

DROP TABLE IF EXISTS species;

-- Create TABLES
CREATE TABLE rangers (
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    region VARCHAR(100) NOT NULL
);