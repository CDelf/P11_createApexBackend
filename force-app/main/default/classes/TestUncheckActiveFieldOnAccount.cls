@isTest
private class TestUncheckActiveFieldOnAccount {

    @isTest static void createTwoOrdersOnAccountThenDeleteOne() {
         // Create an account with an order : active field is true
         Account acc = new Account(Name = 'Test');
         insert acc;
         List<Order> orders = new List<Order>();
         for(Integer i=0; i<2; i++) {
         Order accOrder = TestDataFactory.createOrder(acc.Id, false);
         orders.add(accOrder);
        }
        insert orders;
         Test.startTest();
         // Delete one order
         delete orders.get(0);
         // Check active field on account
         Account newAcc = [ SELECT Active__c FROM Account WHERE Id = :acc.Id ];
         Test.stopTest();
         // Assertion : should be true because there is one order left on account
         System.assertEquals(true, newAcc.Active__c);
    }

    @isTest static void createOneOrdersOnAccountsThenDelete() {
        // Create three accounts 
        List<Account> accList = TestDataFactory.createAccounts(3, true);
        // Create One order for each account
        List<Order> orders = new List<Order>();
        for(Account acc : accList) {
            Order accOrder = TestDataFactory.createOrder(acc.Id, false);
            orders.add(accOrder);
        }
        insert orders;
        Test.startTest();
        // Delete the orders
        delete orders;
        // Check active field on accounts
        List<Account> accs = [ SELECT Active__c FROM Account WHERE Id IN :accList ];
        Test.stopTest();
        // Assertion : should be true because there is one order left on account
        for(Account acc : accs) {
            System.assertEquals(false, acc.Active__c);
        }
   }

   @isTest static void createMoreThanTwoHundredAccounts() {
    // Create three accounts 
    List<Account> accList = TestDataFactory.createAccounts(201, true);
    // Create One order for each account
    List<Order> orders = new List<Order>();
    for(Account acc : accList) {
        Order accOrder = TestDataFactory.createOrder(acc.Id, false);
        orders.add(accOrder);
    }
    insert orders;
    Test.startTest();
    // Delete orders
    List<Order> ordersToDelete = new List<Order>(); 
    for(Integer i=0; i<101; i++){
        ordersToDelete.add(orders.get(i));
    }
    delete ordersToDelete;
    // Check active field on accounts
    List<Account> activeAccs = [ SELECT Active__c FROM Account WHERE Id IN :accList
                                                                AND Active__c = true ];
    List<Account> unactiveAccs = [SELECT Active__c FROM Account WHERE Id IN :accList
                                                                AND Active__c = false ];
    Test.stopTest();
    // Assertion : should be true because there is one order left on account
    System.assertEquals(100, activeAccs.size());
    System.assertEquals(101, unactiveAccs.size());
    }
}

