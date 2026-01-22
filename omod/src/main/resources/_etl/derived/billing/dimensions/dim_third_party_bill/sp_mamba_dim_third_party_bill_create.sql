-- $BEGIN

CREATE TABLE mamba_dim_third_party_bill
(
  id         INT   NOT NULL AUTO_INCREMENT,
  third_party_bill_id INT   NOT NULL,
  amount       decimal not null,
  created_date    DATETIME not null DEFAULT '1900-01-01 00:00:00',

  PRIMARY KEY (id)
);
  

CREATE INDEX mamba_dim_third_party_bill_third_party_bill_id_index
  ON mamba_dim_third_party_bill (third_party_bill_id);

-- $END