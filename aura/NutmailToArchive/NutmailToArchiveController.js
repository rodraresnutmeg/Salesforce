({
    doInit : function(component, event, helper) {
        var currentURL =  window.location.href,
            recordId = component.get("v.recordId") ? component.get("v.recordId") : currentURL.substr(currentURL.length - 23, 18);

        helper.setFormVisibility(component, currentURL);
        helper.getEmailMessages(component, recordId);
    },

    hideNutmail : function(component, event, helper) {
        helper.hideNutmail(component);
    },

    onchangeMessageId : function(component, event, helper) {
        var selectedValue = component.find("messageId").get("v.value");
        helper.setSelectValues(component, selectedValue);
    },

    onchangeSubject : function(component, event, helper) {
        var selectedValue = component.find("subject").get("v.value");
        helper.setSelectValues(component, selectedValue);
    }
})