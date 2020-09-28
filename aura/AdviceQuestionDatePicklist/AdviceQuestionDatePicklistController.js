({

    doInit: function (component, event, helper) {
        let dayList     = [];
        let monthList   = [];
        let yearList    = [];

        for (let i=1; i <= 31; i++) {
            dayList.push(i);
        }

        for (let i=1; i <= 12; i++) {
            monthList.push(i);
        }

        let year = new Date().getFullYear();
        for (let i=0; i <= 100; i++) {
            yearList.push(year);
            year--;
        }

        component.set("v.dayList",      dayList);
        component.set("v.monthList",    monthList);
        component.set("v.yearList",     yearList);
    },

    handleDateChange: function (component, event, helper) {
        let day     = +component.get("v.day");
        let month   = +component.get("v.month");
        let year    = +component.get("v.year");

        let isLeapYear = true;
        if (year !== 0) {
            isLeapYear = (year % 4 === 0 && year % 100 !== 0) || year % 400 === 0;
        }

        let month28_29days = 2;
        let month30days = [4, 6, 9, 11];

        let dayList = [];
        let makeDay0 = false;

        if (month28_29days === month) {
            if (day > (isLeapYear ? 29 : 28)) { makeDay0 = true }

            for (let i=1; i <= (isLeapYear ? 29 : 28); i++) {
                dayList.push(i);
            }
        } else if (month30days.includes(month)) {
            if (day > 30) { makeDay0 = true }

            for (let i=1; i <= 30; i++) {
                dayList.push(i);
            }
        } else {
            for (let i=1; i <= 31; i++) {
                dayList.push(i);
            }
        }

        if (makeDay0) { component.set("v.day", ""); }
        component.set("v.dayList", dayList);

        if (day !== 0 && month !== 0 && year !== 0) {
            component.set("v.questionData.answer", year + '-' + month + '-' + day);
        } else {
            component.set("v.questionData.answer", "");
        }

    }

});