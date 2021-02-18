trigger OrderTrigger on Service_Order__c (after update) {

    Set<Id> orderIds = new Set<Id>();
    Set<Id> soIds = new Set<Id>();

    for(Id i :Trigger.oldMap.keySet()){
        Service_Order__c oldVal = (Service_Order__c)Trigger.oldMap.get(i);
        Service_Order__c newVal = (Service_Order__c)Trigger.newMap.get(i);
        
        if((oldVal.Service_Status__c != newVal.Service_Status__c) && 'Closed' == newVal.Service_Status__c){
            orderIds.add(oldVal.Order__c);
        }
        if(orderIds.size() > 0){
            UpdateServiceOrderAttachmentsBatch b = new UpdateServiceOrderAttachmentsBatch(orderIds);
            Id processId = Database.executeBatch(b, 200);
        }
        

        
    }


}