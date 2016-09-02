public with sharing class WarehouseCalloutService {

    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
    
    @future(callout=true)
    public static void runWarehouseEquipmentSync(){
        HttpRequest request = new HttpRequest();
    	request.setMethod('GET');
    	request.setEndpoint(WAREHOUSE_URL);
    	Http http = new Http();
    	
    	try{
    		HttpResponse response = http.send(request);
    		if(response.getStatusCode() == 200){
    			List<Object> equipmentList = (List<Object>)JSON.deserializeUntyped(response.getBody());
    			List<Product2> listProducts = new List<Product2>();
    			
    			for(Object singleEquipment : equipmentList){
    				Map<String, Object> mapObject = (Map<String, Object>)singleEquipment;
    				
    				Product2 singleProduct = new Product2();
    				
    				Integer maintenanceperiod = (Integer)mapObject.get('maintenanceperiod');
    				Integer lifespan = (Integer)mapObject.get('lifespan');
    				Integer cost = (Integer)mapObject.get('cost');
    				Boolean replacement = (Boolean)mapObject.get('replacement');
    				Integer quantity = (Integer)mapObject.get('quantity');
    				String name = (String)mapObject.get('name');
    				String sku = (String)mapObject.get('sku');
    				
    				singleProduct.Cost__c = cost;
    				singleProduct.Current_Inventory__c = quantity;
    				singleProduct.Lifespan_Months__c = lifespan;
    				singleProduct.Maintenance_Cycle__c = maintenanceperiod;
    				singleProduct.Replacement_Part__c = replacement;
    				singleProduct.Warehouse_SKU__c = sku;
    				singleProduct.Name = name;
    				
    				listProducts.add(singleProduct);
    			}
    			
    			if(!listProducts.isEmpty()){
    				upsert listProducts Warehouse_SKU__c;
    			}
    			
    		}
    	}catch(System.CalloutException e){
    		System.Debug('Exception happened: ' + e.getMessage());
    	}
    }
}