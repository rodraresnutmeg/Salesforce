public with sharing class NutmailToArchiveCtrl {

    private final static String CASE_SOBJECT_PREFIX = Schema.SObjectType.Case.getKeyPrefix();
    private final static List<String> EMAILMESSAGE_FIELDS = new List<String> {
        'Id',
        'MessageID__c',
        'Subject',
        'TextBody'
    };

    private static String emailMessagesQuery = 'SELECT {0} FROM EmailMessage WHERE Nutmail_Message__c = TRUE AND IsHiden__c = FALSE';

    @AuraEnabled
    public static List<EmailMessage> getEmailMessages(String recordId) {
        String ids = '';
        Schema.SObjectType curRecSObjType = Id.valueOf(recordId).getsObjectType();
        if (curRecSObjType == EmailMessage.getsObjectType()) {
            emailMessagesQuery += ' AND Id = {1}';
            ids = '\'' + recordId + '\'';
        } else if (curRecSObjType == Case.getsObjectType()) {
            emailMessagesQuery += ' AND ParentId = {1}';
            ids = '\'' + recordId + '\'';
        } else if (curRecSObjType == Account.getsObjectType()) {
            List<String> casesIds = new List<String>();
            for (AggregateResult arItem : [SELECT WhatId FROM Task WHERE AccountId = :recordId GROUP BY WhatId]) {
                String whatId = String.valueOf(arItem.get('WhatId'));
                if (whatId.startsWith(CASE_SOBJECT_PREFIX)) {
                    casesIds.add(whatId);
                }
            }

            emailMessagesQuery += ' AND ParentId IN {1}';
            ids = '(\'' + String.join(casesIds, '\',\'') + '\')';
        } else {
            return new List<EmailMessage>();
        }

        emailMessagesQuery = String.format(emailMessagesQuery, new List<String> { String.join(EMAILMESSAGE_FIELDS, ','), ids });
        return Database.query(emailMessagesQuery);
    }

    @AuraEnabled
    public static String hideMessage(String messageId) {
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint('https://api.dev.nutmeg.co.uk/crm/nutmail/' + messageId + '/hide');

        String authorizationHeader = 'Bearer eyJ0eXAiOiJKV1QiLCJraWQiOiJkOTgzNDYyYyIsImFsZyI6IlJTNTEyIn0.eyJqdGkiOiJjMDRhNzVmYS0yZWRiLTQzZWQtOWU3Ny1iOGJkZDgyOGExMTAiLCJzdWIiOiJ1cm46bnV0bWVnOmdiOnN2YzpZSEdRS0pWRyIsImlzcyI6InVybjpudXRtZWc6Z2I6YXV0aC1zaXQiLCJhdWQiOiJ1cm46bnV0bWVnOmdiIiwiZXhwIjoxNTk2MjQwMDAwLCJpYXQiOjE1ODYyOTIyNTV9.PlmaIaN7CyJ178wlzVQJwHfbVvx9_3-yUYAot7nVCY4omHM1IwPxMMiimMubjmZvO5j3NMIBEDJU0C43yYyrJB1qoBVF4j5JoOqiFTWJd4d7wPcS7f2gdLUL4zR7HpAMq6VT_Rxj_Xjq_XbVsirF5JtFXf8OsFXgF_IwHnNq4J3rh3M32amEZSZSOzcqlQ66rU4O5UKSFmEDtNM5WVTrEMGyZpkmprfwXzFa-efbgVGKssNogfUgToXsSgHMMuwwo_6vUjAeUbBLuI7QPai1e7y9jRzgT5uZgHactMtgh-OOawsEGhrb3tJFKR-3MbVqy7HBcLyYCh0UztsRaJhAOw';
        req.setHeader('Authorization',  authorizationHeader);

        Http http = new Http();
        HTTPResponse res = http.send(req);

        if (res.getStatusCode() == 200) {
            EmailMessage currentEM = [
                SELECT Id, IsHiden__c
                FROM EmailMessage
                WHERE Nutmail_Message__c = TRUE
                AND MessageID__c = :messageId
                LIMIT 1
            ];
            currentEM.IsHiden__c = true;
            update currentEM;
        }

        return '{"StatusCode":' + res.getStatusCode() + ',"Status":"' + res.getStatus() + '"}';
    }

}