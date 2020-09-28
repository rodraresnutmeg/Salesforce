/**********************************************************************
Purpose:

Handler for Trig_Lead.
======================================================
History
-------
Date        AUTHOR                 	DETAIL
11/10/2019  Kseniya Hanchuk         CRM-165: Initial version.
01/10/2019  Kseniya Hanchuk         MASQ-841: Avios/KMPG/Deloitte fixes.
02/11/2020  Kseniya Hanchuk         MASQ-901: Added custom metadata type.
02/27/2020  Kseniya Hanchuk         MASQ-917: Added IPSE number.
***********************************************************************/

public without sharing class Trig_LeadHandler {

    private static List<Lead_Trigger_Setting__mdt> leadTrigSettings = [
        SELECT Email_for_delete__c, Guide_Key__c
        FROM Lead_Trigger_Setting__mdt
    ];

    public final static List<String> MC_EMAIL_FOR_DELETE    = getUniqEmailsForDelete();
    public final static List<String> GUIDE_KEYS             = getGuideKeys();

    public final static Id RT_PA_PROSPECT_ID = Schema.SObjectType.Account
        .getRecordTypeInfosByName()
        .get('Prospect')
        .getRecordTypeId();

    public static void createPersonalAccount(List<Lead> newLeads) {
        List<Account>           accList     = new List<Account>();
        Map<String, Account>    existAccMap = getExistAccounts(newLeads);

        for (Lead lead : newLeads) {
            // PA not exist
            if (lead.Email != null && !existAccMap.containsKey(lead.Email)) {
                Account newAcc = getNewAccount(lead);

                if (lead.EmailOptIn__c) {
                    updateAccountConsent(newAcc, true, lead.CreatedDate);
                } else if (lead.FormName__c == 'preference-centre') {
                    updateAccountConsent(newAcc, false, lead.CreatedDate);
                }

                accList.add(newAcc);
            }

            // PA exist
            if (lead.Email != null && existAccMap.containsKey(lead.Email)) {
                Account updatedAcc      = existAccMap.get(lead.Email);
                Boolean isAccChanged    = false;

                if (!lead.EmailOptIn__c && lead.FormName__c == 'preference-centre') {
                    updateAccountConsent(updatedAcc, false, lead.CreatedDate);
                    isAccChanged = true;
                }

                if (!String.isBlank(lead.FormName__c) && lead.FormName__c != 'preference-centre') {
                    if (updateAccountCompletedWebForms(updatedAcc, lead)) {
                        isAccChanged = true;
                    }
                }

                if (lead.EmailOptIn__c
                    && updatedAcc.RecordTypeId == RT_PA_PROSPECT_ID
                    && (
                        !updatedAcc.Email_Investment_Product__pc
                        || !updatedAcc.Email_Nutmeg_Promos__pc
                    )
                ) {
                    updateAccountConsentIfFalse(updatedAcc, lead.CreatedDate);
                    isAccChanged = true;
                } else if (
                    lead.FormName__c == 'kpmg' || lead.FormName__c == 'deloitte'
                ) {
                    updatedAcc.FormName__pc = lead.FormName__c;
                    isAccChanged = true;

                } else if (
                    lead.FormName__c == 'avios'
                    && lead.AviosMembershipNumber__c != null
                    && updatedAcc.AviosMembershipNumber__pc == null
                ) {
                    updatedAcc.FormName__pc              = lead.FormName__c;
                    updatedAcc.AviosMembershipNumber__pc = lead.AviosMembershipNumber__c;
                    isAccChanged = true;

                } else if (
                    lead.FormName__c == 'ipse'
                    && lead.IPSE_Number__c != null
                    && updatedAcc.IPSE_Number__pc == null
                ) {
                    updatedAcc.FormName__pc    = lead.FormName__c;
                    updatedAcc.IPSE_Number__pc = lead.IPSE_Number__c;
                    isAccChanged = true;
                }

                if (isAccChanged) {
                    accList.add(updatedAcc);
                }
            }
        }

        upsert accList;
        removeLeads();
    }

    private static Map<String, Account> getExistAccounts(List<Lead> newLeads) {
        List<String> emailsList = new List<String>();

        for (Lead lead : newLeads) {
            if (String.isNotBlank(lead.Email)) {
                emailsList.add(lead.Email);
            }
        }

        List<Account> accList = [
            SELECT
                Id,
                AviosMembershipNumber__pc,
                CompletedWebForms__c,
                Consent_Type__pc,
                Email_Investment_Product__pc,
                Email_Nutmeg_Promos__pc,
                FormName__pc,
                IPSE_Number__pc,
                PersonEmail,
                RecordTypeId
            FROM Account
            WHERE PersonEmail IN :emailsList
            LIMIT 1000
        ];

        Map<String, Account> existAccMap = new Map<String, Account>();
        for (Account acc : accList) {
            existAccMap.put(acc.PersonEmail, acc);
        }

        return existAccMap;
    }

    private static Account getNewAccount(Lead lead) {
        Account newAccount = new Account(
            RecordTypeId                = RT_PA_PROSPECT_ID,
            PersonEmail                 = lead.Email,
            Consent_Type__pc            = lead.Website,
            LastName                    = lead.LastName,
            AviosMembershipNumber__pc   = lead.AviosMembershipNumber__c,
            FormName__pc                = lead.FormName__c,
            IPSE_Number__pc             = lead.IPSE_Number__c,
            CompletedWebForms__c        = lead.FormName__c
        );

        return newAccount;
    }

    private static void updateAccountConsent(Account acc, Boolean value, Datetime createdDate) {
        acc.Email_Investment_Product__pc                 = value;
        acc.Email_Investment_Product_Consent_Date__pc    = createdDate;
        acc.Email_Nutmeg_Promos__pc                      = value;
        acc.Email_Nutmeg_Promos_Consent_Date__pc         = createdDate;
    }

    private static void updateAccountConsentIfFalse(Account acc, Datetime createdDate) {
        if (!acc.Email_Investment_Product__pc) {
            acc.Email_Investment_Product__pc                 = true;
            acc.Email_Investment_Product_Consent_Date__pc    = createdDate;
        }

        if (!acc.Email_Nutmeg_Promos__pc) {
            acc.Email_Nutmeg_Promos__pc                      = true;
            acc.Email_Nutmeg_Promos_Consent_Date__pc         = createdDate;
        }
    }

    private static Boolean updateAccountCompletedWebForms(Account acc, Lead lead) {
        Boolean isAccChanged = false;

        List<String> completedWebFormsList = Utils.getNormalizedListFromString(acc.CompletedWebForms__c);

        if (completedWebFormsList == null) {
            acc.CompletedWebForms__c += lead.FormName__c;
            isAccChanged = true;
        } else if (!completedWebFormsList.contains(lead.FormName__c)) {
            acc.CompletedWebForms__c += ', ' + lead.FormName__c;
            isAccChanged = true;
        }

        return isAccChanged;
    }

    public static void removeLeads(List<Lead> newLeads, List<Lead> oldLeads) {
        List<Id> leadsforDelete = new List<Id>();

        for (Lead newItem : newLeads) {
            for (Lead oldItem : oldLeads) {
                if (newItem.Email != oldItem.Email && MC_EMAIL_FOR_DELETE.contains(newItem.Email)) {
                    leadsforDelete.add(newItem.Id);
                }
            }
        }

        delete [SELECT Id FROM Lead WHERE Id IN :leadsforDelete];
    }

    @Future
    public static void removeLeads() {
        List<Lead> leadsForDel = [
            SELECT Id
            FROM Lead
            WHERE Website NOT IN :GUIDE_KEYS
            LIMIT 1000
        ];

        delete leadsForDel;
    }

    private static List<String> getUniqEmailsForDelete() {
        Set<String> uniqEmails = new Set<String>(); 

        for (Lead_Trigger_Setting__mdt leadTrigSettingItem : leadTrigSettings) {
            uniqEmails.add(String.valueOf(leadTrigSettingItem.Email_for_delete__c));
        }

        return new List<String>(uniqEmails);

    }

    private static List<String> getGuideKeys() {
        List<String> guideKeys = new List<String>(); 

        for (Lead_Trigger_Setting__mdt leadTrigSettingItem : leadTrigSettings) {
            guideKeys.add(String.valueOf(leadTrigSettingItem.Guide_Key__c));
        }

        return guideKeys;
 
    }

}