# Clinical Detailed Report - Concept ID Mapping Documentation

## Overview
This document maps CSV columns to their OpenMRS database sources for the Clinical Detailed Report.

Generated: 2025-12-10

---

## Concept ID Mappings

### Vitals (from `mamba_z_encounter_obs`)
| Column | Concept ID | Concept Name | Data Type |
|--------|------------|--------------|-----------|
| Weight | 5089 | WEIGHT (KG) | numeric |
| Height | 5090 | HEIGHT (CM) | numeric |
| Temperature | 5088 | TEMPERATURE (C) | numeric |

### Clinical Data (from `mamba_z_encounter_obs`)
| Column | Concept ID | Concept Name | Data Type |
|--------|------------|--------------|-----------|
| Chief Complaint | 5219 | CHIEF COMPLAINT | text |
| Treatment | 1282 | MEDICATION ORDERS | text |
| Primary Diagnosis | 105771 | Primary Diagnosis | coded |
| Secondary Diagnosis | 105501 | Secondary diagnosis | coded |
| Presumptive Diagnosis | 1607 | PRESUMPTIVE DIAGNOSIS | coded |

### Patient Context (from `mamba_z_encounter_obs`)
| Column | Concept ID | Concept Name | Data Type | Notes |
|--------|------------|--------------|-----------|-------|
| Catchment Area | 8047 | Catchment area | coded | Answer concepts: 8050 (within), 8051 (outside) |
| Case Status | 8048 | Case status | coded | |

---

## Dimension Table Mappings

### Demographics (from `mamba_dim_person`, `mamba_dim_person_name`)
- PatientID → person_id
- given_name → given_name
- family_name → family_name
- Gender → gender
- BirthDate → birthdate
- Age → age

### Address (from `mamba_dim_person_address`)
- Country → country
- Province → state_province
- District → county_district
- Sector → address3
- Cell → address1
- Umudugudu → address2

### Encounter (from `mamba_dim_encounter`)
- encounter_datetime → encounter_datetime
- Provider → via encounter_provider → mamba_dim_provider.name
- visit_type → via visit_id → visit.visit_type_id → visit_type.name

### Billing/Insurance (from existing dimensions)
- House Hold Name → mamba_dim_beneficiary.owner_name
- Insurance → mamba_dim_insurance.name
- admission_service → mamba_dim_admission.admission_service
- Type of Discharge → mamba_dim_admission.discharge_type
- Department → mamba_dim_department.name

---

## Calculated Fields
- **Age At Encounter**: `TIMESTAMPDIFF(YEAR, birth_date, encounter_datetime)`

---

## Missing Dimensions (Need ETL)
⚠️ **NOTE**: These dimension tables don't exist yet in analysis_db:
- `mamba_dim_provider` - Run ETL to populate from core mamba
- `mamba_dim_visit` - Run ETL to populate from core mamba

---

## SQL Join Strategy
```
FROM mamba_dim_beneficiary ben
  INNER JOIN mamba_dim_person p ON ...
  LEFT JOIN mamba_dim_person_name pn ON ...
  LEFT JOIN mamba_dim_person_address pa ON ...
  LEFT JOIN mamba_dim_encounter e ON e.patient_id = p.person_id
  LEFT JOIN mamba_source_db.encounter_provider ep ON ep.encounter_id = e.encounter_id
  LEFT JOIN mamba_source_db.provider prov ON prov.provider_id = ep.provider_id
  LEFT JOIN mamba_source_db.visit v ON v.visit_id = e.visit_id
  LEFT JOIN mamba_source_db.visit_type vt ON vt.visit_type_id = v.visit_type_id
  LEFT JOIN mamba_z_encounter_obs obs_weight ON obs_weight.encounter_id = e.encounter_id AND obs_weight.obs_question_concept_id = 5089
  LEFT JOIN mamba_z_encounter_obs obs_height ON obs_height.encounter_id = e.encounter_id AND obs_height.obs_question_concept_id = 5090
  ... (additional obs joins for each concept)
```

---

## Implementation Notes
1. Use LEFT JOIN for all obs-based data to avoid excluding encounters without those observations
2. Get diagnosis coded value names via JOIN to concept_name table
3. For coded catchment_area, join to get the answer concept name
4. Provider name concatenation: `CONCAT(prov.given_name, ' ', prov.family_name)` or use prov.name if available
5. Performance: Consider creating materialized view or indexed temp table for obs pivoting
