-- Maak schema aan indien deze nog niet bestaat.
-- StringFilter vult actuele schema naam in.
DROP SCHEMA IF EXISTS {schema} CASCADE;
CREATE SCHEMA {schema};
