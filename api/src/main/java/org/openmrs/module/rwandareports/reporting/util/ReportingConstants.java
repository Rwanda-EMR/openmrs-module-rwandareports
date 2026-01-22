package org.openmrs.module.rwandareports.reporting.util;

/**
 * Constants for reporting module Centralizes all constants related to report names, parameter
 * names, and SQL resource paths
 * 
 * @author smallGod
 */
public class ReportingConstants {
	
	// ==================== SQL Resource Paths ====================
	
	/**
	 * Path to Lab Result Report SQL query file
	 */
	public static final String SQL_LAB_RESULT_REPORT = "sql/lab_result_report.sql";
	
	/**
	 * Path to Lab Exam Report SQL query file
	 */
	public static final String SQL_LAB_EXAM_REPORT = "sql/lab_exam_report.sql";
	
	/**
	 * Path to Pathology Request Report SQL query file
	 */
	public static final String SQL_PATHOLOGY_REQUEST_REPORT = "sql/pathology_request_report.sql";
	
	/**
	 * Path to Generic Drug Report by Dates SQL query file
	 */
	public static final String SQL_GENERIC_DRUG_REPORT_BY_DATES = "sql/generic_drug_report_by_dates.sql";
	
	/**
	 * Path to Generic Drug Report by Drug SQL query file
	 */
	public static final String SQL_GENERIC_DRUG_REPORT_BY_DRUG = "sql/generic_drug_report_by_drug.sql";
	
	/**
	 * Path to Generic Drug Report by Program SQL query file
	 */
	public static final String SQL_GENERIC_DRUG_REPORT_BY_PROGRAM = "sql/generic_drug_report_by_program.sql";
	
	// ==================== Report Names ====================
	
	/**
	 * Display name for Lab Results Report
	 */
	public static final String REPORT_LAB_RESULT = "Lab - Results Report";
	
	/**
	 * Display name for Lab Exam Report
	 */
	public static final String REPORT_LAB_EXAM = "Lab - Exam Report";
	
	/**
	 * Display name for Pathology Request Report
	 */
	public static final String REPORT_PATHOLOGY_REQUEST = "Pathology Request Report";
	
	/**
	 * Display name for Generic Drug Report by Dates
	 */
	public static final String REPORT_GENERIC_DRUG_BY_DATES = "Generic Drug Report by Dates";
	
	/**
	 * Display name for Generic Drug Report by Dates and Drug
	 */
	public static final String REPORT_GENERIC_DRUG_BY_DRUG = "Generic Drug Report by Dates and drug";
	
	/**
	 * Display name for Generic Drug Report by Dates and Program
	 */
	public static final String REPORT_GENERIC_DRUG_BY_PROGRAM = "Generic Drug Report by Dates and program";
	
	// ==================== Report Design Names ====================
	
	/**
	 * CSV design name for Lab Results Report
	 */
	public static final String DESIGN_LAB_RESULT_CSV = "Lab - Results Report.csv_";
	
	/**
	 * CSV design name for Lab Exam Report
	 */
	public static final String DESIGN_LAB_EXAM_CSV = "Lab - Exam Report Exam.csv_";
	
	/**
	 * CSV design name for Pathology Request Report
	 */
	public static final String DESIGN_PATHOLOGY_REQUEST_CSV = "Pathology Request Report.csv_";
	
	/**
	 * CSV design name for Generic Drug Report
	 */
	public static final String DESIGN_GENERIC_DRUG_CSV = "Generic Drug Report.csv_";
	
	// ==================== Parameter Names ====================
	
	/**
	 * Parameter name for start date
	 */
	public static final String PARAM_START_DATE = "startDate";
	
	/**
	 * Parameter name for end date
	 */
	public static final String PARAM_END_DATE = "endDate";
	
	/**
	 * Parameter name for location filter
	 */
	public static final String PARAM_LOCATION = "location";
	
	/**
	 * Parameter name for concept filter
	 */
	public static final String PARAM_CONCEPT = "concept";
	
	/**
	 * Display label for start date parameter
	 */
	public static final String PARAM_START_DATE_LABEL = "From:";
	
	/**
	 * Display label for end date parameter
	 */
	public static final String PARAM_END_DATE_LABEL = "To:";
	
	/**
	 * Display label for concept parameter (exam name)
	 */
	public static final String PARAM_CONCEPT_LABEL = "Exam Name";
	
	/**
	 * Parameter name for drug filter
	 */
	public static final String PARAM_DRUG = "Drug";
	
	/**
	 * Parameter name for program filter
	 */
	public static final String PARAM_PROGRAMS = "programs";
	
	// ==================== SQL Placeholder Names ====================
	
	/**
	 * Placeholder for order type ID in SQL queries Usage in SQL: WHERE order_type_id =
	 * {orderTypeId}
	 */
	public static final String PLACEHOLDER_ORDER_TYPE_ID = "orderTypeId";
	
	/**
	 * Placeholder for health facility attribute type ID in SQL queries Usage in SQL: WHERE
	 * person_attribute_type_id = {healthFacilityTypeId}
	 */
	public static final String PLACEHOLDER_HEALTH_FACILITY_TYPE_ID = "healthFacilityTypeId";
	
	/**
	 * Placeholder for telephone number concept ID in SQL queries
	 */
	public static final String PLACEHOLDER_TELEPHONE_NUMBER_CONCEPT_ID = "telephoneNumberConceptId";
	
	/**
	 * Placeholder for sample status concept ID in SQL queries
	 */
	public static final String PLACEHOLDER_SAMPLE_STATUS_CONCEPT_ID = "sampleStatusConceptId";
	
	/**
	 * Placeholder for referral status concept ID in SQL queries
	 */
	public static final String PLACEHOLDER_REFERRAL_STATUS_CONCEPT_ID = "referralStatusConceptId";
	
	/**
	 * Placeholder for sample drop-off concept ID in SQL queries
	 */
	public static final String PLACEHOLDER_SAMPLE_DROPOFF_CONCEPT_ID = "sampleDropOffConceptId";
	
	/**
	 * Placeholder for pathology request encounter UUID concept ID in SQL queries
	 */
	public static final String PLACEHOLDER_PATHOLOGY_REQUEST_ENCOUNTER_UUID_CONCEPT_ID = "pathologyRequestEncounterUuidConceptId";
	
	/**
	 * Placeholder for pathology results approved concept ID in SQL queries
	 */
	public static final String PLACEHOLDER_PATHOLOGY_RESULTS_APPROVED_CONCEPT_ID = "pathologyResultsApprovedConceptId";
	
	/**
	 * Placeholder for pathologic diagnosis concept ID in SQL queries
	 */
	public static final String PLACEHOLDER_PATHOLOGIC_DIAGNOSIS_CONCEPT_ID = "pathologicDiagnosisConceptId";
	
	/**
	 * Placeholder for health center attribute type ID in SQL queries
	 */
	public static final String PLACEHOLDER_HEALTH_CENTER_ATTRIBUTE_TYPE_ID = "healthCenterAttributeTypeId";
	
	/**
	 * Placeholder for pathology request form ID in SQL queries
	 */
	public static final String PLACEHOLDER_PATHOLOGY_REQUEST_FORM_ID = "pathologyRequestFormId";
	
	// ==================== Global Property Keys ====================
	
	/**
	 * Global property key for laboratory order type
	 */
	public static final String GP_LAB_ORDER_TYPE = "laboratorymanagement.orderType.labOrderTypeId";
	
	// Private constructor to prevent instantiation
	private ReportingConstants() {
		throw new AssertionError("Cannot instantiate constants class");
	}
}
