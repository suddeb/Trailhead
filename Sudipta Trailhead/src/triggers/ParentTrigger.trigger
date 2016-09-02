trigger ParentTrigger on Parent__c (after update) {
    new ParentTriggerHelper().onAfterUpdate(Trigger.New, Trigger.oldMap);
}