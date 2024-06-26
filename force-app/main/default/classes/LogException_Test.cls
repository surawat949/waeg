@isTest
public class LogException_Test {
 
    /*@isTest
    public static void test1()
    {
        try
        {
           integer i = 1/0;    
        }
        catch(exception ex)
        {
            new LogException()
                .Module('unitTestModule')
                .Log(ex);
        }
    }*/
    
    @isTest
    public static void test2()
    {
        try
        {
          Account acc = [SELECT Id, Name FROM Account 
                         WHERE Name =  '7uygft6'];            
        }
        catch(exception ex)
        {
            LogException.Log(ex);
        }
        
    }
    @isTest
    public static void logTest()
    {
       Test.startTest();
           List<String> allErrors = new List<String> {
               'DML Exception',
               'String Exception'
           };
           LogException.log('VisitsPlannedAutomationBatch','execute','DMLException',JSON.SerializePretty(allErrors));
       Test.stopTest();
        
    }
 }