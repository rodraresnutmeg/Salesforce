({

    doInit: function (component, event, helper) {
        var action = component.get("c.getAnswers");

        action.setParams({
            answersId: component.get("v.recordId")
        });
        console.log(888);
        console.log(component.get("v.recordId"));

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                let answers = JSON.parse(response.getReturnValue());
                console.log(answers);

                component.set("v.allQuestions", answers);
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                            errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });

        $A.enqueueAction(action);
    }

});