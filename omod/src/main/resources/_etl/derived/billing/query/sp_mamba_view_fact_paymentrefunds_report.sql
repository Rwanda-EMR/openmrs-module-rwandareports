DELIMITER //

DROP PROCEDURE IF EXISTS sp_mamba_view_fact_paymentrefunds_report;

CREATE PROCEDURE sp_mamba_view_fact_paymentrefunds_report()
BEGIN

  SET SESSION group_concat_max_len = 20000;
  -- Create or Replace View
  SET @select_stmt =
    'CREATE OR REPLACE VIEW mamba_view_fact_paymentrefunds_report AS
      SELECT
        mdpr.refund_id,
        mdpr.bill_payment_id AS payment_id,
        CONCAT(mdpn.given_name, '' '', mdpn.family_name) AS cashier_name,
        mdpr.created_date AS submitted_on,
        CONCAT(mdpn1.given_name, '' '', mdpn1.family_name)AS approvedby,
        CONCAT(mdpn.given_name, '' '', mdpn.family_name) AS confirmed_by,
        mdfsp.name service_name,
        mdpsb.paid_quantity AS qty_paid,
        mdpsbr.refund_quantity AS refund_qty,
        mdps.unit_price,
        COALESCE(mdpsbr.refund_reason, ''No Reason Provided'') AS refund_reason,
        ROW_NUMBER() OVER (PARTITION BY mdpr.refund_id ORDER BY mdpsbr.refund_quantity DESC) AS rn
      FROM mamba_dim_payment_refund mdpr
      LEFT JOIN mamba_dim_person_name mdpn ON mdpn.person_id = mdpr.refunded_by
      LEFT JOIN mamba_dim_paid_service_bill_refund mdpsbr ON mdpsbr.refund_id = mdpr.refund_id
      LEFT JOIN mamba_dim_person_name mdpn1 ON mdpn1.person_id = mdpsbr.approved_by
      LEFT JOIN mamba_dim_paid_service_bill mdpsb ON mdpsb.paid_service_bill_id = mdpsbr.paid_item_id
      LEFT JOIN mamba_dim_patient_service_bill mdps ON mdps.patient_service_bill_id = mdpsb.patient_service_bill_id
      LEFT JOIN mamba_dim_billable_service mdbs ON mdbs.billable_service_id = mdps.billable_service_id
      LEFT JOIN mamba_dim_facility_service_price mdfsp ON mdfsp.facility_service_price_id = mdbs.facility_service_price_id;';

  -- Execute the dynamic SQL statement
  PREPARE select_stmt FROM @select_stmt;
  EXECUTE select_stmt;
  DEALLOCATE PREPARE select_stmt;

END //

DELIMITER ;