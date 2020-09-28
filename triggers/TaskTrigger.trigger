trigger TaskTrigger on Task (before insert, after insert, after update, before update) {

    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            TaskHandler.afterInsert(trigger.newMap.keySet());
        }
    }
    if (Trigger.isAfter) {
        if (Trigger.isUpdate) {
             TaskHandler.afterUpdate(Trigger.oldMap , Trigger.New);
        }
    }
    if (Trigger.isBefore) {
        if (Trigger.isUpdate) {
             TaskHandler.beforeUpdate(Trigger.oldMap , Trigger.New);
        }
    }
    if (Trigger.isBefore && Trigger.isInsert) {
       // TaskHandler.beforeInsert(Trigger.new);
    }
}