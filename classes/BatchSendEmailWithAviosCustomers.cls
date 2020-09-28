/**********************************************************************
Purpose:

Some description
======================================================

Test class:
Test_BatchSendEmailWithAviosCustomers

======================================================
History
-------
Date        AUTHOR                 	DETAIL
03/23/2020  Kseniya Hanchuk         MASQ-1067: Initial version
***********************************************************************/

public class BatchSendEmailWithAviosCustomers implements Database.Batchable<SObject>, Database.Stateful, Schedulable {

    public static final String TABLE_NAME_COLUMN            = 'Name';
    public static final String TABLE_EMAIL_COLUMN           = 'Email';
    public static final String TABLE_AVIOSNUMBER_COLUMN     = 'Avios Number';
    public static final String TABLE_IPSENUMBER_COLUMN      = 'IPSE Number';
    public static final String TABLE_CUSTODIANNUMBER_COLUMN = 'Custodian Number';
    public static final String TABLE_TOTALPOTS_COLUMN       = 'Total Pots Current Value';

    public static final Scheduled_Email_Sending_Configs__c EMAIL_SENDING_CONFIGS = Scheduled_Email_Sending_Configs__c.getOrgDefaults();

    public static final List<String> ACCOUNT_FIELDS = new List<String> {
        'Id',
        'PersonEmail',
        'Name',
        'AviosMembershipNumber__pc',
        'Total_Pots_Current_Value__c',
        'NI_Number__c',
        'IPSE_Number__pc',
        'FormName__pc'
    };
    /*
     * Get all avios customers with populated Derived First Investment Date in last 24 hours.
     */
    public static final List<String> ACCOUNT_AND_CONDITION = new List<String> {
        'FormName__pc IN (\'avios\', \'ipse\')',
        'Derived_First_Investment_Date__pc != NULL',
        'LastModifiedDate = YESTERDAY'
    };

    @TestVisible
    static List<AviosCustomerData> newAviosCustomers = new List<AviosCustomerData>();
    @TestVisible
    static List<IPSECustomerData> newIPSECustomers = new List<IPSECustomerData>();

    String query = 'SELECT {0} FROM Account WHERE {1}';


    public void execute(SchedulableContext ctx) {
        Database.executeBatch(new BatchSendEmailWithAviosCustomers(), 1000);
    }


    public Database.QueryLocator start(Database.BatchableContext bc) {
        if (Test.isRunningTest()) {
            this.query = String.format(query, new List<String> {
                String.join(ACCOUNT_FIELDS, ', '),
                ACCOUNT_AND_CONDITION[0] + ' AND ' + ACCOUNT_AND_CONDITION[1]
            });
        } else {
            this.query = String.format(query, new List<String> {
                String.join(ACCOUNT_FIELDS, ', '),
                String.join(ACCOUNT_AND_CONDITION, ' AND ')
            });
        }

        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<Account> scope) {
        for (Account accItem : scope) {
            if (accItem.FormName__pc.compareTo('avios') == 0) {
                AviosCustomerData newAviosCustomer = new AviosCustomerData();
                newAviosCustomer.email = accItem.PersonEmail;
                newAviosCustomer.customerName = accItem.Name;
                newAviosCustomer.aviosNumber = accItem.AviosMembershipNumber__pc;
                newAviosCustomer.totalPotsValue = accItem.Total_Pots_Current_Value__c;
                newAviosCustomer.custodianNumber = accItem.NI_Number__c;
                newAviosCustomers.add(newAviosCustomer);
            } else if (accItem.FormName__pc.compareTo('ipse') == 0) {
                IPSECustomerData  newIPSECustomer = new IPSECustomerData();
                newIPSECustomer.email = accItem.PersonEmail;
                newIPSECustomer.customerName = accItem.Name;
                newIPSECustomer.ipseNumber = String.valueOf(accItem.IPSE_Number__pc);
                newIPSECustomer.totalPotsValue = accItem.Total_Pots_Current_Value__c;
                newIPSECustomer.custodianNumber = accItem.NI_Number__c;
                newIPSECustomers.add(newIPSECustomer);
            }
        }

    }

    public void finish(Database.BatchableContext bc) {
        if (newAviosCustomers.size() > 0) {
            try {
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { aviosMail() });
            }
            catch (EmailException e) {
                System.debug('BatchSendEmailWithAviosCustomers: Error during sendMail: ' + e);
            }
        }

        if (newIPSECustomers.size() > 0) {
            try {
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { ipseMail() });
            }
            catch (EmailException e) {
                System.debug('BatchSendEmailWithAviosCustomers: Error during sendMail: ' + e);
            }
        }

    }

    private static Messaging.SingleEmailMessage aviosMail() {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> toAddresses = EMAIL_SENDING_CONFIGS.Emails_Avios__c.split('[,]');
        mail.setToAddresses(toAddresses);
        mail.setSubject('New Avios Customers');

        String htmlBody = '<table border="1"><thead><tr>'
            + '<th>' + TABLE_NAME_COLUMN + '</th>'
            + '<th>' + TABLE_EMAIL_COLUMN + '</th>'
            + '<th>' + TABLE_AVIOSNUMBER_COLUMN + '</th>'
            + '<th>' + TABLE_CUSTODIANNUMBER_COLUMN + '</th>'
            + '<th>' + TABLE_TOTALPOTS_COLUMN + '</th>'
            + '</tr></thead><tbody>';

        for (AviosCustomerData aviosCustomer : newAviosCustomers) {
            htmlBody += '<tr><td>' + aviosCustomer.customerName + '</td>';
            htmlBody += '<td>' + aviosCustomer.email + '</td>';
            htmlBody += '<td>' + aviosCustomer.aviosNumber + '</td>';
            htmlBody += '<td>' + aviosCustomer.custodianNumber + '</td>';
            htmlBody += '<td>' + aviosCustomer.totalPotsValue + '</td></tr>';
        }

        htmlBody += '</tbody></table>';
        mail.setHtmlBody(htmlBody);

        return mail;

    }

    private static Messaging.SingleEmailMessage ipseMail() {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> toAddresses = EMAIL_SENDING_CONFIGS.Emails_IPSE__c.split('[,]');
        mail.setToAddresses(toAddresses);
        mail.setSubject('New IPSE Customers');

        String htmlBody = '<table border="1"><thead><tr>'
            + '<th>' + TABLE_NAME_COLUMN + '</th>'
            + '<th>' + TABLE_EMAIL_COLUMN + '</th>'
            + '<th>' + TABLE_IPSENUMBER_COLUMN + '</th>'
            + '<th>' + TABLE_CUSTODIANNUMBER_COLUMN + '</th>'
            + '<th>' + TABLE_TOTALPOTS_COLUMN + '</th>'
            + '</tr></thead><tbody>';

        for (IPSECustomerData ipseCustomer : newIPSECustomers) {
            htmlBody += '<tr><td>' + ipseCustomer.customerName + '</td>';
            htmlBody += '<td>' + ipseCustomer.email + '</td>';
            htmlBody += '<td>' + ipseCustomer.ipseNumber + '</td>';
            htmlBody += '<td>' + ipseCustomer.custodianNumber + '</td>';
            htmlBody += '<td>' + ipseCustomer.totalPotsValue + '</td></tr>';
        }

        htmlBody += '</tbody></table>';
        mail.setHtmlBody(htmlBody);

        return mail;

    }


    public class AviosCustomerData {
        String email;
        String customerName;
        String aviosNumber;
        Decimal totalPotsValue;
        String custodianNumber;

    }

    public class IPSECustomerData {
        String email;
        String customerName;
        String ipseNumber;
        Decimal totalPotsValue;
        String custodianNumber;

    }

}