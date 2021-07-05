trigger ConquerActionsTrigger on DS_Denali__DialSource_Action__c (before insert, after insert, before update, after update) {
	ConquerActionTriggerHandler c = new ConquerActionTriggerHandler();
    
    if(trigger.isUpdate) {
        c.afterUpdate();
    }
    
}
