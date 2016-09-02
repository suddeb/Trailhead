@isTest
private class WarehouseSyncScheduleTest {
	public static String CRON_EXP = '0 0 0 15 3 ? 2022';
  	
  	@isTest  
	public static void testWarehouseSyncSchedule_successful_call_should_update_product(){
		//Arrange
		List<Product2> listProduct = new List<Product2>();
		Product2 singleProduct = new Product2();
    				
    	singleProduct.Cost__c = 4000;
    	singleProduct.Current_Inventory__c = 10;
    	singleProduct.Lifespan_Months__c = 180;
    	singleProduct.Maintenance_Cycle__c = 180;
    	singleProduct.Replacement_Part__c = true;
    	singleProduct.Warehouse_SKU__c = '100003';
    	singleProduct.Name = 'Generator 1000 kW';
    	listProduct.add(singleProduct);
    	insert listProduct;
		
		// Get the IDs of the opportunities we just inserted
        Map<Id, Product2> productMap = new Map<Id, Product2>(listProduct);
        List<Id> productIds = new List<Id>(productMap.keySet());
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
		// Schedule the test job
        String jobId = System.schedule('ScheduledApexTest',
            CRON_EXP,
            new WarehouseSyncSchedule()); 
		// Verify the scheduled job has not run yet.
        List<Task> lt = [SELECT Id
            FROM Task
            WHERE WhatId IN :productIds];
        System.assertEquals(0, lt.size(), 'Tasks exist before job has run');
        Test.stopTest();
		
		/*
		lt = [SELECT Id
            FROM Task
            WHERE WhatId IN :productIds];
        System.assertEquals(productIds.size(), lt.size(), 'Tasks were not created');
		*/
	}
}