@isTest
private class MaintenanceRequestTest {
	private static Integer FIRST_ITEM = 0;
	private static Integer SECOND_ITEM = 1;
	private static Integer THREE_HUNDRED = 300;
	
	 
    @isTest
    static void test_Closing_Mechanical_Maint_ShouldNot_Create_Future_MaintRequest(){
    	//Arrange
    	Vehicle__c singleVehicle = TestDataFactory.createVehicle();
    	List<Product2> equipments = TestDataFactory.createEquipments();
    	Case singleMaintRequest = TestDataFactory.createMaintRequestWith(
    					singleVehicle,
    					'Mechanical',
    					'Open',
    					'Email',
    					'Not Working',
    					'Not Working',
    					Date.today(),
    					Date.today().addDays(10),
    					equipments,
    					null);
    	
    	//Act
    	Test.startTest();
    	singleMaintRequest.status = 'Closed';
    	update singleMaintRequest;
    	Test.stopTest();			
    	
    	//Assert
    	List<Case> allCases = [SELECT ID FROM Case WHERE Vehicle__c =: singleVehicle.Id and status = 'New'];
    	System.assertEquals(0,allCases.size());	
    }
    
    
    @isTest
    static void test_Closing_Repair_Maint_Should_Create_Future_MaintRequest(){
    	//Arrange
    	Vehicle__c singleVehicle = TestDataFactory.createVehicle();
    	List<Product2> equipments = TestDataFactory.createEquipments();
    	Case singleMaintRequest = TestDataFactory.createMaintRequestWith(
    					singleVehicle,
    					'Repair',
    					'Open',
    					'Email',
    					'Not Working',
    					'Not Working',
    					Date.today(),
    					Date.today().addDays(10),
    					equipments,
    					null);
    	
    	//Act
    	Test.startTest();
    	singleMaintRequest.status = 'Closed';
    	update singleMaintRequest;
    	Test.stopTest();			
    	
    	//Assert
    	List<Case> allCases = [SELECT ID,Date_Due__c,Equipment__c FROM Case WHERE Vehicle__c =: singleVehicle.Id and status = 'New'];
    	System.assertEquals(1,allCases.size());	
    	System.assertEquals(Date.today().addDays(8),allCases.get(FIRST_ITEM).Date_Due__c);	
    	System.assertEquals(equipments.get(0).Id,allCases.get(FIRST_ITEM).Equipment__c);
    	
    	List<Work_Part__c> allWorkParts = [SELECT ID FROM Work_Part__c WHERE Maintenance_Request__c =: allCases.get(0).Id];
    	System.assertEquals(2,allWorkParts.size());
    }
    
    @isTest
    static void test_Closing_Routine_Maintenance_Should_Create_Future_MaintRequest(){
    	//Arrange
    	Vehicle__c singleVehicle = TestDataFactory.createVehicle();
    	List<Product2> equipments = TestDataFactory.createEquipments();
    	Case singleMaintRequest = TestDataFactory.createMaintRequestWith(
    					singleVehicle,
    					'Routine Maintenance',
    					'Open',
    					'Email',
    					'Not Working',
    					'Not Working',
    					Date.today(),
    					Date.today().addDays(10),
    					equipments,
    					null);
    	
    	//Act
    	Test.startTest();
    	singleMaintRequest.status = 'Closed';
    	update singleMaintRequest;
    	Test.stopTest();			
    	
    	//Assert
    	List<Case> allCases = [SELECT ID,Date_Due__c,Equipment__c FROM Case WHERE Vehicle__c =: singleVehicle.Id and status = 'New'];
    	System.assertEquals(1,allCases.size());	
    	System.assertEquals(Date.today().addDays(8),allCases.get(FIRST_ITEM).Date_Due__c);
    	System.assertEquals(equipments.get(0).Id,allCases.get(FIRST_ITEM).Equipment__c);
    	
    	List<Work_Part__c> allWorkParts = [SELECT ID FROM Work_Part__c WHERE Maintenance_Request__c =: allCases.get(0).Id];
    	System.assertEquals(2,allWorkParts.size());
    }
    
    @isTest
    static void test_Closing_Routine_Maintenance_Without_WorkPart_Should_Create_Future_MaintRequest_without_work_part(){
    	//Arrange
    	Vehicle__c singleVehicle = TestDataFactory.createVehicle();
    	List<Product2> equipments = new List<Product2>();
    	Product2 singleProduct = TestDataFactory.createSingleEquipment();
    	Case singleMaintRequest = TestDataFactory.createMaintRequestWith(
    					singleVehicle,
    					'Routine Maintenance',
    					'Open',
    					'Email',
    					'Not Working',
    					'Not Working',
    					Date.today(),
    					Date.today().addDays(10),
    					equipments,
    					singleProduct);
    	
    	//Act
    	Test.startTest();
    	singleMaintRequest.status = 'Closed';
    	update singleMaintRequest;
    	Test.stopTest();			
    	
    	//Assert
    	List<Case> allCases = [SELECT ID,Date_Due__c,Equipment__c FROM Case WHERE Vehicle__c =: singleVehicle.Id and status = 'New'];
    	System.assertEquals(1,allCases.size());	
    	System.assertEquals(Date.today(),allCases.get(FIRST_ITEM).Date_Due__c);
    	System.assertEquals(singleProduct.Id,allCases.get(FIRST_ITEM).Equipment__c);
    	
    	List<Work_Part__c> allWorkParts = [SELECT ID FROM Work_Part__c WHERE Maintenance_Request__c =: allCases.get(0).Id];
    	System.assertEquals(0,allWorkParts.size());
    }
    
    @isTest
    static void test_Closing_300_Routine_Maintenance_should_create_300_New_Maint(){
    	//Arrange
    	Vehicle__c singleVehicle = TestDataFactory.createVehicle();
    	List<Product2> equipments = TestDataFactory.createEquipments();
    	List<Case> allMaintRequests = TestDataFactory.createMultipleMainRequestWith(
    					THREE_HUNDRED,
    					singleVehicle,
    					'Routine Maintenance',
    					'Open',
    					'Email',
    					'Not Working',
    					'Not Working',
    					Date.today(),
    					Date.today().addDays(10),
    					equipments);
    	
    	//Act
    	Test.startTest();
    	for(Case singleMaintRequest : allMaintRequests){
    		singleMaintRequest.status = 'Closed';
    	}
    	update allMaintRequests;
    	Test.stopTest();			
    	
    	//Assert
    	List<Case> allCases = [SELECT ID,Date_Due__c FROM Case WHERE Vehicle__c =: singleVehicle.Id and status = 'New'];
    	System.assertEquals(THREE_HUNDRED,allCases.size());	
    	
    }
}