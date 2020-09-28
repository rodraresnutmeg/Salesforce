trigger AccountTrigger on Account (before update) {

    if (Trigger.isBefore && Trigger.isUpdate) {
        AccountTriggerHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
    }

}