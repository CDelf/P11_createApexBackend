public with sharing class DoNotActivateOrderWithoutProductHandler {
    
  public static List<Order> selectOrdersToBlock(Set<Id> ordersToCheckIds) {  
      // List to contain orders without product that will be returned to trigger
      List<Order> ordersWithoutPdt = new List<Order>();
      
      if(!ordersToCheckIds.isEmpty()) {
          // Get the list of orders with their products
          List<Order> ordersToCheck = [ SELECT Id, (SELECT Id, OrderId FROM OrderItems) 
                                                    FROM Order WHERE Id IN :ordersToCheckIds ]; 
          // Check each order looking for product. If no product, add to the list returned to trigger
          if(!ordersToCheck.isEmpty()) {
              for(Order o : ordersToCheck) {
                  List<OrderItem> ois = o.OrderItems;
                  if(ois.size() == 0) {
                      ordersWithoutPdt.add(o);
                  }
              }
          }
      }
      return ordersWithoutPdt;
  }
}
