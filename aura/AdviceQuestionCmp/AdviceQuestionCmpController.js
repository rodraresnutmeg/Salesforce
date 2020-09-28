({

    doInit: function (component, event, helper) {
        let questionData = component.get("v.questionData");

        if (questionData.answerOriginal !== undefined && !component.get("v.isOrigin") && component.get("v.isReviewMode")) {
            helper.isAnswerChanged(component, event, helper);
        }

        let options = [];

        if (questionData.type === 'Country') {
            options = component.get("v.mainCmp").get("v.countriesList");
            component.set("v.picklistOptions", options);
        }

        if (questionData.type === 'Date') {
            var year = new Date().getFullYear();

            if (questionData.defaultOptions) {
                for (let defOption in questionData.defaultOptions) {
                    options.push(questionData.defaultOptions[defOption]);
                }
            }

            if (questionData.subtype === 'Month') {
                for (let i=1; i <= 12; i++) {
                    options.push(i);
                }
            }

            if (questionData.subtype === 'Year/Future') {
                for (let i=0; i <= 100; i++) {
                    options.push(year);
                    year++;
                }
            }

            if (questionData.subtype === 'Year/Past') {
                for (let i=0; i <= 50; i++) {
                    options.push(year);
                    year--;
                }
            }

            if (questionData.subtype === 'Age') {
                for (let i=0; i <= 100; i++) {
                    options.push(i);
                }
            }

            component.set("v.picklistOptions", options);
        }
    },

    dateChanged: function (component, event, helper) {
        component.set("v.questionAnswer", event.getSource().get('v.value'));
    },

    addAnswer: function (component, event, helper) {
        var questionData = component.get("v.questionData");
        var innerAnswers = questionData.innerAnswers;
        var answer = [];

        // TODO questionData.innerQuestions move to some small var
        for (let question in questionData.innerQuestions) {
            let q = questionData.innerQuestions[question];

            if (q.hasDependent && q.dependentQuestionsCondition === q.answer) {
                let dependAnswers = [];
                dependAnswers.push(q.answer);

                for (let dependQuestion in q.dependentQuestions) {
                    dependAnswers.push(q.dependentQuestions[dependQuestion].answer);
                    q.dependentQuestions[dependQuestion].answer = "";
                }

                answer.push(dependAnswers);
            } else if (q.innerQuestions) {
                console.log('HAS INNER QUESTIONS');

                let innerAnswers = [];
                // dependAnswers.push(q.answer);

                for (let innerQuestion in q.innerQuestions) {
                    innerAnswers.push(q.innerQuestions[innerQuestion].answer);
                    q.innerQuestions[innerQuestion].answer = "";
                }

                answer.push(innerAnswers);
            } else {
                // answer.push(q.label);
                answer.push(q.answer);
            }

            q.answer = "";
        }

        console.log(answer);
        innerAnswers.push(answer);

        component.set("v.questionData", questionData);

        // console.log(555555555);
        // console.log(innerAnswers);
        // console.log(JSON.parse(JSON.stringify(component.get("v.questionData"))));
    },

    handleDateChange: function (component, event, helper) {
        // console.log('HANDLE DATE CHANGE');
        let a       = component.get("v.questionData");
        let day     = a.day;
        let month   = a.month;
        let year    = a.year;

        if ($A.util.isEmpty(day) || $A.util.isEmpty(month) || $A.util.isEmpty(year) || (!$A.util.isEmpty(year) && year.length < 4)) {
            component.set("v.isValid", true);
            return;
        }

        let answer = year + '-' + month + '-' + day;
        let bdCmp = component.find('birthday');
        bdCmp.set("v.value", answer);
        component.set("v.isValid", bdCmp.checkValidity());
    },

    handleAnswerChange: function (component, event, helper) {
        let questionData = component.get("v.questionData");

        if (questionData) {
            if (component.get("v.isReviewMode") && !component.get("v.mainCmp").get("v.loader")) {
                if (questionData.answerOriginal === undefined) {
                    // console.log('+++ add answerOriginal');
                    // console.log('=======================');
                    // console.log(questionData.label);
                    // console.log(component.get("v.mainCmp").get("v.loader"));
                    // console.log(event.getParam("oldValue"));

                    questionData.answerOriginal = event.getParam("oldValue");
                    helper.isAnswerChanged(component, event, helper);
                } else if (questionData.answerOriginal === questionData.answer) {
                    // console.log('--- delete answerOriginal');

                    questionData.answerOriginal = undefined;
                    helper.isAnswerChanged(component, event, helper);
                }
            } else {
                // console.log("REVIEW MODE FALSE");
            }
        } else {
            // console.log("--- COMPONENT is null");
        }
        // console.log('============');
    }
});