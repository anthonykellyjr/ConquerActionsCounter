@isTest
public class ConquerActionsTrigger_Test {
    
    static testMethod void validateTrigger(){
        Contact c = new Contact(FirstName='John',LastName='Appleseed');
		insert c;
        
        DS_Denali__DialSource_Sessions_V3__c s = new DS_Denali__DialSource_Sessions_V3__c();
        s.Name = '47f167ed-d5a9-479e-bd19-f74b79c66ece-60d26b03881ba000108b2c0c';
        insert s;
        
        DS_Denali__DialSource_Action__c d = new DS_Denali__DialSource_Action__c();
        d.DS_Denali__DialSource_Session__c = s.Id;
        d.DS_Denali__Contact__c = c.Id;
        insert d;
    }

}
