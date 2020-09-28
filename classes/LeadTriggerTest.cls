@isTest
private with sharing class LeadTriggerTest {

//    @isTest
//    private static void triggerTest() {
//        Integer count = 10;
//        Integer countForWrongLeads = 5;
//
//        List<Lead> newLeadsList = new List<Lead>();
//        for (Integer i=0; i < count; i++) {
//            Lead newLead = new Lead();
//            newLead.Website     = '/testPage-' + i;
//            newLead.Email       = 'testLeadTrigger-' + i + '@gmail.com';
//            newLead.LastName    = '[not provided]';
//
//            if (i==0) {
//                newLead.EmailOptIn__c = true;
//            }
//
//            newLeadsList.add(newLead);
//        }
//
//        // Wrong leads (without Email)
//        for (Integer i=0; i < countForWrongLeads; i++) {
//            Lead newLead = new Lead();
//            newLead.Website     = '/testPage-' + i;
//            newLead.LastName    = '[not provided]';
//
//            newLeadsList.add(newLead);
//        }
//
//        Test.startTest();
//            System.assertEquals(count + countForWrongLeads, newLeadsList.size());
//            insert newLeadsList;
//
//            List<Account> accList   = [SELECT Id FROM Account];
//            List<Lead> leadList     = [SELECT Id FROM Lead];
//
//            System.assertEquals(count,              accList.size());
//            System.assertEquals(countForWrongLeads, leadList.size());
//
//            List<Account> accListWithOptIn      = [SELECT Id FROM Account WHERE Email_Investment_Product__pc = TRUE];
//            List<Account> accListWithoutOptIn   = [SELECT Id FROM Account WHERE Email_Investment_Product__pc = FALSE];
//            System.assertEquals(1, accListWithOptIn.size());
//            System.assertEquals(count - 1, accListWithoutOptIn.size());
//        Test.stopTest();
//    }

}