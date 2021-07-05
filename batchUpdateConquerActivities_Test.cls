@isTest
private class batchUpdateConquerActivities_Test {
    @testSetup 
    static void setup() {
        List<Contact> contacts = new List<Contact>();
        Account acc = new Account(name='My Great Account',description ='Test',NumberOfEmployees=70);
        // insert 200 accounts
        for (Integer i=0;i<200;i++) {
            contacts.add(new Contact(LastName='Account'+i,AccountId =acc.Id));
        }
        insert contacts;
    }
        static testmethod void test() {        
        Test.startTest();
        batchUpdateConquerActivities tb = new batchUpdateConquerActivities();
        Id batchId = Database.executeBatch(tb);
        Test.stopTest();
        Integer con=[select count() from contact];
        // after the testing stops, assert records were inserted properly
        System.assertEquals(200, [select count() from contact]);
        }
}
