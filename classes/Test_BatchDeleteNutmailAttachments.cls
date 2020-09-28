@IsTest
private class Test_BatchDeleteNutmailAttachments {

    @IsTest
    static void test() {
        ContentVersion cv1 = new ContentVersion();
        cv1.Title = 'test title';
        cv1.ContentUrl = '/ContentUrl/test';
        cv1.Nutmail_Attachment__c = true;
        insert cv1;

        ContentVersion cv2 = new ContentVersion();
        cv2.Title = 'test title';
        cv2.ContentUrl = '/ContentUrl/test';
        insert cv2;

        List<ContentVersion> cvAllList1 = [
            SELECT Id
            FROM ContentVersion
        ];
        System.assertEquals(cvAllList1.size(), 2);

        Test.startTest();
        Database.executeBatch(new BatchDeleteNutmailAttachments());
        Test.stopTest();

        List<ContentVersion> cvAllList2 = [
            SELECT Id
            FROM ContentVersion
        ];
        System.assertEquals(cvAllList2.size(), 1);
    }

}