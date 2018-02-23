CREATE SCHEMA `microservice`;
USE `microservice`;
CREATE TABLE greeting (
  id         INTEGER PRIMARY KEY,
  message  VARCHAR(45)  NOT NULL UNIQUE
);INSERT INTO greeting VALUES (1, 'hi');
INSERT INTO greeting VALUES (2, 'hello');
INSERT INTO greeting VALUES (3, 'hola');
INSERT INTO greeting VALUES (4, 'hey');
INSERT INTO greeting VALUES (5, 'whats up?');