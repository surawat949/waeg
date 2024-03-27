public class EndChatButtonController {
    public static Boolean isCmpVisible{get;set;}
public ApexPages.StandardController stdController;
    
    public EndChatButtonController(ApexPages.StandardController controller) {
        stdController = controller;
        isCmpVisible = true;
    }
    
    public void updateRecord() {
        try{
            Id recordId = stdController.getId();
            isCmpVisible = false;
            /*String sObjName = recordId.getSObjectType().getDescribe().getName();
            sObject sobjList = Database.query('SELECT id, Last_SMS_Send__c FROM '+sObjName+ ' WHERE id =\'' + recordId + '\' limit 1');
            Datetime currentDatetime = Datetime.now();
            sobjList.put('Last_SMS_Send__c', currentDatetime);
            update sobjList;*/
        }catch(Exception e){
            System.debug('Exception : '+e.getLineNumber());
        }
    }
    
}