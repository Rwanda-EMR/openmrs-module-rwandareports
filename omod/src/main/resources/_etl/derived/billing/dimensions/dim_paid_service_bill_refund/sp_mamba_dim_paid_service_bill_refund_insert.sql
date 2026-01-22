-- $BEGIN

  INSERT INTO mamba_dim_paid_service_bill_refund (service_bill_refund_id,
                          created_date,
                          refund_id,
                          paid_item_id,
                          refund_quantity,
                          creator,
                          refund_reason,
                          is_approved,
                          approval_date,
                          approved_by,
                          is_declined,
                          declining_note,
                          decline_date,
                          voided,
                          voided_date,
                          void_reason,
                          voided_by)
  SELECT service_bill_refund_id,
      created_date,
      refund_id,
      paid_item_id,
      refund_quantity,
      creator,
      refund_reason,
      is_approved,
      approval_date,
      approved_by,
      is_declined,
      declining_note,
      decline_date,
      voided,
      voided_date,
      void_reason,
      voided_by
  FROM mamba_source_db.moh_bill_paid_service_bill_refund;

-- $END