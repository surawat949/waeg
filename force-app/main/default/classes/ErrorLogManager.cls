public class ErrorLogManager {
    public ErrorLogManager() {

    }

    public static void createExceptionLog(Exception ex, String className, String methodName) {
        try {
            Error_Log__c errLog = new Error_Log__c();
            errLog.Class_Name__c = className;
            errLog.Method_Name__c = methodName;
            errLog.Message__c = ex.getMessage();
            errLog.Exception_Cause__c = String.valueOf(ex.getCause());
            errLog.Exception_Type__c = ex.getTypeName();
            errLog.Line_Number__c = ex.getLineNumber();
            errLog.Stacktrace__c = ex.getStackTraceString();
            insert errLog;   
        } catch (Exception exc) {
            ErrorLogManager.createExceptionLog(exc, 'ErrorLogManager', 'createExceptionLog');
        }
    }

    public static void createExceptionLog(List<Database.SaveResult> saveResultList, String className, String methodName) {
        // TODO: Process saveResult to save in error log
    }
}