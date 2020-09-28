trigger Trig_Case on Case (before insert, after insert, before update, after update) {

    if (Trigger.isBefore && Trigger.isInsert) {
        Trig_CaseHandler.beforeInsert(Trigger.new);
    }

    if (Trigger.isAfter && Trigger.isInsert) {
        Trig_CaseHandler.afterInsert(Trigger.new, trigger.newMap.keySet());
    }

    if (Trigger.isBefore && Trigger.isUpdate) {
        Trig_CaseHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
    }

    if (Trigger.isAfter && Trigger.isUpdate) {
        Trig_CaseHandler.afterUpdate(Trigger.new);
    }
}