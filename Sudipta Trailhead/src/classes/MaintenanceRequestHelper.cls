public class MaintenanceRequestHelper {
    private static List<Work_Part__c> allWorkParts = new List<Work_Part__c>();
    
	
    public static void updateAfterUpdateActivity(List<Case> newCases, Map<Id, Case> oldCases){
    	allWorkParts.clear();
    	List<Case> closedCases = new List<Case>();
    	//Identify only those cases for which status changed to Closed and type is either Repair or Routine Maintenance
    	for(Case singleCase : newCases){
	    	if(	singleCase.status == 'Closed' && 
	    		oldCases.get(singleCase.ID).status != singleCase.status){
	    		if(	singleCase.Type == 'Repair' || 
	    			singleCase.Type == 'Routine Maintenance'){
	    			closedCases.add(singleCase);
	       		}
	    	}
	    }
	    createFollowUpMaintenanceRequest(closedCases);
    }

    public static void createFollowUpMaintenanceRequest(List<Case> closedCases){
    	List<Case> newlyCreatedCases = new List<Case>();
    	Set<ID> caseIds = new Set<ID>();
    	for(Case singleCase : closedCases){
    		caseIds.add(singleCase.Id);
    	}
    	Integer shortestMaintCycle;
    	
    	//Create a map with Case Id as the key and all work parts as the values in list format
    	Map<Id, List<Work_Part__c>> maintWorkPartMap = createMaintWorkPartMap(caseIds);

    	for(Case singleCase : closedCases){
    		//Get the list of work parts associated with only this case
    		List<Work_Part__c> workParts = maintWorkPartMap.get(singleCase.Id);
    		
    		//Calculate the shortest maintenance cycle from the associated work parts
    		if(workParts != null){
    			shortestMaintCycle = Integer.valueOf(findShortestMaintCycle(workParts));	
    		}else{
    			shortestMaintCycle = Integer.valueOf(0.0);
    		}
    		
			//Create the new case
    		Case newCase = new Case();
    		newCase.Vehicle__c = singleCase.Vehicle__c;
    		newCase.Type = 'Routine Maintenance';
    		newCase.status = 'New';
    		newCase.Origin = singleCase.Origin;
    		newCase.Reason = singleCase.Reason;
    		newCase.Subject = String.isBlank(singleCase.Subject) ? 'Routine Maintenance Request' :
    			singleCase.Subject;
    		newCase.Date_Reported__c = Date.today();
    		newCase.Date_Due__c = Date.today().addDays(shortestMaintCycle);
    		newCase.Equipment__c = singleCase.Equipment__c;
    		newCase.Old_Case__c = String.valueOf(singleCase.Id);
    		newlyCreatedCases.add(newCase);
    	}

		//Insert all the newly created case in the system
    	if(!newlyCreatedCases.isEmpty()){
    		insert newlyCreatedCases;
    		updateRelatedWorkOrders(newlyCreatedCases);
    	}
    }
    
    private static void updateRelatedWorkOrders(List<Case> cases){
    	//List<Work_Part__c> allWorkParts = new List<Work_Part__c>();
    	Map<String, Id> oldToNewCaseMap = new Map<String, Id>();
    	for(Case singleCase : cases){
    		oldToNewCaseMap.put(singleCase.Old_Case__c,singleCase.Id);
    	}

    	if(allWorkParts != null){
    		for(Work_Part__c singleWorkPart : allWorkParts){
    			String key = String.valueOf(singleWorkPart.Maintenance_Request__c);
    			Id newCaseId = oldToNewCaseMap.get(key);
    			singleWorkPart.Maintenance_Request__c = newCaseId;
    		}
    	}

    	if(allWorkParts != null && allWorkParts.size() > 0){
    		update allWorkParts;
    	}
    }

    private static Decimal findShortestMaintCycle(List<Work_Part__c> workParts){
    	Decimal shortestValue;
    	if(workParts.size()>0){
    		shortestValue = workParts.get(0).Equipment__r.Maintenance_Cycle__c;
    	}
    	for(Work_Part__c singleWorkPart : workParts){
    		if(singleWorkPart.Equipment__r.Maintenance_Cycle__c < shortestValue){
    			shortestValue = singleWorkPart.Equipment__r.Maintenance_Cycle__c;
    		}
    	}
    	return shortestValue;
    }

    private static Map<Id, List<Work_Part__c>> createMaintWorkPartMap(Set<ID> caseIds){
    	//Fetch all WorkPart details
    	allWorkParts = [SELECT ID, Equipment__c, Maintenance_Request__c, 
    			Quantity__c, Equipment__r.Maintenance_Cycle__c FROM Work_Part__c 
    			WHERE Maintenance_Request__c in: caseIds];
    	Map<Id, List<Work_Part__c>> maintWorkPartMap = new Map<Id, List<Work_Part__c>>();
    	for(Work_Part__c singleWorkPart : allWorkParts){
    		List<Work_Part__c> tempList;
    		if(maintWorkPartMap.get(singleWorkPart.Maintenance_Request__c) == null){
    			tempList = new List<Work_Part__c>();
    		}else{
    			tempList = maintWorkPartMap.get(singleWorkPart.Maintenance_Request__c);
    		}
    		tempList.add(singleWorkPart);
    		maintWorkPartMap.put(singleWorkPart.Maintenance_Request__c, tempList);
    	}

    	return maintWorkPartMap;
    }
    
}