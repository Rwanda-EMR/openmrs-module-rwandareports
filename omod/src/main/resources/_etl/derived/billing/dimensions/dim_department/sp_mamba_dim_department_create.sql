-- $BEGIN

CREATE TABLE IF NOT EXISTS mamba_dim_department
(
  id      INT     NOT NULL AUTO_INCREMENT,
  department_id INT     NOT NULL,
  name     varchar(50) null,
  description  varchar(50) null,
  created_date DATETIME  NOT NULL DEFAULT '1900-01-01 00:00:00',

  PRIMARY KEY (id)
);

CREATE INDEX mamba_dim_department_department_id_index
  ON mamba_dim_department (department_id);

-- $END
