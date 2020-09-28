({

    doInit: function (component, event, helper) {
        let text = 'We’re going to ask you a series of questions about you and your financial situation so we can make sure we tailor our advice to your circumstance. There are five sections in total, and the whole survey should take around 10 minutes to complete.\n\n' +
            'We’ll need to collect personal and financial data, some of which will be information regarding your health and lifestyle. All information will be treated in accordance with our privacy policy. We are required to obtain your explicit consent to record this data, without which we will be unable to proceed with the financial advice service. By consenting you are also agreeing to our privacy policy. Do we have your consent?\n\n' +
            'Please be assured that we won’t use the data we collect here for anything other than giving you personalised advice service.\n\n';
        component.set("v.text", text);
    },

    start: function (component, event, helper) {
        if (component.get("v.isConsent")) {
            component.set("v.isStarted", true);
        }
    }

});