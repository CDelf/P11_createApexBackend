trigger CheckActiveFieldOnAccount on Order (after insert, before update) {

    // Create the list of the accounts associated to orders in trigger.new
    List<Account> orderAccs = [ SELECT Id FROM Account WHERE Id IN (SELECT accountId FROM Order WHERE Id IN :trigger.new) ]; 

    // Check active field on each account
    if(!orderAccs.isEmpty()) {
        for(Account acc : orderAccs) {
            acc.active__c = true;
            }
        update orderAccs;
    }
}