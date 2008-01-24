-- Drop unnecessary tables
DROP TABLE blogs; -- I only have one blog
DROP TABLE schema_info; -- Don't need rails' schema info
DROP TABLE sessions; -- Don't need browser session info
DROP TABLE text_filters; -- I only use textile
DROP TABLE triggers; -- Empty table
DROP TABLE users; -- I'm the only user
DROP TABLE pings; -- A record of pings we sent to other sites seems pointless
DROP TABLE resources; -- Empty table
DROP TABLE redirects; -- Empty table
DROP TABLE page_caches; -- Empty table
DROP TABLE notifications; -- A record of when we notified the user, me, for each article seems pointless
DROP TABLE categories; -- Empty table
DROP TABLE blacklist_patterns; -- Empty table
DROP TABLE articles_categories; -- Empty table
DROP TABLE sidebars; -- Contains the fact that we want to display archives and the html snippet to display the subscribe to rss button
DROP TABLE excerpts; -- I think I created this table to contain the distinct excerpts from trackbacks

-- Remove unnecessary columns
ALTER TABLE contents DROP COLUMN extended; -- Empty column
ALTER TABLE contents DROP COLUMN allow_pings; -- Useless info
ALTER TABLE contents DROP COLUMN allow_comments; -- Useless info
ALTER TABLE contents DROP COLUMN whiteboard; -- Empty column
ALTER TABLE contents DROP COLUMN text_filter_id; -- All articles use textile
ALTER TABLE contents DROP COLUMN blog_id; -- I only have one blog
ALTER TABLE contents DROP COLUMN user_id; -- I only have one user
ALTER TABLE contents DROP COLUMN extended_html; -- Empty column
ALTER TABLE tags DROP COLUMN created_at; -- I don't use this in any of my templates
ALTER TABLE tags DROP COLUMN updated_at; -- I don't use this in any of my templates
ALTER TABLE tags DROP COLUMN display_name; -- I use name rather than display_name

-- Split articles out from the contents table and remove some now unnecessary columns
CREATE TABLE articles (id INTEGER, title VARCHAR(255), author VARCHAR(255), body TEXT, keywords VARCHAR(255), guid VARCHAR(255), published_at DATETIME);
INSERT INTO articles SELECT id, title, author, body, keywords, guid, published_at FROM contents WHERE type = 'Article';
DELETE FROM contents WHERE type = 'Article';
ALTER TABLE contents DROP COLUMN keywords;
ALTER TABLE contents DROP COLUMN permalink;

-- Split pages out from the contents table and remove some now unecessary columns
-- Although all (five) of my pages are accessible on the web, only one was published (and therefore had a published_at value) - hence me ignoring the published* columns
CREATE TABLE pages (id INTEGER, title VARCHAR(255), body TEXT, created_at DATETIME, updated_at DATETIME, name VARCHAR(255));
INSERT INTO pages SELECT id, title, body, created_at, updated_at, name FROM contents WHERE type = 'page';
DELETE FROM contents WHERE type = 'page';
ALTER TABLE contents DROP COLUMN name;

-- Split trackbacks out from the contents table and remove some now unnecessary columns
CREATE TABLE trackbacks (id INTEGER, title VARCHAR(255), excerpt TEXT, article_id INTEGER, url VARCHAR(255), ip VARCHAR(40), blog_name VARCHAR(255), published TINYINT(1), published_at DATETIME);
INSERT INTO trackbacks SELECT id, title, excerpt, article_id, url, ip, blog_name, published, published_at FROM contents WHERE type = 'trackback';
DELETE FROM contents WHERE type = 'trackback';
ALTER TABLE contents DROP COLUMN title;
ALTER TABLE contents DROP COLUMN excerpt;
ALTER TABLE contents DROP COLUMN blog_name;

-- Split comments out from the contents table and remove the contents table
CREATE TABLE comments (id INTEGER, author VARCHAR(255), body TEXT, created_at DATETIME, updated_at DATETIME, article_id INTEGER, email VARCHAR(255), url VARCHAR(255), ip VARCHAR(255), published TINYINT(1), published_at DATETIME);
INSERT INTO comments SELECT id, author, body, created_at, updated_at, article_id, email, url, ip, published, published_at FROM contents;
DROP TABLE contents;

-- Unpublish some spam comments (I decided they were spam by manually looking at my published comments - there were only 100 or so, so it wasn't too painful)
UPDATE comments SET published = false WHERE id in (163, 2439, 2681, 2682, 23244, 52651, 52652, 60260, 64396, 72994, 78223);