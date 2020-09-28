/**********************************************************************
Purpose:

Migrate Cases to archive and remove from Case sObject.
======================================================

Test class:
Test_BatchMigrateCasesToArchived
======================================================
History
-------
Date        AUTHOR                 	DETAIL
03/31/2020  Kseniya Hanchuk         MASQ-1082: Initial version
***********************************************************************/
public class BatchMigrateCasesToArchived  implements Database.Batchable<SObject>, Database.Stateful, Schedulable {

    private static DescribeSObjectResult caseObjectDescribe = Schema.SObjectType.Case;
    private static DescribeSObjectResult archivedCaseObjectDescribe = Schema.SObjectType.Archived_Case__c;

    private static final Map<String, Schema.SObjectField> CASE_FIELDS = caseObjectDescribe.fields.getMap();
    private static final Map<String, Schema.SObjectField> ARCHIVED_CASE_FIELDS = archivedCaseObjectDescribe.fields.getMap();

    private static final String FIELDNAME_POSTFIX = '__c';
    private static final String RECORDTYPE_FIELDNAME = 'RecordTypeId';
    private static final String EMAIL_SUBJECT = 'ERRORS: Case Archivation Job';
    private static final String NOT_SAVED_TITLE = 'ERRORs occurred when saved to the archive';
    private static final String NOT_DELETED_TITLE = 'ERRORs occurred when deleted cases';
    private static final Datetime YEAR_AGO = System.today() - 365;

    private static final List<String> EMAIL_ADDRESSES_TO = new List<String> {
        'ksenia.ganchuk@gmail.com'
    };
    // Cases that should be moved to archive.
    private static final List<String> QUERY_CONDITIONS_OR = new List<String> {
        'ClosedDate <= ' + YEAR_AGO.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'') + ' AND Status = \'Closed\''
    };
    private static final List<String> FIELDS_TO_SKIP = new List<String> {
        'Id',
        'IsDeleted',
        'MasterRecordId',
        'AssetId',
        'ProductId',
        'SourceId',
        'ParentId',
        'IsClosed',
        'CreatedById',
        'LastModifiedDate',
        'LastModifiedById',
        'SystemModstamp',
        'LastViewedDate',
        'LastReferencedDate',
        'ContactPhone',
        'ContactMobile',
        'ContactEmail',
        'ContactFax',
        'Language'
    };
    // Map<[Case field name], [Archived Case field name]>
    private static final Map<String, String> FIELDS_SPECIFIC_MAPPING = new Map<String, String> {
        'CaseNumber' => 'Name',
        'CreatedDate' => 'CreatedDate__c',
        'OwnerId' => 'OwnerId__c'
    };
    private static final Map<String, String> RECORD_TYPE_IDS_MAPPING = new Map<String, String> {
        caseObjectDescribe.getRecordTypeInfosByName().get('Child Case').getRecordTypeId() => archivedCaseObjectDescribe.getRecordTypeInfosByName().get('Child Case').getRecordTypeId(),
        caseObjectDescribe.getRecordTypeInfosByName().get('FOS Case').getRecordTypeId() => archivedCaseObjectDescribe.getRecordTypeInfosByName().get('FOS Case').getRecordTypeId(),
        caseObjectDescribe.getRecordTypeInfosByName().get('Serenova Case').getRecordTypeId() => archivedCaseObjectDescribe.getRecordTypeInfosByName().get('Serenova Case').getRecordTypeId(),
        caseObjectDescribe.getRecordTypeInfosByName().get('Standard Case').getRecordTypeId() => archivedCaseObjectDescribe.getRecordTypeInfosByName().get('Standard Case').getRecordTypeId()
    };

    private static List<String> caseFields = getAllFieldnames(CASE_FIELDS);
    private static List<String> archvedCaseFields = getAllFieldnames(ARCHIVED_CASE_FIELDS);

    private static List<String> notSavedArchives = new List<String>();
    private static List<String> notDeletedCases = new List<String>();
    private static String errorMoc = '{0}: {1}\r\nFields that affected this error: {2}';

    String query = 'SELECT {0} FROM Case WHERE {1}';


    public void execute(SchedulableContext ctx) {
        Database.executeBatch(new BatchMigrateCasesToArchived(), 500);

    }


    public Database.QueryLocator start(Database.BatchableContext bc) {
        if (Test.isRunningTest()) {
            this.query = String.format(query, new List<String> {
                String.join(caseFields, ', '),
                'Status = \'Closed\''
            });
        } else {
            this.query = String.format(query, new List<String> {
                String.join(caseFields, ', '),
                String.join(QUERY_CONDITIONS_OR, ' OR ')
            });
        }
        return Database.getQueryLocator(query);

    }

    public void execute(Database.BatchableContext bc, List<Case> scope) {
        List<Archived_Case__c> archive = new List<Archived_Case__c>();
        Map<String, String> caseNumToCaseId = new Map<String, String>();
        Map<Id, Case> casesToDelete = new Map<Id, Case>(scope);

        for (Case caseItem : scope) {
            caseNumToCaseId.put(caseItem.CaseNumber, caseItem.Id);
            archive.add(copyCaseToArchive(caseItem));
        }

        try {
            Database.SaveResult[] savedArchives = Database.insert(archive, false);

            List<String> newArchivedCases = new List<String>();

            for (Database.SaveResult srItem : savedArchives) {
                if (srItem.isSuccess()) {
                    newArchivedCases.add(srItem.getId());
                } else {
                    for(Database.Error errItem : srItem.getErrors()) {
                        notSavedArchives.add(errorString(errItem));
                    }
                }
            }

            for (Archived_Case__c archivedCaseItem : [
                SELECT Name
                FROM Archived_Case__c
                WHERE Id IN :newArchivedCases
            ]) {
                if (caseNumToCaseId.containsKey(archivedCaseItem.Name)) {
                    casesToDelete.remove(caseNumToCaseId.get(archivedCaseItem.Name));
                }
            }

            Database.DeleteResult[] deletedCases = Database.delete(casesToDelete.values(), false);

            for (Database.DeleteResult delItem : deletedCases) {
                if (!delItem.isSuccess()) {
                    for (Database.Error errItem : delItem.getErrors()) {
                        notDeletedCases.add(errorString(errItem));
                    }
                }
            }

        } catch (Exception e) {
            System.debug('BatchMigrateCasesToArchived: Error during DML operations: ' + e.getMessage());
        }

    }

    public void finish(Database.BatchableContext bc) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(EMAIL_ADDRESSES_TO);
        mail.setSubject(EMAIL_SUBJECT);

        String htmlBody = '';
        if (!notSavedArchives.isEmpty()) {
            htmlBody += '<b>' + NOT_SAVED_TITLE + '</b></br></br>';
            
            for (String item : notSavedArchives) {
                htmlBody += item + '</br>';
            }
        }

        if (!notDeletedCases.isEmpty()) {
            htmlBody += '</br><b>' + NOT_DELETED_TITLE + '</b></br></br>';
            
            for (String item : notDeletedCases) {
                htmlBody += item + '</br>';
            }
        }

        if (String.isNotBlank(htmlBody)) {
            mail.setHtmlBody(htmlBody);

            try {
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
            catch (EmailException e) {
                System.debug('BatchMigrateCasesToArchived: Error during sendMail: ' + e.getMessage());
            }
        }
    }


    private static Archived_Case__c copyCaseToArchive(Case caseToArchive) {
        Archived_Case__c newArchivedCase = new Archived_Case__c();

        for (String caseFieldnameItem : caseFields) {
            if (caseFieldnameItem == RECORDTYPE_FIELDNAME) {
                newArchivedCase.put(
                    RECORDTYPE_FIELDNAME,
                    RECORD_TYPE_IDS_MAPPING.get(String.valueOf(caseToArchive.get(caseFieldnameItem)))
                );
            } else {
                newArchivedCase.put(
                    approprArchivedCaseFieldname(caseFieldnameItem),
                    caseToArchive.get(caseFieldnameItem)
                );
            }
        }

        return newArchivedCase;

    }

    private static String approprArchivedCaseFieldname(String caseFieldName) {
        if (archvedCaseFields.isEmpty()) {
            return null;
        } else if (FIELDS_SPECIFIC_MAPPING.containsKey(caseFieldName)) {
            return FIELDS_SPECIFIC_MAPPING.get(caseFieldName);
        } else if (archvedCaseFields.contains(caseFieldName)) {
            return caseFieldName;
        } else if (archvedCaseFields.contains(caseFieldName + FIELDNAME_POSTFIX)) {
            return caseFieldName + FIELDNAME_POSTFIX;
        } else {
            return null;
        }

    }

    private static String errorString(Database.Error errItem) {
        return String.format(errorMoc, new List<String> {
            String.valueOf(errItem.getStatusCode()),
            errItem.getMessage(),
            String.valueOf(errItem.getFields())
        });

    }
    
    private static List<String> getAllFieldnames(Map<String, Schema.SObjectField> fieldsMap) {
        List<String> fieldnames = new List<String>();

        for (Schema.SObjectField field : fieldsMap.values()) {
            String fieldName = field.getDescribe().getName();
            if (!field.getDescribe().isCalculated() && !FIELDS_TO_SKIP.contains(fieldName)) {
                fieldnames.add(fieldName);
            }
        }

        return fieldnames;

    }

}