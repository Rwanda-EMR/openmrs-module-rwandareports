package org.openmrs.module.rwandareports.customcalculator;

import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.Obs;
import org.openmrs.module.heightweighttracker.mapper.WHOCalculations;
import org.openmrs.module.reporting.evaluation.EvaluationContext;
import org.openmrs.module.rowperpatientreports.patientdata.definition.CustomCalculation;
import org.openmrs.module.rowperpatientreports.patientdata.result.AllObservationValuesResult;
import org.openmrs.module.rowperpatientreports.patientdata.result.DateValueResult;
import org.openmrs.module.rowperpatientreports.patientdata.result.ObservationResult;
import org.openmrs.module.rowperpatientreports.patientdata.result.PatientAttributeResult;
import org.openmrs.module.rowperpatientreports.patientdata.result.PatientDataResult;
import org.openmrs.module.rowperpatientreports.patientdata.result.PatientPropertyResult;

public class HIVPediAlerts implements CustomCalculation {
	
	protected Log log = LogFactory.getLog(this.getClass());
	
	public PatientDataResult calculateResult(List<PatientDataResult> results, EvaluationContext context) {
		
		PatientAttributeResult alert = new PatientAttributeResult(null, null);
		
		//		ProgramWorkflowState state = (ProgramWorkflowState)context.getParameterValue("state");
		
		StringBuffer alerts = new StringBuffer();
		
		PatientPropertyResult age = null;
		ObservationResult weight = null;
		ObservationResult height = null;
		ObservationResult heightWeight = null;
		ObservationResult cd4Obs = null;
		ObservationResult cd4Percent = null;
		
		for (PatientDataResult result : results) {
			if (result.getName().equals("CD4Test")) {
				ObservationResult cd4 = (ObservationResult) result;
				
				if (cd4.getValue() == null) {
					alerts.append(" No CD4 recorded\n");
				} else {
					Date dateCd4 = cd4.getDateOfObservation();
					Date date = Calendar.getInstance().getTime();
					
					int diff = calculateMonthsDifference(date, dateCd4);
					
					if (diff > 12) {
						alerts.append("Very late CD4(" + diff + " months ago).\n");
					} else if (diff > 6)
					//					else if((diff > 6) && state.toString().contains("FOLLOWING"))
					{
						alerts.append("late CD4(" + diff + " months ago).\n");
					}
				}
			}
			
			if (result.getName().equals("weightObs")) {
				AllObservationValuesResult wt = (AllObservationValuesResult) result;
				
				if (wt.getValue() != null) {
					int decline = calculateDecline(wt.getValue());
					
					if (decline > 0) {
						alerts.append("WT decline(");
						alerts.append(decline);
						alerts.append("kg)\n");
					}
				}
			}
			
			if (result.getName().equals("IO") && result.getValue() != null) {
				alerts.append("OI reported last visit: " + result.getValue() + "\n");
			}
			
			if (result.getName().equals("SideEffects") && result.getValue() != null) {
				alerts.append("Side effects reported last visit: " + result.getValue() + "\n");
			}
			
			if (result.getName().equals("height") && result.getValue() != null) {
				height = (ObservationResult) result;
			}
			
			if (result.getName().equals("weight") && result.getValue() != null) {
				weight = (ObservationResult) result;
			}
			
			if (result.getName().equals("CD4Test") && result.getValue() != null) {
				cd4Obs = (ObservationResult) result;
			}
			
			if (result.getName().equals("CD4Percent") && result.getValue() != null) {
				cd4Percent = (ObservationResult) result;
			}
			
			if (result.getName().equals("age") && result.getValue() != null) {
				age = (PatientPropertyResult) result;
			}
			//VL test
			if (result.getName().equals("viralLoadTest")) {
				AllObservationValuesResult viraload = (AllObservationValuesResult) result;
				
				if (viraload.getValue() != null) {
					Obs lastviraload = null;
					
					if (viraload.getValue().size() > 0) {
						lastviraload = viraload.getValue().get(viraload.getValue().size() - 1);
					}
					//					if (state.toString().contains("GROUP") && (lastviraload == null)) {
					if (lastviraload == null) {
						alerts.append("VL needed.\n");
					} else {
						try {
							Date dateVl = lastviraload.getObsDatetime();
							Date date = Calendar.getInstance().getTime();
							
							int diff = calculateMonthsDifference(date, dateVl);
							
							//							if (state.toString().contains("GROUP")) {
							if (diff > 12) {
								alerts.append("Late VL(" + diff + " months ago).\n");
							}
							
							if (lastviraload.getValueNumeric() != null && lastviraload.getValueNumeric() > 1000) {
								alerts.append("VL Failure " + lastviraload.getValueNumeric() + ".\n");
							}
							//							}
						}
						catch (Exception e) {}
					}
				}
			}
			if (result.getName().equals("lastEncInMonth")) {
				DateValueResult encinmonths = (DateValueResult) result;
				if (encinmonths.getValue() != null) {
					Date dateVl = encinmonths.getDateOfObservation();
					Date date = Calendar.getInstance().getTime();
					int diff = calculateMonthsDifference(date, dateVl);
					if (diff > 12) {
						alerts.append("LTFU determine status.\n");
					}
				}
			}
			
		}
		
		if (age != null) {
			Integer ageInt = Integer.parseInt(age.getValueAsString());
			WHOCalculations who = new WHOCalculations();
			
			Double zscore = null;
			if (ageInt < 6) {
				if (heightWeight != null && heightWeight.getValue() != null) {
					zscore = Double.parseDouble(who.getHeightForWeightZRange(height.getObs(), weight.getObs()));
				}
			} else if (ageInt < 16) {
				if (height != null && height.getValue() != null && weight != null && weight.getValue() != null) {
					
					String bmiAge = who.getCalculatedBmiForAge(height.getObs(), weight.getObs());
					if (bmiAge != null && bmiAge.length() > 0) {
						zscore = Double.parseDouble(bmiAge);
					}
				}
			}
			
			if (zscore != null) {
				if (zscore <= -3) {
					alerts.append("Malnutrion rating: severe\n");
				} else if (zscore <= -2) {
					alerts.append("Malnutrion rating: moderate\n");
				} else if (zscore <= -1) {
					alerts.append("Malnutrion rating: mild\n");
				}
			}
			
			if (ageInt > 5) {
				//				if(cd4Obs != null && state.toString().contains("FOLLOWING") && cd4Obs.getObs().getValueNumeric() != null && cd4Obs.getObs().getValueNumeric() < 500)
				if (cd4Obs != null && cd4Obs.getObs().getValueNumeric() != null && cd4Obs.getObs().getValueNumeric() < 500)
				
				{
					alerts.append("CD4 < 500 \n");
				}
			}
			
			if (ageInt <= 5) {
				//				if(state.toString().contains("FOLLOWING"))
				//				{
				alerts.append("Needs ART \n");
				//				}
			}
		}
		alert.setValue(alerts.toString());
		return alert;
	}
	
	private int calculateMonthsDifference(Date observation, Date startingDate) {
		int diff = 0;
		
		Calendar obsDate = Calendar.getInstance();
		obsDate.setTime(observation);
		
		Calendar startDate = Calendar.getInstance();
		startDate.setTime(startingDate);
		
		//find out if there is any difference in years first
		diff = obsDate.get(Calendar.YEAR) - startDate.get(Calendar.YEAR);
		diff = diff * 12;
		
		int monthDiff = obsDate.get(Calendar.MONTH) - startDate.get(Calendar.MONTH);
		diff = diff + monthDiff;
		
		return diff;
	}
	
	private int calculateDecline(List<Obs> obs) {
		Obs lastOb = null;
		Obs nextToLastOb = null;
		
		if (obs.size() > 0) {
			lastOb = obs.get(obs.size() - 1);
		}
		
		if (obs.size() > 1) {
			nextToLastOb = obs.get(obs.size() - 2);
		}
		
		if (lastOb != null && nextToLastOb != null) {
			Double firstVal = lastOb.getValueNumeric();
			Double nextToLastVal = nextToLastOb.getValueNumeric();
			
			if (firstVal != null && nextToLastVal != null) {
				double decline = nextToLastVal - firstVal;
				
				if (decline > 0) {
					return (int) decline;
				}
			}
		}
		
		return 0;
	}
}
