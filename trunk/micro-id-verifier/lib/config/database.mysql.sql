CREATE TABLE links (
  id INT AUTO_INCREMENT, 
  url VARCHAR(255), 
  expected_micro_id VARCHAR(255), 
  status INT, 
  PRIMARY KEY(id)
) ENGINE InnoDB;