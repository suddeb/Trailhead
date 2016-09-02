@isTest
public class TestDataFactory {
	public static Vehicle__c createVehicle(){
		Vehicle__c singleVehicle = new Vehicle__c();
		singleVehicle.Name = 'Honda';
		insert singleVehicle;
		return singleVehicle;
	}
	
	public static Product2 createSingleEquipment(){
		Product2 singleProduct1 = new Product2();
		singleProduct1.Cost__c = 100;
    	singleProduct1.Current_Inventory__c = 5;
    	singleProduct1.Lifespan_Months__c = 12;
    	singleProduct1.Maintenance_Cycle__c = 12;
    	singleProduct1.Replacement_Part__c = true;
    	singleProduct1.Warehouse_SKU__c = '00012345';
    	singleProduct1.Name = 'Test Product 1';
    	
    	return singleProduct1;
	}
	
	public static List<Product2> createEquipments(){
		List<Product2> listOfEquipments = new List<Product2>();
		Product2 singleProduct1 = new Product2();
		singleProduct1.Cost__c = 100;
    	singleProduct1.Current_Inventory__c = 5;
    	singleProduct1.Lifespan_Months__c = 12;
    	singleProduct1.Maintenance_Cycle__c = 12;
    	singleProduct1.Replacement_Part__c = true;
    	singleProduct1.Warehouse_SKU__c = '00012345';
    	singleProduct1.Name = 'Test Product 1';
    	
    	Product2 singleProduct2 = new Product2();
		singleProduct2.Cost__c = 100;
    	singleProduct2.Current_Inventory__c = 5;
    	singleProduct2.Lifespan_Months__c = 6;
    	singleProduct2.Maintenance_Cycle__c = 8;
    	singleProduct2.Replacement_Part__c = true;
    	singleProduct2.Warehouse_SKU__c = '00054321';
    	singleProduct2.Name = 'Test Product 2';
    	
    	listOfEquipments.add(singleProduct1);
    	listOfEquipments.add(singleProduct2);
    	
    	insert listOfEquipments;
    	return listOfEquipments;
	}
	
	public static List<Case> createMultipleMainRequestWith(
				Integer numberOfMaintRequest,
				Vehicle__c vehicle,
    			String type,
    			String status,
    			String origin,
    			String reason,
    			String subject,
    			Date dateReported,
    			Date dueDate,
    			List<Product2> listOfEquipments){
    	List<Case> allCases = new List<Case>();
		for(Integer i = 0; i < numberOfMaintRequest; i++){
			Case singleCase = new Case();
	    	singleCase.Vehicle__c = vehicle.Id;
	    	singleCase.Type = type;
	    	singleCase.Status = status;
	    	singleCase.Origin = origin;
	    	singleCase.Reason = reason;
	    	singleCase.Subject = subject;
	    	singleCase.Date_Reported__c = dateReported;
	    	singleCase.Date_Due__c = dueDate;
	    	singleCase.Equipment__c = listOfEquipments.get(0).Id;
	    	allCases.add(singleCase);
		}	
		
		insert allCases;
		
		List<Work_Part__c> allWorkParts = new List<Work_Part__c>();
		for(Case singleCase : allCases){
			Work_Part__c workPart1 = new Work_Part__c();
	    	workPart1.Equipment__c = listOfEquipments.get(0).Id;
	    	workPart1.Maintenance_Request__c = singleCase.Id;
	    	workPart1.Quantity__c = 10;
	    	
	    	Work_Part__c workPart2 = new Work_Part__c();
	    	workPart2.Equipment__c = listOfEquipments.get(1).Id;
	    	workPart2.Maintenance_Request__c = singleCase.Id;
	    	workPart2.Quantity__c = 5;
	    	
	    	allWorkParts.add(workPart1);
	    	allWorkParts.add(workPart2);
		}
		
		insert allWorkParts;
		return allCases;
	}
	
    public static Case createMaintRequestWith(
    			Vehicle__c vehicle,
    			String type,
    			String status,
    			String origin,
    			String reason,
    			String subject,
    			Date dateReported,
    			Date dueDate,
    			List<Product2> listOfEquipments,
    			Product2 singleProduct ){
    	Case singleCase = new Case();
    	singleCase.Vehicle__c = vehicle.Id;
    	singleCase.Type = type;
    	singleCase.Status = status;
    	singleCase.Origin = origin;
    	singleCase.Reason = reason;
    	singleCase.Subject = subject;
    	singleCase.Date_Reported__c = dateReported;
    	singleCase.Date_Due__c = dueDate;
    	singleCase.Equipment__c = !listOfEquipments.isEmpty() ? listOfEquipments.get(0).Id : singleProduct.Id;
    	
    	
    	insert singleCase;
    	if(!listOfEquipments.isEmpty()){
    		List<Work_Part__c> allWorkParts = new List<Work_Part__c>();
	    	Work_Part__c workPart1 = new Work_Part__c();
	    	workPart1.Equipment__c = listOfEquipments.get(0).Id;
	    	workPart1.Maintenance_Request__c = singleCase.Id;
	    	workPart1.Quantity__c = 10;
	    	
	    	Work_Part__c workPart2 = new Work_Part__c();
	    	workPart2.Equipment__c = listOfEquipments.get(1).Id;
	    	workPart2.Maintenance_Request__c = singleCase.Id;
	    	workPart2.Quantity__c = 5;
	    	
	    	allWorkParts.add(workPart1);
	    	allWorkParts.add(workPart2);
	    	
	    	insert allWorkParts;
    	}
    	
    	return singleCase;
    }
}