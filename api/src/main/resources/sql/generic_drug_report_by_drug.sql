-- ================================================================================
-- Generic Drug Report by Dates and Drug Query
-- ================================================================================
-- Description: Retrieves drug orders for a specific drug within a date range
-- Performance: Uses INNER JOINs for required relationships, LEFT JOIN for optional
-- MySQL Compatibility: Works with MySQL 5.x and above
-- Parameters:
--   :startDate  - Filter orders from this date (inclusive)
--   :endDate    - Filter orders to this date (inclusive)
--   :Drug       - Filter by specific drug ID (required)
-- ================================================================================

SELECT
    o.patient_id,
    d.name,
    dro.dose,
    d.strength,
    o.date_activated,
    o.date_stopped,
    o.auto_expire_date,
    d.route,
    o.voided
FROM orders o
INNER JOIN drug_order dro ON o.order_id = dro.order_id
LEFT JOIN drug d ON dro.drug_inventory_id = d.drug_id
LEFT JOIN patient p ON o.patient_id = p.patient_id
WHERE o.date_activated >= :startDate
    AND o.date_activated <= :endDate
    AND d.drug_id = :Drug
    AND p.voided = 0
    AND o.voided = 0
ORDER BY o.date_activated DESC, o.patient_id
