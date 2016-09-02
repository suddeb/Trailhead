@isTest
private class ParentTriggerHelperTest {
    private static Integer COUNT = 300;
    
    public static void createTestData(){
    	List<Parent__c> allParents = new List<Parent__c>();
    	for(Integer i = 0 ;i < COUNT ; i++){
    		allParents.add(new Parent__c(
    			Type__c = 'New',
    			Description__c = 'Test Description'
    		));	
    	}
    	
    	insert allParents;
    }
    
    @isTest
    public static void testBulkifyCode(){
    	//Arrange
    	createTestData();
    	
    	List<Parent__c> fetchedParents = [SELECT ID, Type__c, Description__c from Parent__c];
    	System.assertEquals(COUNT, fetchedParents.size());
    	
    	//Act
    	Test.startTest();
    	for(Parent__c aParent : fetchedParents){
    		aParent.Type__c = 'Closed';
    	}
    	update fetchedParents;
    	Test.stopTest();
    	
    	//Assert
    	fetchedParents = [SELECT ID, Type__c, Description__c from Parent__c Where Type__c = 'New'];
    	System.assertEquals(COUNT, fetchedParents.size());
    	
    	fetchedParents = [SELECT ID, Type__c, Description__c from Parent__c Where Type__c = 'closed'];
    	System.assertEquals(COUNT, fetchedParents.size());
    	
    }
}