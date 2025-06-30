CREATE OR REPLACE TABLE json_data (
  raw VARIANT
);

INSERT INTO json_data
VALUES
(PARSE_JSON('{"name": "Jane", "age": 30, "city": "Toronto"}'));

SELECT
  raw:name::STRING AS name,
  raw:age::INT AS age,
  raw:city::STRING AS city
FROM json_data;
