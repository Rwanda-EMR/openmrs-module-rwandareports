package org.openmrs.module.rwandareports.reporting;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.*;
import org.openmrs.module.reporting.dataset.definition.SqlDataSetDefinition;
import org.openmrs.module.reporting.evaluation.parameter.Mapped;
import org.openmrs.module.reporting.evaluation.parameter.Parameter;
import org.openmrs.module.reporting.report.ReportDesign;
import org.openmrs.module.reporting.report.definition.ReportDefinition;
import org.openmrs.module.rwandareports.util.GlobalPropertiesManagement;
import org.openmrs.module.rwandareports.reporting.util.ReportingConstants;
import org.openmrs.module.rwandareports.reporting.util.SqlQueryLoader;

import java.util.HashMap;
import java.util.Map;

public class SetupPathologyRequestReport implements SetupReport {
	
	protected final Log log = LogFactory.getLog(getClass());
	
	GlobalPropertiesManagement gp = new GlobalPropertiesManagement();
	
	private EncounterType pathologyEncounterType;
	
	private PersonAttributeType healthCenterPersonAttributeType;
	
	//    private PersonAttributeType phoneNumberPersonAttributeType;
	private Form pathologyRequestForm;
	
	private Concept sampleStatusConcept;
	
	private Concept referralStatusConcept;
	
	private Concept sampleDropOffConcept;
	
	private Concept pathologyRequestEncounterUUID;
	
	private Concept telephoneNumberConcept;
	
	private Concept PATHOLOGYREQUESTRESULTSAPPROVED;
	
	private Concept pathologicDiagnoisis;
	
	private PatientIdentifierType patientIMBPrimaryCareId;
	
	/**
	 * @return
	 */
	@Override
	public String getReportName() {
		return null;
	}
	
	/**
	 * Sets up pathology request report Creates report definition and CSV design
	 * 
	 * @throws Exception if report setup fails
	 */
	public void setup() throws Exception {
		log.info("Setting up Pathology Request Report...");
		
		try {
			setupProperties();
			
			ReportDefinition rd = createReportDefinition();
			ReportDesign designCSV = Helper.createCsvReportDesign(rd, ReportingConstants.DESIGN_PATHOLOGY_REQUEST_CSV);
			Helper.saveReportDesign(designCSV);
			log.info("Pathology Request Report created successfully");
		}
		catch (Exception e) {
			log.error("Failed to setup Pathology Request Report", e);
			throw e;
		}
	}
	
	/**
	 * Deletes pathology request report definition and design
	 */
	public void delete() {
		log.info("Deleting Pathology Request Report...");
		Helper.purgeReportDefinition(ReportingConstants.REPORT_PATHOLOGY_REQUEST);
		log.info("Pathology Request Report deleted successfully");
	}
	
	/**
	 * Creates Pathology Request Report definition
	 * 
	 * @return configured ReportDefinition
	 */
	private ReportDefinition createReportDefinition() {
		log.debug("Creating Pathology Request Report definition...");
		
		ReportDefinition reportDefinition = new ReportDefinition();
		reportDefinition.setName(ReportingConstants.REPORT_PATHOLOGY_REQUEST);
		reportDefinition.setUuid("996cf192-ff54-11eb-a63a-080027ce9ca0");
		
		Parameter location = new Parameter(ReportingConstants.PARAM_LOCATION, "Location", Location.class);
		location.setRequired(false);
		reportDefinition.addParameter(location);
		
		createDataSetDefinition(reportDefinition);
		Helper.saveReportDefinition(reportDefinition);
		
		return reportDefinition;
	}
	
	/**
	 * Creates dataset definition for Pathology Request Report Uses external SQL file with JOIN
	 * optimization Validates parameters before use to prevent SQL injection
	 * 
	 * @param reportDefinition the report definition to add dataset to
	 */
	private void createDataSetDefinition(ReportDefinition reportDefinition) {

		// Define parameters
		Parameter location = new Parameter(
			ReportingConstants.PARAM_LOCATION,
			"Location",
			Location.class
		);
		location.setRequired(false);

		// Validate configuration
		validateConfiguration();

		// Build parameters map for SQL placeholder replacement
		Map<String, Object> params = new HashMap<>();
		params.put(
			ReportingConstants.PLACEHOLDER_TELEPHONE_NUMBER_CONCEPT_ID,
			telephoneNumberConcept.getConceptId()
		);
		params.put(
			ReportingConstants.PLACEHOLDER_SAMPLE_STATUS_CONCEPT_ID,
			sampleStatusConcept.getConceptId()
		);
		params.put(
			ReportingConstants.PLACEHOLDER_REFERRAL_STATUS_CONCEPT_ID,
			referralStatusConcept.getConceptId()
		);
		params.put(
			ReportingConstants.PLACEHOLDER_SAMPLE_DROPOFF_CONCEPT_ID,
			sampleDropOffConcept.getConceptId()
		);
		params.put(
			ReportingConstants.PLACEHOLDER_PATHOLOGY_REQUEST_ENCOUNTER_UUID_CONCEPT_ID,
			pathologyRequestEncounterUUID.getConceptId()
		);
		params.put(
			ReportingConstants.PLACEHOLDER_PATHOLOGY_RESULTS_APPROVED_CONCEPT_ID,
			PATHOLOGYREQUESTRESULTSAPPROVED.getConceptId()
		);
		params.put(
			ReportingConstants.PLACEHOLDER_PATHOLOGIC_DIAGNOSIS_CONCEPT_ID,
			pathologicDiagnoisis.getConceptId()
		);
		params.put(
			ReportingConstants.PLACEHOLDER_HEALTH_CENTER_ATTRIBUTE_TYPE_ID,
			healthCenterPersonAttributeType.getPersonAttributeTypeId()
		);
		params.put(
			ReportingConstants.PLACEHOLDER_PATHOLOGY_REQUEST_FORM_ID,
			pathologyRequestForm.getFormId()
		);

		// Load SQL from external file with validated parameters
		String sql = SqlQueryLoader.loadQueryWithParams(
			ReportingConstants.SQL_PATHOLOGY_REQUEST_REPORT,
			params
		);

		log.debug("Loaded Pathology Request Report SQL (" + sql.length() + " characters)");

		// Create dataset
		SqlDataSetDefinition sqldsd = new SqlDataSetDefinition();
		sqldsd.setSqlQuery(sql);
		sqldsd.addParameter(location);

		reportDefinition.addDataSetDefinition("dsd", Mapped.mapStraightThrough(sqldsd));
	}
	
	/**
	 * Validates required configuration is present Prevents NullPointerException and provides clear
	 * error messages
	 * 
	 * @throws IllegalStateException if required configuration is missing
	 */
	private void validateConfiguration() {
		
		if (telephoneNumberConcept == null || telephoneNumberConcept.getConceptId() == null) {
			throw new IllegalStateException("Telephone number concept not configured");
		}
		
		if (sampleStatusConcept == null || sampleStatusConcept.getConceptId() == null) {
			throw new IllegalStateException("Sample status concept not configured");
		}
		
		if (referralStatusConcept == null || referralStatusConcept.getConceptId() == null) {
			throw new IllegalStateException("Referral status concept not configured");
		}
		
		if (sampleDropOffConcept == null || sampleDropOffConcept.getConceptId() == null) {
			throw new IllegalStateException("Sample drop-off concept not configured");
		}
		
		if (pathologyRequestEncounterUUID == null || pathologyRequestEncounterUUID.getConceptId() == null) {
			throw new IllegalStateException("Pathology request encounter UUID concept not configured");
		}
		
		if (PATHOLOGYREQUESTRESULTSAPPROVED == null || PATHOLOGYREQUESTRESULTSAPPROVED.getConceptId() == null) {
			throw new IllegalStateException("Pathology results approved concept not configured");
		}
		
		if (pathologicDiagnoisis == null || pathologicDiagnoisis.getConceptId() == null) {
			throw new IllegalStateException("Pathologic diagnosis concept not configured");
		}
		
		if (healthCenterPersonAttributeType == null || healthCenterPersonAttributeType.getPersonAttributeTypeId() == null) {
			throw new IllegalStateException("Health center person attribute type not configured");
		}
		
		if (pathologyRequestForm == null || pathologyRequestForm.getFormId() == null) {
			throw new IllegalStateException("Pathology request form not configured");
		}
		
		log.debug("Pathology Request Report configuration validated successfully");
	}
	
	private void setupProperties() {
		
		pathologyRequestForm = gp.getForm(GlobalPropertiesManagement.PATHOLOGYREQUESTFORM);
		sampleStatusConcept = gp.getConcept(GlobalPropertiesManagement.SAMPLESTATUSCONCEPT);
		referralStatusConcept = gp.getConcept(GlobalPropertiesManagement.REFERRALSTATUSCONCEPT);
		sampleDropOffConcept = gp.getConcept(GlobalPropertiesManagement.SAMPLEDROPOFFCONCEPT);
		pathologyEncounterType = gp.getEncounterType(GlobalPropertiesManagement.PATHOLOGYENCOUNTERTYPE);
		//        phoneNumberPersonAttributeType =gp.getPersonAttributeType(GlobalPropertiesManagement.PERSONATTRIBUTEPHONENUMBER);
		healthCenterPersonAttributeType = gp
		        .getPersonAttributeType(GlobalPropertiesManagement.FACILITY_PERSON_ATTRIBUTE_TYPE_ID);
		pathologyRequestEncounterUUID = gp.getConcept(GlobalPropertiesManagement.PATHOLOGYREQUESTENCOUNTERUUID);
		telephoneNumberConcept = gp.getConcept(GlobalPropertiesManagement.TELEPHONE_NUMBER_CONCEPT);
		PATHOLOGYREQUESTRESULTSAPPROVED = gp.getConcept(GlobalPropertiesManagement.PATHOLOGYREQUESTRESULTSAPPROVED);
		pathologicDiagnoisis = gp.getConcept(GlobalPropertiesManagement.PATHOLOGICDIAGNOSIS);
		//        patientIMBPrimaryCareId = gp.getPatientIdentifier(GlobalPropertiesManagement.PC_IDENTIFIER);
	}
	
}
