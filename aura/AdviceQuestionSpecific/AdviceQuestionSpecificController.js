({

    doInit: function (component, event, helper) {
        let aList = [];

        aList.push({
            "label" : "test1",
            "answer" : "test1 answer"
        });

        aList.push({
            "label" : "test2",
            "answer" : "test2 answer",
            "init" : [{
                "label" : "test3",
                "answer" : "test3 answer"
            }, {
                "label" : "test4",
                "answer" : "test4 answer"
            }]
        });

        aList.push({
            "label" : "test5",
            "answer" : "test5 answer"
        });

        aList.push({
            "label" : "test6",
            "answer" : "test6 answer",
            "init" : [{
                "label" : "test7",
                "answer" : "test7 answer"
            }, {
                "label" : "test8",
                "answer" : "test8 answer"
            }]
        });

        component.set("v.answers", aList);
    }

});