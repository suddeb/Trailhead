global class WarehouseCalloutServiceExceptionMock implements HttpCalloutMock{
    global HttpResponse respond(HttpRequest request){
   		//Create a fake response
   		CalloutException e = (CalloutException)CalloutException.class.newInstance();
   		e.setMessage('Unauthorized endpoint, please check Setup->Security->Remote site settings.');
        throw e;
   	}
}