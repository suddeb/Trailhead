@isTest
private class WarehouseCalloutServiceTest {
  
  	private static void createTestProduct(){
  		Product2 singleProduct = new Product2();
    				
    	singleProduct.Cost__c = 4000;
    	singleProduct.Current_Inventory__c = 10;
    	singleProduct.Lifespan_Months__c = 180;
    	singleProduct.Maintenance_Cycle__c = 180;
    	singleProduct.Replacement_Part__c = true;
    	singleProduct.Warehouse_SKU__c = '100003';
    	singleProduct.Name = 'Generator 1000 kW';
    	
    	insert singleProduct;
  	}
  	
	@isTest  
	public static void testWarehouseCalloutService_successful_call_should_update_product(){
		//Arrange
		createTestProduct();
		
		//Act
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
		WarehouseCalloutService.runWarehouseEquipmentSync();
		Test.stopTest();
		
		//Assert
		List<Product2> listOfProducts = [SELECT ID, 
												Cost__c, 
												Current_Inventory__c, 
												Lifespan_Months__c, 
												Maintenance_Cycle__c, 
												Replacement_Part__c, 
												Warehouse_SKU__c, 
												Name 
										FROM Product2 
										WHERE Warehouse_SKU__c = '100003'];
										
		System.assertEquals(1,listOfProducts.size());
		System.assertEquals(5000,listOfProducts.get(0).Cost__c);
		System.assertEquals(5,listOfProducts.get(0).Current_Inventory__c);
		System.assertEquals(120,listOfProducts.get(0).Lifespan_Months__c);
		System.assertEquals(365,listOfProducts.get(0).Maintenance_Cycle__c);
		System.assertEquals(false,listOfProducts.get(0).Replacement_Part__c);
		System.assertEquals('Generator 1000 kW',listOfProducts.get(0).Name);
	}
	
	@isTest  
	public static void testWarehouseCalloutService_failed_call_should_throw_exception(){
		//Arrange
		createTestProduct();
		Exception testException;
		
		//Act
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceExceptionMock());
		WarehouseCalloutService.runWarehouseEquipmentSync();
		Test.stopTest();
		
		//Assert
	}
}