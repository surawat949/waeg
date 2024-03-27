@isTest
public class serviceFlow_EmailMessageTest {    
    @isTest static void testUpdateCaseDetails() {
        List<ServiceFlowEmailConfig__mdt> configRecord = ServiceFlowEmailConfig__mdt.getAll().values();
        String recordTypeId = Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosByName().get('ServiceFlow Case Create').getRecordTypeId();

        Case testCase = new Case(
            RecordTypeId = recordTypeId,
            Priority = 'Low',
            Origin = 'E-Mail',
            OwnerId = UserInfo.getUserId(),
            User_country__c = 'Spain'
            //SFlow_Subject__c = 'Correo',
            //SFlow_Sub_Subject__c = 'Pedidos'
        );
        insert testCase;
        
        EmailMessage email = new EmailMessage();
        email.FromAddress = 'abonos@hoya.es';
        email.Incoming = True;
        email.ToAddress= 'abonos@hoya.es';
        email.Subject = 'Test email';
        email.HtmlBody = 'Test email body';
        email.ParentId = testCase.Id; 
        insert email;

        Test.startTest();
            serviceFlow_EmailMessageTriggerHandler.updateCaseDetails(new List<EmailMessage>{email});
            serviceFlow_EmailMessageTriggerHandler.mapCaseDetailsUtility(testCase,configRecord.get(0));
        Test.stopTest();
    }
}