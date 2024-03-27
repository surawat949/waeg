@isTest
public class ErrorLogManager_Test {
    @isTest
    private static void testLogs(){
        Test.startTest();
        try {
            ErrorLogManager errManagr = new ErrorLogManager();
            List<Database.SaveResult> saveResultList;
            ErrorLogManager.createExceptionLog(saveResultList, '', '');
            integer a = 2-2;
            a = 2/a;
        } catch(Exception ex) {
            ErrorLogmanager.createExceptionLog(ex, 'TestClass', 'TestMethod');
        }
        Test.stopTest();
    }
}