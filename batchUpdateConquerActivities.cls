global class batchUpdateConquerActivities implements Database.Batchable <sObject>,Database.Stateful,Schedulable {   
    global batchUpdateConquerActivities(){
    }
    Set<id> successRecord = new Set<id>();
    Set<id> failRecord = new Set<id>();
   
 global Database.QueryLocator start(Database.BatchableContext info){ 
        String SOQL='Select id, Conquer_Activities__c from Contact';
        return Database.getQueryLocator(SOQL);
   }     
   global void execute(Database.BatchableContext info, List<Contact> scope){
       Set<Contact> cUpdate = new Set<Contact>();
       Set<Id> conIds = new Set<Id>();
       List<DS_Denali__DialSource_Action__c> conActions = new List<DS_Denali__DialSource_Action__c>();
       for(Contact c : scope)
          { 
           conIds.add(c.Id);
           /*conActions = [SELECT Id FROM DS_Denali__DialSource_Action__c WHERE DS_Denali__Contact__c =: c.Id FOR UPDATE];
           c.Conquer_Activities__c = conActions.size();
           cUpdate.add(c);*/
       }
       
       AggregateResult[] groupedResults = [SELECT Count(Id), DS_Denali__Contact__c FROM DS_Denali__DialSource_Action__c group by DS_Denali__Contact__c having DS_Denali__Contact__c in: conIds];
       Map<Id,Integer> dsCountMap = new Map<Id,Integer>();
        for (AggregateResult ar : groupedResults) { dsCountMap.put((Id)ar.get('DS_Denali__Contact__c'),Integer.valueOf(ar.get('expr0')));}
       conActions = [SELECT Id, DS_Denali__Contact__c FROM DS_Denali__DialSource_Action__c WHERE DS_Denali__Contact__c =: conIds];
       for(DS_Denali__DialSource_Action__c d : conActions) {
           if(dsCountMap.containsKey(d.DS_Denali__Contact__c)) {cUpdate.add(new Contact(Id=d.DS_Denali__Contact__c, Conquer_Activities__c=dsCountMap.get(d.DS_Denali__Contact__c)));}
       }
       /*if(cUpdate.size() > 0) {
           System.debug(cUpdate[0]);
       	   
       }*/
       Contact[] cUpdateList = new List<Contact>();
       for(Contact c : cUpdate) {
           cUpdateList.add(c);
       }
       Database.SaveResult[] srList1 = Database.update(cUpdateList, false);
        for (Database.SaveResult sr : srList1) {
            if (sr.isSuccess()) {
                successRecord.add(sr.getId());
            }
    else {
        for(Database.Error err : sr.getErrors()) {
        }
          failRecord.add(sr.getId());
    }
  }
 
 
   }     
   global void finish(Database.BatchableContext info){ 
   // Get the ID of the AsyncApexJob representing this batch job
   // from Database.BatchableContext.
   // Query the AsyncApexJob object to retrieve the current job's information.
   	AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
      TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id = :info.getJobId()];
   } 
  
    
    global void execute(SchedulableContext SC){
        database.executeBatch(new batchUpdateConquerActivities(),1000);
       //for cron expression
        // String cronexpression = ‘0 0 0 ? * * *’
       // System.schedule(‘Testing’, cronexpression, testobj);        
    } 
}
