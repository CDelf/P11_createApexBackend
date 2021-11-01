global class AccountsToCallReminder implements Database.Batchable<sObject> {
   
    global Database.QueryLocator start(Database.BatchableContext info){ 
        // Request accounts without any order or reminder task associated :
        // Get a set of account ids with reminder task
        Set<Id> accsWithTaskIds = new Map<Id, AggregateResult>([ SELECT WhatId Id FROM Task 
        WHERE subject = 'Call' AND what.type = 'Account' GROUP BY WhatId]).keySet();
        // Get accounts without any associated order and excluding the previous set        
        return Database.getQueryLocator('SELECT Id, OwnerId FROM Account WHERE Id NOT IN (SELECT AccountId FROM Order) '
                                        + 'AND Id NOT IN :accsWithTaskIds');
    }

    global void execute(Database.BatchableContext info, List<Account> scope){      
        // Define the reminder 5 days later
        Datetime delay = System.now().addDays(5);
        // Create a task to remind salers to call these clients
        List<Task> reminders = new List<Task>();
        for (Account acc : scope) {
            Task reminder = new Task(
                WhatId = acc.Id,
                OwnerId = acc.OwnerId,
                Subject = 'Call',
                Status = 'Not Started',
                Priority = 'Normal',
                IsReminderSet = true,
                ReminderDateTime = delay
            );
            reminders.add(reminder);
        }
        insert reminders;
     }
     
     public void finish(Database.BatchableContext bc) {
     } 
}
