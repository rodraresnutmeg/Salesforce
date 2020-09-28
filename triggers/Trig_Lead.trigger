/**********************************************************************
History
-------
Date        AUTHOR                 	DETAIL
--/--/----  Raman Aliakevich        Initial version
10/10/2019  Kseniya Hanchuk         CRM-165: Moved logic to handler class.
***********************************************************************/

trigger Trig_Lead on Lead (after insert, after update) {

    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            Trig_LeadHandler.createPersonalAccount(Trigger.new);
        }

        if (Trigger.isUpdate) {
            Trig_LeadHandler.removeLeads(Trigger.new, Trigger.old);
        }
    }

}