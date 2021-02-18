public with sharing class GoogleAPIService {
   public static void getContacts(){
       HttpRequest req = new HttpRequest();
       Http http = new Http();
       req.setMethod('GET');
       req.setEndpoint('callout:Google_People_API/v1/people/c1150104659039327954?personFields=names,emailAddresses');
       HttpResponse res = http.send(req);
       Logs__c log = new Logs__c(JSON_response__c = res.getBody(), Status_Code__c=String.valueOf(res.getStatusCode()));
       insert log;

   }


}