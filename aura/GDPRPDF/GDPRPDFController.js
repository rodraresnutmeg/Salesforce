({
	openWizardModal : function(component, event, helper) {
		component.set("v.isWizardOpen", true);
	},
    closeWizardModal : function(component, event, helper) {
       helper.closeModal(component, event, helper);
    },
    pdfSendingProcess : function(component, event, helper) {
        helper.sendEmail(component, event, helper);
    },
    exportToExcel : function(component, event, helper) {
        component.set("v.isExportExcel", true);
    },
    closeExportToExcel : function(component, event, helper) {
        component.set("v.isExportExcel", false);
    }
})