public class LinkTaskToCaseController {
    
    public String caseId {get;set;}
    
    public LinkTaskToCaseController() {
        this.caseId = ApexPages.currentPage().getParameters().get('Id');
    }
    
    public PageReference LinkTask() {
    	Case currentCase = [SELECT Id, AccountId, ContactId FROM Case WHERE Id = :this.caseId];
        System.debug('Case Id: ' + this.caseId);
        
        List<Task> caseTasksList = [SELECT Id, WhoId, Subject, WhatId, CreatedDate 
                                    FROM Task 
                                    WHERE Type='Call' 
                                    AND (WhatId = :currentCase.AccountId 
                                         OR WhatId = :currentCase.ContactId) 
                                    Order By CreatedDate DESC];
        
        if (!caseTasksList.isEmpty()) {
            System.debug('Task: ' + caseTasksList[0]);
            caseTasksList[0].WhoId = currentCase.ContactId;
            caseTasksList[0].WhatId = currentCase.Id;
            update caseTasksList[0];
        }
        PageReference pr = new PageReference('/'+this.caseId);
        pr.setRedirect(true);
        return pr;

    }
}