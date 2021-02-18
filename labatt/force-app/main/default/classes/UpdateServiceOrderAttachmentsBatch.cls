public class UpdateServiceOrderAttachmentsBatch implements Database.Batchable<sObject> {
    public final String query; 

    public UpdateServiceOrderAttachmentsBatch(Set<Id> orderIds) {
        List<Id> ordLst = new List<Id>();
        ordLst.addAll(orderIds);
        query = 'select id from order__c where ID in :'+ordLst;
    }

    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<Object> scope){
        Set<Id> soIds = new Set<Id>();
        List<Id> soIdList = new List<Id>();
        //Filter Service_Orders 
        for(Order__c o: [SELECT ID, (select id from Service_Orders__r order by lastModifiedDate desc) FROM Order__c where Id IN :(List<Id>)scope]){
            if(null != o.Service_Orders__r && o.Service_Orders__r.size() > 0){
                for(Service_Order__c so: o.Service_Orders__r){
                    soIds.add(so.Id);
                }
                soIdList.addAll(soIds); 
                soIdList.remove(0);
                soIdList.remove(0);
            }
        }
        
        //Delete Attachments
        if(soIdList.size() > 0){
            List<Attachment> attToDelete = new List<Attachment>();
            for(Attachment at: [SELECT ID, Name from attachment where parentId IN :soIdList]){
                if(at.Name.contains('.'))
                    if(at.Name.subStringAfter('.').toUpperCase() == 'JPEG'){
                        attToDelete.add(at);
                    }
            }
        if(attToDelete.size() > 0)
            delete attToDelete;
        }
    }

    public void finish(Database.BatchableContext bc){

    }


}