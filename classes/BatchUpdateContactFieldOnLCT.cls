/**********************************************************************
Purpose:

Some description
======================================================

Test class:
Test_BatchUpdateContactFieldOnLCT

======================================================
History
-------
Date        AUTHOR                 	DETAIL
01/01/2020  Raman Aliakevich        MASQ-973: Initial version
***********************************************************************/

global class BatchUpdateContactFieldOnLCT implements Database.Batchable<SObject>, Database.Stateful, Schedulable {

    private static final String CHAT_STATUS = 'InProgress';

    String query = '' +
        'SELECT Id, ContactId, AccountId, Account.PersonContactId, Status ' +
        'FROM LiveChatTranscript ' +
        'WHERE AccountId != NULL AND ContactId != NULL AND Status != {0}';

    global BatchUpdateContactFieldOnLCT() {
        this.query = String.format(query, new List<String>{ '\'InProgress\'' });

        if (Test.isRunningTest()) {
            this.query = 'SELECT Id, ContactId, AccountId, Account.PersonContactId, Status FROM LiveChatTranscript';
        }
    }

    public void execute(SchedulableContext ctx) {
        Database.executeBatch(new BatchUpdateContactFieldOnLCT(), 500);
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug('Query to perform: ' + this.query);
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<LiveChatTranscript> scope) {
        for (LiveChatTranscript lct : scope) {
            lct.ContactId = lct.Account.PersonContactId;
        }

        update scope;
    }

    global void finish(Database.BatchableContext bc) {
    }

}