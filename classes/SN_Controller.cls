/**********************************************************************
Purpose:

Controller for support.nutmeg website. Included to SN_Layout page.
======================================================
Test class:

Test_SN_Controller
======================================================
History
-------
Date        AUTHOR                 	DETAIL
08/01/2019  Kseniya Hanchuk         CRM-247: Initial version
***********************************************************************/

global without sharing class SN_Controller {

    global String pageData { get; set; }
    global static String pageError { get; set; }
    global static LiveChat__c liveChatSettings { get; set; }

    public static Map<String, Object> categoriesTree = getDescribeDataCategoryGroupStructureResults();


    global SN_Controller() {
        String articleUrl = ApexPages.currentPage().getParameters().get('article');
        String sectionId = ApexPages.currentPage().getParameters().get('section');
        String categoryId = ApexPages.currentPage().getParameters().get('category');
        String query = ApexPages.currentPage().getParameters().get('query');
        String pageParam = ApexPages.currentPage().getParameters().get('page');
        String articleId = null;
        System.debug(LoggingLevel.Info, 'article ' + articleUrl);
        if (articleUrl != null) {
            Article artic = getArticleByUrl(articleUrl);
            articleId = artic.id;
        }


        if (articleId != null) {
            this.pageData = JSON.serialize(new ArticlePage(articleId));
        } else if (sectionId != null) {
            this.pageData = JSON.serialize(new SectionPage(categoryId, sectionId));
        } else if (categoryId != null) {
            this.pageData = JSON.serialize(new CategoryPage(categoryId));
        } else if (query != null) {
            Integer page = pageParam != null ? Integer.valueOf(pageParam) : 0;
            this.pageData = JSON.serialize(new SearchResults(query, page)); 
        } else {
            this.pageData = JSON.serialize(new Homepage()); 
        }

        liveChatSettings = LiveChat__c.getOrgDefaults();
    }


    global static void addRecentlyViewedArticle() {
        String articleUrl = ApexPages.currentPage().getParameters().get('article');
        String articleId = null;
        if (articleUrl != null) {
            Article artic = getArticleByUrl(articleUrl);
            articleId = artic.id;
        }
 
        SN_Recent_Articles__c cts = SN_Recent_Articles__c.getOrgDefaults();
        List<String> resentlyViewedArticles = String.isNotBlank(cts.Recent_Articles__c) ?
            new List<String>(cts.Recent_Articles__c.split('[,]')) : new List<String>();

        if (String.isNotBlank(articleId)) {
            if (!resentlyViewedArticles.contains(articleId)) {
                if (resentlyViewedArticles.size() >= SN_Constants.MAX_RECENT_ARTICLES) {
                    resentlyViewedArticles.remove(0);
                    resentlyViewedArticles.add(articleId);
                } else {
                    resentlyViewedArticles.add(articleId);
                }

                try {
                    cts.Recent_Articles__c = String.join(resentlyViewedArticles, ',');
                    update cts;
                } catch (Exception e) {
                    pageError = SN_Constants.ERROR_NOT_FOUND;
                }
            }
        }

    }

    global static List<Object> getBreadcrumbs(String categoryName, String sectionName) {
        Map<String, Object> categoryData = (Map<String, Object>) categoriesTree.get(categoryName);
        String categoryLabel = (String) categoryData.get(SN_Constants.CATEGORY_TREE_LABEL);
        String sectionLabel = ((Map<String, String>) categoryData.get(SN_Constants.CATEGORY_TREE_SECTIONS)).get(sectionName);

        return new List<Object> {
            new Map<String, String> { 'url' => SN_Constants.CATEGORY_START_URL + categoryName, 'name' => categoryLabel }, 
            new Map<String, String> { 'url' => SN_Constants.SECTION_START_URL + sectionName + '&category=' + categoryName, 'name' => sectionLabel }
        };

    }

    @RemoteAction
    global static void voteUp(String articleId) {
        Knowledge__kav know = new Knowledge__kav();
        if (articleId != null) {
            if(articleId.contains('-')){
                know = [SELECT Id FROM Knowledge__kav WHERE UrlName =:articleId AND PublishStatus = 'Online' limit 1];
                articleId = know.id;
            }
            
        }
        List<SN_Vote_Scoring__c> votesForCurrentAtricle = [
            SELECT Knowledge__c, Vote_Sum__c
            FROM SN_Vote_Scoring__c
            WHERE Knowledge__c = :articleId
            LIMIT 1
        ];

        SN_Vote_Scoring__c newScoring = new SN_Vote_Scoring__c();

        if (votesForCurrentAtricle.isEmpty()) {
            newScoring.Knowledge__c = articleId;
            newScoring.Vote_Sum__c = 1;
        } else {
            newScoring.Id = votesForCurrentAtricle.get(0).Id;
            newScoring.Knowledge__c = votesForCurrentAtricle.get(0).Knowledge__c;
            newScoring.Vote_Sum__c = votesForCurrentAtricle.get(0).Vote_Sum__c + 1;
        }

        upsert newScoring;

    }
 
    @RemoteAction
    global static void voteDown(String articleId) {
        Knowledge__kav know = new Knowledge__kav();
        if (articleId != null) {
            if(articleId.contains('-')){
                know = [SELECT Id FROM Knowledge__kav WHERE UrlName =:articleId AND PublishStatus = 'Online' limit 1];
                articleId = know.id;
            }
            
        }
        List<SN_Vote_Scoring__c> votesForCurrentAtricle = [
            SELECT Knowledge__c, Vote_Sum__c
            FROM SN_Vote_Scoring__c
            WHERE Knowledge__c = :articleId
            LIMIT 1
        ];

        SN_Vote_Scoring__c newScoring = new SN_Vote_Scoring__c();

        if (votesForCurrentAtricle.isEmpty()) {
            newScoring.Knowledge__c = articleId;
            newScoring.Vote_Sum__c = -1;
        } else {
            newScoring.Id = votesForCurrentAtricle.get(0).Id;
            newScoring.Knowledge__c = votesForCurrentAtricle.get(0).Knowledge__c;
            newScoring.Vote_Sum__c = votesForCurrentAtricle.get(0).Vote_Sum__c - 1;
        }

        upsert newScoring;

    }

    @RemoteAction
    global static List<Map<String, String>> search(String query) {
        if (String.isBlank(query) || query.length() < 2) {
            return null;
        }
        query = '%' + query + '%';

        List<Knowledge__kav> articleList = [
            SELECT Id, Title, Urlname
            FROM Knowledge__kav
            WHERE PublishStatus = 'Online'
            AND Title LIKE :query
            LIMIT :SN_Constants.MAX_ARTICLES_IN_SEARCH
        ];

        List<Knowledge__DataCategorySelection> articleCategories = [
            SELECT Id, ParentId, DataCategoryName
            FROM Knowledge__DataCategorySelection
            WHERE ParentId IN :articleList
        ];

        Map<String, String> articleIdToCatgory = new Map<String, String>();
        for (Knowledge__DataCategorySelection item : articleCategories) {
            articleIdToCatgory.put(item.ParentId, item.DataCategoryName.replaceAll('_', ' '));
        }

        List<Map<String, String>> articles = new List<Map<String, String>>();
        for (Knowledge__kav article : articleList) { 
            articles.add(new Map<String, String>{
                'sfid' => article.Id,
                'title' => article.Title,
                'url_name' => article.UrlName,
                'section' => articleIdToCatgory.get(article.Id)
            });
        }

        return articles;

    }


    private static Boolean hasMultipleCategories() {
        return categoriesTree.size() > 1;

    }

    private static Integer countArticles(String sectionName) {
        List<Knowledge__DataCategorySelection> articlesToSections = [
            SELECT Id, ParentId, DataCategoryName
            FROM Knowledge__DataCategorySelection
        ];
        
        List<Id> articlesForSectionName = new List<Id>();
        for (Knowledge__DataCategorySelection kdcItem : articlesToSections) {
            if (kdcItem.DataCategoryName.compareTo(sectionName) == 0) {
            	articlesForSectionName.add(kdcItem.ParentId);
            }
        }
        
        List<Knowledge__kav> articlesWithLatestVersion = [
            SELECT Id
            FROM Knowledge__kav
            WHERE Id IN :articlesForSectionName
            AND IsLatestVersion = TRUE
        ];

        return articlesWithLatestVersion.size();

    }

    private static Integer getVoteSum(Id articleId) {
        System.debug(LoggingLevel.INFO, 'rodri 90 ' + articleId);
        List<SN_Vote_Scoring__c> votesForCurrentAtricle = [
            SELECT Vote_Sum__c
            FROM SN_Vote_Scoring__c
            WHERE Knowledge__c = :articleId
            LIMIT 1
        ];

        return votesForCurrentAtricle.isEmpty() ? 0 : Integer.valueOf(votesForCurrentAtricle.get(0).Vote_Sum__c);

    }

    private static Article getArticleById(Id articleId) {
        System.debug(LoggingLevel.INFO, 'rodri 909 ' + articleId);

        Knowledge__kav articleItem = [
            SELECT Id, Title, Description_Rich_Text__c, UrlName, Promoted__c
            FROM Knowledge__kav
            WHERE Id = :articleId 
            AND PublishStatus = 'Online'
            LIMIT 1
        ];

        return new Article(articleItem);

    }

    private static Article getArticleByUrl(String url) {
        Knowledge__kav articleItem = [
            SELECT Id, Title, Description_Rich_Text__c, UrlName, Promoted__c
            FROM Knowledge__kav
            WHERE UrlName = :url
            AND PublishStatus = 'Online'
            LIMIT 1
        ];

        return new Article(articleItem);

    }

    private static List<Article> getArticles(List<String> articleString) {
        List<Article> allArticles = new List<Article>();
        List<String> articleUrl = new List<String>();
        List<Id> articleIds = new List<Id>();
        if (articleString.size() > 0) {
            for(String s : articleString){
                if(s.contains('-')){
                    articleUrl.add(s);
                }else{
                    articleIds.add(s);
                }
            }
        }


        System.debug(LoggingLevel.info , 'rodrigo 2 ' +articleIds );
        try{

        
            if (articleIds.size() > 0 || articleUrl.size() > 0) {
                for (Knowledge__kav articleItem : [
                    SELECT Id, Title, Description_Rich_Text__c, UrlName, Promoted__c
                    FROM Knowledge__kav
                    WHERE (Id IN :articleIds or UrlName IN:articleUrl)
                    AND PublishStatus = 'Online'
                    ORDER BY Title
                ]) {
                    System.debug(LoggingLevel.info , 'rodrigo 3 ' +articleItem );

                    allArticles.add(new Article(articleItem));
                }
            }
        } catch(Exception e) {
            System.debug('Exception e '+e);
            System.debug('Exception e '+e.getLineNumber());
            pageError = SN_Constants.ERROR_NOT_FOUND;
        }


        return allArticles;

    }

    private static List<Article> getArticlesBySection(String sectionName, Integer maxArticles) {
        List<String> articleIds = new List<String>();
        List<Knowledge__DataCategorySelection> articlesToSections = [
            SELECT Id, ParentId, DataCategoryName
            FROM Knowledge__DataCategorySelection order by ParentId desc
            LIMIT 1000 
        ];

        Integer index = 0;
        for (Knowledge__DataCategorySelection kdcItem : articlesToSections) {
            if (kdcItem.DataCategoryName == sectionName && (maxArticles != null ? index < maxArticles : true)) {
                System.debug(LoggingLevel.INFO, 'rodrigo 11:' + kdcItem.ParentId) ;
                articleIds.add(kdcItem.ParentId);
            	index ++;
            }
        }

        return getArticles(articleIds);

    }

    private static List<Article> getAllPromotedArticles() {
        List<Article> allPromotedArticles = new List<Article>();

        for (Knowledge__kav articleItem : [
            SELECT Id, Title, Description_Rich_Text__c, UrlName, Promoted__c
            FROM Knowledge__kav
            WHERE Promoted__c = TRUE
            AND PublishStatus = 'Online'
            ORDER BY Title
        ]) {
            allPromotedArticles.add(new Article(articleItem));
        }

        return allPromotedArticles;

    }

    private static List<Article> search(String query, Integer page) {
        if (String.isBlank(query)) {
            return null;
        }
        System.debug(LoggingLevel.INFO, 'rodri 10: ' );

        List<String> articleIds = new List<String>();
        Search.SearchResults searchResults =  Search.find(
            'FIND \'' + query + '\' IN ALL FIELDS RETURNING Knowledge__kav(Id WHERE PublishStatus = \'Online\' LIMIT '
            + SN_Constants.MAX_ARTICLES_ON_PAGE + (page <= 1 ? '' : ' OFFSET ' + ((page - 1) * SN_Constants.MAX_ARTICLES_ON_PAGE) )+ ')'
        );
        System.debug(LoggingLevel.INFO, 'rodri 101: '  + searchResults);

        List<Search.SearchResult> articlelist = searchResults.get('Knowledge__kav');

        for (Search.SearchResult searchResult : articleList) { 
            Knowledge__kav article = (Knowledge__kav) searchResult.getSObject(); 
            System.debug(LoggingLevel.INFO, 'rodri 10: ' + article);
            articleIds.add(article.Id);
        }

        return getArticles(articleIds);

    }

    private static Integer countSearchResults(String query) {
        if (String.isBlank(query)) {
            return null;
        }

        List<Id> articleIds = new List<Id>();
        Search.SearchResults searchResults =  Search.find(
            'FIND \'' + query + '\' IN ALL FIELDS RETURNING Knowledge__kav(Id WHERE PublishStatus = \'Online\')'
        );
        List<Search.SearchResult> articlelist = searchResults.get('Knowledge__kav');

        for (Search.SearchResult searchResult : articleList) { 
            Knowledge__kav article = (Knowledge__kav) searchResult.getSObject(); 
            articleIds.add(article.Id);
        }

        return articleIds.size();

    }

    private static List<Category> getAllCategories() {
        List<Category> allCatedgories = new List<Category>();

        for (String categoryName : categoriesTree.keySet()) {
            allCatedgories.add(new Category(categoryName));
        }

        return allCatedgories;

    }

    private static List<Section> getSectionsByCategory(String categoryName) {
        List<Section> allSections = new List<Section>();

        for (String sectionItem :
            ((Map<String, String>) ((Map<String, Object>) categoriesTree.get(categoryName))
            .get(SN_Constants.CATEGORY_TREE_SECTIONS)).keySet()) {
            allSections.add(new Section(categoryName, sectionItem, SN_Constants.MAX_ARTICLES_IN_SECTION));
        }

        return allSections;

    }

    private static Map<String, Object> getDescribeDataCategoryGroupStructureResults() {
        Map<String, Object> result = new Map<String, Object>();
        List<DescribeDataCategoryGroupStructureResult> describeCategoryStructureResult;

        try {
            List<DataCategoryGroupSobjectTypePair> pairs = new List<DataCategoryGroupSobjectTypePair>();
            DataCategoryGroupSobjectTypePair p = new DataCategoryGroupSobjectTypePair();
            p.setSobject(SN_Constants.KNOWLEDGE_SOBJECT_NAME);
            p.setDataCategoryGroupName(SN_Constants.KNOWLEDGE_TOP_CATEGORY);
            pairs.add(p);

            describeCategoryStructureResult = Schema.describeDataCategoryGroupStructures(pairs, false);

            for (DescribeDataCategoryGroupStructureResult singleResult : describeCategoryStructureResult) {
                DataCategory [] toplevelCategories =  singleResult.getTopCategories();
                List<DataCategory> allCategories = getCategoriesTree(toplevelCategories, result);
            }

        } catch (Exception e) {
            System.debug(e);
        }

        return result;

    }

    // not flexible method: it is worked only for the structure where are
    // categories - top level and have only one level of subcategories - sections
    private static  DataCategory[] getCategoriesTree(DataCategory [] categories, Map<String, Object> result) {
        if (categories.isEmpty()) {
            return new DataCategory[]{};
        } else {
            DataCategory [] categoriesClone = categories.clone();
            DataCategory category = categoriesClone[0];
            DataCategory[] allCategories = new DataCategory[] { category };
            categoriesClone.remove(0);

            if (category.getName() != SN_Constants.KNOWLEDGE_ALL_CATEGORY && category.getChildCategories().size() > 0) {
                Map<String, String> subcategories = new Map<String, String>();

                for (DataCategory subcategory : category.getChildCategories()) {
                    subcategories.put(subcategory.getName(), subcategory.getLabel());
                }
                
                result.put(category.getName(), new Map<String, Object> {
                    SN_Constants.CATEGORY_TREE_LABEL => category.getLabel(),
                    SN_Constants.CATEGORY_TREE_SECTIONS => subcategories
                });
            }
            categoriesClone.addAll(category.getChildCategories());
            allCategories.addAll(getCategoriesTree(categoriesClone, result));

            return allCategories;
        }

    }


    public class Article {
        Id id;
        String url;
        String url_name;
        String title;
        String body;
        String locale;
        Boolean promoted;
        Integer position;
        Decimal vote_sum;
        Decimal vote_count;
        String section_id;
        String text;

        public Article(Knowledge__kav articleItem) {
            this.id = articleItem.Id;
            //this.url = SN_Constants.ARTICLE_START_URL + articleItem.Id + 'test rodri';
            this.url = SN_Constants.ARTICLE_START_URL + articleItem.Id ;
            this.url_name = '?article=' + articleItem.UrlName ;
            this.title =  articleItem.Title.replaceAll('[\']', '&#39;');
            //this.title =  articleItem.Title;
           this.body = articleItem.Description_Rich_Text__c.escapeUnicode();
            this.vote_sum = getVoteSum(articleItem.Id);
            this.promoted = articleItem.Promoted__c;
 
        }
 
    }

    public class Section {
        String id;
        String name; 
        String description;
        String locale;
        String url;
        String category_id;
        Integer position;
        Integer article_count;
        List<Object> articles;
        Boolean more_articles;

        public Section(String categoryName, String sectionName, Integer articlesLimits) {
            this.id = sectionName;
            this.name = ((Map<String, String>) ((Map<String, Object>) categoriesTree.get(categoryName))
                .get(SN_Constants.CATEGORY_TREE_SECTIONS)).get(sectionName);
            this.url = SN_Constants.SECTION_START_URL + sectionName + '&category=' + categoryName;
            this.category_id = categoryName;
            this.articles = getArticlesBySection(sectionName, articlesLimits);
            this.article_count = countArticles(sectionName);
            this.more_articles = this.article_count > SN_Constants.MAX_ARTICLES_IN_SECTION;

        }

    }

    public class Category {
        String id;
        String name;
        String description;
        String locale;
        String url;
        Integer position;

        public Category(String categoryName) {
            this.id = categoryName;
            this.name = String.valueOf(((Map<String, Object>) categoriesTree.get(categoryName)).get(SN_Constants.CATEGORY_TREE_LABEL));
            this.url = SN_Constants.CATEGORY_START_URL + categoryName;

        }

    }


    public class Homepage {
        List<Category> categories;
        Boolean has_multiple_categories;
        List<Article> promoted_articles;

        public Homepage() {
            try {
                this.categories = getAllCategories();
                this.has_multiple_categories = hasMultipleCategories();
                this.promoted_articles = getAllPromotedArticles();
            } catch(Exception e) {
                pageError = SN_Constants.ERROR_NOT_FOUND;
            }

        }

    }

    public class CategoryPage {
        Category category;
        List<Section> sections;
        List<Article> promoted_articles;

        public CategoryPage(String categoryName) {
            try {
                this.category = new Category(categoryName);
                this.sections = getSectionsByCategory(categoryName);
                this.promoted_articles = getAllPromotedArticles();
            } catch(Exception e) {
                pageError = SN_Constants.ERROR_NOT_FOUND;
            }
        }

    }

    public class SectionPage {
        Section section;
        List<Article> promoted_articles;
        List<Object> breadcrumbs;

        public SectionPage(String categoryName, String sectionName) {
            try {
                this.section = new Section(categoryName, sectionName, null);
                this.promoted_articles = getAllPromotedArticles();
                this.breadcrumbs = getBreadcrumbs(categoryName, sectionName);
            } catch(Exception e) {
                pageError =  SN_Constants.ERROR_NOT_FOUND;
            }

        }

    }

    public class ArticlePage {
        Article article;
        List<Object> attachments;
        List<Object> comments;
        List<Object> comment_sorters;
        List<Object> labels;
        List<Article> promoted_articles;
        Section section;
        List<Object> breadcrumbs;
        List<Article> recent_viewed;

        public ArticlePage(Id articleId) {
            try {
                System.debug(LoggingLevel.info, 'rodri: ' + articleId);
                Knowledge__DataCategorySelection dataCategorySelection = [
                    SELECT DataCategoryName
                    FROM Knowledge__DataCategorySelection
                    WHERE ParentId = :articleId
                    LIMIT 1
                ];

                String categoryName;

                for (String categoryItem : categoriesTree.keySet()) {
                    Map<String, String> sectionData =
                        (Map<String, String>) ((Map<String, Object>) categoriesTree.get(categoryItem)).get(SN_Constants.CATEGORY_TREE_SECTIONS);

                    for (String sectionItem : sectionData.keySet()) {
                        if (sectionItem == dataCategorySelection.DataCategoryName) {
                            categoryName = categoryItem;
                            break;
                        }
                    }
                }
                SN_Recent_Articles__c cts = SN_Recent_Articles__c.getOrgDefaults();

                this.article = getArticleById(articleId);

                this.promoted_articles = getAllPromotedArticles();

                this.section = new Section(categoryName, dataCategorySelection.DataCategoryName, SN_Constants.MAX_ARTICLES_ON_PAGE);

                this.breadcrumbs = getBreadcrumbs(categoryName, dataCategorySelection.DataCategoryName);

                this.recent_viewed = getArticles(cts.Recent_Articles__c.split('[,]'));

            } catch(Exception e) {
                System.debug('Exception e '+e);
                System.debug('Exception e '+e.getLineNumber());
                pageError = SN_Constants.ERROR_NOT_FOUND;
            }
        }

    }

    public class SearchResults {
        String query;
        List<Article> article_results;
        Integer results_count;
        
        public SearchResults(String query, Integer page) {
            try {
                this.query = query.escapeUnicode();
                this.article_results = search(query.escapeUnicode(), page);
                this.results_count = countSearchResults(query.escapeUnicode());
            } catch(Exception e) {
                // pageError = SN_Constants.ERROR_NOT_FOUND;
                this.query = query;
                this.article_results = new List<Article>();
                this.results_count = 0;
            }

        }

    }

}