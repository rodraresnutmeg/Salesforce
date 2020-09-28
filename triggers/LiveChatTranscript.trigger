trigger LiveChatTranscript on LiveChatTranscript (before insert, before update, after update) {

    if (Trigger.isBefore && Trigger.isInsert) {
        Trig_LiveChatTranscriptHandler.beforeInsert(Trigger.new);
    }

    if (Trigger.isAfter && Trigger.isUpdate) {
        Trig_LiveChatTranscriptHandler.afterUpdate(Trigger.oldMap , Trigger.New);
    }

    if (Trigger.isAfter && Trigger.isInsert) {
        Trig_LiveChatTranscriptHandler.afterInsert(trigger.newMap.keySet());
    }
}