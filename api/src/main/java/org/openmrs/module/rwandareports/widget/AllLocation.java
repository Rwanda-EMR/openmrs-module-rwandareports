package org.openmrs.module.rwandareports.widget;

import org.apache.commons.lang.StringUtils;

public class AllLocation {
	
	public static String LOCATION = "location";
	
	String hierarchy;
	
	String value;
	
	String displayHierarchy;
	
	boolean allSites = false;
	
	public String getHierarchy() {
		return hierarchy;
	}
	
	public void setHierarchy(String hierarchy) {
		this.hierarchy = hierarchy;
	}
	
	public String getValue() {
		return value;
	}
	
	public void setValue(String value) {
		this.value = value;
	}
	
	@Override
	public String toString() {
		return value;
	}
	
	public boolean isAllSites() {
		return allSites;
	}
	
	public void setAllSites(boolean allSites) {
		this.allSites = allSites;
	}
	
	public String getDisplayHierarchy() {
		return displayHierarchy;
	}
	
	public void setDisplayHierarchy(String displayHierarchy) {
		this.displayHierarchy = displayHierarchy;
	}
	
	public static AllLocation valueOf(String value) {
		AllLocation location = new AllLocation();
		if (StringUtils.isNotBlank(value)) {
			location.setHierarchy(AllLocation.LOCATION);
			location.setValue(value);
		}
		return location;
	}
}
