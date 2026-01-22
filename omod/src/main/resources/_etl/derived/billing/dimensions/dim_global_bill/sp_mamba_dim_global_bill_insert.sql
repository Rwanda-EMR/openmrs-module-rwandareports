-- $BEGIN

INSERT INTO mamba_dim_global_bill (global_bill_id,
                  admission_id,
                  insurance_id,
                  bill_identifier,
                  global_amount,
                  closing_date,
                  closed,
                  closed_by_id,
                  closed_reason,
                  edited_by,
                  edit_reason,
                  created_date,
                  closed_by_name)
SELECT 
    gb.global_bill_id,
    gb.admission_id,
    gb.insurance_id,
    gb.bill_identifier,
    gb.global_amount,
    gb.closing_date,
    gb.closed,
    gb.closed_by as closed_by_id,
    gb.closed_reason,
    gb.edited_by,
    gb.edit_reason,
    gb.created_date,
    CASE
        WHEN gb.closed = 1 THEN CONCAT(psn.family_name, ' ', psn.given_name)
        ELSE NULL
    END as closed_by_name
FROM mamba_source_db.moh_bill_global_bill gb
LEFT JOIN mamba_dim_users u ON u.user_id = gb.closed_by AND gb.closed = 1
LEFT JOIN mamba_dim_person_name psn ON psn.person_id = u.person_id;

-- $END