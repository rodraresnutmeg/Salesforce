({

    changeStep: function (component, event, helper) {
        component.set("v.currentStep", component.get("v.stepIndex"));
    },

    handleCurrentStep: function (component, event, helper) {
        component.set("v.svg", false);
        var currentStep = +component.get("v.currentStep");
        var index       = +component.get("v.stepIndex");

        if (currentStep === index) {
            component.set("v.status", 's2');
        }

        if (currentStep < index) {
            component.set("v.status", 's1');
        }

        if (currentStep < index) {
            component.set("v.status", 's3');
        }

        component.set("v.svg", true);
    }

});