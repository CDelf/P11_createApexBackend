trigger Orders on Order (before update, after delete) {  
    // If order is updated, call apex page to check orders whose status is changed from draft to activate. 
    // If order has no product, block the activation and display an error message to the user.
    if(Trigger.isUpdate) {
        // Create a set to contain the id af orders whose status is changed
        Set<Id> ordersToCheckIds = new Set<Id>();
        // Create list to contain only orders with no product
        List<Order> ordersWithoutPdt = new List<Order>();
        // in Trigger.new, just add to the first set orders whose status is changed
        for(Order o : Trigger.new) {
            if(Trigger.oldMap.get(o.Id).Status == 'Draft' && o.Status == 'Activated') {
                ordersToCheckIds.add(o.Id);
            }
        }
        // Call an apex page to check if orders have products and just select those without    
        ordersWithoutPdt = DoNotActivateOrderWithoutProductHandler.selectOrdersToBlock(ordersToCheckIds);
        // Check orders in trigger.new : 
        // each order in the list from apex handler will display the error message and block the update
        for(Order o : Trigger.new) {
            for(Order newOrder : ordersWithoutPdt) {
                if(o.Id == newOrder.Id) {
                    o.addError('An order must have at least one product to be activated. Please add products and try again.');
                }
            }
        }  
    // If order is deleted, call apex page to check if the associated account has at least one another order. 
    // If not, uncheck active field.
    } else if(Trigger.isDelete) {
        UncheckActiveFieldHandler.uncheckIfNoOrder(Trigger.old);
    }
}
