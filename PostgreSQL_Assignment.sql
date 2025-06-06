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

-- Insert sample data
INSERT INTO
    rangers (ranger_id, name, region)
VALUES (
        1,
        'Alice Green',
        'Northern Hills'
    ),
    (2, 'Bob White', 'River Delta'),
    (
        3,
        'Carol King',
        'Mountain Range'
    );

INSERT INTO
    species (
        species_id,
        common_name,
        scientific_name,
        discovery_date,
        conservation_status
    )
VALUES (
        1,
        'Snow Leopard',
        'Panthera uncia',
        '1775-01-01',
        'Endangered'
    ),
    (
        2,
        'Bengal Tiger',
        'Panthera tigris tigris',
        '1758-01-01',
        'Endangered'
    ),
    (
        3,
        'Red Panda',
        'Ailurus fulgens',
        '1825-01-01',
        'Vulnerable'
    ),
    (
        4,
        'Asiatic Elephant',
        'Elephas maximus indicus',
        '1758-01-01',
        'Endangered'
    );

INSERT INTO
    sightings (
        sighting_id,
        species_id,
        ranger_id,
        location,
        sighting_time,
        notes
    )
VALUES (
        1,
        1,
        1,
        'Peak Ridge',
        '2024-05-10 07:45:00',
        'Camera trap image captured'
    ),
    (
        2,
        2,
        2,
        'Bankwood Area',
        '2024-05-12 16:20:00',
        'Juvenile seen'
    ),
    (
        3,
        3,
        3,
        'Bamboo Grove East',
        '2024-05-15 09:10:00',
        'Feeding observed'
    ),
    (
        4,
        1,
        2,
        'Snowfall Pass',
        '2024-05-18 18:30:00',
        NULL
    );

-- Register new ranger
INSERT INTO
    rangers (name, region)
VALUES ('Derek Fox', 'Coastal Plains');

-- Count unique species sighted
SELECT COUNT(DISTINCT species_id) AS unique_species_count
FROM sightings;

-- Find sightings with "Pass" in location

SELECT * FROM sightings WHERE location ILIKE '%Pass%';

-- List rangers and total sightings
SELECT r.name, COUNT(s.sighting_id) AS total_sightings
FROM rangers r
    LEFT JOIN sightings s ON r.ranger_id = s.ranger_id
GROUP BY
    r.ranger_id,
    r.name
ORDER BY r.name ASC;

-- Species never sighted
SELECT sp.common_name
FROM species sp
    LEFT JOIN sightings s ON sp.species_id = s.species_id
WHERE
    s.sighting_id IS NULL;

-- Most recent 2 sightings
SELECT sp.common_name, s.sighting_time, r.name
FROM
    sightings s
    JOIN species sp ON s.species_id = sp.species_id
    JOIN rangers r ON s.ranger_id = r.ranger_id
ORDER BY s.sighting_time DESC
LIMIT 2;

-- Update species discoverd before 1800
UPDATE species
SET
    conservation_status = 'Historic'
WHERE
    discovery_date < '1800-01-01';

-- Label sighting time of day
SELECT
    sighting_id,
    CASE
        WHEN EXTRACT(
            HOUR
            FROM sighting_time
        ) < 12 THEN 'Morning'
        WHEN EXTRACT(
            HOUR
            FROM sighting_time
        ) >= 12
        AND EXTRACT(
            HOUR
            FROM sighting_time
        ) < 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_of_day
FROM sightings;

-- Delete rangers with no sightings
DELETE FROM rangers
WHERE
    ranger_id NOT IN (
        SELECT DISTINCT
            ranger_id
        FROM sightings
    );