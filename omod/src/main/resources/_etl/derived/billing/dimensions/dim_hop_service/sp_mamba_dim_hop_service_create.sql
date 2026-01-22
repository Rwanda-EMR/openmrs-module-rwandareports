-- $BEGIN

CREATE TABLE mamba_dim_hop_service
(
  id      INT     NOT NULL AUTO_INCREMENT,
  service_id  INT     NOT NULL,
  name     varchar(50) null,
  description varchar(50) null,
  created_date DATETIME  not null DEFAULT '1900-01-01 00:00:00',

  PRIMARY KEY (id)
);

CREATE INDEX mamba_dim_hop_service_service_id_index
  ON mamba_dim_hop_service (service_id);

-- $END
