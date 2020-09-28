/**********************************************************************
Purpose:

Knowledge Hub API for Mobile team.

Test class:
    Test_SN_PopularArticlesAPI
======================================================
History
-------
Date        AUTHOR                  DETAIL
04/24/2020  Kseniya Hanchuk         MASQ-635: Initial version.
***********************************************************************/

@RestResource(urlMapping='/v1.0/popularArticles/*')
global without sharing class SN_PopularArticlesAPI {

    public enum StatusCode { SUCCESS, CANCELLED, ERROR }

    global static RestRequest req = RestContext.request;
    global static RestResponse res = RestContext.response;

    @HttpGet
    global static void getAll() {
        CResponse cRes = new CResponse();

        SN_Recent_Articles__c cts = SN_Recent_Articles__c.getOrgDefaults();
        List<String> resentlyViewedArticles = String.isNotBlank(cts.Recent_Articles__c) ?
            new List<String>(cts.Recent_Articles__c.split('[,]')) : new List<String>();

        if (resentlyViewedArticles.isEmpty()) {
            cRes.status = StatusCode.CANCELLED;
            cRes.message = 'Have no records';
            response(200, cRes);
            return;
        }

        try {
            List<Knowledge__DataCategorySelection> articleCategories = [
                SELECT Id, ParentId, DataCategoryName, DataCategoryGroupName
                FROM Knowledge__DataCategorySelection
                WHERE ParentId IN :resentlyViewedArticles
            ];

            Map<String, Object> categoryGroups = new Map<String, Object>();
            for (Knowledge__DataCategorySelection categoryItem : articleCategories) {
                categoryGroups.put(categoryItem.ParentId, new Map<String, Object> {
                    'groupLabel' => categoryItem.DataCategoryGroupName.replaceAll('_', ' '),
                    'groupName' => categoryItem.DataCategoryGroupName,
                    'selectedCategories' => new List<Object> {
                        new Map<String, Object> {
                            'categoryLabel' => categoryItem.DataCategoryName.replaceAll('_', ' '),
                            'categoryName' => categoryItem.DataCategoryName,
                            'url' => '/services/data/v48.0/support/dataCategoryGroups/' + categoryItem.DataCategoryGroupName
                                + '/dataCategories/' + categoryItem.DataCategoryName + '?sObjectName=KnowledgeArticleVersion'
                        }
                    }
                });
            }

            cRes.status = StatusCode.SUCCESS;
            cRes.articles = new List<Object>();

            List<Knowledge__kav> articles = [
                SELECT Id, Title, Summary, KnowledgeArticleId
                FROM Knowledge__kav
                WHERE Id IN :resentlyViewedArticles
            ];

            for (Knowledge__kav articleItem : articles) {
                cRes.articles.add(new Map<String, Object> {
                    'categoryGroups' => new List<Object> { categoryGroups.get(articleItem.Id) },
                    'id' => articleItem.KnowledgeArticleId,
                    'summary' => articleItem.Summary,
                    'title' => articleItem.Title
                });
            }

            response(200, cRes);
            return;
        } catch (Exception e) {
            cRes.status = StatusCode.ERROR;
            cRes.message = e.getMessage();
            response(400, cRes);
            return;
        }
    }

    public static void response(Integer statusCode, CResponse responseData) {
        res.statusCode = statusCode;
        res.responseBody = Blob.valueOf(JSON.serialize(responseData));

    }

    global class CResponse {
        StatusCode status;
        String message;
        List<Object> articles;

    }

}