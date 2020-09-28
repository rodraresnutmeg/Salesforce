/**********************************************************************
Purpose:

Apex Controller for the ChildCaseGenerator Lightning Component
======================================================
Test class:

ChildCaseGeneratorControllerTest
======================================================
History
-------
Date        AUTHOR                 	DETAIL
03/02/2018  Timothy Gentet-O'Brien  Initial version
02/07/2020  Kseniya Hanchuk         MASQ-923: Bug fixing
***********************************************************************/

public class ChildCaseGeneratorController {

    public static final String FOLDER_NAME = 'Case Template';
    public static final String SOBJECT_TYPE = 'Case';

    /**
     * @method		: getCaseQueues()
     * @description	: Aura Enabled Method to get Case Queues to be displayed in the Lightning Component
     * @return		: Response Class
     * @params		: N/A
     */
    @AuraEnabled
    public static List<QueueSObject> getCaseQueues() {
        List<QueueSObject> caseQueue = [
            SELECT Id, Queue.Name
            FROM QueueSObject
            WHERE SobjectType = :SOBJECT_TYPE
        ];

        return caseQueue;

    }

    /**
     * @method		: getCaseQueues()
     * @description	: Aura Enabled Method to get Email Templates to be displayed in the Lightning Component
     * @return		: Response Class
     * @params		: N/A
     */
    @AuraEnabled
    public static Response getTemplates(String caseId, String contactId) {
        List<EmailTemplate> templates = [
            SELECT Id, Name, Body, Subject, Folder.Name
            FROM EmailTemplate
            WHERE Folder.Name LIKE :FOLDER_NAME + '%'
            ORDER BY Folder.Name, Name
        ];

        List<PicklistValue> values = new List<PicklistValue>();
        Map<Id, TemplateData> templateMap = new Map<Id, TemplateData>();

        for (EmailTemplate item : templates) {
            values.add(new PicklistValue(item.id, item.folder.name.replace(FOLDER_NAME, '') + ' ' + item.name));
            templateMap.put(item.Id, new TemplateData(item.Id, caseId, contactId));
        }

        return new Response(values, templateMap);

    }

    /**
     * @method		: saveCase()
     * @description	: Aura Enabled Method to insert the created Case
     * @return		: Response Class
     * @params		: c - Case sObject record to be inserted
     */
    @AuraEnabled
    public static Response saveCase(String caseString, Case c) {
        QueueSObject caseQueue = [
            SELECT Id, Queue.Name, QueueId
            FROM QueueSObject
            WHERE SobjectType = :SOBJECT_TYPE
            AND Queue.Name = :caseString
        ];

        c.AccountId = [SELECT AccountId FROM Case WHERE Id = :c.ParentId LIMIT 1].AccountId;
        c.OwnerId = caseQueue.QueueId; 
        c.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.Label.Child_Case_Record_Type).getRecordTypeId();

        return new Response(Database.insert(c));

    }


    public class Response {
        @AuraEnabled
        public Boolean isSuccess;
        @AuraEnabled
        public String type;
        @AuraEnabled
        public String title;
        @AuraEnabled
        public String message;
        @AuraEnabled
        public String recordId;
        @AuraEnabled
        public List<PicklistValue> values;
        @AuraEnabled
        public Map<Id, TemplateData> templateMap;

        public Response(List<PicklistValue> values) {
            this.isSuccess = true;
            this.values = values;

        }

        public Response(List<PicklistValue> values, Map<Id, TemplateData> templateMap) {
            this.isSuccess = true;
            this.values = values;
            this.templateMap = templateMap;

        }

        public Response(Database.SaveResult result) {
            this.isSuccess = result.isSuccess();
            this.type = (result.isSuccess() ? 'success' : 'danger');
            this.title = (result.isSuccess() ? 'Success!' : 'An Error Ocurred!');
            this.message = (result.isSuccess() ? 'Your case was successfully created. Click {0} to view it.' : String.join(result.getErrors(), '\r\n\r\n'));
            this.recordId = result.id;

        }

    }

    public class TemplateData {
        @AuraEnabled
        public String subject;
        @AuraEnabled
        public String description;

        public TemplateData(String templateId, String contactId, String caseId) {
            Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(templateId, contactId, caseId);
            subject = email.getSubject();
            description = email.getPlainTextBody();

        }

    }

    public class PicklistValue {
        @AuraEnabled
        public String value;
        @AuraEnabled
        public String label;

        public PicklistValue(String value, String label) {
            this.value = value;
            this.label = label;

        }

    }

}