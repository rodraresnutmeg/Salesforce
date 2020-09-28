public with sharing class ZendeskAPI {

    public static RecordType availableRecordType = [SELECT Id FROM RecordType WHERE SobjectType = 'Knowledge__kav' AND Name = 'FAQ' LIMIT 1];
    public static Map<String, Object> categoryStructure =  ZendeskAPI.getDescribeDataCategoryGroupStructureResults();

    public static final Map<String, String> zendeskSectionIdToSfCategory = new Map<String, String>{
        '115000083612' => 'General_Lifetime_ISA_Information',
        '115000078651' => 'General_Pension_Information',
        '115000083412' => 'ISA_and_General_Accounts_Paying_in',
        '115000083592' => 'ISA_Transfers',
        '115000078471' => 'Pension_Paying_in',
        '115000082672' => 'FAQ',
        '115000083632' => 'Opening_an_account',
        '115000083572' => 'ISA_and_General_Accounts_General_Information',
        '115000083432' => 'Lifetime_ISA_Withdrawals',
        '115000078851' => 'Your_Portfolio',
        '115000083452' => 'Pension_Transfers',
        '115000078451' => 'ISA_and_General_Accounts_Withdrawals',
        '115000083652' => 'Everything_Else',
        '115000078891' => 'Company_Information',
        '115000078871' => 'Reports_and_Statements',
        '115000078911' => 'Compliance',
        '115000078811' => 'Pension_Withdrawals_drawdown',
        '360001598397' => 'General_Junior_ISA_Information'
    };

    private static final String CATEGORY_ENDPOINT = 'https://nutmeg.zendesk.com/api/v2/help_center/en-us/categories.json';
    private static final String SECTION_ENDPOINT = 'https://nutmeg.zendesk.com/api/v2/help_center/en-us/sections.json';
    private static final String ARTICLE_ENDPOINT = 'https://nutmeg.zendesk.com/api/v2/help_center/en-us/articles.json';
    private static final String USERNAME = 'max.rae@nutmeg.com';
    private static final String PASSWORD = 'Godel87';
    
    public static void main() {
        Map<String, String> categories = ZendeskAPI.getAllCategories();
        Map<String, ZendeskAPI.Section> sections = ZendeskAPI.getAllSections(categories);
        ZendeskAPI.getAllArticles(sections);

    }

    public static void getAllArticles(Map<String, ZendeskAPI.Section> sections) {
        getAllArticles(ARTICLE_ENDPOINT, sections);

    }

    public static void getAllArticles(String endpoint, Map<String, ZendeskAPI.Section> sections) {
        Integer currentPage = 0;
        Integer countPages = 0;
        List<Object> articlesToSave = new List<Object>();

        do {
            HttpRequest req = new HttpRequest();
            req.setMethod('GET');
            req.setEndpoint(endpoint);

            Blob headerValue = Blob.valueOf(USERNAME + ':' + PASSWORD);
            String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
            req.setHeader('Authorization',  authorizationHeader);

            Http http = new Http();
            HTTPResponse res = http.send(req);

            Map<String, Object> responsMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            endpoint = (String) responsMap.get('next_page');
            currentPage = (Integer) responsMap.get('page');
            countPages = (Integer) responsMap.get('page_count');
            articlesToSave.addAll((List<Object>) responsMap.get('articles'));
        } while (currentPage < countPages);

        if (currentPage == countPages) {
            List<Knowledge__kav> knowledgeArticles = new List<Knowledge__kav>();

            for (Object article : articlesToSave) {
                Map<String, Object> item = (Map<String, Object>) article;

                knowledgeArticles.add(new Knowledge__kav(
                    Title = (String) item.get('title'),
                    Description_Rich_Text__c = (String) item.get('body'),
                    Zendesk_Section_Id__c = String.valueOf(item.get('section_id')),
                    UrlName = removeUnavailableURLSymbols((String) item.get('html_url')),
                    RecordTypeId = availableRecordType.Id,
                    IsVisibleInPkb = true,
                    IsVisibleInCsp = true,
                    IsVisibleInPrm = true
                ));
            }

            Database.UpsertResult[] urList = Database.upsert(knowledgeArticles, false);
            List<Id> upsertedArticle = new List<Id>();
            
            for (Database.UpsertResult ur : urList) {
                if (ur.isSuccess()) {
                    System.debug('Successfully inserted. Knowledge ID: ' + ur.getId());
                    upsertedArticle.add(ur.getId());
                } else {
                    for (Database.Error err : ur.getErrors()) {
                        System.debug('The following error has occurred.');
                        System.debug(ur);
                    }
                }
            }

            List<Knowledge__DataCategorySelection> dataCategorySelections = new List<Knowledge__DataCategorySelection>();
            for (Knowledge__kav article : knowledgeArticles) {
                //if(upsertedArticle.contains(article.Id)){
                    dataCategorySelections.add(createKnowledgeDataCategorySelection(article, sections));
                    System.debug(dataCategorySelections);
                //}
            }

            Database.UpsertResult[] dtcList = Database.upsert(dataCategorySelections, false);

            for (Database.UpsertResult ur : dtcList) {
                if (ur.isSuccess()) {
                    System.debug('Successfully inserted. Data category ID: ' + ur.getId());
                    System.debug(ur);
                    upsertedArticle.add(ur.getId());
                } else {
                    for (Database.Error err : ur.getErrors()) {
                        System.debug('The following error has occurred.');
                        System.debug(ur);
                    }
                }
            }

        }

    }

    public static Knowledge__DataCategorySelection createKnowledgeDataCategorySelection(Knowledge__kav article, Map<String, ZendeskAPI.Section> sections) {
      //  String categoryNameApi;
      //String categoryName = sections.get(article.Zendesk_Section_Id__c).NameCategory;
      //  String sectionName = sections.get(article.Zendesk_Section_Id__c).NameSection;
      //  Map<String, String> allSFsections = (Map<String, String>) ((Map<String, Object>) categoryStructure.get(categoryName)).get('sections');

      //  for (String key : allSFsections.keySet()) {
      //      if (key.toLowerCase().contains(sectionName.toLowerCase())) {
      //          categoryNameApi = key;
      //          break;
      //      }
      //  }

        return new Knowledge__DataCategorySelection(
            ParentId = article.Id,
            DataCategoryGroupName = SN_Constants.KNOWLEDGE_TOP_CATEGORY,
            DataCategoryName  = zendeskSectionIdToSfCategory.get(article.Zendesk_Section_Id__c)
        );

    }


    private static Map<String, String> getAllCategories() {
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint(CATEGORY_ENDPOINT);

        Blob headerValue = Blob.valueOf(USERNAME + ':' + PASSWORD);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization',  authorizationHeader);

        Http http = new Http();
        HTTPResponse res = http.send(req);

        Map<String, Object> responsMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        System.debug(responsMap);
        List<Object> allCategories = (List<Object>) responsMap.get('categories');

        Map<String, String> categoriesMap = new Map<String, String>();

        for (Object categoryItem : allCategories) {
            Map<String, Object> item = (Map<String, Object>) categoryItem;

            categoriesMap.put(
                String.valueOf(item.get('id')),
                String.valueOf(item.get('name')).replace(' ', '_').toLowerCase()
            );
        }       
        
        return categoriesMap;

    }

    private static Map<String, ZendeskAPI.Section> getAllSections(Map<String, String> categories) {
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint(SECTION_ENDPOINT);

        Blob headerValue = Blob.valueOf(USERNAME + ':' + PASSWORD);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization',  authorizationHeader);

        Http http = new Http();
        HTTPResponse res = http.send(req);

        Map<String, Object> responsMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        List<Object> allSections = (List<Object>) responsMap.get('sections');

        Map<String, ZendeskAPI.Section> sectionsForUpsert = new Map<String, ZendeskAPI.Section>();

        for (Object sectionItem : allSections) {
            Map<String, Object> item = (Map<String, Object>) sectionItem;

            sectionsForUpsert.put(
                String.valueOf(item.get('id')),
                new Section(
                    String.valueOf(item.get('name')).replace(' ', '_').toLowerCase(), 
                    categories.get(String.valueOf(item.get('category_id')))
                )
            );
        }

        return sectionsForUpsert;

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

    // not a flexible method: it is worked only for the structure where are
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
                
                result.put(category.getName().toLowerCase(), new Map<String, Object> {
                    SN_Constants.CATEGORY_TREE_LABEL => category.getLabel(),
                    SN_Constants.CATEGORY_TREE_SECTIONS => subcategories
                });
            }
            categoriesClone.addAll(category.getChildCategories());
            allCategories.addAll(getCategoriesTree(categoriesClone, result));

            return allCategories;
        }

    }

    private static String removeUnavailableURLSymbols(String str) {
        Set<String> unavailableSymbols = new Set<String>{ '-', '_' };

        String resultString = str.trim().replaceAll('[_]', '-').substring(str.lastIndexOf('/') + 1, str.length());
        String lastSymbol = resultString.substring(resultString.length() - 1, resultString.length());

        if (unavailableSymbols.contains(lastSymbol)) {
            return resultString.substring(0, resultString.length() - 1);
        }

        return resultString;

    }

    public class Section{
        public String NameSection;
        public String NameCategory;  

        public Section(String NameSection, String NameCategory) {
            this.NameSection = NameSection;
            this.NameCategory = NameCategory;
        }

    }

}