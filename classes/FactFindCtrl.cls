public with sharing class FactFindCtrl {

    @AuraEnabled
    public static String saveAnswers(String answersJSON, Id recordId, String caseId) {
        if (answersJSON == null) {
            return 'ERROR';
        }

        Answers_Form__c answerForm = new Answers_Form__c();
        answerForm.AnswersJSON__c = answersJSON;

        if (recordId != null) {
            answerForm.Id = recordId;
        }

        if (String.isNotBlank(caseId)) {
            Id cId = Id.valueOf(Utils.getDecodedCaseId(caseId));
            Case c = [
                SELECT
                    Id,
                    AccountId,
                    Account.AdviceFactFindConsent__pc
                FROM Case
                WHERE Id = :cId
                LIMIT 1
            ];

            if (c != null && c.AccountId != null && !c.Account.AdviceFactFindConsent__pc) {
                Account acc = new Account();
                acc.Id = c.AccountId;
                acc.AdviceFactFindConsent__pc = true;
                update acc;

                answerForm.Account__c = c.AccountId;
            }

            answerForm.Case__c = cId;
        }

        upsert answerForm;

        return 'SUCCESS';
    }

    @AuraEnabled
    public static List<String> getCountries() {
        List<String> countries = new List<String>();

        Schema.DescribeFieldResult fieldResult = User.Countrycode.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple){
            countries.add(f.getLabel());
        }

        return countries;
    }

    @AuraEnabled
    public static String getAnswers(Id answersId) {
        String result;

        Answers_Form__c af = [
            SELECT
                Id,
                AnswersJSON__c
            FROM Answers_Form__c
            WHERE Id =: answersId
            LIMIT 1
        ];

        result = af.AnswersJSON__c;

        return result;
    }

}