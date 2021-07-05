public class ConquerActionTriggerHandler extends TriggerHandler {

    public override void afterUpdate() {
        Integer actionCount;
        List<DS_Denali__DialSource_Action__c> actions = [SELECT Id, DS_Denali__Contact__c FROM DS_Denali__DialSource_Action__c 
                                                         WHERE Id IN :Trigger.newMap.keySet() AND DS_Denali__Contact__c != null];
        List<Id> conIds = new List<Id>();
        
        for(DS_Denali__DialSource_Action__c a : actions) {
            conIds.add(a.DS_Denali__Contact__c);
        }
        
        if(conIds.size() > 0) {
            List<Contact> consToUpdate = [Select Id, Conquer_Activities__c FROM Contact WHERE Id =: conIds FOR UPDATE];
            List<DS_Denali__DialSource_Action__c> conActions = [SELECT Id FROM DS_Denali__DialSource_Action__c WHERE DS_Denali__Contact__c =: conIds FOR UPDATE];
            actionCount = conActions.size();
        	
            for(Contact c : consToUpdate) {
                c.Conquer_Activities__c = actionCount;
            }
            try {
                update consToUpdate;
            } catch (Exception e) {
                System.debug('could not update contact activity count: ' + e.getMessage());
            }
           	
        }
        
  	}     
}
