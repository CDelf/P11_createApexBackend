@isTest
private class TestAccountsToCallReminder {

    @testSetup
    static void setup() {
        // Create a list of 10 accounts
        List<Account> accs = new List<Account>();
        for(Integer i = 0; i<10; i++) {
            Account acc = new Account (Name = 'Test ' + i);
            accs.add(acc);
        }
        insert accs;
    }
   
    @isTest static void testOnAccsWithoutOrderAndTask() {
        // Launch the batch
        Test.startTest();
        AccountsToCallReminder testReminder = new AccountsToCallReminder();
        Id batchId = Database.executeBatch(testReminder);
        Test.stopTest();

        // Check that tasks have been created, associated to the accounts
        List<Account> accs = [ SELECT Id, OwnerId FROM Account WHERE Name LIKE 'Test _' LIMIT 10 ];
        Set<Id> accsIds = new Set<Id>();
        for (Account acc : accs) {
            accsIds.add(acc.Id);
        }
        List<Task> tasksToCheck = [ SELECT Id, WhatId, OwnerId FROM Task WHERE WhatId IN :accsIds ];

        System.assertEquals(tasksToCheck.size(), 10);
        for(Task t : tasksToCheck) {
            System.assertEquals(accs.get(0).OwnerId, t.OwnerId);
        }
    }

    @isTest static void testOnAccsWithOrders() {
        // Get the list of accounts
        List<Account> accs = [SELECT Id, OwnerId FROM Account WHERE Name LIKE 'Test _' LIMIT 10 ];
        // Create orders for 5 accounts
        List<Order> accsOrders = new List<Order>();
        for(Integer i=0; i<5; i++) {
            Order newOrder = TestDataFactory.createOrder(accs.get(i).Id, false);
            accsOrders.add(newOrder);
        }
        insert accsOrders;

        // Launch the batch
        Test.startTest();
        AccountsToCallReminder testReminder = new AccountsToCallReminder();
        Id batchId = Database.executeBatch(testReminder);
        Test.stopTest();

        // Check that tasks have been created, associated to the accounts
        Set<Id> accsIds = new Set<Id>();
        for (Account acc : accs) {
            accsIds.add(acc.Id);
        }
        List<Task> tasksToCheck = [ SELECT Id, WhatId, OwnerId FROM Task WHERE WhatId IN :accsIds ];

        System.assertEquals(tasksToCheck.size(), 5);
        for(Task t : tasksToCheck) {
            System.assertEquals(accs.get(0).OwnerId, t.OwnerId);
        }
    }
        
        @isTest static void testOnAccsWithCallTasks() {
            // Get the list of accounts
            List<Account> accs = [SELECT Id, OwnerId FROM Account WHERE Name LIKE 'Test _' LIMIT 10 ];
            // Create call tasks for 5 accounts
            List<Task> calls = new List<Task>();
            for(Integer i=0; i<5; i++) {
                Task call = new Task(WhatId = accs.get(i).Id, Subject = 'Call', Priority = 'Normal', Status = 'Completed');
                calls.add(call);
            }
            insert calls;
    
            // Launch the batch
            Test.startTest();
            AccountsToCallReminder testReminder = new AccountsToCallReminder();
            Id batchId = Database.executeBatch(testReminder);
            Test.stopTest();
    
            // Check that tasks have been created, associated to the accounts
            Set<Id> accsIds = new Set<Id>();
            for (Account acc : accs) {
                accsIds.add(acc.Id);
            }
            List<Task> tasksToCheck = [ SELECT Id, WhatId, OwnerId FROM Task WHERE WhatId IN :accsIds AND Status = 'Not Started' ];
    
            System.assertEquals(tasksToCheck.size(), 5);     
            for(Task t : tasksToCheck) {
                System.assertEquals(accs.get(0).OwnerId, t.OwnerId);
            }  
    }

    @isTest static void testOnTwoHundredAccs() {
        // Get the list of accounts
        List<Account> accs = new List<Account>();
        // Create 191 more accounts 
        for(Integer i=0; i<190; i++) {
            Account acc = new Account(Name = 'Test ' + i+10);
            accs.add(acc);
        }
        insert accs;
        // Launch the batch
        Test.startTest();
        AccountsToCallReminder testReminder = new AccountsToCallReminder();
        Id batchId = Database.executeBatch(testReminder);
        Test.stopTest();

        // Check that tasks have been created, associated to the accounts
        List<Account> accsList = [ SELECT Id, OwnerId FROM Account WHERE Name LIKE 'Test %' ];
        Set<Id> accsIds = new Set<Id>();
        for (Account acc : accsList) {
            accsIds.add(acc.Id);
        }
        List<Task> tasksToCheck = [ SELECT Id, WhatId, OwnerId FROM Task WHERE WhatId IN :accsIds ];

        System.assertEquals(tasksToCheck.size(), 200);
        for(Task t : tasksToCheck) {
            System.assertEquals(accsList.get(0).OwnerId, t.OwnerId);
        }
    }
}
