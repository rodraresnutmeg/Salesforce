/**********************************************************************
Purpose:
Controller for FactFind Export button on PA.
======================================================
Test class:

======================================================
History
-------
Date        AUTHOR                 	DETAIL
11/18/2019  Kseniya Hanchuk         MASQ-399: Initial version
***********************************************************************/

public with sharing class FactFindExportCtrl {

    public String answersForm { get; set; }
    public Id accountId { get; set; }

    public FactFindExportCtrl() {
        this.accountId = 'a090C000000Ki8BQAS';
        this.answersForm = JSON.serialize(getData(accountId));

    }

    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getData(Id accountId) {
        Answers_Form__c answersForm = [
            SELECT Id, AnswersJSON__c
            FROM Answers_Form__c
            WHERE Id =: accountId
            LIMIT 1
        ];

        return (Map<String, Object>) JSON.deserializeUntyped(answersForm.AnswersJSON__c.replaceAll('[\']', '&#39;').replaceAll('[\r\n]', ''));

    }


    public class Prepage {
        String title;
        String text;

    }

    public class Question {
        String label;
        String type;
        Integer position;
        Boolean isComplex;
        Boolean isMultiple;
        List<InnerQuestion> innerQuestions;
        List<InnerAnswer> innerAnswers;
        String answer;
        String subtype;
        Integer day;
        Integer month;
        Integer year;
        Map<Integer, String> options;
        Boolean hasDependent;
        String dependentQuestionsCondition;
        List<Question> dependentQuestions;
        Map<Integer, String> defaultOptions;

    }

    public class InnerQuestion {
        String label;
        String type;
        Integer position;
        String answer;

    }

    public class InnerAnswer {

    }

}