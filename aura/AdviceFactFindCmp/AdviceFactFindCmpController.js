({
    doInit: function (component, event, helper) {
        helper.getQuestions(component, event, helper);
        console.log('DO INIT');
    },

    handleStep: function (component, event, helper) {
        /*TODO optimise*/
        component.set("v.loader", true);

        if (!component.get("v.isReviewMode")) {
            component.set("v.isPrepage", true);
        }

        component.set("v.prepage",      component.get("v.allQuestions").prepages[component.get("v.step")]);
        component.set("v.questions",    component.get("v.allQuestions").questions[component.get("v.step")]);
        component.set("v.loader",       false);
    },

    saveEditToggle: function (component, event, helper) {
        if (component.get("v.isReviewMode")) {
            component.set("v.isReadMode", !component.get("v.isReadMode"))
        }
    },

    nextPrepage: function (component, event, helper) {
        if (!component.get("v.isReviewMode")) {
            component.set("v.isPrepage", false);
        }
    },

    backStep: function (component, event, helper) {
        component.set("v.loader", true);
        let step = component.get("v.step");
        step--;
        component.set("v.step", step);
        window.scrollTo(0, 0);

        component.set("v.loader", false);
    },

    nextStep: function (component, event, helper) {
        component.set("v.loader", true);
        let step = component.get("v.step");
        step++;
        component.set("v.step", step);
        window.scrollTo(0, 0);

        component.set("v.loader", false);
    },

    sendAnswers: function (component, event, helper) {
        // var answersJSON = JSON.stringify(component.get("v.allQuestions").questions);
        var answersJSON = JSON.stringify(component.get("v.allQuestions"));
        console.log(answersJSON);

        var action = component.get("c.saveAnswers");
        action.setParams({
            answersJSON:    answersJSON,
            recordId:       component.get("v.answerId"),
            caseId:         component.get("v.caseId")
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log("+++++++++++++++++++");
            console.log(state);
            if (state === "SUCCESS") {
                if (component.get("v.isReviewMode")) {
                    component.set("v.isReadMode", !component.get("v.isReadMode"))
                } else {
                    component.set("v.isSubmitted", true);
                }
            } else if (state === "ERROR") {
                alert("Error: " + response.getError());
                console.log(response.getError());
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });

        $A.enqueueAction(action);
    }

});