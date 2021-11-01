@isTest
public with sharing class TestDataFactory {
    
    // Create several accounts
    public static List<Account> createAccounts(Integer numAccs, Boolean doInsert) {
        List<Account> accs = new List<Account>();
        for(Integer i=0; i<numAccs; i++) {
            Account acc = new Account(Name = 'Account ' + i);
            accs.add(acc);
        }
        if(doInsert) {
            insert accs;
        }
        return accs;
    }
    
    // Create a priceBookEntry
    public static PriceBookEntry createPriceBookEntry() {
        Product2 product = new Product2(Name = 'Chemise Verte longue XYX', Family = 'Chemise');
        Insert product;
        
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = product.Id,
            UnitPrice = 1020,
            IsActive = true
        );
        Insert pbe;
        Return pbe;
    }
    
    // Create an order with draft status, associated to an account
    public static Order createOrder(Id accountId, boolean doInsert) {
        Order newOrder = new Order(
            AccountId = accountId,
            Pricebook2Id=Test.getStandardPricebookId(),
            status = 'draft',
            effectiveDate = Date.today()
        );
        if(doInsert) {
            insert newOrder;
        }
        return newOrder;
    }
    
    // Create several orders with ordered status on one account
    // TotalAmount of each orders is equal to 100
    public static List<Order> createOrdersOnAccount(Integer numberOfOrders, Id accountId){
        // First insert draft orders
        List<Order> newOrders = new List<Order>();
        for(Integer i=0; i<numberOfOrders; i++) {
            Order newOrder = new Order(
                AccountId = accountId,
                Pricebook2Id = Test.getStandardPricebookId(),
                status = 'draft',
                effectiveDate = Date.today()
            );
            newOrders.add(newOrder);
        }
        insert newOrders;
        // Create a priceBookEntry
        PriceBookEntry pbe = TestDataFactory.createPriceBookEntry();
        // Create an order product: totalAmount is equal to 100
        List<OrderItem> items = new List<OrderItem>();
        for(Order newOrder : newOrders) {
            OrderItem item = new OrderItem (OrderId = newOrder.Id, PricebookEntryId = pbe.Id, Quantity=10, UnitPrice = 10);
            items.add(item);
        }
        insert items;     
        // Activate the orders
        for(Order newOrder : newOrders) {
            newOrder.Status = 'activated';
        }
        update newOrders;
        return newOrders;
    }
    
    // Create an ordered order with multiple products
    public static List<Order> createMultipleProductsOrders(Id accountId, Integer numOrders, Integer numProducts){
        List<Order> newOrders = new List<Order>();
        for(Integer i=0; i<numOrders; i++) {
            Order newOrder = TestDataFactory.createOrder(accountId, false);
            newOrders.add(newOrder);
        }
        insert newOrders;
        // Create a priceBookEntry
        PriceBookEntry pbe = TestDataFactory.createPriceBookEntry();
        // Create order products : each product add 50 to order TotalAmount 
        List<OrderItem> items = new List<OrderItem>();
        for(Order newOrder : newOrders) {
            for(Integer j=0; j<numProducts; j++) {
                OrderItem item = new OrderItem (OrderId = newOrder.Id, PricebookEntryId = pbe.Id, Quantity=5, UnitPrice = 10);
                items.add(item);
            } 
        }   
        insert items;
        // Activate the orders
        for(Order newOrder : newOrders) {
            newOrder.Status = 'Activated';
        }
        update newOrders;
        return newOrders;
    }    
}