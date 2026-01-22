-- $BEGIN

CREATE TABLE mamba_dim_service_category
(
  id         INT     NOT NULL AUTO_INCREMENT,
  service_category_id INT     NOT NULL,
  insurance_id    int     not null,
  department_id    int     null,
  service_id     int     null,
  name        varchar(150) not null,
  description     varchar(250) null,
  price        decimal   null,
  created_date    DATETIME   not null DEFAULT '1900-01-01 00:00:00',

  PRIMARY KEY (id)
);
  

CREATE INDEX mamba_dim_service_category_service_category_id_index
  ON mamba_dim_service_category (service_category_id);

CREATE INDEX mamba_dim_service_category_insurance_id_index
  ON mamba_dim_service_category (insurance_id);

CREATE INDEX mamba_dim_service_category_department_id_index
  ON mamba_dim_service_category (department_id);

CREATE INDEX mamba_dim_service_category_service_id_index
  ON mamba_dim_service_category (service_id);

-- $END