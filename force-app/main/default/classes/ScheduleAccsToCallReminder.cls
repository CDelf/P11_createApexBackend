global class ScheduleAccsToCallReminder implements Schedulable {
    
    // Implements the Schedulable interface for the batch AccountsToCallReminder
    global void execute(SchedulableContext sc) {
       AccountsToCallReminder reminder = new AccountsToCallReminder(); 
       database.executebatch(reminder);
    }
 }