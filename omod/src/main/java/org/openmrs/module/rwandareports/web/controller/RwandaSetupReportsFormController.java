package org.openmrs.module.rwandareports.web.controller;

import org.openmrs.module.rwandareports.reporting.*;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.RedirectView;

@Controller
public class RwandaSetupReportsFormController {
	
	@RequestMapping("/module/rwandareports/register_adulthivartregister.form")
	public ModelAndView registerAdultHivArtRegiser() throws Exception {
		// new SetupHivArtRegisterReport(false).setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_adulthivartregister.form")
	public ModelAndView removeAdultHivArtRegister() throws Exception {
		// new SetupHivArtRegisterReport(false).delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/register_pedihivartregister.form")
	public ModelAndView registerPediHivArtRegiser() throws Exception {
		// new SetupHivArtRegisterReport(true).setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_pedihivartregister.form")
	public ModelAndView removePediHivArtRegister() throws Exception {
		// new SetupHivArtRegisterReport(true).delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/register_combinedHSCSPConsultation.form")
	public ModelAndView registerCombinedHSCSPConsultation() throws Exception {
		new SetupCombinedHFCSPConsultationReport().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_combinedHSCSPConsultation.form")
	public ModelAndView removeCombinedHSCSPConsultation() throws Exception {
		new SetupCombinedHFCSPConsultationReport().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/register_EncounterAndObsReport.form")
	public ModelAndView registerEncounterAndObsReport() throws Exception {
		new SetupGenericEncounterReport().setup();
		//new SetupGenericEncounterBySiteReport().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_EncounterAndObsReport.form")
	public ModelAndView removeEncounterAndObsReport() throws Exception {
		new SetupGenericEncounterReport().delete();
		//new SetupGenericEncounterBySiteReport().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	/*
	 * @RequestMapping("/module/rwandareports/register_pmtctFoodDistributionSheet"
	 * ) public ModelAndView registerPmtctFoodDistribution() throws Exception {
	 * new SetupPMTCTFoodDistributionReport().setup(); return new
	 * ModelAndView(new RedirectView("rwandareports.form")); }
	 * 
	 * @RequestMapping("/module/rwandareports/remove_pmtctFoodDistributionSheet")
	 * public ModelAndView removePmtctFoodDistribution() throws Exception { new
	 * SetupPMTCTFoodDistributionReport().delete(); return new ModelAndView(new
	 * RedirectView("rwandareports.form")); }
	 * 
	 * @RequestMapping(
	 * "/module/rwandareports/register_pmtctFormulaDistributionSheet") public
	 * ModelAndView registerPmtctFormulaDistribution() throws Exception { new
	 * SetupPMTCTFormulaDistributionReport().setup(); return new
	 * ModelAndView(new RedirectView("rwandareports.form")); }
	 * 
	 * @RequestMapping("/module/rwandareports/remove_pmtctFormulaDistributionSheet"
	 * ) public ModelAndView removePmtctFormulaDistribution() throws Exception {
	 * new SetupPMTCTFormulaDistributionReport().delete(); return new
	 * ModelAndView(new RedirectView("rwandareports.form")); }
	 */
	@RequestMapping("/module/rwandareports/register_pmtctPregnancyConsultationSheet.form")
	public ModelAndView registerPmtctPregnancyConsultation() throws Exception {
		new SetupPMTCTPregnancyConsultationReport().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_pmtctPregnancyConsultationSheet.form")
	public ModelAndView removePmtctPregnanacyConsultation() throws Exception {
		new SetupPMTCTPregnancyConsultationReport().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	/*
	 * @RequestMapping("/module/rwandareports/register_pmtctFormCompletionSheet")
	 * public ModelAndView registerPmtctFormCompletionSheet() throws Exception {
	 * new SetupPMTCTFormCompletionSheet().setup(); return new ModelAndView(new
	 * RedirectView("rwandareports.form")); }
	 * 
	 * @RequestMapping("/module/rwandareports/remove_pmtctFormCompletionSheet")
	 * public ModelAndView removePmtctFormCompletionSheet() throws Exception {
	 * new SetupPMTCTFormCompletionSheet().delete(); return new ModelAndView(new
	 * RedirectView("rwandareports.form")); }
	 */
	
	// Consult sheets
	@RequestMapping("/module/rwandareports/register_pediHIVConsultationSheet.form")
	public ModelAndView registerPediHIVConsultationSheet() throws Exception {
		new SetupPediHIVConsultationSheet().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_pediHIVConsultationSheet.form")
	public ModelAndView removePediHIVConsultationSheet() throws Exception {
		new SetupPediHIVConsultationSheet().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/register_adultHIVConsultationSheet.form")
	public ModelAndView registerAdultHIVConsultationSheet() throws Exception {
		new SetupAdultHIVConsultationSheet().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_adultHIVConsultationSheet.form")
	public ModelAndView removeAdultHIVConsultationSheet() throws Exception {
		new SetupAdultHIVConsultationSheet().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/register_tbConsultationSheet.form")
	public ModelAndView registerTbConsultationSheet() throws Exception {
		new SetupTBConsultationSheet().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_tbConsultationSheet.form")
	public ModelAndView removeTbConsultationSheet() throws Exception {
		new SetupTBConsultationSheet().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/register_asthmaConsultationSheet.form")
	public ModelAndView registerAsthmaConsultationSheet() throws Exception {
		new SetupAsthmaConsultationSheet().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_asthmaConsultationSheet.form")
	public ModelAndView removeAsthmaConsultationSheet() throws Exception {
		new SetupAsthmaConsultationSheet().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	// Remove/Register Adult Late visit And CD4
	
	@RequestMapping("/module/rwandareports/register_adultLatevisitAndCD4.form")
	public ModelAndView registerAdultLatevisitAndCD4() throws Exception {
		new SetupAdultLateVisitAndCD4Report().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_adultLatevisitAndCD4.form")
	public ModelAndView removeAdultLatevisitAndCD4() throws Exception {
		new SetupAdultLateVisitAndCD4Report().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	// Remove/Register Pediatric Late visit And CD4
	@RequestMapping("/module/rwandareports/register_pediatricLatevisitAndCD4.form")
	public ModelAndView registerPediatricLatevisitAndCD4() throws Exception {
		new SetupPediatricLateVisitAndCD4Report().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_pediatricLatevisitAndCD4.form")
	public ModelAndView removePediatricLatevisitAndCD4() throws Exception {
		new SetupPediatricLateVisitAndCD4Report().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	// Remove/Register Heart Failure report by site and all
	@RequestMapping("/module/rwandareports/remove_heartFailureReport.form")
	public ModelAndView removeHeartFailureIndicator() throws Exception {
		new SetupHeartFailurereport().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/register_heartFailureReport.form")
	public ModelAndView registerHeartFailureIndicatorIndicator() throws Exception {
		new SetupHeartFailurereport().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	// end of Heart failure report
	
	/*
	 * @RequestMapping("/module/rwandareports/register_missingCD4Report") public
	 * ModelAndView registerMissingCD4Report() throws Exception { new
	 * SetupMissingCD4Report().setup(); return new ModelAndView(new
	 * RedirectView("rwandareports.form")); }
	 * 
	 * @RequestMapping("/module/rwandareports/remove_missingCD4Report") public
	 * ModelAndView removeMissingCD4Report() throws Exception { new
	 * SetupMissingCD4Report().delete(); return new ModelAndView(new
	 * RedirectView("rwandareports.form")); }
	 */
	@RequestMapping("/module/rwandareports/register_dataQualityReport.form")
	public ModelAndView registerDataQualityReport() throws Exception {
		new SetupDataQualityIndicatorReport().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_dataQualityReport.form")
	public ModelAndView removeDataQualityReport() throws Exception {
		new SetupDataQualityIndicatorReport().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	// Diabetes Consult/LTFU
	@RequestMapping("/module/rwandareports/register_DiabetesConsultAndLTFU.form")
	public ModelAndView registerDiabetesConsultAndLTFU() throws Exception {
		new SetupDiabetesConsultAndLTFU().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_DiabetesConsultAndLTFU.form")
	public ModelAndView removeDiabetesConsultAndLTFU() throws Exception {
		new SetupDiabetesConsultAndLTFU().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	// NCD late visit and LTFU
	@RequestMapping("/module/rwandareports/register_NCDlatevistAndLTFU.form")
	public ModelAndView registerNCDlatevistAndLTFUReport() throws Exception {
		new SetupNCDLateVisitandLTFUReport().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_NCDlatevistAndLTFU.form")
	public ModelAndView removeNCDlatevistAndLTFUReport() throws Exception {
		new SetupNCDLateVisitandLTFUReport().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	// Remove/Register Pediatric Late visit And CD4
	@RequestMapping("/module/rwandareports/register_NCDConsult.form")
	public ModelAndView registerNCDConsult() throws Exception {
		new SetupNCDConsultationSheet().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_NCDConsult.form")
	public ModelAndView removeNCDConsult() throws Exception {
		new SetupNCDConsultationSheet().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	/*
	 * @RequestMapping("/module/rwandareports/register_monthlyCD4Decline")
	 * public ModelAndView registerMonthlyCD4Decline() throws Exception { new
	 * SetupMonthlyCD4DeclineReport().setup(); return new ModelAndView(new
	 * RedirectView("rwandareports.form")); }
	 * 
	 * @RequestMapping("/module/rwandareports/remove_monthlyCD4Decline") public
	 * ModelAndView removeMonthlyCD4Decline() throws Exception { new
	 * SetupMonthlyCD4DeclineReport().delete(); return new ModelAndView(new
	 * RedirectView("rwandareports.form")); }
	 */
	
	@RequestMapping("/module/rwandareports/register_DiabetesQuarterlyAndMonthReport.form")
	public ModelAndView registerDiabetesQuarterlyAndMonthReport() throws Exception {
		new SetupDiabetesQuarterlyAndMonthReport().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_DiabetesQuarterlyAndMonthReport.form")
	public ModelAndView removeDiabetesQuarterlyAndMonthReport() throws Exception {
		new SetupDiabetesQuarterlyAndMonthReport().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	// Remove/Register HMIS report
	@RequestMapping("/module/rwandareports/remove_hmisReport.form")
	public ModelAndView removeHMISIndicator() throws Exception {
		new SetupHMISRwandaReportBySite().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/register_hmisReport.form")
	public ModelAndView registerHMISIndicator() throws Exception {
		new SetupHMISRwandaReportBySite().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	// Remove/Register PMTCT Combined Clinic Mother Monthly Report report
	
	@RequestMapping("/module/rwandareports/register_pmtctCombinedClinicMotherMonthlyReport.form")
	public ModelAndView registerPMTCTCombinedClinicMotherMonthly() throws Exception {
		new SetupPMTCTCombinedClinicMotherMonthlyReport().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_pmtctCombinedClinicMotherMonthlyReport.form")
	public ModelAndView removePMTCTCombinedClinicMotherMonthly() throws Exception {
		new SetupPMTCTCombinedClinicMotherMonthlyReport().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	// Remove/Register Asthma Quarterly And Monthly Report
	
	@RequestMapping("/module/rwandareports/register_asthmaQuarterlyAndMonthReport.form")
	public ModelAndView registerAsthmaQuarterlyAndMonthReport() throws Exception {
		new SetupAsthmaQuarterlyAndMonthReport().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_asthmaQuarterlyAndMonthReport.form")
	public ModelAndView removeAsthmaQuarterlyAndMonthReport() throws Exception {
		new SetupAsthmaQuarterlyAndMonthReport().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	// Remove/Register Asthma Late Visit Report
	
	@RequestMapping("/module/rwandareports/register_asthmaLateVisitReport.form")
	public ModelAndView registerAsthmaLateVisit() throws Exception {
		new SetupAsthmaLateVisit().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_asthmaLateVisitReport.form")
	public ModelAndView removeAsthmaLateVisit() throws Exception {
		new SetupAsthmaLateVisit().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	// Hypertension Reports
	@RequestMapping("/module/rwandareports/register_hypertensionConsultationSheet.form")
	public ModelAndView registerHypertensionConsultationSheet() throws Exception {
		new SetupHypertensionConsultationSheet().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_hypertensionConsultationSheet.form")
	public ModelAndView removeHypertensionConsultationSheet() throws Exception {
		new SetupHypertensionConsultationSheet().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/register_hypertensionLateVisit.form")
	public ModelAndView registerHypertensionLateVisit() throws Exception {
		new SetupHypertensionLateVisit().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_hypertensionLateVisit.form")
	public ModelAndView removeHypertensionLateVisit() throws Exception {
		new SetupHypertensionLateVisit().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/register_hypertensionQuarterlyAndMonthlyReport.form")
	public ModelAndView registerHypertensionQuarterlyAndMonthlyReport() throws Exception {
		new SetupHypertensionQuarterlyAndMonthlyReport().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_hypertensionQuarterlyAndMonthlyReport.form")
	public ModelAndView removeHypertensionQuarterlyAndMonthlyReport() throws Exception {
		new SetupHypertensionQuarterlyAndMonthlyReport().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	// Remove/Register PMTCT Pregnancy Monthly Report
	
	@RequestMapping("/module/rwandareports/register_pmtctPregMonthlyReport.form")
	public ModelAndView registerPMTCTPregMonthlyVisit() throws Exception {
		new SetupPMTCTPregnancyMonthlyReport().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_pmtctPregMonthlyReport.form")
	public ModelAndView removePMTCTPregMonthlyVisit() throws Exception {
		new SetupPMTCTPregnancyMonthlyReport().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	// Remove/Register Combined Infant Monthly Report
	
	@RequestMapping("/module/rwandareports/register_pmtctCombinedClinicInfantReport.form")
	public ModelAndView registerPMTCTCombinedInfantReport() throws Exception {
		new SetupExposedClinicInfantMonthly().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_pmtctCombinedClinicInfantReport.form")
	public ModelAndView removePMTCTCombinedInfantReport() throws Exception {
		new SetupExposedClinicInfantMonthly().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	// Oncology Reports
	@RequestMapping("/module/rwandareports/register_treatmentAdministrationPlan.form")
	public ModelAndView registerTreatmentAdministrationPlan() throws Exception {
		new SetupOncologyTreatmentAdministrationPlan().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_treatmentAdministrationPlan.form")
	public ModelAndView removeTreatmentAdministrationPlan() throws Exception {
		new SetupOncologyTreatmentAdministrationPlan().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/register_oncologyBiopsyList.form")
	public ModelAndView registerOncologyBiopsyList() throws Exception {
		new SetupOncologyTestPatientList().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_oncologyBiopsyList.form")
	public ModelAndView removeOncologyBiopsyList() throws Exception {
		new SetupOncologyTestPatientList().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/register_oncologyExternalBiopsyList.form")
	public ModelAndView registerOncologyExternalBiopsyList() throws Exception {
		new SetupOncologyExternalBiopsyContactList().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_oncologyExternalBiopsyList.form")
	public ModelAndView removeOncologyExternalBiopsyList() throws Exception {
		new SetupOncologyExternalBiopsyContactList().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/register_chemotherapyPatientList.form")
	public ModelAndView registerChemotherapyPatientList() throws Exception {
		new SetupChemotherapyExpectedPatientList().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_chemotherapyPatientList.form")
	public ModelAndView removeChemotherapyPatientList() throws Exception {
		new SetupChemotherapyExpectedPatientList().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/register_chemotherapyDailyPatientList.form")
	public ModelAndView registerChemotherapyDailyPatientList() throws Exception {
		new SetupChemotherapyDailyExpectedPatientList().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_chemotherapyDailyPatientList.form")
	public ModelAndView removeChemotherapyDailyPatientList() throws Exception {
		new SetupChemotherapyDailyExpectedPatientList().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/register_missedChemotherapyPatientList.form")
	public ModelAndView registerMissedChemotherapyPatientList() throws Exception {
		new SetupMissedChemotherapyPatientList().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_missedChemotherapyPatientList.form")
	public ModelAndView removeMissedChemotherapyPatientList() throws Exception {
		new SetupMissedChemotherapyPatientList().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/register_oncologyOutpatientClinicPatientList.form")
	public ModelAndView registerOncologyOutpatientClinicPatientList() throws Exception {
		new SetupOncologyOutpatientClinicPatientList().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_oncologyOutpatientClinicPatientList.form")
	public ModelAndView removeOncologyOutpatientClinicPatientList() throws Exception {
		new SetupOncologyOutpatientClinicPatientList().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/register_oncologyOutpatientClinicMissedVisit.form")
	public ModelAndView registerOncologyOutpatientClinicMissedVisit() throws Exception {
		new SetupOncologyOutpatientClinicMissedVisit().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_oncologyOutpatientClinicMissedVisit.form")
	public ModelAndView removeOncologyOutpatientClinicMissedVisit() throws Exception {
		new SetupOncologyOutpatientClinicMissedVisit().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/register_oncologyOutpatientAppointment.form")
	public ModelAndView registerOncologyOutpatientAppointment() throws Exception {
		new SetupOncologyOutpatientAppointmentList().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_oncologyOutpatientAppointment.form")
	public ModelAndView removeOncologyOutpatientAppointment() throws Exception {
		new SetupOncologyOutpatientAppointmentList().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	// Data Delay
	@RequestMapping("/module/rwandareports/register_dataDelay.form")
	public ModelAndView registerDataDelay() throws Exception {
		new SetupDataEntryDelayReport().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_dataDelay.form")
	public ModelAndView removeDataDelay() throws Exception {
		new SetupDataEntryDelayReport().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	// ID Program Quarterly Indicators
	@RequestMapping("/module/rwandareports/register_IDProgramQuarterlyIndicators.form")
	public ModelAndView registerIDProgramQuarterlyIndicators() throws Exception {
		new SetupIDProgramQuarterlyIndicatorReport().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_IDProgramQuarterlyIndicators.form")
	public ModelAndView removeIDProgramQuarterlyIndicators() throws Exception {
		new SetupIDProgramQuarterlyIndicatorReport().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	// Remove/Register Heart Failure consult sheet by site and all
	@RequestMapping("/module/rwandareports/remove_heartFailureConsultSheet.form")
	public ModelAndView removeHeartFailureConsultSheet() throws Exception {
		new SetupHeartFailureConsultSheet().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/register_heartFailureConsultSheet.form")
	public ModelAndView registerHeartFailureConsultSheet() throws Exception {
		new SetupHeartFailureConsultSheet().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	// Remove/Register Heart Failure Late Visit by site and all
	@RequestMapping("/module/rwandareports/remove_heartFailureLateVisit.form")
	public ModelAndView removeHeartFailureLateVisit() throws Exception {
		new SetupHeartFailureLateVisit().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/register_heartFailureLateVisit.form")
	public ModelAndView registerHeartFailureLateVisit() throws Exception {
		new SetupHeartFailureLateVisit().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	// Heart Failure Quarterly and Monthly Reports
	@RequestMapping("/module/rwandareports/register_heartFailureQuarterlyAndMonthlyReport.form")
	public ModelAndView registerHeartFailureQuarterlyAndMonthlyReport() throws Exception {
		new SetupHeartFailureQuarterlyAndMonthlyReport().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_heartFailureQuarterlyAndMonthlyReport.form")
	public ModelAndView removeHeartFailureQuarterlyAndMonthlyReport() throws Exception {
		new SetupHeartFailureQuarterlyAndMonthlyReport().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	// Remove/Register Oncology data extraction report
	@RequestMapping("/module/rwandareports/register_oncologydataextrationSheet.form")
	public ModelAndView registerOncologyDataExtrationSheet() throws Exception {
		new SetupOncologyDataExtractionSheet().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_oncologydataextrationSheet.form")
	public ModelAndView removeOncologyDataExtrationSheet() throws Exception {
		new SetupOncologyDataExtractionSheet().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	// Remove/Register Oncology quarterly indicato report
	@RequestMapping("/module/rwandareports/register_oncologyquarterlyindicatorreport.form")
	public ModelAndView registerOncologyQuarterlyIndicatorReport() throws Exception {
		new SetupOncologyQuarterlyIndicatorReport().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_oncologyquarterlyindicatorreport.form")
	public ModelAndView removeOncologyQuarterlyIndicatorReport() throws Exception {
		new SetupOncologyQuarterlyIndicatorReport().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/register_oncologyOutpatientExpectedPatientList.form")
	public ModelAndView registerOncologyOutpatientExpectedPatientListReport() throws Exception {
		new SetupOncologyOutpatientExpectedPatientList().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_oncologyOutpatientExpectedPatientList.form")
	public ModelAndView removeOncologyOutpatientExpectedPatientListReport() throws Exception {
		new SetupOncologyOutpatientExpectedPatientList().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/register_oncologyInpatientClinicMissedVisit.form")
	public ModelAndView registerOncologyInpatientClinicMissedVisitReport() throws Exception {
		new SetupOncologyInpatientClinicMissedVisit().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_oncologyInpatientClinicMissedVisit.form")
	public ModelAndView removeOncologyInpatientClinicMissedVisitReport() throws Exception {
		new SetupOncologyInpatientClinicMissedVisit().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/register_OncologyRegistry.form")
	public ModelAndView registerOncologyRegistryReport() throws Exception {
		new SetupOncologyRegistry().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_OncologyRegistry.form")
	public ModelAndView removeOncologyRegistryReport() throws Exception {
		new SetupOncologyRegistry().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	// Remove/Register PBF report
	@RequestMapping("/module/rwandareports/remove_PBFReport.form")
	public ModelAndView removePBFIndicator() throws Exception {
		new SetupPBFReport().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/register_PBFReport.form")
	public ModelAndView registerPBFIndicator() throws Exception {
		new SetupPBFReport().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	// Remove/Register PDC-consultation sheet
	@RequestMapping("/module/rwandareports/register_pdcWeeklySheet.form")
	public ModelAndView registerPDCIndicators() throws Exception {
		new SetupPDCWeeklyAlert().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_pdcWeeklySheet.form")
	public ModelAndView removePDCIndicators() throws Exception {
		new SetupPDCWeeklyAlert().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	// Remove/Register PDC-Weekly Consultation sheet
	@RequestMapping("/module/rwandareports/register_pdcMonthlySheet.form")
	public ModelAndView registerPDCMonthlyIndicators() throws Exception {
		new SetupPDCMonthlyAlert().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_pdcMonthlySheet.form")
	public ModelAndView removePDCMonthlyIndicators() throws Exception {
		new SetupPDCMonthlyAlert().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	// Remove/Register PDC-Indicator Report
	@RequestMapping("/module/rwandareports/register_pdcIndicatorReport.form")
	public ModelAndView registerPDCIndicatorReport() throws Exception {
		new SetupPDCIndicatorReport().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_pdcIndicatorReport.form")
	public ModelAndView removePDCIndicatorReport() throws Exception {
		new SetupPDCIndicatorReport().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	// Register/Remove PDC missed visits report
	@RequestMapping("/module/rwandareports/register_pdcMissedVisitsReport.form")
	public ModelAndView registerPDCMissedVisits() throws Exception {
		new SetupPDCMissedVisits().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_pdcMissedVisitsReport.form")
	public ModelAndView removePDCMissedVisits() throws Exception {
		new SetupPDCMissedVisits().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	// Register/Remove PDC Monthly Lost to Follow-up report
	@RequestMapping("/module/rwandareports/register_pdcMonthlyLTFUReport.form")
	public ModelAndView registerPDCMonthlyLTFU() throws Exception {
		new SetupPDCMonthlyLTFU().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_pdcMonthlyLTFUReport.form")
	public ModelAndView removePDCMonthlyLTFU() throws Exception {
		new SetupPDCMonthlyLTFU().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/register_PatientByProgramReport.form")
	public ModelAndView registerGenericPatientsByProgramReport() throws Exception {
		new SetupGenericPatientByProgramReport().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_PatientByProgramReport.form")
	public ModelAndView removeGenericPatientsByProgramReport() throws Exception {
		new SetupGenericPatientByProgramReport().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/register_DrugReport.form")
	public ModelAndView registerDrugReport() throws Exception {
		new SetupGenericDrugReport().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_DrugReport.form")
	public ModelAndView removeDrugReport() throws Exception {
		new SetupGenericDrugReport().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/register_CKDMissedVisitReport.form")
	public ModelAndView registerCKDMissedVisitReport() throws Exception {
		new SetupCKDMissedvisitReport().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_CKDMissedVisitReport.form")
	public ModelAndView removeCKDMissedVisitReport() throws Exception {
		new SetupCKDMissedvisitReport().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/register_CKDConsultSheetReport.form")
	public ModelAndView registerCKDConsultSheetReport() throws Exception {
		new SetupCKDConsultationSheetReport().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_CKDConsultSheetReport.form")
	public ModelAndView removeCKDConsultSheetReport() throws Exception {
		new SetupCKDConsultationSheetReport().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/register_CKDIndicatorReport.form")
	public ModelAndView registerCKDIndicatorReport() throws Exception {
		new SetupCKDQuarterlyAndMonthlyReport().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_CKDIndicatorReport.form")
	public ModelAndView removeCKDIndicatorReport() throws Exception {
		new SetupCKDQuarterlyAndMonthlyReport().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/register_MOH-HMISIndicatorreport.form")
	public ModelAndView registerMOHHMISIndicatorreport() throws Exception {
		new SetupHMISMOHReport().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_MOH-HMISIndicatorreport.form")
	public ModelAndView removeMOHHMISIndicatorreport() throws Exception {
		new SetupHMISMOHReport().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/register_MentalHealthConsultationreport.form")
	public ModelAndView registerMentalHealthConsultationreport() throws Exception {
		new SetupMentalHealthConsultationSheet().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_MentalHealthConsultationreport.form")
	public ModelAndView removeMentalHealthConsultationreport() throws Exception {
		new SetupMentalHealthConsultationSheet().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/register_MentalHealthLateVisit.form")
	public ModelAndView registerMentalHealthLateVisit() throws Exception {
		new SetupMentalHealthLateVisit().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_MentalHealthLateVisit.form")
	public ModelAndView removeMentalHealthLateVisit() throws Exception {
		new SetupMentalHealthLateVisit().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/register_MentalHealthIndicatorReport.form")
	public ModelAndView registerMentalHealthIndicatorReport() throws Exception {
		new SetupMentalHealthIndicatorReport().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_MentalHealthIndicatorReport.form")
	public ModelAndView removeMentalHealthIndicatorReport() throws Exception {
		new SetupMentalHealthIndicatorReport().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/register_MonthlyExecutiveDashboardMetricsReport.form")
	public ModelAndView registerMonthlyExecutiveDashboardMetricsReport() throws Exception {
		new SetupMonthlyExecutiveDashboardMetricsReport().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_MonthlyExecutiveDashboardMetricsReport.form")
	public ModelAndView removeMonthlyExecutiveDashboardMetricsReport() throws Exception {
		new SetupMonthlyExecutiveDashboardMetricsReport().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/register_HMISIndicatorMonthly.form")
	public ModelAndView registerHMISIndicatorMonthlyIndicatorReport() throws Exception {
		new SetupHMISIndicatorMonthlyReport().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_HMISIndicatorMonthlyReport.form")
	public ModelAndView removeHMISIndicatorMonthlyReport() throws Exception {
		new SetupHMISIndicatorMonthlyReport().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/register_DataEntryQuantityReport.form")
	public ModelAndView registerDataEntryQuantityReport() throws Exception {
		new SetupDataEntryQuantityReport().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_DataEntryQuantityReport.form")
	public ModelAndView removeDataEntryQuantityReport() throws Exception {
		new SetupDataEntryQuantityReport().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/register_LabResultReport.form")
	public ModelAndView registerGenericLabResultReport() throws Exception {
		new SetupLabResultReports().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_LabResultReport.form")
	public ModelAndView removeGenericLabResultReport() throws Exception {
		new SetupLabResultReports().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	//		@RequestMapping("/module/rwandareports/register_HMISCancerScreeningIndicatorReport")
	//	public ModelAndView registerHMISCancerScreeningIndicatorReport() throws Exception {
	//		new SetupHMISCancerScreeningMonthlyIndicatorReport().setup();
	//		return new ModelAndView(new RedirectView("rwandareports.form"));
	//	}
	//
	//	@RequestMapping("/module/rwandareports/remove_HMISCancerScreeningIndicatorReport")
	//	public ModelAndView removeHMISCancerScreeningIndicatorReport() throws Exception {
	//		new SetupHMISCancerScreeningMonthlyIndicatorReport().delete();
	//		return new ModelAndView(new RedirectView("rwandareports.form"));
	//	}
	@RequestMapping("/module/rwandareports/register_CancerScreeningConsultationSheetAndMissedVisitReport.form")
	public ModelAndView registerCancerScreeningConsultationSheetAndMissedVisitReport() throws Exception {
		new SetupCancerScreeningConsultAndMissedVisit().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_CancerScreeningConsultationSheetAndMissedVisitReport.form")
	public ModelAndView removeCancerScreeningConsultationSheetAndMissedVisitReport() throws Exception {
		new SetupCancerScreeningConsultAndMissedVisit().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	//		@RequestMapping("/module/rwandareports/register_CancerScreeningSMSReport")
	//	public ModelAndView registerCancerScreeningSMSReport() throws Exception {
	//		new SetupCancerScreeningSMSReport().setup();
	//		return new ModelAndView(new RedirectView("rwandareports.form"));
	//	}
	//
	//	@RequestMapping("/module/rwandareports/remove_CancerScreeningSMSReport")
	//	public ModelAndView removeCancerScreeningSMSReport() throws Exception {
	//		new SetupCancerScreeningSMSReport().delete();
	//		return new ModelAndView(new RedirectView("rwandareports.form"));
	//	}
	//	@RequestMapping("/module/rwandareports/register_SetupCancerScreeningLabReport")
	//	public ModelAndView registerCancerScreeningLabReport() throws Exception {
	//		new SetupCancerScreeningLabReport().setup();
	//		return new ModelAndView(new RedirectView("rwandareports.form"));
	//	}
	//	@RequestMapping("/module/rwandareports/remove_CancerScreeningLabReport")
	//	public ModelAndView removeCancerScreeningLabReport() throws Exception {
	//		new SetupCancerScreeningLabReport().delete();
	//		return new ModelAndView(new RedirectView("rwandareports.form"));
	//	}
	//	@RequestMapping("/module/rwandareports/register_CancerScreeningProgramIndicatorReport")
	//	public ModelAndView registerCancerScreeningProgramIndicatorReport() throws Exception {
	//		new SetupCancerScreeningProgramIndicatorReport().setup();
	//		return new ModelAndView(new RedirectView("rwandareports.form"));
	//	}
	//	@RequestMapping("/module/rwandareports/remove_CancerScreeningProgramIndicatorReport")
	//	public ModelAndView removeCancerScreeningProgramIndicatorReport() throws Exception {
	//		new SetupCancerScreeningProgramIndicatorReport().delete();
	//		return new ModelAndView(new RedirectView("rwandareports.form"));
	//	}
	
	@RequestMapping("/module/rwandareports/register_PathologyRequestReport.form")
	public ModelAndView registerPathologyRequestReport() throws Exception {
		new SetupPathologyRequestReport().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_PathologyRequestReport.form")
	public ModelAndView removePathologyRequestReport() throws Exception {
		new SetupPathologyRequestReport().delete();
		
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/register_NCDsHMISReport.form")
	public ModelAndView registerNCDsHMISReport() throws Exception {
		new SetupNCDsHMISReport().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_NCDsHMISReport.form")
	public ModelAndView removeNCDsHMISReport() throws Exception {
		new SetupNCDsHMISReport().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/register_OncologyInpatientAppointmentList.form")
	public ModelAndView registerOncologyInpatientAppointmentList() throws Exception {
		new SetupOncologyInpatientAppointmentList().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_OncologyInpatientAppointmentList.form")
	public ModelAndView removeOncologyInpatientAppointmentList() throws Exception {
		new SetupOncologyInpatientAppointmentList().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/register_OncologyCancerCenterAppointmentList.form")
	public ModelAndView registerOncologyCancerCenterAppointmentList() throws Exception {
		new SetupOncologyRwandaCancerCenterAppointmentList().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_OncologyCancerCenterAppointmentList.form")
	public ModelAndView removeOncologyCancerCenterAppointmentList() throws Exception {
		new SetupOncologyRwandaCancerCenterAppointmentList().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/register_OncologyPediatricAppointmentList.form")
	public ModelAndView registerOncologyPediatricAppointmentList() throws Exception {
		new SetupOncologyPediatricAppointmentList().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_OncologyPediatricAppointmentList.form")
	public ModelAndView removeOncologyPediatricAppointmentList() throws Exception {
		new SetupOncologyPediatricAppointmentList().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/register_oncologyPediatricExpectedPatientList.form")
	public ModelAndView registeroncologyPediatricExpectedPatientList() throws Exception {
		new SetupChemotherapyPediatricExpectedPatientList().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_oncologyPediatricExpectedPatientList.form")
	public ModelAndView removeoncologyPediatricExpectedPatientList() throws Exception {
		new SetupChemotherapyPediatricExpectedPatientList().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/register_oncologyCancerCenterExpectedPatientList.form")
	public ModelAndView registeroncologyCancerCenterExpectedPatientList() throws Exception {
		new SetupChemotherapyCancerCenterExpectedPatientList().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_oncologyCancerCenterExpectedPatientList.form")
	public ModelAndView removeoncologyCancerCenterExpectedPatientList() throws Exception {
		new SetupChemotherapyCancerCenterExpectedPatientList().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/register_oncologyPediatricClinicMissedVisit.form")
	public ModelAndView registeroncologyPediatricClinicMissedVisit() throws Exception {
		new SetupOncologyPediatricClinicMissedVisit().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_oncologyPediatricClinicMissedVisit.form")
	public ModelAndView removeoncologyPediatricClinicMissedVisit() throws Exception {
		new SetupOncologyCancerCenterClinicMissedVisit().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/register_oncologyRwandaCancerCenterClinicMissedVisit.form")
	public ModelAndView registeroncologyRwandaCancerCenterClinicMissedVisit() throws Exception {
		new SetupOncologyCancerCenterClinicMissedVisit().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_oncologyRwandaCancerCenterClinicMissedVisit.form")
	public ModelAndView removeoncologyRwandaCancerCenterClinicMissedVisit() throws Exception {
		new SetupOncologyCancerCenterClinicMissedVisit().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/register_OncologyLostToFollowUpIndicatorReport.form")
	public ModelAndView registerOncologyLostToFollowUpIndicatorReport() throws Exception {
		new SetupOncologyLostToFollowUpIndicatorReport().setup();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
	
	@RequestMapping("/module/rwandareports/remove_OncologyLostToFollowUpIndicatorReport.form")
	public ModelAndView removeOncologyLostToFollowUpIndicatorReport() throws Exception {
		new SetupOncologyLostToFollowUpIndicatorReport().delete();
		return new ModelAndView(new RedirectView("rwandareports.form"));
	}
}
