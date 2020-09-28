trigger UpdateCaseTask on Task (before insert) {

/*String caseKeyPrefix = Case.sObjectType.getDescribe().getKeyPrefix();


    Set<Id> caseIds = new Set<Id>();
    
    for (Task t: Trigger.new)     {
     
     if (t.WhatId != null) { 
             String taskWhatId = t.WhatId;
                
                 if (taskWhatId.startsWith(caseKeyPrefix ) ) {
                        caseIds.add(t.WhatId);
                 }
            
            }
            
     } //end first loop
     
     //Now search for Cases
     Map<Id, Id> ConCaseMap = new Map<Id, Id> ();
     
     for (Case c: [Select Id, ContactId from Case where Id in :caseIds]) {
     
             if (c.ContactId != null ) {
             ConCaseMap.put(c.Id, c.ContactId);
             } 
     }

//Now Loop again and update Contact
  for (Task t: Trigger.new)     {
     
     if (t.WhatId != null) { 
              if (ConCaseMap.containsKey(t.WhatId) ) {
              t.WhoId = ConCaseMap.get(t.WhatId);
              }
          }
          
    }*/
    
    } //end trigger