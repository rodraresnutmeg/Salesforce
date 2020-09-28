/**********************************************************************
Purpose:

Populates First Investment Day to all Account from their related Pots
======================================================
Test class:

Test_BatchAddFirstInvestmentDay
======================================================
History
-------
Date        AUTHOR                 	DETAIL
03/04/2019  Kseniya Hanchuk         MASQ-1046: Initial version
***********************************************************************/

public class BatchAddFirstInvestmentDay implements Database.Batchable<sObject>, Database.Stateful, Schedulable {

    public static DescribeSObjectResult accountObjectDescribe = Schema.SObjectType.Account;

    private static final String CUSTOMER_RT_ID = accountObjectDescribe.getRecordTypeInfosByName().get('Customer').getRecordTypeId();

    String query = 'SELECT Id, Derived_First_Investment_Date__pc FROM Account WHERE RecordTypeId = \'' + CUSTOMER_RT_ID + '\' AND Derived_First_Investment_Date__pc = null';

    public void execute(SchedulableContext ctx) {
        Database.executeBatch(new BatchAddFirstInvestmentDay(), 500);
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug('Query to perform: ' + this.query);
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<Account> scope) {
        List<AggregateResult> relatedPots = [
            SELECT Person_Account__c, MIN(Pot_Started_Date__c)minInvestDay
            FROM Pot__c
            WHERE Person_Account__c IN :scope
            GROUP BY Person_Account__c
        ];

        Map<String, Datetime> accIdToFirstInvestDay = new Map<String, Datetime>();

        for (AggregateResult potItem : relatedPots) {
            accIdToFirstInvestDay.put(
                String.valueOf(potItem.get('Person_Account__c')),
                Datetime.valueOf(potItem.get('minInvestDay'))
            );
        }

        for (Account accItem : scope) {
            accItem.Derived_First_Investment_Date__pc = accIdToFirstInvestDay.get(accItem.Id);
        }

        if (accountObjectDescribe.isAccessible() && accountObjectDescribe.isUndeletable()) {
            update scope;
        }

    }

    public void finish(Database.BatchableContext bc) {
        System.debug('Query to perform: ' + this.query);
    }

}