public with sharing class CaseHandler {
    
    public static void afterInsert(Set<id> casesId) {
        List<String> casesOrigin = new List<String>{'Web','Email'};
        List<SLA_Metrics__c> metricsToInser = new List<SLA_Metrics__c>();
        List<SLA_Metrics__c> metricsEmailToInsert = new List<SLA_Metrics__c>();
        List<Case> casesInserted = new List<Case> ();
        Set<Id> emailIds = new Set<Id>();
        casesInserted = [select id, Origin, createdDate  from Case where id in:casesId ];

        // si es email , queriar email message para ver si fue support support? 
        for(Case c :casesInserted ){
            if(casesOrigin.contains(c.origin) ){
                SLA_Metrics__c sla = new SLA_Metrics__c(
                User__c = Userinfo.getuserid(),
                Case__c =  c.id ,
                Type__c = c.origin,
                Received_date__c = System.now(),
                Outbound__c = false);
                metricsToInser.add(sla);
            }else if(c.origin == 'Email'){
                emailIds.add(c.id);
            }
        }
        if(emailIds.size() > 0){
            metricsEmailToInsert = addSLAforEmailSupporToSupport(emailIds);
        }

        if(!metricsEmailToInsert.isEmpty()){
            metricsToInser.addAll(metricsEmailToInsert);
        }
        if(!metricsToInser.isEmpty()){
            insert metricsToInser;
        }
    }
    /**
     * if it is email the origin,  check if the case was created for a support to support email. 
     */
    public static List<SLA_Metrics__c> addSLAforEmailSupporToSupport(Set<id> casesId){
        List<SLA_Metrics__c> toCreate = new List<SLA_Metrics__c>();
        List<EmailMessage>emails = [select id, fromAddress, toAddress From EmailMessage where parentId in: casesId];
        for(EmailMessage e : emails){
            if(e.fromAddress == 'support@nutmeg.com' && e.toAddress == 'support@nutmeg.com'){
                SLA_Metrics__c m = new SLA_Metrics__c();
                m.User__c= Userinfo.getuserid();
                m.Case__c = e.parentId;
                m.Type__c = 'MAIL';
                m.Received_date__c = System.now();
                toCreate.add(m);
            }
        }
        return toCreate;
    }
    
}