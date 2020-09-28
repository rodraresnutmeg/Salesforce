@RestResource(UrlMapping='/v1.0/suggestArticles/*')
global with sharing class SN_SuggestArticlesAPI {

    public enum StatusCode { SUCCESS, CANCELLED, ERROR }

    global static RestRequest   req = RestContext.request;
    global static RestResponse  res = RestContext.response;

    @HttpGet
    global static void get() {
        CResponse   cRes    = new CResponse();
        String      params  = req.params.get('q');

        if (String.isBlank(params)) {
            cRes.status     = StatusCode.CANCELLED;
            cRes.message    = 'Query is empty';

            response(400, cRes);
            return;
        }

        try {
            List<Knowledge__kav> articles = suggest(params);
            if (articles.isEmpty()) {
                articles = search(params);
            }

            cRes.status = StatusCode.SUCCESS;
            cRes.setArticles(articles);

            response(200, cRes);
            return;
        } catch (Exception e) {
            cRes.status     = StatusCode.ERROR;
            cRes.message    = e.getMessage();

            response(400, cRes);
            return;
        }
    }

    public static List<Knowledge__kav> search(String params) {
        List<String> searchParams   = new List<String>();
        List<String> paramList      = params.split(' ');

        for (String param : paramList) {
            searchParams.add('Title LIKE \'%' + param + '%\'');
        }

        String queryString = getQueryString();

        String q = String.format(queryString, new List<String>{'\'Online\'', String.join(searchParams, ' AND ')});
        List<Knowledge__kav> articles = Database.query(q);

        return articles;
    }

    public static List<Knowledge__kav> suggest(String searchText) {
        List<Knowledge__kav> result = new List<Knowledge__kav>();

        Set<Id> articleSet = new Set<Id>();

        Integer queryLimit  = 5;
        String  language    = 'en_US';
        String  objectType  = 'KnowledgeArticleVersion';

        Search.KnowledgeSuggestionFilter filters = new Search.KnowledgeSuggestionFilter();
        filters.setLanguage(language);
        filters.setPublishStatus('Online');

        Search.SuggestionOption options = new Search.SuggestionOption();
        options.setFilter(filters);
        options.setLimit(queryLimit);

        Search.SuggestionResults        suggestionResults   = Search.suggest(searchText, objectType, options);
        List<Search.SuggestionResult>   suggestionResult    = suggestionResults.getSuggestionResults();

        for (Search.SuggestionResult sr : suggestionResult) {
            articleSet.add(sr.getSObject().Id);
        }

        String queryString  = getQueryString();
        String q            = String.format(queryString, new List<String>{'\'Online\'', 'Id IN :articleSet'});

        List<Knowledge__kav> articles = Database.query(q);

        return articles;
    }

    public static String getQueryString() {
        String queryString = '' +
            'SELECT ' +
                'Id, ' +
                'Title, ' +
                'PublishStatus, ' +
                'Summary, ' +
                'KnowledgeArticleId, ' +
                '(' +
                    'SELECT ' +
                        'Id, ' +
                        'DataCategoryGroupName, ' +
                        'DataCategoryName ' +
                    'FROM DataCategorySelections' +
                ')' +
            'FROM Knowledge__kav ' +
            'WHERE PublishStatus = {0} ' +
                'AND {1} ' +
            'LIMIT 5000';

        return queryString;
    }

    public static void response(Integer statusCode, CResponse responseData) {
        res.statusCode      = statusCode;
        res.responseBody    = Blob.valueOf(JSON.serialize(responseData));
    }

    global class CResponse {
        StatusCode      status;
        String          message;
        List<Object>    articles;

        public void setArticles(List<Knowledge__kav> articles) {
            List<Object> result = new List<Object>();

            for (Knowledge__kav articleItem : articles) {
                result.add(new Map<String, Object> {
                    'categoryGroups'    => getCategoryGroups(articleItem),
                    'id'                => articleItem.KnowledgeArticleId,
                    'summary'           => articleItem.Summary,
                    'title'             => articleItem.Title
                });
            }

            this.articles = result;
        }

        public List<Object> getCategoryGroups(Knowledge__kav articleItem) {
            List<Object> result = new List<Object>();

            for (Knowledge__DataCategorySelection dcs : articleItem.DataCategorySelections) {
                Map<String, Object> groupItem = new Map<String, Object> {
                    'groupLabel'            => dcs.DataCategoryGroupName.replaceAll('_', ' '),
                    'groupName'             => dcs.DataCategoryGroupName,
                    'selectedCategories'    => new List<Object> {
                        new Map<String, Object> {
                            'categoryLabel' => dcs.DataCategoryName.replaceAll('_', ' '),
                            'categoryName'  => dcs.DataCategoryName,
                            'url'           => '' +
                                '/services/data/v48.0/support/dataCategoryGroups/' + dcs.DataCategoryGroupName
                                + '/dataCategories/' + dcs.DataCategoryName
                                + '?sObjectName=KnowledgeArticleVersion'
                        }
                    }
                };

                result.add(groupItem);
            }

            return result;
        }
    }

}