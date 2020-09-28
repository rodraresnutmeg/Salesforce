public with sharing class AccountTriggerHandler {

    public static void beforeUpdate(List<Account> newContacts, Map<Id, Account> oldContactsMap) {
        for (Account c : newContacts) {
            if (c.Phone_Opt_Out__pc != oldContactsMap.get(c.Id).Phone_Opt_Out__pc) {
                c.PhoneOptOutChangedBy__pc       = System.UserInfo.getUserId();
                c.Phone_Opt_Out_Changed_Date__pc = System.now();
            }
        }
    }

}