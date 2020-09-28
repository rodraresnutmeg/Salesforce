/**********************************************************************
Purpose:

Salesforce REST API for Account object.
======================================================
History
-------
Date        AUTHOR                 	DETAIL
--/--/----  Empaua                  Initial version.
--/--/----  Raman Aliakevich        Added JISA accounts.
27/12/2019  Kseniya Hanchuk         MASQ-820: Endpoint fixes.
***********************************************************************/

@RestResource(UrlMapping='/v1.0/Account/*')
global with sharing class UpsertAccount {

    public static DescribeSObjectResult accObjDescribe = Schema.SObjectType.Account;

    global static final String DUPLICATE_RULE_NAME = System.Label.DuplicateRuleAPI; // PA_API_DUPE_RULE
    global static final Id CUSTOMER_RT = accObjDescribe.getRecordTypeInfosByName().get(System.Label.PA_Label).getRecordTypeId();
    global static final Id PROSPECT_RT = accObjDescribe.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
    global static final String JISA_PARENT_UUID = 'JISA_Parent_UUID';
    global static final String EMAIL_FIELD_LABEL = 'PersonEmail';

    @HttpPost
    global static void checkAccount() {
        RestRequest req = RestContext.request;
        String requestString = req.requestBody.toString();

        //Check if external Id is in the URL
        String externalIdField = req.requestURI.substringAfterLast('/');
        if (String.isBlank(externalIdField)) {
            returnJSONValues('{"success": false,"httpStatusCode": 400,"message" :"No external Id field submitted"}', 400);
            return;
        }

        // Check if the field provided is an external Id
        Boolean isExternalId = accObjDescribe.fields.getMap().get(externalIdField).getDescribe().isExternalID();
        if (!isExternalId) {
            //Field isn't external Id so return error
            returnJSONValues('{"success": false,"httpStatusCode": 400,"message" :"Field provided is not an external ID"}', 400);
            return;
        }

        Account acc = (Account) JSON.deserialize(requestString, Account.class);
        Map<String, String> accMap  = (Map<String, String>) JSON.deserialize(requestString, Map<String, String>.class);

        if (acc.RecordTypeId == null) {
            acc.RecordTypeId = CUSTOMER_RT;
        }

        String jisaParentUuid = accMap.get(JISA_PARENT_UUID);
        if (
            String.isNotBlank(jisaParentUuid) &&
            jisaParentUuid.toLowerCase() != 'null'
        ) {
            if (jisaParentUuid.toLowerCase() == 'none') {
                acc.JISAParentAccount__c = null;
            } else {
                List<Account> accList = [
                    SELECT
                        Id
                    FROM Account
                    WHERE User_UUID__c = :jisaParentUuid
                    ORDER BY LastModifiedDate DESC
                ];

                if (!accList.isEmpty()) {
                    acc.JISAParentAccount__c = accList[0].Id;
                }
            }
        }

        //Query existing Accounts for external Id value
        String query = 'SELECT Id, RecordTypeId, PersonContactId, ' + externalIdField + ' ' +
            'FROM Account ' +
            'WHERE ' + externalIdField + ' = \'' + acc.get(externalIdField) + '\' ' +
            'ORDER BY LastModifiedDate DESC ' +
            'LIMIT 1';

        List<Account> existingAccByExtId = Database.query(query);

        String accEmail = (String) acc.get(EMAIL_FIELD_LABEL);
        List<Account> accProspExist = [
            SELECT Id, RecordTypeId, PersonEmail, User_UUID__c, LastName, PersonContactId
            FROM Account
            WHERE PersonEmail = :accEmail
            AND RecordTypeId = :PROSPECT_RT
        ];

        if (acc.get('RecordTypeId') == PROSPECT_RT && accProspExist.isEmpty()) {
            createAccount(acc);
            return;
        } else if (acc.get('RecordTypeId') != PROSPECT_RT) {
            if (existingAccByExtId.isEmpty()) {
                if (accProspExist.size() == 1) {
                    acc.Id = accProspExist[0].Id;
                    acc.RecordTypeId = CUSTOMER_RT;
                    updateAccount(acc);
                } else if (accProspExist.size() > 1) {
                    acc.RecordTypeId = CUSTOMER_RT;
                    createAccount(acc);
                } else {
                    createAccount(acc);
                }
            } else {
                if (accProspExist.size() == 1) {
                    acc.Id = existingAccByExtId[0].Id;
                    updateAccount(acc);
                    try {
                        merge acc accProspExist;
                        Account result = [SELECT PersonContactId FROM Account WHERE Id = :acc.Id];
                        returnJSONValues('{ "PersonContactId": "' + result.PersonContactId + '","success": true,"httpStatusCode": 200,"message" : "Record updated"}', 200);
                        return;
                    } catch(DMLException e) {
                        returnJSONValues('{"success": false,"httpStatusCode": 400, "message" : "' + e + '"}', 400);
                        return;
                    }
                } else if (accProspExist.size() > 1) {
                    acc.Id = existingAccByExtId[0].Id;
                    updateAccount(acc);
                } else {
                    acc.Id = existingAccByExtId[0].Id;
                    updateAccount(acc);
                }
            }
        }

    }


    public static void returnJSONValues(String JSONval, Integer statusCodeVal) {
        RestContext.response.statusCode = statusCodeVal;
        RestContext.response.responseBody = Blob.valueOf(JSONval);

    }


    private static void updateAccount(Account acc) {
        try {
            update(acc);
            Account result = [SELECT PersonContactId FROM Account WHERE Id = :acc.Id];
            returnJSONValues('{ "PersonContactId": "' + result.PersonContactId + '","success": true,"httpStatusCode": 200,"message" : "Record updated"}', 200);
            return;
        } catch(DMLException e) {
            returnJSONValues('{"success": false,"httpStatusCode": 400, "message" : "' + e + '"}', 400);
            return;
        }

    }

    private static void createAccount(Account acc) {
        try {
            insert(acc);
            Account result = [SELECT PersonContactId FROM Account WHERE Id = :acc.Id];
            returnJSONValues('{ "PersonContactId": "' + result.PersonContactId + '","success": true,"httpStatusCode": 201,"message" : "Record created"}', 201);
            return;
        } catch(DMLException e) {
            returnJSONValues('{"success": false,"httpStatusCode": 400, "message" : "' + e + '"}', 400);
            return;
        }

    }

}