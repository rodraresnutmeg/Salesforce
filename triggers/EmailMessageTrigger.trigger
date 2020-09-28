/*****************************************************************
Author:    Fco.Javier Sanz <javier.sanz@empaua.com>
Component Type:  Handler
Component Name:  EmailMessageTrigger
Object: Case
Description: Trigger events for EmailMessage object

30/10/2019  Fco.Javier Sanz    Initial 
30/10/2019  added before insert call
*******************************************************************/
trigger EmailMessageTrigger on EmailMessage (before insert, after insert, after update) {

    if (Trigger.isBefore && Trigger.isInsert) {
        EmailMessageHandler.beforeInsert(Trigger.new);
    }
    if(trigger.isAfter ) {
        if(trigger.isInsert) {
           EmailMessageHandler.afterInsert(trigger.newMap.keySet());
        }
    }   
    if (Trigger.isAfter && Trigger.isUpdate) {
        EmailMessageHandler.afterUpdate(trigger.newMap.keySet());
    }

}