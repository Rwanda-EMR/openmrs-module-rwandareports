package org.openmrs.module.rwandareports.reporting;

import java.util.Date;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.Drug;
import org.openmrs.Program;
import org.openmrs.api.context.Context;
import org.openmrs.module.reporting.dataset.definition.SqlDataSetDefinition;
import org.openmrs.module.reporting.evaluation.parameter.Mapped;
import org.openmrs.module.reporting.evaluation.parameter.Parameter;
import org.openmrs.module.reporting.report.ReportDesign;
import org.openmrs.module.reporting.report.definition.ReportDefinition;
import org.openmrs.module.reporting.report.service.ReportService;
import org.openmrs.module.rwandareports.reporting.util.ReportingConstants;
import org.openmrs.module.rwandareports.reporting.util.SqlQueryLoader;

public class SetupGenericDrugReport implements SetupReport {
	
	protected final Log log = LogFactory.getLog(getClass());
	
	/**
	 * @return
	 */
	@Override
	public String getReportName() {
		return null;
	}
	
	/**
	 * Sets up generic drug reports Creates report definitions and CSV designs
	 * 
	 * @throws Exception if report setup fails
	 */
	public void setup() throws Exception {
		log.info("Setting up Generic Drug Reports...");
		
		try {
			ReportDefinition rd = createReportDefinitionByDate();
			ReportDesign designCSV = Helper.createCsvReportDesign(rd, ReportingConstants.DESIGN_GENERIC_DRUG_CSV);
			Helper.saveReportDesign(designCSV);
			
			ReportDefinition rd2 = createReportDefinitionByDrugAndDates();
			ReportDesign designCSV2 = Helper.createCsvReportDesign(rd2, ReportingConstants.DESIGN_GENERIC_DRUG_CSV);
			Helper.saveReportDesign(designCSV2);
			
			ReportDefinition rd3 = createReportDefinitionByProgramAndDates();
			ReportDesign designCSV3 = Helper.createCsvReportDesign(rd3, ReportingConstants.DESIGN_GENERIC_DRUG_CSV);
			Helper.saveReportDesign(designCSV3);
			log.info("Generic Drug Reports created successfully");
		}
		catch (Exception e) {
			log.error("Failed to setup Generic Drug Reports", e);
			throw e;
		}
	}
	
	/**
	 * Deletes all generic drug report definitions
	 */
	public void delete() {
		log.info("Deleting Generic Drug Reports...");
		Helper.purgeReportDefinition(ReportingConstants.REPORT_GENERIC_DRUG_BY_DATES);
		Helper.purgeReportDefinition(ReportingConstants.REPORT_GENERIC_DRUG_BY_DRUG);
		Helper.purgeReportDefinition(ReportingConstants.REPORT_GENERIC_DRUG_BY_PROGRAM);
		log.info("Generic Drug Reports deleted successfully");
	}
	
	/**
	 * Creates Generic Drug Report by Dates definition
	 * 
	 * @return configured ReportDefinition
	 */
	private ReportDefinition createReportDefinitionByDate() {
		log.debug("Creating Generic Drug Report by Dates definition...");
		
		ReportDefinition reportDefinition = new ReportDefinition();
		reportDefinition.setName(ReportingConstants.REPORT_GENERIC_DRUG_BY_DATES);
		reportDefinition.addParameter(new Parameter(ReportingConstants.PARAM_START_DATE,
		        ReportingConstants.PARAM_START_DATE_LABEL, Date.class));
		reportDefinition.addParameter(new Parameter(ReportingConstants.PARAM_END_DATE,
		        ReportingConstants.PARAM_END_DATE_LABEL, Date.class));
		
		createDataSetDefinitionByDate(reportDefinition);
		Helper.saveReportDefinition(reportDefinition);
		
		return reportDefinition;
	}
	
	/**
	 * Creates Generic Drug Report by Dates and Drug definition
	 * 
	 * @return configured ReportDefinition
	 */
	private ReportDefinition createReportDefinitionByDrugAndDates() {
		log.debug("Creating Generic Drug Report by Dates and Drug definition...");
		
		ReportDefinition reportDefinition = new ReportDefinition();
		reportDefinition.setName(ReportingConstants.REPORT_GENERIC_DRUG_BY_DRUG);
		reportDefinition.addParameter(new Parameter(ReportingConstants.PARAM_START_DATE,
		        ReportingConstants.PARAM_START_DATE_LABEL, Date.class));
		reportDefinition.addParameter(new Parameter(ReportingConstants.PARAM_END_DATE,
		        ReportingConstants.PARAM_END_DATE_LABEL, Date.class));
		
		createDataSetDefinitionByDrugAndDates(reportDefinition);
		Helper.saveReportDefinition(reportDefinition);
		
		return reportDefinition;
	}
	
	/**
	 * Creates Generic Drug Report by Dates and Program definition
	 * 
	 * @return configured ReportDefinition
	 */
	private ReportDefinition createReportDefinitionByProgramAndDates() {
		log.debug("Creating Generic Drug Report by Dates and Program definition...");
		
		ReportDefinition reportDefinition = new ReportDefinition();
		reportDefinition.setName(ReportingConstants.REPORT_GENERIC_DRUG_BY_PROGRAM);
		reportDefinition.addParameter(new Parameter(ReportingConstants.PARAM_START_DATE,
		        ReportingConstants.PARAM_START_DATE_LABEL, Date.class));
		reportDefinition.addParameter(new Parameter(ReportingConstants.PARAM_END_DATE,
		        ReportingConstants.PARAM_END_DATE_LABEL, Date.class));
		
		createDataSetDefinitionByProgramAndDates(reportDefinition);
		Helper.saveReportDefinition(reportDefinition);
		
		return reportDefinition;
	}
	
	/**
	 * Creates dataset definition for Generic Drug Report by Dates Uses external SQL file
	 * 
	 * @param reportDefinition the report definition to add dataset to
	 */
	private void createDataSetDefinitionByDate(ReportDefinition reportDefinition) {
		
		// Load SQL from external file
		String sql = SqlQueryLoader.loadQuery(ReportingConstants.SQL_GENERIC_DRUG_REPORT_BY_DATES);
		log.debug("Loaded Generic Drug Report by Dates SQL (" + sql.length() + " characters)");
		
		// Create dataset
		SqlDataSetDefinition sqldsd = new SqlDataSetDefinition();
		sqldsd.setSqlQuery(sql);
		sqldsd.addParameter(new Parameter(ReportingConstants.PARAM_START_DATE, ReportingConstants.PARAM_START_DATE_LABEL,
		        Date.class));
		sqldsd.addParameter(new Parameter(ReportingConstants.PARAM_END_DATE, ReportingConstants.PARAM_END_DATE_LABEL,
		        Date.class));
		
		reportDefinition.addDataSetDefinition("dsd", Mapped.mapStraightThrough(sqldsd));
	}
	
	/**
	 * Creates dataset definition for Generic Drug Report by Drug and Dates Uses external SQL file
	 * 
	 * @param reportDefinition the report definition to add dataset to
	 */
	private void createDataSetDefinitionByDrugAndDates(ReportDefinition reportDefinition) {
		
		// Define parameters
		Parameter drug = new Parameter(ReportingConstants.PARAM_DRUG, "Drug", Drug.class);
		drug.setRequired(false);
		reportDefinition.addParameter(drug);
		
		// Load SQL from external file
		String sql = SqlQueryLoader.loadQuery(ReportingConstants.SQL_GENERIC_DRUG_REPORT_BY_DRUG);
		log.debug("Loaded Generic Drug Report by Drug SQL (" + sql.length() + " characters)");
		
		// Create dataset
		SqlDataSetDefinition sqldsd = new SqlDataSetDefinition();
		sqldsd.setSqlQuery(sql);
		sqldsd.addParameter(new Parameter(ReportingConstants.PARAM_START_DATE, ReportingConstants.PARAM_START_DATE_LABEL,
		        Date.class));
		sqldsd.addParameter(new Parameter(ReportingConstants.PARAM_END_DATE, ReportingConstants.PARAM_END_DATE_LABEL,
		        Date.class));
		sqldsd.addParameter(drug);
		
		reportDefinition.addDataSetDefinition("dsddrug", Mapped.mapStraightThrough(sqldsd));
	}
	
	/**
	 * Creates dataset definition for Generic Drug Report by Program and Dates Uses external SQL
	 * file
	 * 
	 * @param reportDefinition the report definition to add dataset to
	 */
	private void createDataSetDefinitionByProgramAndDates(ReportDefinition reportDefinition) {
		
		// Define parameters
		Parameter prog = new Parameter(ReportingConstants.PARAM_PROGRAMS, "Program", Program.class);
		prog.setRequired(false);
		reportDefinition.addParameter(prog);
		
		// Load SQL from external file
		String sql = SqlQueryLoader.loadQuery(ReportingConstants.SQL_GENERIC_DRUG_REPORT_BY_PROGRAM);
		log.debug("Loaded Generic Drug Report by Program SQL (" + sql.length() + " characters)");
		
		// Create dataset
		SqlDataSetDefinition sqldsd = new SqlDataSetDefinition();
		sqldsd.setSqlQuery(sql);
		sqldsd.addParameter(new Parameter(ReportingConstants.PARAM_START_DATE, ReportingConstants.PARAM_START_DATE_LABEL,
		        Date.class));
		sqldsd.addParameter(new Parameter(ReportingConstants.PARAM_END_DATE, ReportingConstants.PARAM_END_DATE_LABEL,
		        Date.class));
		sqldsd.addParameter(prog);
		
		reportDefinition.addDataSetDefinition("dsdprogram", Mapped.mapStraightThrough(sqldsd));
	}
	
}
