({

    init : function(cmp, event, helper) {
        helper.chooseButtonToDisplay(cmp, event, helper);
        helper.getEmailTemplates(cmp, event, helper);
        helper.getSubject(cmp, event, helper);
    },

    handleUploadFinished: function (cmp, event, helper) {
        let uploadedFiles = event.getParam("files");

        uploadedFiles.forEach(file => {
            cmp.set("v.attachmentId",   file.documentId);
            cmp.set("v.attachmentName", file.name);

            helper.markAsNutmailAttachment(cmp, event, helper);
        });
    },

    onRemoveAttachment: function (cmp, event, helper) {
        helper.deleteNutmailAttachment(cmp, event, helper);
    },

    onButtonPressed: function(cmp, event, helper) {

        cmp.set("v.emailBody", cmp.find("nutmailBody").get("v.value"));
        cmp.set("v.caseSubject", cmp.find("subjectId").get("v.value"));

        let actionClicked   = event.getSource().getLocalId();
        let navigate        = cmp.get('v.navigateFlow')
        let attachmentId    = cmp.get("v.attachmentId");

        if (actionClicked === "NEXT" && attachmentId != null) {
            
            cmp.set("v.spinner", true); 

            helper.sendNutmailApi(cmp, event, helper, actionClicked);

           // navigate(actionClicked);

            console.log('rodrigo aca');
        } else {
            navigate(actionClicked);

        }

    },

    onPicklistChange:  function(cmp, event, helper) {
        let targetId = event.currentTarget.id;

        if (targetId !== null) {
            let currentEmailTemplate = {
                label : cmp.get("v.emailTemplatesMap")[targetId].emailTemplateName,
                name  : targetId
            }

            cmp.set("v.items",          currentEmailTemplate);
            cmp.set("v.searchValue",    null);

            helper.changeEmailBody(cmp, event, helper);
        }
    },

    handleSearch:  function(cmp, event, helper) {
        let searchValue = cmp.get("v.searchValue").toLowerCase();

        let filtredList = [];
        let emailTemplatesList = cmp.get("v.emailTemplates");

        for (const emailTemplatesListKey in emailTemplatesList) {
            let emailItem = emailTemplatesList[emailTemplatesListKey];

            if (emailItem.emailTemplateName.toLowerCase().indexOf(searchValue) !== -1) {
                filtredList.push(emailTemplatesList[emailTemplatesListKey]);
            }
        }

        cmp.set("v.emailTemplatesView", filtredList);
    },
 
    handleItemRemove: function (cmp, event, helper) {
        var items = cmp.get('v.items');
        var item = event.getParam("index");
        items.splice(item, 1);
        cmp.set('v.items', items);

        helper.changeEmailBody(cmp, event, helper);
    },

    handleSubject: function (cmp, event, helper) {
        var subjectValue = cmp.find("subjectId").get("v.value");
        if(subjectValue == '' || subjectValue ==null){
            let button = cmp.find('NEXT');
            button.set('v.disabled',true);
        }else{
            let button = cmp.find('NEXT');
            button.set('v.disabled',false);
        }

    },

    onBlurEmailTemplateInput: function (cmp, event, helper) {
        setTimeout(cmp.set, 300, 'v.showEmailTemplateList', false);
    },

    onFocusEmailTemplateInput: function (cmp, event) {
        cmp.set('v.showEmailTemplateList', true);
    }

})
 