-- $BEGIN

CREATE TABLE IF NOT EXISTS mamba_dim_billing_report_columns
(
  id        INT     NOT NULL AUTO_INCREMENT,
  report_type    VARCHAR(50) NOT NULL,
  hop_service_id  INT     NOT NULL,
  column_name    VARCHAR(50) NOT NULL,
  group_column_name VARCHAR(50) DEFAULT NULL,

  PRIMARY KEY (id),
  UNIQUE KEY uk_report_service (report_type, hop_service_id),
  FOREIGN KEY (`hop_service_id`) REFERENCES `mamba_dim_hop_service` (`service_id`)
);

CREATE INDEX idx_report_group ON mamba_dim_billing_report_columns (report_type, group_column_name);

-- $END