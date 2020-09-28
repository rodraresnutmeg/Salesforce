global without sharing class SN_URL_Rewriter implements Site.UrlRewriter {
    String START_URL = '/';
    String HOMEPAGE_VF = '/SN_Layout';
    String CATEGORY_PAGE_VF = '/SN_CategoryPage';
    String SECTION_PAGE_VF = '/SN_SectionPage';
    String ARTICLE_PAGE_VF = '/SN_ArticlePage';

    String HOMEPAGE = '/hc/en-us';
    String CATEGORY_PAGE = '/hc/en-us/categories/';
    String SECTION_PAGE = '/hc/en-us/sections/';
    String ARTICLE_PAGE = '/hc/en-us/articles/';

    Map<String, String> VFPAGE_TO_FRIENDLY_URL = new Map<String, String> {
        '/apex/SN_Layout' => '/hc/en-us',
        '/apex/SN_Layout?category=' => '/hc/en-us/categories/',
        '/apex/SN_Layout?section=' => '/hc/en-us/sections/',
        '/apex/SN_Layout?article=' => '/hc/en-us/articles/',
        '/apex/SN_Layout?query=' => '/hc/en-us/search/'
    };

    global PageReference mapRequestUrl(PageReference myFriendlyUrl) {
        String url = myFriendlyUrl.getUrl();

        if (url.startsWith(CATEGORY_PAGE)) {
            return new PageReference('/hc' + CATEGORY_PAGE_VF);
        }
        if (url.startsWith(SECTION_PAGE)) {
            return new PageReference('/hc' + SECTION_PAGE_VF);
        }
        if (url.startsWith(ARTICLE_PAGE)) {
            return new PageReference('/hc' + ARTICLE_PAGE_VF);
        }
        if (url.startsWith(HOMEPAGE)) {
            return new PageReference('/hc' + HOMEPAGE_VF);
        }

        return null;

    }

    global List<PageReference> generateUrlFor(List<PageReference> mySalesforceUrls) {
        List<PageReference> friendlyUrls = new List<PageReference>();

      for (PageReference mySalesforceUrl : mySalesforceUrls) {
           String url = mySalesforceUrl.getUrl();
            
            if (url.startsWith(CATEGORY_PAGE_VF)) {
                friendlyUrls.add(new PageReference(CATEGORY_PAGE));
            } else if (url.startsWith(SECTION_PAGE_VF)) {
             friendlyUrls.add(new PageReference(SECTION_PAGE));
            } else if (url.startsWith(ARTICLE_PAGE_VF)) {
             friendlyUrls.add(new PageReference(ARTICLE_PAGE));
            } else if (url.startsWith(HOMEPAGE_VF) || url.startsWith(START_URL)) {
             friendlyUrls.add(new PageReference(HOMEPAGE));
           } else {
             friendlyUrls.add(mySalesforceUrl);
           }
      }

      return friendlyUrls;

    }

}