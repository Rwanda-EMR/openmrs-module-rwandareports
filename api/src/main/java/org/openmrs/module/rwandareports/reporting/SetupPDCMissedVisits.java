package org.openmrs.module.rwandareports.reporting;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import org.openmrs.Concept;
import org.openmrs.EncounterType;
import org.openmrs.Form;
import org.openmrs.Location;
import org.openmrs.Program;
import org.openmrs.module.reporting.cohort.definition.InProgramCohortDefinition;
import org.openmrs.module.reporting.cohort.definition.InverseCohortDefinition;
import org.openmrs.module.reporting.common.SortCriteria;
import org.openmrs.module.reporting.common.SortCriteria.SortDirection;
import org.openmrs.module.reporting.evaluation.parameter.Parameter;
import org.openmrs.module.reporting.evaluation.parameter.ParameterizableUtil;
import org.openmrs.module.reporting.report.ReportDesign;
import org.openmrs.module.reporting.report.definition.ReportDefinition;
import org.openmrs.module.rowperpatientreports.dataset.definition.RowPerPatientDataSetDefinition;
import org.openmrs.module.rowperpatientreports.patientdata.definition.CustomCalculationBasedOnMultiplePatientDataDefinitions;
import org.openmrs.module.rowperpatientreports.patientdata.definition.MostRecentObservation;
import org.openmrs.module.rowperpatientreports.patientdata.definition.ObservationInMostRecentEncounterOfType;
import org.openmrs.module.rowperpatientreports.patientdata.definition.PatientAgeInMonths;
import org.openmrs.module.rowperpatientreports.patientdata.definition.PatientProperty;
import org.openmrs.module.rowperpatientreports.patientdata.definition.RecentEncounter;
import org.openmrs.module.rowperpatientreports.patientdata.definition.RecentEncounterType;
import org.openmrs.module.rwandareports.customcalculator.PDCAlerts;
import org.openmrs.module.rwandareports.filter.LastEncounterFilter;
import org.openmrs.module.rwandareports.util.Cohorts;
import org.openmrs.module.rwandareports.util.GlobalPropertiesManagement;
import org.openmrs.module.rwandareports.util.RowPerPatientColumns;

public class SetupPDCMissedVisits extends SingleSetupReport {
	
	//properties retrieved from global variables
	private Program PDCProgram;
	
	List<EncounterType> pdcEncounters;
	
	private ArrayList<Form> intakeForm = new ArrayList<Form>();
	
	private EncounterType pdcEncType;
	
	private List<Form> referralAndVisitForms = new ArrayList<Form>();
	
	private Form referralForm;
	
	private List<Form> referralFormList = new ArrayList<Form>();
	
	private Form visitForm;
	
	private Concept returnVisitDate;
	
	private Concept namesAndFirstNamesOfContact;
	
	private Concept telephoneNumberOfContact;
	
	@Override
	public String getReportName() {
		return "PDC Missed Visits";
	}
	
	public void setup() throws Exception {
		log.info("Setting up report: " + getReportName());
		setupProperties();
		
		ReportDefinition rd = createReportDefinition();
		
		ReportDesign design = Helper.createRowPerPatientXlsOverviewReportDesign(rd, "PDCMissedVisitSheet.xls",
		    "PDCMissedVisitSheet.xls_", null);
		
		Properties props = new Properties();
		props.put("repeatingSections", "sheet:1,row:9,dataset:dataSet|sheet:1,row:13,dataset:dataSet2");
		props.put("sortWeight", "5000");
		design.setProperties(props);
		
		Helper.saveReportDesign(design);
	}
	
	private ReportDefinition createReportDefinition() {
		
		ReportDefinition reportDefinition = new ReportDefinition();
		reportDefinition.setName(getReportName());
		
		reportDefinition.addParameter(new Parameter("location", "Health Center", Location.class));
		reportDefinition.setBaseCohortDefinition(Cohorts.createParameterizedLocationCohort("At Location"),
		    ParameterizableUtil.createParameterMappings("location=${location}"));
		reportDefinition.addParameter(new Parameter("endDate", "Monday", Date.class));
		createDataSetDefinition(reportDefinition);
		
		Helper.saveReportDefinition(reportDefinition);
		
		return reportDefinition;
	}
	
	private void createDataSetDefinition(ReportDefinition reportDefinition) {
		// Create new dataset definition 
		RowPerPatientDataSetDefinition dataSetDefinition = new RowPerPatientDataSetDefinition();
		RowPerPatientDataSetDefinition dataSetDefinition2 = new RowPerPatientDataSetDefinition();
		dataSetDefinition.setName("PDC Missed Visits Data Set");
		
		SortCriteria sortCriteria = new SortCriteria();
		sortCriteria.addSortElement("LastVisit Date", SortDirection.DESC);
		dataSetDefinition.setSortCriteria(sortCriteria);
		dataSetDefinition2.setSortCriteria(sortCriteria);
		
		dataSetDefinition.addParameter(new Parameter("location", "Location", Location.class));
		dataSetDefinition.addParameter(new Parameter("endDate", "Monday", Date.class));
		dataSetDefinition2.addParameter(new Parameter("location", "Location", Location.class));
		dataSetDefinition2.addParameter(new Parameter("endDate", "Monday", Date.class));
		
		//Add filters
		dataSetDefinition.addFilter(
		    Cohorts.createInProgramParameterizableByDate("Patients in " + PDCProgram.getName(), PDCProgram),
		    ParameterizableUtil.createParameterMappings("onDate=${endDate}"));
		//dataSetDefinition.addFilter(Cohorts.createPatientsLateForPDCVisit(pdcEncType,1), ParameterizableUtil.createParameterMappings("endDate=${endDate}"));
		dataSetDefinition.addFilter(Cohorts.createPatientsLateForVisit(pdcEncType, 1),
		    ParameterizableUtil.createParameterMappings("endDate=${endDate}"));
		dataSetDefinition2.addFilter(Cohorts.createPatientsLateForVisit(referralFormList, pdcEncType),
		    ParameterizableUtil.createParameterMappings("endDate=${endDate}"));
		InProgramCohortDefinition inprogram = Cohorts.createInProgramParameterizableByDate(
		    "Patients in " + PDCProgram.getName(), PDCProgram);
		InverseCohortDefinition notInProgram = new InverseCohortDefinition(inprogram);
		dataSetDefinition2.addFilter(notInProgram, new HashMap<String, Object>());
		
		//Add Columns
		dataSetDefinition.addColumn(RowPerPatientColumns.getFirstNameColumn("givenName"), new HashMap<String, Object>());
		dataSetDefinition2.addColumn(RowPerPatientColumns.getFirstNameColumn("givenName"), new HashMap<String, Object>());
		dataSetDefinition.addColumn(RowPerPatientColumns.getFamilyNameColumn("familyName"), new HashMap<String, Object>());
		dataSetDefinition2.addColumn(RowPerPatientColumns.getFamilyNameColumn("familyName"), new HashMap<String, Object>());
		dataSetDefinition.addColumn(RowPerPatientColumns.getIMBId("Id"), new HashMap<String, Object>());
		dataSetDefinition2.addColumn(RowPerPatientColumns.getIMBId("Id"), new HashMap<String, Object>());
		
		PatientAgeInMonths ageinMonths = RowPerPatientColumns.getAgeInMonths("age");
		dataSetDefinition.addColumn(ageinMonths, new HashMap<String, Object>());
		dataSetDefinition2.addColumn(ageinMonths, new HashMap<String, Object>());
		
		PatientProperty ageinYrs = RowPerPatientColumns.getAge("ageinYrs");
		dataSetDefinition.addColumn(ageinYrs, new HashMap<String, Object>());
		dataSetDefinition2.addColumn(ageinYrs, new HashMap<String, Object>());
		
		dataSetDefinition.addColumn(RowPerPatientColumns.getGender("Sex"), new HashMap<String, Object>());
		dataSetDefinition2.addColumn(RowPerPatientColumns.getGender("Sex"), new HashMap<String, Object>());
		
		MostRecentObservation intervalgrowth = RowPerPatientColumns
		        .getMostRecentIntervalGrowth("intervalgrowth", "@ddMMMyy");
		dataSetDefinition.addColumn(intervalgrowth, new HashMap<String, Object>());
		dataSetDefinition2.addColumn(intervalgrowth, new HashMap<String, Object>());
		
		MostRecentObservation intervalgrowthcoded = RowPerPatientColumns.getMostRecentCodedIntGrowth("inadequate",
		    "@ddMMMyy");
		dataSetDefinition.addColumn(intervalgrowthcoded, new HashMap<String, Object>());
		dataSetDefinition2.addColumn(intervalgrowthcoded, new HashMap<String, Object>());
		
		MostRecentObservation wtAgezscore = RowPerPatientColumns.getMostRecentWtAgezscore("wtagezcore", "@ddMMMyy");
		dataSetDefinition.addColumn(wtAgezscore, new HashMap<String, Object>());
		dataSetDefinition2.addColumn(wtAgezscore, new HashMap<String, Object>());
		
		MostRecentObservation wtHeightzcore = RowPerPatientColumns.getMostRecentWtHeightzscore("wthtzscore", "@ddMMMyy");
		dataSetDefinition.addColumn(wtHeightzcore, new HashMap<String, Object>());
		dataSetDefinition2.addColumn(wtHeightzcore, new HashMap<String, Object>());
		
		MostRecentObservation temperaturesign = RowPerPatientColumns.getMostRecentTemperature("temperature", "@ddMMMMyy");
		dataSetDefinition.addColumn(temperaturesign, new HashMap<String, Object>());
		dataSetDefinition2.addColumn(temperaturesign, new HashMap<String, Object>());
		
		MostRecentObservation respitatorysign = RowPerPatientColumns.getMostRecentRespiratoryRate("respitatorysign",
		    "@ddMMMMyy");
		dataSetDefinition.addColumn(respitatorysign, new HashMap<String, Object>());
		dataSetDefinition2.addColumn(respitatorysign, new HashMap<String, Object>());
		
		MostRecentObservation asqScore = RowPerPatientColumns.getMostRecentASQ("asqscore", "@ddMMMMyy");
		dataSetDefinition.addColumn(asqScore, new HashMap<String, Object>());
		dataSetDefinition2.addColumn(asqScore, new HashMap<String, Object>());
		
		MostRecentObservation swAssesment = RowPerPatientColumns.getMostRecentSWA("swa", "@ddMMMMyy");
		dataSetDefinition.addColumn(swAssesment, new HashMap<String, Object>());
		dataSetDefinition2.addColumn(swAssesment, new HashMap<String, Object>());
		
		MostRecentObservation ecdeducation = RowPerPatientColumns.getMostRecentECDEDUC("ecdeducation", "@ddMMMMyy");
		dataSetDefinition.addColumn(ecdeducation, new HashMap<String, Object>());
		dataSetDefinition2.addColumn(ecdeducation, new HashMap<String, Object>());
		
		MostRecentObservation discharged = RowPerPatientColumns.getMostRecentCondition("dischargedmet", "@ddMMMMyy");
		dataSetDefinition.addColumn(discharged, new HashMap<String, Object>());
		dataSetDefinition2.addColumn(discharged, new HashMap<String, Object>());
		
		ObservationInMostRecentEncounterOfType nextVisit = RowPerPatientColumns.getReturnVisitInMostRecentEncounterOfType(
		    "nextVisit", pdcEncType);
		dataSetDefinition.addColumn(nextVisit, new HashMap<String, Object>());
		dataSetDefinition2.addColumn(nextVisit, new HashMap<String, Object>());
		
		RecentEncounter lastpdcIntake = RowPerPatientColumns.getRecentEncounter("lastintake", intakeForm, pdcEncounters,
		    "dd-MMM-yyyy", null);
		dataSetDefinition.addColumn(lastpdcIntake, new HashMap<String, Object>());
		dataSetDefinition2.addColumn(lastpdcIntake, new HashMap<String, Object>());
		
		RecentEncounterType lastEncounterType = RowPerPatientColumns.getRecentEncounterType("LastVisit", pdcEncounters,
		    null, new LastEncounterFilter());
		dataSetDefinition.addColumn(lastEncounterType, new HashMap<String, Object>());
		dataSetDefinition2.addColumn(lastEncounterType, new HashMap<String, Object>());
		
		dataSetDefinition.addColumn(RowPerPatientColumns.getPatientAddress("address", true, true, true, true),
		    new HashMap<String, Object>());
		dataSetDefinition2.addColumn(RowPerPatientColumns.getPatientAddress("address", true, true, true, true),
		    new HashMap<String, Object>());
		
		dataSetDefinition.addColumn(RowPerPatientColumns.getMostRecentInPeriod("Next Of Kin Name",
		    namesAndFirstNamesOfContact, null, null, "dd-MMM-yyyy"), new HashMap<String, Object>());
		dataSetDefinition2.addColumn(RowPerPatientColumns.getMostRecentInPeriod("Next Of Kin Name",
		    namesAndFirstNamesOfContact, null, null, "dd-MMM-yyyy"), new HashMap<String, Object>());
		
		dataSetDefinition.addColumn(RowPerPatientColumns.getMostRecentInPeriod("Next Of Kin Tel Number",
		    telephoneNumberOfContact, null, null, "dd-MMM-yyyy"), new HashMap<String, Object>());
		dataSetDefinition2.addColumn(RowPerPatientColumns.getMostRecentInPeriod("Next Of Kin Tel Number",
		    telephoneNumberOfContact, null, null, "dd-MMM-yyyy"), new HashMap<String, Object>());
		
		CustomCalculationBasedOnMultiplePatientDataDefinitions alert = new CustomCalculationBasedOnMultiplePatientDataDefinitions();
		alert.setName("alert");
		alert.addPatientDataToBeEvaluated(intervalgrowth, new HashMap<String, Object>());
		alert.addPatientDataToBeEvaluated(intervalgrowthcoded, new HashMap<String, Object>());
		alert.addPatientDataToBeEvaluated(wtAgezscore, new HashMap<String, Object>());
		alert.addPatientDataToBeEvaluated(wtHeightzcore, new HashMap<String, Object>());
		alert.addPatientDataToBeEvaluated(temperaturesign, new HashMap<String, Object>());
		alert.addPatientDataToBeEvaluated(respitatorysign, new HashMap<String, Object>());
		alert.addPatientDataToBeEvaluated(asqScore, new HashMap<String, Object>());
		alert.addPatientDataToBeEvaluated(ageinMonths, new HashMap<String, Object>());
		alert.addPatientDataToBeEvaluated(swAssesment, new HashMap<String, Object>());
		alert.addPatientDataToBeEvaluated(ecdeducation, new HashMap<String, Object>());
		alert.addPatientDataToBeEvaluated(discharged, new HashMap<String, Object>());
		alert.addPatientDataToBeEvaluated(nextVisit, new HashMap<String, Object>());
		alert.addPatientDataToBeEvaluated(lastpdcIntake, new HashMap<String, Object>());
		alert.setCalculator(new PDCAlerts());
		dataSetDefinition.addColumn(alert, new HashMap<String, Object>());
		dataSetDefinition2.addColumn(alert, new HashMap<String, Object>());
		
		Map<String, Object> mappings = new HashMap<String, Object>();
		mappings.put("location", "${location}");
		mappings.put("endDate", "${endDate}");
		
		reportDefinition.addDataSetDefinition("dataSet", dataSetDefinition, mappings);
		reportDefinition.addDataSetDefinition("dataSet2", dataSetDefinition2, mappings);
	}
	
	private void setupProperties() {
		PDCProgram = gp.getProgram(GlobalPropertiesManagement.PDC_PROGRAM);
		pdcEncounters = gp.getEncounterTypeList(GlobalPropertiesManagement.PDC_VISIT);
		pdcEncType = gp.getEncounterType(GlobalPropertiesManagement.PDC_VISIT);
		intakeForm.add(gp.getForm(GlobalPropertiesManagement.PDC_INTAKE_FORM));
		referralForm = gp.getForm(GlobalPropertiesManagement.PDC_REFERRAL_FORM);
		visitForm = gp.getForm(GlobalPropertiesManagement.PDC_VISIT_FORM);
		referralFormList.add(referralForm);
		referralAndVisitForms.add(referralForm);
		referralAndVisitForms.add(visitForm);
		returnVisitDate = gp.getConcept(GlobalPropertiesManagement.RETURN_VISIT_DATE);
		namesAndFirstNamesOfContact = gp.getConcept(GlobalPropertiesManagement.NAMESANDFIRSTNAMESOFCONTACT);
		
		telephoneNumberOfContact = gp.getConcept(GlobalPropertiesManagement.TELEPHONE_NUMBER_OF_CONTACT);
		
	}
	
}
