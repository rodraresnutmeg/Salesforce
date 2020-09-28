({
	closeModal : function(component, event, helper) {
    	component.set("v.isWizardOpen", false);
	},
    sendEmail : function(component, event, helper) {
        var action = component.get("c.send");
        action.setParams({ recordId : component.get("v.recordId") });

        action.setCallback(this, function(response) {
            console.log(response);
            component.set("v.isWizardOpen", false);
        });
        $A.enqueueAction(action);
    }
})