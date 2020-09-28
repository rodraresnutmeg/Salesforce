public class TaskHandler {
    public static void afterUpdate(Map<id, Task> oldTask , List<Task> newTask) {
       // List<Task> tasks = [Select id , Type from Task where id in:taskIds];
        List<SLA_Metrics__c> metrics = new List<SLA_Metrics__c> ();
        set<String> callIdentifier = new set<String> ();
       
        for(Task t :newTask ){
                if(t.Type == 'Call' || t.Task_type__c == 'Call'){
                    
                    if(oldTask.get(t.id).whatId == null  && t.whatId != null &&  t.WhatId.getSobjectType() == Schema.Case.SObjectType){
                        SLA_Metrics__c sla = new SLA_Metrics__c(
                            User__c = Userinfo.getuserid(),
                            Case__c = t.whatId,
                            Type__c = 'Call');
                            if(t.CallType == 'Outbound' || t.CallTypeCopy__c == 'Outbound'){
                                sla.Outbound__c =true;
                                sla.Response_date__c = t.createdDate;
                            }else if(t.CallType == 'Inbound' || t.CallTypeCopy__c == 'Inbound'){
                                sla.Outbound__c =false;
                                sla.Received_date__c = t.createdDate; 
                            }
                            metrics.add(sla);
                    }
                    
                }
                
               
        }
        if(!metrics.isEmpty()){
            insert metrics;
        }
    }
    public static void afterInsert(Set<id> taskIds) {
       List<Task> tasks = [Select id , Type, CallObject , CallTypeCopy__c , WhatId, What.type, CallType, Task_Type__c , CreatedDate from Task where id in:taskIds];
       List<SLA_Metrics__c> metricsToInser = new List<SLA_Metrics__c>();


        for(Task t  :tasks ){
            if((t.Type == 'Call' || t.Task_Type__c == 'Call' )&& t.WhatId != null  &&  t.WhatId.getSobjectType() == Schema.Case.SObjectType){
                SLA_Metrics__c sla = new SLA_Metrics__c(
                User__c = Userinfo.getuserid(),
                Case__c = t.WhatId,
                Type__c = 'Call');
                if(t.CallType == 'Outbound' || t.CallTypeCopy__c == 'Outbound'){
                    sla.Outbound__c =true;
                    sla.Response_date__c = t.createdDate;
                }else if(t.CallType == 'Inbound' || t.CallTypeCopy__c == 'Inbound'){
                    sla.Outbound__c =false;
                    sla.Received_date__c = t.createdDate;
                }
                metricsToInser.add(sla);
            }
        }
       
        if(!metricsToInser.isEmpty()){
            insert metricsToInser;
        }
        updateWhoId(taskIds);
    }
    @future
    public static void updateWhoId(Set<id> taskIds) {
        set<id> casesId = new set<id> ();
        set<id> accountsId = new set<id> ();
        map<id,id> taskToContact = new map<id,id>();
        map<id,id> caseToTask = new map<id,id>();
        map<id,id> accountTotask = new map<id,id>();
        List<Case> cases = new  List<Case>();
        List<Contact> contacts = new  List<Contact>();
        List<Task> taskToUpdate = new  List<Task> ();
        List<Task> tasks = new  List<Task> ();
        tasks = [Select id, whatId, WhoId From Task where id in:taskIds limit 10000];
         for(Task t  :tasks ){
            if(t.WhatId != null && t.WhatId.getSobjectType() == Schema.Case.SObjectType){
                casesId.add(t.WhatId);
                caseToTask.put(t.WhatId,t.id);
            }else if (t.WhatId != null && t.WhatId.getSobjectType() == Schema.Account.SObjectType){
                accountsId.add(t.WhatId);
                accountTotask.put(t.WhatId,t.id);
            }

         }
         if(!casesId.isEmpty()){
            cases = [Select id,ContactId  from Case where id in:casesId ];
            for(Case c : cases){
                if(c.ContactId != null){
                    if(caseToTask.get(c.id) != null){
                        taskToContact.put(caseToTask.get(c.id),c.ContactId);
                    }
                }
            }

        }
        if(!accountsId.isEmpty()){
            contacts= [Select id,AccountId  from Contact where AccountId in:accountsId ];
            for(Contact ct : contacts){
                if(accountTotask.get(ct.AccountId) != null){
                    taskToContact.put(accountTotask.get(ct.AccountId),ct.id);
                }

            }
        }

        for(Task tnew  :tasks ){
            if(taskToContact.get(tnew.id) != null){
                tnew.whoId = Id.valueOf(taskToContact.get(tnew.id));

                taskToUpdate.add(tnew);
            }

        }
        if(!taskToUpdate.isEmpty()){

            update taskToUpdate;
        }
        
        
     }

     public static void beforeUpdate(Map<id, Task> oldTask , List<Task> newTask ) {
        set<id> casesId = new set<id> ();
        set<id> accountsId = new set<id> ();
        map<id,id> taskToContact = new map<id,id>();
        map<id,id> caseToTask = new map<id,id>();
        map<id,id> accountTotask = new map<id,id>();
        List<Case> cases = new  List<Case>();
        List<Contact> contacts = new  List<Contact>();
        set<id> taskToupdate = new set<Id>();

         for(Task t  :newTask ){
            if( t.whatId != null &&  oldTask.get(t.id).whatId == null && t.WhatId.getSobjectType() == Schema.Case.SObjectType){

                casesId.add(t.WhatId);
                caseToTask.put(t.WhatId,t.id);
            }else if (t.whatId != null  && oldTask.get(t.id).whatId == null &&  t.WhatId.getSobjectType() == Schema.Account.SObjectType){

                accountsId.add(t.WhatId);
                accountTotask.put(t.WhatId,t.id);
            }

         }
         if(!casesId.isEmpty()){
            cases = [Select id,ContactId  from Case where id in:casesId ];

            for(Case c : cases){
                if(c.ContactId != null){

                    if(caseToTask.get(c.id) != null){
                        taskToContact.put(caseToTask.get(c.id),c.ContactId);
                    }
                }
            }

        }
        if(!accountsId.isEmpty()){

            contacts= [Select id,AccountId  from Contact where AccountId in:accountsId ];

            for(Contact ct : contacts){
                if(accountTotask.get(ct.AccountId) != null){
                    taskToContact.put(accountTotask.get(ct.AccountId),ct.id);
                }

            }
        }

        for(Task tnew  :newTask ){
            if(taskToContact.get(tnew.id) != null){
                taskToupdate.add(tnew.id);
            }

         }
         if(!taskToupdate.isEmpty()){
            updateWhoId(taskToupdate);
         }
        
      
     }
 
        
 
  /* public static void afterInsert(List<Task> triggerNew) {
        linkCaseToCall(triggerNew);
        
    }
    
    /*
     * Method to link a Call Task to a Call Case based on time between task.Subject and Case.CreatedDate
     
    private static void linkCaseToCall(List<Task> triggerNew) {
        List<Task> tasksToProcess = new List<Task>();
        
        for (Task task : triggerNew) {
            if (task.Type == 'Call') {
                tasksToProcess.add(task);
            }
        }
        
        // Map to store all accounts with their tasks and datetime to compare with Case creation
        
        Map<String,Map<Id,Datetime>> accountIdWithTaskDateTimeMap = new Map<String,Map<Id,Datetime>>();
        for (Task task : tasksToProcess) {
            Datetime taskDateTime = convertStringToDateTime(task.Subject);
            if (!accountIdWithTaskDateTimeMap.containsKey(task.WhatId)) {
                accountIdWithTaskDateTimeMap.put(task.WhatId, new Map<Id,Datetime>());
            }
            accountIdWithTaskDateTimeMap.get(task.WhatId).put(task.Id,taskDateTime);
        }
        System.debug('Map: ' + accountIdWithTaskDateTimeMap);
        
        // Filtering and matching Case to Task
        for (Case caseItem : [SELECT Id, Status, Subject, Type, CreatedDate FROM Case WHERE AccountId IN :accountIdWithTaskDateTimeMap.keySet() AND Origin = 'Phone']) {
            for (String accId : accountIdWithTaskDateTimeMap.keySet()) {
                for (Id taskId : accountIdWithTaskDateTimeMap.get(accId).keySet()) {
                    if (caseItem.CreatedDate.addMinutes(-5) <= accountIdWithTaskDateTimeMap.get(accId).get(taskId) && accountIdWithTaskDateTimeMap.get(accId).get(taskId) <= caseItem.CreatedDate.addMinutes(5)) {
                        
                    }
                }
            } -
        }
    }
    
    /*
     * Method to convert the Task DateTime String into a DateTime
     
    private static DateTime convertStringToDateTime(String dateString) {
        List<String> splitStringsList = dateString.split(' ');
        List<String> splitDateStringList = splitStringsList[1].split('/');
        List<String> splitTimeStringList = splitStringsList[2].split(':');
        
        //Creating date section of string YYYY-MM-dd
        String newDateString = splitDateStringList[2] + '-' + splitDateStringList[0] + '-' + splitDateStringList[1] + ' ';
        //Creating time section of string in 24hrr format
        newDateString += splitStringsList[3] == 'am'? splitTimeStringList[0] + ':' + splitTimeStringList[1] + ':00' : Integer.valueOf(splitTimeStringList[0]) + 12 + ':' + splitTimeStringList[1] + ':00';

        Datetime newDateTime = getLocalDateTime(Datetime.valueOf(newDateString));
        
        return newDateTime;
    }
    
    /*
     * Method to set Local time zone to DateTime
     
    private static Datetime getLocalDateTime(Datetime convertDate) {    
        Datetime loc = convertDate.Date();
        loc = loc.addHours(convertDate.hour());
        loc = loc.addMinutes(convertDate.minute());
        loc = loc.addSeconds(convertDate.second());
        
        return loc;
    }*/
}