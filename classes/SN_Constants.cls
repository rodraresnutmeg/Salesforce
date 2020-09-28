/**********************************************************************
Purpose:

Constant values for SN_Controller
======================================================
Test class:

Test_SN_Controller
======================================================
History
-------
Date        AUTHOR                 	DETAIL
08/16/2019  Kseniya Hanchuk         CRM-247: Initial version
***********************************************************************/

public without sharing class SN_Constants {

    public static final String CATEGORY_START_URL = '?category=';
    public static final String SECTION_START_URL = '?section=';
    public static final String ARTICLE_START_URL = '?article=';

    public static final String KNOWLEDGE_SOBJECT_NAME = 'KnowledgeArticleVersion';
    public static final String KNOWLEDGE_TOP_CATEGORY = 'Topics';
    public static final String KNOWLEDGE_ALL_CATEGORY = 'All';

    public static final String CATEGORY_TREE_LABEL = 'label';
    public static final String CATEGORY_TREE_SECTIONS = 'sections';

    public static final Integer MAX_ARTICLES_ON_PAGE = 10;
    public static final Integer MAX_ARTICLES_IN_SEARCH = 6;
    public static final Integer MAX_RECENT_ARTICLES = 5;
    public static final Integer MAX_ARTICLES_IN_SECTION = 6;

    public static final String ERROR_UNAUTHORIZED = 'unauthorized';
    public static final String ERROR_FORBIDDEN = 'forbidden';
    public static final String ERROR_NOT_FOUND = 'not_found';

}