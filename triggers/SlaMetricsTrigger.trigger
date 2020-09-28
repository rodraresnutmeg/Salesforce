trigger SlaMetricsTrigger on SLA_Metrics__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    if(trigger.isafter) {
        if(trigger.isInsert) {
           SlaMetricsHandler.afterInsert(trigger.newMap.keySet());
        }
    }
}