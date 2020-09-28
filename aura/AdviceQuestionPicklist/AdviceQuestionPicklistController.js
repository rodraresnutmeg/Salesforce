({
    chooseOption: function (component, event, helper) {
        if (!component.get("v.isReadMode")) {
            component.set("v.answer", component.get("v.option"));
        }
    }
});