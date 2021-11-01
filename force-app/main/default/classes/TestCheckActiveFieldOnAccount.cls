@isTest
private class TestCheckActiveFieldOnAccount {

    @isTest static void testAccountsWithoutOrder() {
        // Create 10 accounts without order
        List<Account> accs = TestDataFactory.createAccounts(10, true);
        // Check active field of these accounts
        Test.startTest();
        List<Account> checkAccs = [ SELECT Active__c FROM Account WHERE Id IN :accs ];
        Test.stopTest();
        // Assertions : all active__c fields are false
        for(Account acc : checkAccs) {
            System.assertEquals(false, acc.active__c);
        }
    }
    
    @isTest static void testAccountsWithOrder() {
        // Create 10 accounts without order
        List<Account> accs = TestDataFactory.createAccounts(10, true);
        // Add an order to each account
        List<Order> newOrders = new List<Order>();
        for(Account acc : accs) {
            Order newOrder = TestDataFactory.createOrder(acc.Id, false);
            newOrders.add(newOrder);
        }
        insert newOrders;
        // Check active field of these accounts
        Test.startTest();
        List<Account> checkAccs = [ SELECT Active__c FROM Account WHERE Id IN :accs ];
        Test.stopTest();
        // Assertions : all active__c fields are false
        for(Account acc : checkAccs) {
            System.assertEquals(true, acc.active__c);
        }   
    }
}
