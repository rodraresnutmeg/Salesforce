@IsTest
private class Test_AccountTriggerHandler {

    @IsTest
    static void test() {
        Account a1 = new Account();
        a1.LastName = 'testName';
        insert a1;

        a1.Phone_Opt_Out__pc = true;
        update a1;

        List<Account> accList = [
            SELECT
                Id,
                Phone_Opt_Out__pc,
                PhoneOptOutChangedBy__pc,
                Phone_Opt_Out_Changed_Date__pc
            FROM Account
        ];

        for (Account acc : accList) {
            System.assertEquals(acc.Phone_Opt_Out__pc, true);
            System.assertNotEquals(acc.Phone_Opt_Out_Changed_Date__pc, null);
            System.assertNotEquals(acc.PhoneOptOutChangedBy__pc, null);
        }
    }

}