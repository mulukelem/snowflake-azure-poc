SELECT * FROM users;

SELECT name, COUNT(*) AS user_count
FROM users
GROUP BY name
ORDER BY user_count DESC;
