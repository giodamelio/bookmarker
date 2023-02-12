.mode box
.nullvalue NULL

DROP TABLE IF EXISTS folder;
CREATE TABLE folder (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  parent INTEGER REFERENCES folder
);

DROP TABLE IF EXISTS bookmark;
CREATE TABLE bookmark (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  parent INTEGER REFERENCES folder
);

-- Create root folder and initial bookmarks
INSERT INTO folder (title) VALUES ("Root");
INSERT INTO bookmark (title, parent) VALUES ("Bookmark 1", (SELECT id FROM folder WHERE title="Root"));
INSERT INTO bookmark (title, parent) VALUES ("Bookmark 2", (SELECT id FROM folder WHERE title="Root"));

-- Create subfolder and subbookmarks
INSERT INTO folder (title, parent) VALUES ("Subfolder", (SELECT id FROM folder WHERE title="Root"));
INSERT INTO bookmark (title, parent) VALUES ("SubBookmark 1", (SELECT id FROM folder WHERE title="Subfolder"));
INSERT INTO bookmark (title, parent) VALUES ("SubBookmark 2", (SELECT id FROM folder WHERE title="Subfolder"));

-- Query all child bookmarks of a folder
WITH RECURSIVE
  child_of(n) AS (
    SELECT * FROM bookmark WHERE parent = n
    UNION ALL
    SELECT * FROM
  )

-- SELECT * FROM bookmark; SELECT * FROM folder;
