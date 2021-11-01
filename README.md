# Openclassrooms Project 11 : create an apex backend

Developped 3 features for iDEM Connect :
RG-01 : Trigger 'Orders' + Class 'DoNotActivateOrderWithoutProductHandler' + Test class 'TestDoNotUpdateOrderStatusIfNoProduct'
RG-02 : Trigger 'Orders' + Class 'UncheckActiveFieldHandler' +  Test class 'TestUncheckActiveFieldOnAccount'
RG-03 : Batch 'AccountsToCallReminder' + Class 'ScheduleAccsToCallReminder' + Test class 'TestAccountsToCallReminder'

## Please don't consider the trigger entitled 'CheckActiveFieldOnAccount' 
Should normaly be integrated in 'Orders' trigger to have only one relative to Order Object, according to best practices. 
It has been voluntarily separated because part of pre-existent of the project (RG-02). 
Thus, code in Orders trigger shows my work stricly relative to asked fonctionnalities.
