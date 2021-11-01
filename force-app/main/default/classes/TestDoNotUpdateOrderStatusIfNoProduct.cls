@isTest
private class TestDoNotUpdateOrderStatusIfNoProduct {
    
    @isTest static void tryToActiveOrderWithoutProduct() {
        // Create an account
        Account acc = new Account(Name = 'Test');
        insert acc;
        // Create an order with draft status
        Order newOrder = TestDataFactory.createOrder(acc.Id, true);
        Test.startTest();
        // Try to update the order
        try {
            newOrder.status = 'Activated';
            update newOrder;
        } catch (Exception e) {
            // Assertion : try to activate an order without product launch an error
            System.assert(e.getMessage().contains('An order must have at least one product to be activated. Please add products and try again.'));
        }
        // Check order's status
        Order o = [ SELECT Status FROM Order WHERE Id = :newOrder.Id ];
        Test.stopTest();
        System.assertNotEquals('Activated', o.Status);
    }

    @isTest static void activeOrderWithProduct() {
        // Create an account
        Account acc = new Account(Name = 'Test');
        insert acc;
        // Create an activated order associated to the account
        List<Order> orderList = TestDataFactory.createMultipleProductsOrders(acc.Id, 1, 1);
        Order newOrder = orderList.get(0);
        // Try to update the order
        Test.startTest();
        try {
            newOrder.status = 'Activated';
            update newOrder;
        } catch (Exception e) {
            // Assertion : try to activate an order without product launch an error
            System.assert(e.getMessage().contains('An order must have at least one product to be activated. Please add products and try again.'));
        }

        // Check the order status
        Order activatedOrder = [ SELECT Status FROM Order WHERE Id = :newOrder.Id ];
        Test.stopTest();
        // Assertion : order was correctly updated and has an activated status
        System.assertEquals('Activated', activatedOrder.Status);
    }
    @isTest static void testOnMoreThanTwoHundredOrders() {
        // Create an account
        Account acc = new Account(Name = 'Test');
        insert acc;
        // Create 100 orders with one product each
        List<Order> ordersWithPdt = TestDataFactory.createMultipleProductsOrders(acc.Id, 50, 1);
        // Create 101 orders without product
        List<Order> ordersWithoutPdt = new List<Order>();
        for(Integer i=0; i<51; i++) {
            Order o = TestDataFactory.createOrder(acc.Id, false);
            ordersWithoutPdt.add(o);
        }
        insert ordersWithoutPdt;
        
        // Account has more than 200 orders to test governor limits, all in one list
        List<Order> accOrders = new List<Order>();
        insert accOrders;
        for(Order o : ordersWithPdt) {
            accOrders.add(o);
        }
        for(Order o : ordersWithoutPdt) {
            accOrders.add(o);
        }
        update accOrders;

        // Try to update the order
        Test.startTest();
        for(Order o : accOrders) {
            o.status = 'Activated';
        }
        try { 
                update accOrders;
            } catch (Exception e) {
                // Assertion : try to activate an order without product launch an error
                System.assert(e.getMessage().contains('An order must have at least one product to be activated. Please add products and try again.'));
            }
        
        // Check the orders status
        List<Order> activateOrders = [ SELECT Status FROM Order WHERE accountId = :acc.Id
                                                                AND Status = 'Activated' ];
        List<Order> draftOrders = [ SELECT Status FROM Order WHERE accountId = :acc.Id
                                                                AND Status = 'Draft' ];                                                        
        Test.stopTest();
        // Assertion : order was correctly updated and has an activated status
        System.assertEquals(50, activateOrders.size());
        System.assertEquals(51, draftOrders.size());
    }
}
