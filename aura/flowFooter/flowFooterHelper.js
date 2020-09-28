({

    chooseButtonToDisplay : function(cmp, event, helper) {
        var availableActions = cmp.get("v.availableActions");
        for (var i = 0; i < availableActions.length; i++) {
            if (availableActions[i] === "PAUSE") {
                cmp.set("v.canPause", true);
            } else if (availableActions[i] === "BACK") {
                cmp.set("v.canBack", true);
            } else if (availableActions[i] === "NEXT") {
                cmp.set("v.canNext", true);
            } else if (availableActions[i] === "FINISH") {
                cmp.set("v.canFinish", true);
            }
        }
    },

    getSubject : function(cmp, event, helper) {
        var action = cmp.get("c.getCaseSubject");
        action.setParams({
            caseId : cmp.get("v.currentRecord")
        });
        console.log('teetetete');

        action.setCallback(this, function(response) {
            var res = response.getReturnValue();



            cmp.find("subjectId").set("v.value", res);
            cmp.set("v.caseSubject", res);
        });
        $A.enqueueAction(action);
    },
    deleteNutmailAttachment : function(cmp, event, helper) {
        let action = cmp.get("c.deleteNutmailAttachment");

        action.setParams({
            attachmentId :  cmp.get("v.attachmentId")
        });

        action.setCallback(this, function(response) {
            let res = response.getReturnValue();

            if (res !== 'SUCCESS') {
                let toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "ERROR",
                    "message": res
                });
                toastEvent.fire();
            } else {
                cmp.set("v.attachmentId",   null);
                cmp.set("v.attachmentName", null);
            }
        });
        $A.enqueueAction(action);
    },

    markAsNutmailAttachment : function(cmp, event, helper) {
        let action = cmp.get("c.markAsNutmailAttachment");

        action.setParams({
            attachmentId :  cmp.get("v.attachmentId")
        });

        action.setCallback(this, function(response) {
            let res = response.getReturnValue();

            if (res !== 'SUCCESS') {
                let toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "ERROR",
                    "message": res
                });
                toastEvent.fire();

                cmp.set("v.attachmentId",   null);
                cmp.set("v.attachmentName", null);
            }

            console.log(res);
        });
        $A.enqueueAction(action);
    },

    sendNutmailApi : function(cmp, event, helper, actionClicked) {
        let action = cmp.get("c.sendNutmailApi");
        let navigate        = cmp.get('v.navigateFlow')

        action.setParams({
            attachmentId :  cmp.get("v.attachmentId"),
            subject :       cmp.get("v.caseSubject"),
            emailBody :     cmp.get("v.emailBody"),
            caseId :     cmp.get("v.currentRecord")

        });

        action.setCallback(this, function(response) {
            let res = response.getReturnValue();

            console.log("Nutmail API response");
            console.log(res);

            if (res.status === 'FILE_DELETED') {
                let toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "ERROR",
                    "message": res.message,
                    "type":"error"
                });
                toastEvent.fire();

                cmp.set("v.attachmentId",   null);
                cmp.set("v.attachmentName", null);
            }

            if (res.status === 'ERROR') {
                let toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "ERROR",
                    "message": res.message,
                    "type":"error"

                });
                cmp.set("v.spinner", false); 

                toastEvent.fire();
            }

            if (res.status === 'SUCCESS') {
                let toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "SUCCESS",
                    "message": res.message,
                    "type":"success"
                });
                toastEvent.fire();
                cmp.set("v.attachmentId",   null);
                cmp.set("v.attachmentName", null);
                cmp.set("v.conversationId", res.conversationId);
                cmp.set("v.messageId", res.messageID);
                cmp.set("v.userUid", res.userId);
                navigate(actionClicked);

            }

        });
        $A.enqueueAction(action); 

    },
    /*updateEmailMessage : function(cmp, event, helper) {
        var action = cmp.get("c.updateEmailMessage");
        action.setParams({
            caseId : cmp.get("v.currentRecord"),
            msgId : cmp.get("v.messageId"),
            userUUId : cmp.get("v.userUid"),
            converstationId : cmp.get("v.conversationId")
        });
        $A.enqueueAction(action); 
        navigate(actionClicked);

    },*/

    getEmailTemplates : function(cmp, event, helper) {
        var action = cmp.get("c.getEmailTemplates");
        action.setParams({
            caseId : cmp.get("v.currentRecord")
        });
        console.log('ropdr ' ) ;
        action.setCallback(this, function(response) {
            var res = JSON.parse(response.getReturnValue());

            console.log(res.templates);
            console.log(res.templatesMap);

            cmp.set("v.isExistEmailTemplates",  (res.status === "SUCCESS"));
            cmp.set("v.emailTemplates",         res.templates);
            cmp.set("v.emailTemplatesMap",      res.templatesMap);
            cmp.set("v.emailTemplatesView",     res.templates);
            cmp.set("v.footerTemplate",         res.defaultTemplate);

            cmp.find("nutmailBody").set("v.value", res.defaultTemplate.emailBody);
        });
        $A.enqueueAction(action);
    },

    changeEmailBody : function(cmp, event, helper) {
        let items = cmp.get("v.items");
        let footerValue = cmp.get("v.footerTemplate").emailBody;
        let subjectValue = cmp.get("v.footerTemplate").emailSubject;

        let choosenTemplateId = $A.util.isEmpty(items)
            ? null
            : cmp.get("v.items")[0].name;

            let emailBodyValue = choosenTemplateId
            ? (cmp.get("v.emailTemplatesMap")[choosenTemplateId].emailBody + '\r\n\r\n' )
            : footerValue;

            let emailTemplateSubject = choosenTemplateId
            ? (cmp.get("v.emailTemplatesMap")[choosenTemplateId].emailSubject  )
            : '';

        //let emailTemplateSubject = cmp.get("v.emailTemplatesMap")[choosenTemplateId].emailSubject
        cmp.find("subjectId").set("v.value", emailTemplateSubject);
        cmp.set("v.caseSubject", emailTemplateSubject);
        cmp.find("nutmailBody").set("v.value", emailBodyValue);
        cmp.set("v.emailBody", emailBodyValue);
        if(emailTemplateSubject == '' || emailTemplateSubject ==null){
            let button = cmp.find('NEXT');
            button.set('v.disabled',true);
        }else{
            let button = cmp.find('NEXT');
            button.set('v.disabled',false);
        }

    }

})