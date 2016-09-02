public class ParentTriggerHelper {
    public void onAfterUpdate(List<Parent__c> newParents, Map<Id, Parent__c> oldParentMap){
    	List<Parent__c> parentsWithTypeChange = new List<Parent__c>();
    	
    	for(Parent__C aParent : newParents){
    		if(	aParent.Type__c.equalsIgnoreCase('Closed') && 
    			!aParent.Type__c.equalsIgnoreCase(oldParentMap.get(aParent.Id).Type__c)){
    			parentsWithTypeChange.add(aParent);
    		}
    	}
    	
    	if(!parentsWithTypeChange.isEmpty()){
    		processParentTypeChange(parentsWithTypeChange);
    	}
    }
    
    public void processParentTypeChange(List<Parent__c> parentsWithTypeChange){
    	List<Parent__c> newParentList = new List<Parent__c>();
    	
    	for(Parent__c aParent : parentsWithTypeChange){
    		newParentList.add(new Parent__C(
    			Type__c = 'New',
    			Description__c	= aParent.Description__c,
    			Old_Parent_Id__c = String.valueOf(aParent.Id)		
    		));
    	}
    	
    	if(!newParentList.isEmpty()){
    		insert newParentList;
    	}
    }
}