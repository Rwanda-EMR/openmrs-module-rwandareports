package org.openmrs.module.rwandareports.reporting;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.*;
import org.openmrs.api.context.Context;
import org.openmrs.module.reporting.dataset.definition.SqlDataSetDefinition;
import org.openmrs.module.reporting.evaluation.parameter.Mapped;
import org.openmrs.module.reporting.evaluation.parameter.Parameter;
import org.openmrs.module.reporting.report.ReportDesign;
import org.openmrs.module.reporting.report.definition.ReportDefinition;
import org.openmrs.module.reporting.report.service.ReportService;
import org.openmrs.module.rwandareports.util.GlobalPropertiesManagement;
import org.openmrs.module.rwandareports.reporting.util.ReportingConstants;
import org.openmrs.module.rwandareports.reporting.util.SqlQueryLoader;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * Setup class for Lab Result and Lab Exam reports Manages report definitions and SQL dataset
 * configurations
 * <p>
 * This class creates two types of lab reports:
 * </p>
 * <ul>
 * <li>Lab Results Report - Shows results filtered by result location</li>
 * <li>Lab Exam Report - Shows all orders filtered by patient location</li>
 * </ul>
 * 
 * @author Rwanda Reports Team
 */
public class SetupLabResultReports {
	
	protected final static Log log = LogFactory.getLog(SetupLabResultReports.class);
	
	private final GlobalPropertiesManagement gp = new GlobalPropertiesManagement();
	
	/**
	 * Sets up lab result reports Creates report definitions and CSV designs
	 * 
	 * @throws Exception if report setup fails
	 */
	public void setup() throws Exception {
		log.info("Setting up Lab Result Reports...");
		
		try {
			// Create Lab Results Report
			ReportDefinition rdResults = createLabResultReportDefinition();
			ReportDesign designResults = Helper.createCsvReportDesign(rdResults, ReportingConstants.DESIGN_LAB_RESULT_CSV);
			Helper.saveReportDesign(designResults);
			log.info("Lab Results Report created successfully");
			
			// Create Lab Exam Report
			ReportDefinition rdExam = createLabExamReportDefinition();
			ReportDesign designExam = Helper.createCsvReportDesign(rdExam, ReportingConstants.DESIGN_LAB_EXAM_CSV);
			Helper.saveReportDesign(designExam);
			log.info("Lab Exam Report created successfully");
			
		}
		catch (Exception e) {
			log.error("Failed to setup Lab Result Reports", e);
			throw e;
		}
	}
	
	/**
	 * Deletes all lab result report definitions and designs Removes both report definitions and
	 * associated CSV designs
	 */
	public void delete() {
		log.info("Deleting Lab Result Reports...");
		
		ReportService rs = Context.getService(ReportService.class);
		
		// Delete report designs
		for (ReportDesign rd : rs.getAllReportDesigns(false)) {
			if (ReportingConstants.DESIGN_LAB_RESULT_CSV.equals(rd.getName())
			        || ReportingConstants.DESIGN_LAB_EXAM_CSV.equals(rd.getName())) {
				rs.purgeReportDesign(rd);
			}
		}
		
		// Delete report definitions
		Helper.purgeReportDefinition(ReportingConstants.REPORT_LAB_RESULT);
		Helper.purgeReportDefinition(ReportingConstants.REPORT_LAB_EXAM);
		
		log.info("Lab Result Reports deleted successfully");
	}
	
	/**
	 * Creates Lab Results Report definition Shows results filtered by result location
	 * 
	 * @return configured ReportDefinition
	 */
	private ReportDefinition createLabResultReportDefinition() {
		log.debug("Creating Lab Results Report definition...");
		
		ReportDefinition reportDefinition = new ReportDefinition();
		reportDefinition.setName(ReportingConstants.REPORT_LAB_RESULT);
		reportDefinition.addParameter(new Parameter(ReportingConstants.PARAM_START_DATE,
		        ReportingConstants.PARAM_START_DATE_LABEL, Date.class));
		reportDefinition.addParameter(new Parameter(ReportingConstants.PARAM_END_DATE,
		        ReportingConstants.PARAM_END_DATE_LABEL, Date.class));
		
		createLabResultDataSetDefinition(reportDefinition);
		Helper.saveReportDefinition(reportDefinition);
		
		return reportDefinition;
	}
	
	/**
	 * Creates Lab Exam Report definition Shows all orders filtered by patient location
	 * 
	 * @return configured ReportDefinition
	 */
	private ReportDefinition createLabExamReportDefinition() {
		log.debug("Creating Lab Exam Report definition...");
		
		ReportDefinition reportDefinition = new ReportDefinition();
		reportDefinition.setName(ReportingConstants.REPORT_LAB_EXAM);
		reportDefinition.addParameter(new Parameter(ReportingConstants.PARAM_START_DATE,
		        ReportingConstants.PARAM_START_DATE_LABEL, Date.class));
		reportDefinition.addParameter(new Parameter(ReportingConstants.PARAM_END_DATE,
		        ReportingConstants.PARAM_END_DATE_LABEL, Date.class));
		
		createLabExamDataSetDefinition(reportDefinition);
		Helper.saveReportDefinition(reportDefinition);
		
		return reportDefinition;
	}
	
	/**
	 * Creates dataset definition for Lab Results Report Uses external SQL file with JOIN
	 * optimization Validates parameters before use to prevent SQL injection
	 * 
	 * @param reportDefinition the report definition to add dataset to
	 */
	private void createLabResultDataSetDefinition(ReportDefinition reportDefinition) {

		// Define parameters
		Parameter concept = new Parameter(
			ReportingConstants.PARAM_CONCEPT,
			ReportingConstants.PARAM_CONCEPT_LABEL,
			Concept.class
		);
		concept.setRequired(false);

		Parameter location = new Parameter(
			ReportingConstants.PARAM_LOCATION,
			"Location of result",
			Location.class
		);
		location.setRequired(false);

		reportDefinition.addParameter(location);
		reportDefinition.addParameter(concept);

		// Fetch and validate configuration
		OrderType labOrder = gp.getOrderType(ReportingConstants.GP_LAB_ORDER_TYPE);
		PersonAttributeType healthFacilityAttributeType = gp.getPersonAttributeType(
			GlobalPropertiesManagement.FACILITY_PERSON_ATTRIBUTE_TYPE_ID
		);

		validateConfiguration(labOrder, healthFacilityAttributeType);

		// Load SQL from external file with validated parameters
		Map<String, Object> params = new HashMap<>();
		params.put(
			ReportingConstants.PLACEHOLDER_ORDER_TYPE_ID,
			labOrder.getOrderTypeId()
		);
		params.put(
			ReportingConstants.PLACEHOLDER_HEALTH_FACILITY_TYPE_ID,
			healthFacilityAttributeType.getPersonAttributeTypeId()
		);

		String sql = SqlQueryLoader.loadQueryWithParams(
			ReportingConstants.SQL_LAB_RESULT_REPORT,
			params
		);

		log.debug("Loaded Lab Result Report SQL (" + sql.length() + " characters)");

		// Create dataset
		SqlDataSetDefinition sqldsd = new SqlDataSetDefinition();
		sqldsd.setSqlQuery(sql);
		sqldsd.addParameter(new Parameter(
			ReportingConstants.PARAM_START_DATE,
			ReportingConstants.PARAM_START_DATE_LABEL,
			Date.class
		));
		sqldsd.addParameter(new Parameter(
			ReportingConstants.PARAM_END_DATE,
			ReportingConstants.PARAM_END_DATE_LABEL,
			Date.class
		));
		sqldsd.addParameter(location);
		sqldsd.addParameter(concept);

		reportDefinition.addDataSetDefinition("dsd", Mapped.mapStraightThrough(sqldsd));
	}
	
	/**
	 * Creates dataset definition for Lab Exam Report Uses external SQL file with JOIN optimization
	 * Validates parameters before use to prevent SQL injection
	 * 
	 * @param reportDefinition the report definition to add dataset to
	 */
	private void createLabExamDataSetDefinition(ReportDefinition reportDefinition) {

		// Define parameters
		Parameter concept = new Parameter(
			ReportingConstants.PARAM_CONCEPT,
			ReportingConstants.PARAM_CONCEPT_LABEL,
			Concept.class
		);
		concept.setRequired(false);

		Parameter location = new Parameter(
			ReportingConstants.PARAM_LOCATION,
			"Location of Patient",
			Location.class
		);
		location.setRequired(false);

		reportDefinition.addParameter(location);
		reportDefinition.addParameter(concept);

		// Fetch and validate configuration
		OrderType labOrder = gp.getOrderType(ReportingConstants.GP_LAB_ORDER_TYPE);
		PersonAttributeType healthFacilityAttributeType = gp.getPersonAttributeType(
			GlobalPropertiesManagement.FACILITY_PERSON_ATTRIBUTE_TYPE_ID
		);

		validateConfiguration(labOrder, healthFacilityAttributeType);

		// Load SQL from external file with validated parameters
		Map<String, Object> params = new HashMap<>();
		params.put(
			ReportingConstants.PLACEHOLDER_ORDER_TYPE_ID,
			labOrder.getOrderTypeId()
		);
		params.put(
			ReportingConstants.PLACEHOLDER_HEALTH_FACILITY_TYPE_ID,
			healthFacilityAttributeType.getPersonAttributeTypeId()
		);

		String sql = SqlQueryLoader.loadQueryWithParams(
			ReportingConstants.SQL_LAB_EXAM_REPORT,
			params
		);

		log.debug("Loaded Lab Exam Report SQL (" + sql.length() + " characters)");

		// Create dataset
		SqlDataSetDefinition sqldsd = new SqlDataSetDefinition();
		sqldsd.setSqlQuery(sql);
		sqldsd.addParameter(new Parameter(
			ReportingConstants.PARAM_START_DATE,
			ReportingConstants.PARAM_START_DATE_LABEL,
			Date.class
		));
		sqldsd.addParameter(new Parameter(
			ReportingConstants.PARAM_END_DATE,
			ReportingConstants.PARAM_END_DATE_LABEL,
			Date.class
		));
		sqldsd.addParameter(location);
		sqldsd.addParameter(concept);

		reportDefinition.addDataSetDefinition("dsd", Mapped.mapStraightThrough(sqldsd));
	}
	
	/**
	 * Validates required configuration is present Prevents NullPointerException and provides clear
	 * error messages
	 * 
	 * @param labOrder the laboratory order type
	 * @param healthFacilityAttributeType the health facility person attribute type
	 * @throws IllegalStateException if required configuration is missing
	 */
	private void validateConfiguration(OrderType labOrder, PersonAttributeType healthFacilityAttributeType) {
		
		if (labOrder == null || labOrder.getOrderTypeId() == null) {
			throw new IllegalStateException("Lab order type not configured. Please check global property: "
			        + ReportingConstants.GP_LAB_ORDER_TYPE);
		}
		
		if (healthFacilityAttributeType == null || healthFacilityAttributeType.getPersonAttributeTypeId() == null) {
			throw new IllegalStateException("Health facility attribute type not configured. Please check global property: "
			        + GlobalPropertiesManagement.FACILITY_PERSON_ATTRIBUTE_TYPE_ID);
		}
		
		log.debug("Configuration validated - Order Type ID: " + labOrder.getOrderTypeId() + ", Health Facility Type ID: "
		        + healthFacilityAttributeType.getPersonAttributeTypeId());
	}
}
