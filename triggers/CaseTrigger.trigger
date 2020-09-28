trigger CaseTrigger on Case (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
   /* if(trigger.isafter) {
        if(trigger.isInsert) {
           CaseHandler.afterInsert(trigger.newMap.keySet());
        }
    }*/
}