({

    getCountriesList: function (component, event, helper) {
        component.set("v.loader", true);
        var action = component.get("c.getCountries");

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('GET COUNTRIES LIST');
                var filtered = response.getReturnValue().filter(function(value, index, arr){
                    return value !== 'Great Britain';
                });
                console.log(filtered);

                component.set("v.countriesList", filtered);

                component.set("v.loader", false);
            }
            else if (state === "ERROR") {
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
    },

    getQuestions: function (component, event, helper) {
        helper.getCountriesList(component, event, helper);

        if (component.get("v.allQuestions") === null) {
            var q = {
                prepages: {
                    0: {
                        title: "Personal Details",
                        text: 'We’re going to start by asking for some personal details, and about your motivations for seeking financial advice. Let’s get started.\n'
                        // text: 'We’re going to ask you a series of questions about you and your financial situation so we can make sure we tailor our advice to your circumstance. There are five sections in total, and the whole survey should take around 10 minutes to complete.\n\n' +
                        //     'Please be assured that we won’t use the data we collect here for anything other than giving you personalised advice service.\n\n' +
                        //     'We’re going to start by asking for some personal details, and about your motivations for seeking financial advice. Let’s get started.\n'
                    },

                    1: {
                        title: "Assets & Debts",
                        text: 'We’d like to understand more about your assets and any debt you hold. We’re going to break these areas down into different asset and debt types, and we’d like you to specify the value you hold in pounds (£) and pence.'
                    },

                    2: {
                        title: "Your income",
                        text: 'Now, we’d like to get an understanding of your income on an annual basis, and your outgoings on a monthly basis. Please provide an approximate value in (£) pounds as applicable.',
                    },

                    3: {
                        title: "Your expenses",
                        text: 'Now, let’s look at your average monthly expenditure. Please provide an approximate value in (£) pounds as applicable.'
                    },

                    4: {
                        title: " Your investments",
                        text: 'We’re now going to find out a bit more about your experience with investing and your tolerance for taking risk with your money.'
                    },

                    5: {
                        title: "Your goals",
                        text: 'In this final section, we’d like to understand your financial goals, where you are on the path to retirement, and a few extra bits of information that will help give us context on your finances.'
                    }
                },
                lastPageIndex: 5,
                questions: {
                    0: [
                        {
                            label: "What’s your name?",
                            type: "Specific",
                            position: 1,
                            isComplex: true,
                            isMultiple: false,
                            innerQuestions: [
                                {
                                    label: "First",
                                    type: "Text",
                                    position: 1,
                                    answer: ""
                                },
                                {
                                    label: "Last",
                                    type: "Text",
                                    position: 2,
                                    answer: ""
                                }
                            ],
                            innerAnswers: [],
                            answer: ""
                        },
                        {
                            label: "Address",
                            type: "Specific",
                            position: 3,
                            isComplex: true,
                            isMultiple: false,
                            innerQuestions: [
                                {
                                    label: "Street",
                                    type: "Text",
                                    position: 1,
                                    answer: ""
                                },
                                {
                                    label: "City",
                                    type: "Text",
                                    position: 2,
                                    answer: ""
                                },
                                {
                                    label: "Postal Code",
                                    type: "Text",
                                    position: 3,
                                    answer: ""
                                },
                                {
                                    label: "Province",
                                    type: "Text",
                                    position: 4,
                                    answer: ""
                                },
                                {
                                    label: "Country",
                                    type: "Text",
                                    position: 5,
                                    answer: ""
                                }
                            ],
                            innerAnswers: [],
                            answer: ""
                        },
                        {
                            label: "Date of birth",
                            type: "Date",
                            subtype: "Birthday",
                            position: 4,
                            answer: ""
                        },
                        {
                            label: "Gender",
                            type: "Picklist",
                            position: 5,
                            options: [
                                "Male",
                                "Female",
                                "Prefer not to say",
                                "Other [please specify, free text response]"
                            ],
                            hasDependent: true,
                            dependentQuestionsCondition: "Other [please specify, free text response]",
                            dependentQuestions: [
                                {
                                    type: "Text",
                                    position: 1,
                                    answer: ""
                                }
                            ],
                            answer: ""
                        },
                        {
                            label: "Do you have any medical condition that could impact your financial goals?",
                            type: "Picklist",
                            position: 6,
                            options: [
                                "Yes",
                                "No"
                            ],
                            answer: ""
                        },
                        {
                            label: "Nationality",
                            type: "Country",
                            position: 7,
                            answer: ""
                        },
                        {
                            label: "Tax residence",
                            type: "Country",
                            position: 8,
                            answer: ""
                        },
                        {
                            label: "Which of the following best describes your relationship status?",
                            type: "Picklist",
                            position: 9,
                            options: [
                                "Single",
                                "Married",
                                "Co-habiting",
                                "Widowed",
                                "Other (please specify) [free text response]"
                            ],
                            hasDependent: true,
                            dependentQuestionsCondition: "Other (please specify) [free text response]",
                            dependentQuestions: [
                                {
                                    type: "Text",
                                    position: 1,
                                    answer: ""
                                }
                            ],
                            answer: ""
                        },
                        {
                            label: "Do you have any financial dependants? (For example a child or elderly parent)",
                            type: "Picklist",
                            position: 10,
                            options: [
                                "Yes",
                                "No"
                            ],
                            hasDependent: true,
                            dependentQuestionsCondition: "Yes",
                            dependentQuestions: [
                                {
                                    label: "For each of your dependants, please tell us their relationship to you.",
                                    type: "Specific",
                                    position: 1,
                                    isComplex: true,
                                    isMultiple: true,
                                    innerQuestions: [
                                        {
                                            type: "Picklist",
                                            position: 1,
                                            options: [
                                                "Single",
                                                "Married",
                                                "Co-habiting",
                                                "Widowed",
                                                "Other (please specify) [free text response]"
                                            ],
                                            hasDependent: true,
                                            dependentQuestionsCondition: "Other (please specify) [free text response]",
                                            dependentQuestions: [
                                                {
                                                    type: "Text",
                                                    position: 1,
                                                    answer: ""
                                                }
                                            ],
                                            answer: ""
                                        },
                                        {
                                            type: "Date",
                                            subtype: "Age",
                                            position: 2,
                                            answer: ""
                                        }
                                    ],
                                    innerAnswers: [],
                                    answer: ""
                                }
                            ],
                            answer: ""
                        },
                        {
                            label: "Are you working?",
                            type: "Picklist",
                            position: 12,
                            options: [
                                "Employed",
                                "Self-employed",
                                "Retired",
                                "Not working"
                            ],
                            answer: ""
                        },
                        {
                            label: "What's the highest rate at which you pay tax?",
                            type: "Picklist",
                            position: 13,
                            options: [
                                "Non-taxpayer",
                                "Basic rate",
                                "Higher rate",
                                "Additional rate",
                                "Don’t know/not sure"
                            ],
                            answer: ""
                        },
                        {
                            label: "Why are you looking for financial advice at the moment?",
                            type: "Textarea",
                            position: 14,
                            answer: ""
                        }
                    ],

                    1: [
                        {
                            label: "What type of property do you own?",
                            type: "Specific",
                            position: 1,
                            isComplex: true,
                            isMultiple: true,
                            innerQuestions: [
                                {
                                    type: "Picklist",
                                    position: 1,
                                    options: [
                                        "Home",
                                        "Investment property",
                                        "Holiday home",
                                        "Other (please specify) [free text response]",
                                        "I don’t own any property"
                                    ],
                                    hasDependent: true,
                                    dependentQuestionsCondition: "Other (please specify) [free text response]",
                                    dependentQuestions: [
                                        {
                                            type: "Text",
                                            position: 1,
                                            answer: ""
                                        }
                                    ],
                                    answer: ""
                                },
                                {
                                    label: "Value",
                                    type: "Numeric",
                                    position: 2,
                                    answer: ""
                                }
                            ],
                            innerAnswers: [],
                            answer: ""
                        },
                        {
                            label: "How much money do you have in cash/liquid assets?",
                            type: "Specific",
                            position: 2,
                            isComplex: true,
                            isMultiple: true,
                            innerQuestions: [
                                {
                                    label: "Provider name",
                                    type: "Text",
                                    position: 1,
                                    answer: ""
                                },
                                {
                                    label: "Approximate Value",
                                    type: "Numeric",
                                    position: 2,
                                    answer: ""
                                },
                                {
                                    label: "Do you make a regular contribution?",
                                    type: "Picklist",
                                    position: 3,
                                    options: [
                                        "Yes",
                                        "No"
                                    ],
                                    hasDependent: true,
                                    dependentQuestionsCondition: "Yes",
                                    dependentQuestions: [
                                        {
                                            label: "Interest rate",
                                            type: "Numeric",
                                            position: 1,
                                            answer: ""
                                        }
                                    ],
                                    answer: ""
                                }
                            ],
                            innerAnswers: [],
                            answer: ""
                        },
                        {
                            label: "Please tell us about any investments you have outside of Nutmeg",
                            type: "Specific",
                            position: 3,
                            isComplex: true,
                            isMultiple: true,
                            innerQuestions: [
                                {
                                    label: "Provider name",
                                    type: "Text",
                                    position: 1,
                                    answer: ""
                                },
                                {
                                    label: "Investment type",
                                    type: "Picklist",
                                    position: 2,
                                    options: [
                                        "Stocks and Shares ISA",
                                        "General Investment Account",
                                        "Mutual Fund",
                                        "Shares",
                                        "Investment Bond",
                                        "Other (please specify) [free text response]"
                                    ],
                                    hasDependent: true,
                                    dependentQuestionsCondition: "Other (please specify) [free text response]",
                                    dependentQuestions: [
                                        {
                                            type: "Text",
                                            position: 1,
                                            answer: ""
                                        }
                                    ],
                                    answer: ""
                                },
                                {
                                    label: "Value",
                                    type: "Numeric",
                                    position: 3,
                                    answer: ""
                                },
                                {
                                    label: "Regular contribution?",
                                    type: "Picklist",
                                    position: 4,
                                    options: [
                                        "Yes",
                                        "No"
                                    ],
                                    hasDependent: true,
                                    dependentQuestionsCondition: "Yes",
                                    dependentQuestions: [
                                        {
                                            type: "Picklist",
                                            position: 1,
                                            options: [
                                                "monthly",
                                                "annually"
                                            ],
                                            answer: ""
                                        }
                                    ],
                                    answer: ""
                                },
                                {
                                    label: "Contribution amount",
                                    type: "Numeric",
                                    position: 5,
                                    answer: ""
                                }
                            ],
                            innerAnswers: [],
                            answer: ""
                        },
                        {
                            label: "Are there any other assets we should know about?",
                            type: "Text",
                            position: 4,
                            answer: ""
                        },
                        {
                            label: "Pension",
                            type: "Specific",
                            position: 5,
                            isComplex: true,
                            isMultiple: true,
                            innerQuestions: [
                                {
                                    label: "Provider name",
                                    type: "Text",
                                    position: 1,
                                    answer: ""
                                },
                                {
                                    label: "Pension type",
                                    type: "Picklist",
                                    position: 2,
                                    options: [
                                        "Defined contribution",
                                        "Defined benefit (final salary)",
                                        "Don’t know/not sure"
                                    ],
                                    answer: ""
                                },
                                {
                                    label: "Value",
                                    type: "Numeric",
                                    position: 3,
                                    answer: ""
                                },
                                {
                                    label: "Regular contribution?",
                                    type: "Picklist",
                                    position: 4,
                                    options: [
                                        "Yes",
                                        "No"
                                    ],
                                    hasDependent: true,
                                    dependentQuestionsCondition: "Yes",
                                    dependentQuestions: [
                                        {
                                            type: "Picklist",
                                            position: 11,
                                            options: [
                                                "monthly",
                                                "annually"
                                            ],
                                            answer: ""
                                        }
                                    ],
                                    answer: ""
                                },
                                {
                                    label: "Contribution amount",
                                    type: "Numeric",
                                    position: 5,
                                    answer: ""
                                }
                            ],
                            innerAnswers: [],
                            answer: ""
                        },
                        {
                            label: "Do you have any debt?",
                            type: "Picklist",
                            position: 6,
                            options: [
                                "Yes",
                                "No"
                            ],
                            hasDependent: true,
                            dependentQuestionsCondition: "Yes",
                            dependentQuestions: [
                                {
                                    label: "",
                                    type: "Specific",
                                    position: 1,
                                    isComplex: true,
                                    isMultiple: true,
                                    innerQuestions: [
                                        {
                                            label: "Provider name",
                                            type: "Text",
                                            position: 1,
                                            answer: ""
                                        },
                                        {
                                            label: "Debt type",
                                            type: "Picklist",
                                            position: 2,
                                            options: [
                                                "Mortgage",
                                                "Loan",
                                                "Credit card",
                                                "Other (please specify) [free text response]"
                                            ],
                                            hasDependent: true,
                                            dependentQuestionsCondition: "Other (please specify) [free text response]",
                                            dependentQuestions: [
                                                {
                                                    type: "Text",
                                                    position: 1,
                                                    answer: ""
                                                }
                                            ],
                                            answer: ""
                                        },
                                        {
                                            label: "Term",
                                            type: "Specfic",
                                            position: 3,
                                            isComplex: true,
                                            isMultiple: false,
                                            innerQuestions: [
                                                {
                                                    label: "Month",
                                                    type: "Date",
                                                    subtype: "Month",
                                                    position: 1,
                                                    answer: ""
                                                },
                                                {
                                                    label: "Year",
                                                    type: "Date",
                                                    subtype: "Year/Future",
                                                    position: 2,
                                                    answer: ""
                                                }
                                            ],
                                            innerAnswers: "",
                                            answer: ""
                                        },
                                        {
                                            label: "Current repayments",
                                            type: "Numeric",
                                            position: 4,
                                            hasDependent: true,
                                            dependentQuestionsConditionNotNull: "true",
                                            dependentQuestions: [
                                                {
                                                    type: "Picklist",
                                                    position: 1,
                                                    options: [
                                                        "monthly",
                                                        "annually"
                                                    ],
                                                    answer: ""
                                                }
                                            ],
                                            answer: ""
                                        },
                                        {
                                            label: "Interest rate",
                                            type: "Numeric",
                                            position: 5,
                                            answer: ""
                                        }
                                    ],
                                    innerAnswers: [],
                                    answer: ""
                                }
                            ],
                            answer: ""
                        },
                        {
                            label: "Do you have any life assurance?",
                            type: "Picklist",
                            position: 7,
                            options: [
                                "Yes",
                                "No"
                            ],
                            hasDependent: true,
                            dependentQuestionsCondition: "Yes",
                            dependentQuestions: [
                                {
                                    label: "",
                                    type: "Specific",
                                    position: 1,
                                    isComplex: true,
                                    isMultiple: true,
                                    innerQuestions: [
                                        {
                                            label: "Provider name",
                                            type: "Text",
                                            position: 1,
                                            answer: ""
                                        },
                                        {
                                            label: "Life assurance type",
                                            type: "Picklist",
                                            position: 2,
                                            options: [
                                                "Level term insurance",
                                                "Decreasing term insurance",
                                                "Death in service",
                                                "Other (please specify) [free text response]"
                                            ],
                                            hasDependent: true,
                                            dependentQuestionsCondition: "Other (please specify) [free text response]",
                                            dependentQuestions: [
                                                {
                                                    type: "Text",
                                                    position: 1,
                                                    answer: ""
                                                }
                                            ],
                                            answer: ""
                                        },
                                        {
                                            label: "Sum assured",
                                            type: "Numeric",
                                            position: 3,
                                            answer: ""
                                        },
                                        {
                                            label: "Length of term",
                                            type: "Specfic",
                                            position: 4,
                                            isComplex: true,
                                            isMultiple: false,
                                            innerQuestions: [
                                                {
                                                    label: "Month",
                                                    type: "Date",
                                                    subtype: "Month",
                                                    position: 1,
                                                    answer: ""
                                                },
                                                {
                                                    label: "Year",
                                                    type: "Date",
                                                    subtype: "Year/Future",
                                                    position: 2,
                                                    answer: ""
                                                }
                                            ],
                                            innerAnswers: "",
                                            answer: ""
                                        }
                                    ],
                                    innerAnswers: [],
                                    answer: ""
                                }
                            ],
                            answer: ""
                        },
                        {
                            label: "Do you have any critical illness cover?",
                            type: "Picklist",
                            position: 8,
                            options: [
                                "Yes",
                                "No"
                            ],
                            hasDependent: true,
                            dependentQuestionsCondition: "Yes",
                            dependentQuestions: [
                                {
                                    label: "",
                                    type: "Specific",
                                    position: 1,
                                    isComplex: true,
                                    isMultiple: true,
                                    innerQuestions: [
                                        {
                                            label: "Provider name",
                                            type: "Text",
                                            position: 1,
                                            answer: ""
                                        },
                                        {
                                            label: "Sum assured",
                                            type: "Numeric",
                                            position: 2,
                                            answer: ""
                                        },
                                        {
                                            label: "Term",
                                            type: "Date",
                                            subtype: "Year/Future",
                                            position: 3,
                                            answer: ""
                                        }
                                    ],
                                    innerAnswers: [],
                                    answer: ""
                                }
                            ],
                            answer: ""
                        },
                        {
                            label: "Do you have any income protection?",
                            type: "Picklist",
                            position: 9,
                            options: [
                                "Yes",
                                "No"
                            ],
                            hasDependent: true,
                            dependentQuestionsCondition: "Yes",
                            dependentQuestions: [
                                {
                                    label: "",
                                    type: "Specific",
                                    position: 1,
                                    isComplex: true,
                                    isMultiple: true,
                                    innerQuestions: [
                                        {
                                            label: "Provider name",
                                            type: "Text",
                                            position: 1,
                                            answer: ""
                                        },
                                        {
                                            label: "Sum assured",
                                            type: "Numeric",
                                            position: 2,
                                            answer: ""
                                        },
                                        {
                                            label: "Term",
                                            type: "Date",
                                            subtype: "Year/Future",
                                            position: 3,
                                            answer: ""
                                        }
                                    ],
                                    innerAnswers: [],
                                    answer: ""
                                }
                            ],
                            answer: ""
                        },
                        {
                            label: "Do you have any other type of financial protection?",
                            type: "Picklist",
                            position: 10,
                            options: [
                                "Yes",
                                "No"
                            ],
                            hasDependent: true,
                            dependentQuestionsCondition: "Yes",
                            dependentQuestions: [
                                {
                                    label: "",
                                    type: "Specific",
                                    position: 1,
                                    isComplex: true,
                                    isMultiple: true,
                                    innerQuestions: [
                                        {
                                            label: "Provider name",
                                            type: "Text",
                                            position: 1,
                                            answer: ""
                                        },
                                        {
                                            label: "Sum assured",
                                            type: "Numeric",
                                            position: 2,
                                            answer: ""
                                        },
                                        {
                                            label: "Term",
                                            type: "Date",
                                            subtype: "Year/Future",
                                            position: 3,
                                            answer: ""
                                        }
                                    ],
                                    innerAnswers: [],
                                    answer: ""
                                }
                            ],
                            answer: ""
                        },
                        {
                            label: "Do you have a will?",
                            type: "Picklist",
                            position: 11,
                            options: [
                                "Yes, and I’m happy with the content",
                                "Yes, but I want to update it",
                                "No"
                            ],
                            answer: ""
                        },
                        {
                            label: "Have you used all of your ISA allowance this tax year?",
                            type: "Picklist",
                            position: 12,
                            options: [
                                "Yes",
                                "No",
                                "Don’t know"
                            ],
                            answer: ""
                        },
                        {
                            label: "Have you used all of your pension allowance this tax year?",
                            type: "Picklist",
                            position: 13,
                            options: [
                                "Yes",
                                "No",
                                "Don’t know"
                            ],
                            answer: ""
                        },
                        {
                            label: "Have you used all of your capital gains allowance this tax year?",
                            type: "Picklist",
                            position: 14,
                            options: [
                                "Yes",
                                "No",
                                "Don’t know"
                            ],
                            answer: ""
                        },
                        {
                            label: "What level of state pension are your expecting?",
                            type: "Picklist",
                            position: 15,
                            options: [
                                "Full – you’ll pay enough National Insurance to receive the full amount",
                                "Part – Your National Insurance contributions won’t be enough to give you the full amount",
                                "Don’t know"
                            ],
                            answer: ""
                        }
                    ],

                    2: [
                        {
                            label: "Your income",
                            type: "Specific",
                            position: 1,
                            isComplex: true,
                            isMultiple: false,
                            innerQuestions: [
                                {
                                    label: "Average monthly income after tax",
                                    type: "Numeric",
                                    position: 1,
                                    answer: ""
                                },
                                {
                                    label: "Annual salary before tax",
                                    type: "Numeric",
                                    position: 2,
                                    answer: ""
                                },
                                {
                                    label: "Bonuses each year",
                                    type: "Numeric",
                                    position: 3,
                                    answer: ""
                                },
                                {
                                    label: "Dividends each year",
                                    type: "Numeric",
                                    position: 4,
                                    answer: ""
                                },
                                {
                                    label: "Interest each year",
                                    type: "Numeric",
                                    position: 5,
                                    answer: ""
                                },
                                {
                                    label: "Other income each year",
                                    type: "Numeric",
                                    position: 6,
                                    answer: ""
                                },
                                {
                                    label: "Are you expecting any cash lump sums, such as an inheritance?",
                                    type: "Specific",
                                    position: 7,
                                    isComplex: true,
                                    isMultiple: true,
                                    innerQuestions: [
                                        {
                                            label: "Value",
                                            type: "Numeric",
                                            position: 1,
                                            answer: ""
                                        },
                                        {
                                            label: "Date",
                                            type: "Date",
                                            position: 2,
                                            answer: ""
                                        }
                                    ],
                                    innerAnswers: [],
                                    answer: ""
                                }
                            ],
                            innerAnswers: [],
                            answer: ""
                        },
                    ],

                    3: [
                        {
                            label: "Your expenses",
                            type: "Specific",
                            position: 1,
                            isComplex: true,
                            isMultiple: false,
                            innerQuestions: [
                                {
                                    label: "Home (buildings/contents insurance, council tax, maintenance etc)",
                                    type: "Numeric",
                                    position: 1,
                                    answer: ""
                                },
                                {
                                    label: "Utilities",
                                    type: "Numeric",
                                    position: 2,
                                    answer: ""
                                },
                                {
                                    label: "Housekeeping (food, drink, eating out)",
                                    type: "Numeric",
                                    position: 3,
                                    answer: ""
                                },
                                {
                                    label: "Car or bike (fuel, servicing, insurance etc)",
                                    type: "Numeric",
                                    position: 4,
                                    answer: ""
                                },
                                {
                                    label: "Travel and leisure expenditure (Rail fares, holidays, entertainment, subscriptions etc)",
                                    type: "Numeric",
                                    position: 5,
                                    answer: ""
                                },
                                {
                                    label: "Personal expenditure (clothes, gifts etc)",
                                    type: "Numeric",
                                    position: 6,
                                    answer: ""
                                },
                                {
                                    label: "Personal insurance (medical insurance etc)",
                                    type: "Numeric",
                                    position: 7,
                                    answer: ""
                                },
                                {
                                    label: "Other expenditure",
                                    type: "Numeric",
                                    position: 8,
                                    answer: ""
                                },
                                {
                                    label: "Planned one-off expenditure (new car, windows for house etc)",
                                    type: "Numeric",
                                    position: 9,
                                    answer: ""
                                }
                            ],
                            innerAnswers: [],
                            answer: ""
                        }
                    ],

                    4: [
                        {
                            label: "When, if ever, did you first invest?",
                            type: "Date",
                            subtype: "Year/Past",
                            position: 1,
                            defaultOptions: [
                                "I have never invested before"
                            ],
                            answer: "I have never invested before"
                        },
                        {
                            label: "What investments and tax wrappers have you used?",
                            type: "Picklist",
                            position: 2,
                            options: [
                                "Pension",
                                "ISA",
                                "Investment bond",
                                "Mutual fund",
                                "Shares",
                                "Other (please specify)"
                            ],
                            hasDependent: true,
                            dependentQuestionsCondition: "Other (please specify)",
                            dependentQuestions: [
                                {
                                    type: "Text",
                                    position: 1,
                                    answer: ""
                                }
                            ],
                            answer: ""
                        },
                        {
                            label: "How often do you make investment decisions?",
                            type: "Picklist",
                            position: 3,
                            options: [
                                "Monthly",
                                "Once every six months or so",
                                "Once a year",
                                "Less than once a year"
                            ],
                            answer: ""
                        },
                        {
                            label: "Have you studied finance or related subjects?",
                            type: "Picklist",
                            position: 4,
                            options: [
                                "Yes",
                                "No"
                            ],
                            answer: ""
                        },
                        {
                            label: "How you worked in finance?",
                            type: "Picklist",
                            position: 5,
                            options: [
                                "Yes",
                                "No"
                            ],
                            answer: ""
                        }
                    ],

                    5: [
                        {
                            label: "",
                            type: "Specific",
                            position: 1,
                            isComplex: true,
                            isMultiple: false,
                            innerQuestions: [
                                {
                                    label: "When would you like to retire?",
                                    type: "Numeric",
                                    position: 1,
                                    answer: ""
                                },
                                {
                                    label: "How much income will you require in retirement?",
                                    type: "Numeric",
                                    position: 2,
                                    answer: ""
                                }
                            ],
                            innerAnswers: [],
                            answer: ""
                        },
                        {
                            label: "Financial goals",
                            type: "Specific",
                            position: 2,
                            isComplex: true,
                            isMultiple: false,
                            innerQuestions: [
                                {
                                    label: "What are your financial goals?",
                                    type: "Picklist",
                                    position: 1,
                                    options: [
                                        "House purchase",
                                        "Just invest",
                                        "Investment/pension review",
                                        "Assist family/children",
                                        "Other (please specify)"
                                    ],
                                    hasDependent: true,
                                    dependentQuestionsCondition: "Other (please specify)",
                                    dependentQuestions: [
                                        {
                                            type: "Text",
                                            position: 1,
                                            answer: ""
                                        }
                                    ],
                                    answer: ""
                                },
                                {
                                    label: "How much do you need for this goal?",
                                    type: "Numeric",
                                    position: 2,
                                    answer: ""
                                },
                                {
                                    label: "When do you need the money?",
                                    type: "Date",
                                    subtype: "Year/Future",
                                    position: 3,
                                    answer: ""
                                },
                            ],
                            innerAnswers: [],
                            answer: ""
                        },
                        {
                            label: "Is inheritance tax a concern?",
                            type: "Picklist",
                            position: 3,
                            options: [
                                "Yes",
                                "No",
                                "Not sure"
                            ],
                            answer: ""
                        },
                        {
                            label: "Preferred investment style",
                            type: "Picklist",
                            position: 4,
                            options: [
                                "Fully managed",
                                "Fixed allocation",
                                "Socially responsible"
                            ],
                            answer: ""
                        },
                        {
                            label: "Is there anything else we should know?",
                            type: "Text",
                            position: 5,
                            answer: ""
                        }
                    ]
                }
            };

            component.set("v.allQuestions", q);
        }

        component.set("v.questions", component.get("v.allQuestions").questions[component.get("v.step")]);
        component.set("v.prepage", component.get("v.allQuestions").prepages[component.get("v.step")]);

        var q2 = component.get("v.allQuestions");

        var stepsTitles = [];
        for (let prepage in q2.prepages) {
            stepsTitles.push(q2.prepages[prepage].title);
        }
        component.set("v.stepsList", stepsTitles);
    }

});