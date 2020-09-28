/**
 * @who		: Timothy Gentet-O'Brien <timothy@empaua.com>
 * @when	: 2018-03-02
 * @what	: Test class for the ChildCaseGeneratorController class
*/
@IsTest
public class ChildCaseGeneratorControllerTest {

    @TestSetup
    static void setup() {
        Test_Trig_Case.setup();
    }

    @IsTest public static void testGetCaseQueues(){
        ChildCaseGeneratorController.getCaseQueues();
    }

    @IsTest public static void testSaveCase(){
        Contact con = new Contact(
            LastName = 'Name'
        );

        insert con;

        Case cas = new Case(
            ContactId = con.Id
        );

        insert cas;

        ChildCaseGeneratorController.Response res = ChildCaseGeneratorController.getTemplates(
            cas.Id,
            con.Id
        );

        System.assert(res != null);
        System.assert(res.isSuccess);

        Case newCase = [SELECT Id FROM Case WHERE ContactId != NULL];
        ChildCaseGeneratorController.Response reso = ChildCaseGeneratorController.saveCase('QA',new Case(ParentId = cas.Id));

        System.assert(reso != null);
        System.assert(reso.isSuccess);
    }
}