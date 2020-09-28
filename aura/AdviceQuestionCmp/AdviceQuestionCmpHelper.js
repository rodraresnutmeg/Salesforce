({

    isAnswerChanged: function (component, event, helper) {
        let questionData = component.get("v.questionData");
        component.set("v.isAnswerChanged", questionData.answerOriginal !== undefined);
    }

});