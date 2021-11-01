public with sharing class UncheckActiveFieldHandler {
    
    public static void uncheckIfNoOrder(List<Order> deletedOrders) {
        // Create a set with all accountIds of the orders entering the trigger
        Set<Id> accIds = new Set<Id>();
        for(order o : deletedOrders) {
            if(o.AccountId != null) {
                accIds.add(o.AccountId);
            } 
        }
        
        //Get these accounts with associated orders
        List<Account> accList = new List<Account> ([SELECT Id, Active__c, (SELECT Id FROM orders)
                                                       FROM Account WHERE Id IN :accIds]);

        // Check if accounts have at least one associated order, if not uncheck the Active__c field
        if(accList.size() > 0) {
            for(Account acc : accList) {
                List<Order> accOrders = acc.Orders;
                if(accOrders.size() == 0) {
                   acc.Active__c = False;
                }
            }
            update accList;
        }
    }
}