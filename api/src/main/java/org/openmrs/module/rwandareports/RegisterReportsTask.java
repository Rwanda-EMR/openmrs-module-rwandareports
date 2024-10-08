/**
 * The contents of this file are subject to the OpenMRS Public License
 * Version 1.0 (the "License"); you may not use this file except in
 * compliance with the License. You may obtain a copy of the License at
 * http://license.openmrs.org
 *
 * Software distributed under the License is distributed on an "AS IS"
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
 * License for the specific language governing rights and limitations
 * under the License.
 *
 * Copyright (C) OpenMRS, LLC.  All Rights Reserved.
 */
package org.openmrs.module.rwandareports;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.GlobalProperty;
import org.openmrs.api.context.Context;
import org.openmrs.module.ModuleFactory;
import org.openmrs.module.rwandareports.util.ReportSetup;
import org.openmrs.scheduler.tasks.AbstractTask;

/**
 * Task to aggregate raw data and delete old data
 */
public class RegisterReportsTask extends AbstractTask {
	
	private static Log log = LogFactory.getLog(RegisterReportsTask.class);
	
	/**
	 * @see org.openmrs.scheduler.tasks.AbstractTask#execute()
	 */
	@Override
	public void execute() {
		if (!isExecuting) {
			log.debug("Starting Register Reports Task...");
			
			startExecuting();
			try {
				onExecute();
			}
			catch (Exception e) {
				log.error("Error executing Register Reports Task", e);
			}
			finally {
				stopExecuting();
			}
		}
	}
	
	/**
	 * Does the actual data aggregation
	 */
	protected void onExecute() {
		try {
			String version = ModuleFactory.getModuleById("rwandareports").getVersion();
			String oldversion = Context.getAdministrationService().getGlobalProperty("reports.moduleVersion");
			if (!version.equals(oldversion)) {
				
				ReportSetup.cleanTables();
				ReportSetup.registerReports();
				
				Context.getAdministrationService().saveGlobalProperty(new GlobalProperty("reports.moduleVersion", version));
			}
		}
		catch (Exception ex) {
			log.error("One of reports has an error which blocks it and other reports to be registered");
			ex.printStackTrace();
		}
	}
}
