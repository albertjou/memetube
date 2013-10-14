CREATE TABLE videos (
  id SERIAL4 PRIMARY KEY,
  title TEXT,
  url TEXT,
  genre TEXT
);

INSERT INTO videos (title, url, genre) VALUES ('Cat Man Do','www.youtube.com/embed/w0ffwDYo00Q','Animation');
INSERT INTO videos (title, url, genre) VALUES ('Mirror Mirror','www.youtube.com/embed/G5FUH3eoizc','Animation');