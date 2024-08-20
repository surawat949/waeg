public without sharing class LogException extends Exception {
    /*public String ModuleName {
        get;
        set;
    }
    public String StackTrace {
        get;
        set;
    }
    public String ClassName {
        get;
        set;
    }
    public String MethodName {
        get;
        set;
    }
    public String ExceptionCause {
        get;
        set;
    }

    public static boolean stopLoop {
        get; set;
    }

    public void log(Exception ex) {
        try {
            extractExceptionData(ex);
            writeToObject(ex);
            System.debug('This is a debug message');
        } catch (Exception e) {
            if (!stopLoop) {
                stopLoop = true;
                new LogException().Module('LogException').log(e);
            }
        }
    }

    public LogException Module(String Name) {
        ModuleName = name;
        return this;
    }

    public LogException ExceptionCause(String cause) {
        ExceptionCause = cause;
        return this;
    }

    public void extractExceptionData(Exception ex) {
        try {
            stackTrace = ex.getStackTraceString()
                .substringBefore('\n');

            className = stackTrace.substringAfter('.')
                .substringBefore('.');

            methodName = stackTrace.substringBefore(':')
                .substringAfter(className)
                .substringAfter('.');
        } catch (Exception e) {
            new LogException().Module('LogException').log(e);
        }
    }
    
    public void writeToObject(Exception ex) {
        if(ex != null){
            Exception_Logger__c logger = new Exception_Logger__c();
            logger.Module_Name__c = ModuleName;
            logger.Stack_Trace__c = ex.getStackTraceString();
            logger.Class_Name__c = className;
            logger.Method_Name__c = methodName;
            logger.Line_Number__c = ex.getLineNumber();
            logger.Exception_Type__c = ex.getTypeName();
            logger.Exception_Cause_Override__c = ExceptionCause;
            logger.Exception_Cause__c = String.valueOf(ex.getCause());

            logger.Exception_Message__c = ex.getMessage();
            
            insert logger;
            system.debug('### Insert exception logger : ' + logger);
        }
    }*/
    
    public static void log(Exception e){
        try{
            String stackTrace = e.getStackTraceString().substringBefore('\n');
            String className = stackTrace.substringAfter('.').substringBefore('.'); 
            String methodName = stackTrace.substringBefore(':').substringAfter(className).substringAfter('.');
                
            //Governer Limit of executingQuery 
            String QueryLimit = '1. SOQL Queries used / SOQL Queries allowed: ' + Limits.getQueries() + '/' + Limits.getLimitQueries();
            String DMLimit = '2. Number of records queried so far /  Number allowed: ' + Limits.getDmlRows() + '/' + Limits.getLimitDmlRows();
            String DMLStat = '3. Number of DML statements used so far / Number allowed: ' +  Limits.getDmlStatements() + '/' + Limits.getLimitDmlStatements();   
            String CPUT = '4. Amount of CPU time (in ms) used so far / CPU usage time (in ms) allowed: ' + Limits.getCpuTime() + '/' + Limits.getLimitCpuTime();
              
            //Log information in object
            Exception_Logger__c exc = new Exception_Logger__c();
            //exc.Related_To_Number__c=relatedToId;
            //exc.Govt_Limit_in_Executing_Code__c = String.format('{0}\n{1}\n{2}\n{3}',new List{QueryLimit, DMLimit,DMLStat,CPUT});
            exc.Exception_Message__c = e.getMessage();
            exc.Exception_Type__c = e.getTypeName();
            exc.Line_Number__c = e.getLineNumber();
            exc.Stack_Trace__c = e.getStackTraceString();
            exc.Method_Name__c=methodName;
            exc.Class_Name__c=className;
            system.debug('#### Insert exceptions ' + exc);
            insert exc;          
        } 
        finally{}            
    }
    public static void log(String className, String methodName, String exceptionType, String errorMessage){
        try{
            Exception_Logger__c exc = new Exception_Logger__c();
            exc.Exception_Message__c = errorMessage;
            exc.Exception_Type__c = exceptionType;
            exc.Method_Name__c = methodName;
            exc.Class_Name__c = className;
            insert exc;          
        }catch(Exception ex){
            LogException.log(ex);
        }
    }
}