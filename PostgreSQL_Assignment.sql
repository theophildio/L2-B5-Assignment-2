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

CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(50) NOT NULL,
    scientific_name VARCHAR(100) NOT NULL,
    discovery_date DATE NOT NULL,
    conservation_status VARCHAR(50) NOT NULL
);

CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    ranger_id INT REFERENCES rangers (ranger_id),
    species_id INT REFERENCES species (species_id),
    location VARCHAR(150) NOT NULL,
    sighting_time TIMESTAMP NOT NULL,
    notes TEXT
);