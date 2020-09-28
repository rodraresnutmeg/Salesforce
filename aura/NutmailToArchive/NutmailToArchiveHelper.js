({
    getEmailMessages : function(component, recordId) {
        var action = component.get("c.getEmailMessages");
        action.setParams({ recordId : recordId });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if (response.getReturnValue().length > 0) {
                    component.set("v.errorMessage", undefined);
                    component.set("v.emailMessages", response.getReturnValue());
                    component.set("v.emailMessageTextBody", response.getReturnValue()[0].TextBody);
                } else {
                    component.set("v.errorMessage", "No appropriate records found. Please, contact your system administrator.");
                    component.set("v.emailMessages", undefined);
                }                
            } else if (state === "ERROR") {
                component.set("v.emailMessages", undefined);

                var errors = response.getError();
                if (errors[0] && errors[0].message) {
                    component.set("v.errorMessage", errors[0].message);
                } else {
                    component.set("v.errorMessage", "Unknown error. Please, contact your system administrator.");
                }
            }
        });
        $A.enqueueAction(action);
    },

    setFormVisibility : function(component, currentURL) {
        var currentURLWOId = currentURL.substr(0, currentURL.length - 24),
            sobjType = currentURLWOId.substr(currentURLWOId.lastIndexOf("/") + 1);
        component.set("v.isEmailMessageObjType", (sobjType === "EmailMessage"));
    },

    setSelectValues : function(component, selectedValue) {
        var selectedObject = {};

        component.get("v.emailMessages").forEach(element => {
            if (element.MessageID__c === selectedValue) {
                selectedObject = element;
            }
        });

        console.log(selectedObject);
        component.find("subject").set("v.value", selectedObject.MessageID__c);
        component.find("messageId").set("v.value", selectedObject.MessageID__c);
        component.set("v.emailMessageTextBody", selectedObject.TextBody);
    },

    hideNutmail : function(component) {
        var action = component.get("c.hideMessage"),
            message = component.find("messageId").get("v.value");
        action.setParams({ messageId : message });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = JSON.parse(response.getReturnValue());
                if (res.StatusCode == 200) {
                    alert("SUCCESS! Message " + message + " was hidden.");
                    $A.get("e.force:closeQuickAction").fire();
                } else {
                    component.set("v.errorMessage", "HTTP ERROR. " + res.StatusCode + ": " + res.Status + ". Please, contact your system administrator.");
                    component.set("v.emailMessages", undefined);
                }
            } else if (state === "ERROR") {
                component.set("v.emailMessages", undefined);

                var errors = response.getError();
                if (errors[0] && errors[0].message) {
                    component.set("v.errorMessage", errors[0].message);
                } else {
                    component.set("v.errorMessage", "Unknown error. Please, contact your system administrator.");
                }
            }
        });
        $A.enqueueAction(action);
    }
})