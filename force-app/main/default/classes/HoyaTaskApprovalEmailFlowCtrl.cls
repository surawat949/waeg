/*
     * @Author : Fazurulla
     * @Class name : HoyaTaskApprovalEmailFlowCtrl
     * Created date : 2024-21-05
     * @Created by : Fazurulla
     * @Description : The provided Apex code defines a class HoyaTaskApprovalEmailFlowCtrl that sends customized email notifications based on different task approval events using Salesforce messaging framework.

 */
 
public class HoyaTaskApprovalEmailFlowCtrl {
    
    // Map to store email subjects based on event type
    public static final Map<String, String> eventTypeToSubjectMap = new Map<String, String>{
        'Submit_for_approval' => 'New Approval Request!',
        'Approve' => 'Your request has been approved!',
        'Reject' => 'Your request has been rejected!'
    };

    @InvocableMethod(label='Send Email')
    public static void sendEmail(List<RequestWrapper> requestWrappers) {
        RequestWrapper requestWrapper = requestWrappers[0];
        List<Id> recordIds = requestWrapper.recordIds;
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        for(Task taskRec : [SELECT Id, Owner.Email,Owner.FirstName,Owner.LastName, CreatedBy.Name,CreatedBy.Email, Instructions__c,
                                AccountId, Account.Name, Account.Owner.Email,Account.Owner.Manager.Email,Account.Hoya_Account_ID__c,
                                Account.Owner.Name,Account.OwnerId,Account.CHCUSTCLASSIFICATIONID__c,
                                Account.Segmentation_Net__c,Account.Strategic_Value_Gross_Sales__c,Account.Strategic_Value_Net_Sales__c,
                                Account.Agreed_Visits__c,Account.Agreed_No_of_Digital_Visits__c,Account.Total_Visits_Planned__c,Account.Total_Visits_Achieved__c,Account.Requested_Direct_Visits__c,
                                Account.Requested_Digital_Visits__c
                                FROM Task WHERE Id IN :recordIds]){
            String subject = eventTypeToSubjectMap.get(requestWrapper.eventType);
            String body = prepareEmailTemplate(taskRec,requestWrapper.eventType);
            String email = (requestWrapper.eventType == 'Submit_for_approval') ? taskRec.Owner.Email : taskRec.CreatedBy.Email;
            emailList.add(sendEmail(email, subject, body));
        }

        try {
            Messaging.SendEmailResult[] results = Messaging.sendEmail(emailList);
            for (Messaging.SendEmailResult result : results) {
                if (!result.isSuccess()) {
                    System.debug('Email failed to send. Error: ' + result.getErrors()[0].getMessage());
                }
            }
        } catch (Exception e) {
            System.debug('Exception occurred while sending email: ' + e.getMessage());
        }
    }

    // Method to send email
    public static Messaging.SingleEmailMessage sendEmail(String toAddress, String subject, String body) {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new String[] { toAddress });
        email.setSubject(subject);
        email.setHtmlBody(body);
        return email;
    }

   // Method to prepare email template
    public static String prepareEmailTemplate(Task taskRec, String eventType){
        if(eventType == 'Submit_for_approval'){
            return '<body style="font-family: courier, serif;"><p>Dear '+taskRec.Owner.FirstName+' '+taskRec.Owner.LastName+',</p>' +
            '<p>You are kindly requested by <b>'+UserInfo.getFirstName()+' '+UserInfo.getLastName()+'</b> to authorize the new visit planning frequency as follow:</p>' +
            '<ul>' +
            '<li><b><font color="blue">Requested Direct Visit: '+taskRec.Account.Requested_Direct_Visits__c+'</font></b></li>' +
            '<li><b><font color="blue">Requested Digital Visit: '+taskRec.Account.Requested_Digital_Visits__c+'</font></b></li>' +
            '<p>for the following customer:</p>'+
            '<li>Account name: '+taskRec.Account.Name+'</li>' +
            '<li>Account code: '+taskRec.Account.Hoya_Account_ID__c+'</li>' +
            '<li>Account owner: '+taskRec.Account.Owner.Name+'</li>' +
            '<li>Account HVC Channel: '+taskRec.Account.CHCUSTCLASSIFICATIONID__c+'</li>' +
            '<li>Segmentation: '+taskRec.Account.Segmentation_Net__c+'</li>' +
            '<li>Strategic value: '+taskRec.Account.Strategic_Value_Gross_Sales__c+'</li>' +
            '<b><li>Direct visit planned (current value): '+taskRec.Account.Agreed_Visits__c+'</li>' +
            '<li>Digital visit planned (current value): '+taskRec.Account.Agreed_No_of_Digital_Visits__c+'</li>' +
            '<li>Total visit planned (current value): '+taskRec.Account.Total_Visits_Planned__c+'</li>' +
            '<li>Total Visit achieved (current value): '+taskRec.Account.Total_Visits_Achieved__c+'%</li></b>' +            
            '</ul>' +
            '<p>Please, approve or reject following the Link to the task: '+URL.getOrgDomainURL().toExternalForm() +'/'+taskRec.Id+'</p>' +
            '<p>Contact your Local SFDC expert, in case you need more information or support.</p>'+
            'With Best Regards,<br/>'+
            'SFDC Global Team / Commercial Excellence Team</body>';
        }else if(eventType == 'Approve'){
            return '<html><body style="font-family: courier, serif;">' +
            '<p>Your Request on visit planning changes for account ('+taskRec.Account.Hoya_Account_ID__c+') ('+taskRec.Account.Name+'), has been approved</p>' +
            '<p><strong>Comment:</strong>'+taskRec.Instructions__c+'</p>' +
            '<p>Link to the Task : '+URL.getOrgDomainURL().toExternalForm() +'/'+taskRec.Id+'</p>' +
            '</body></html>';
        }else if(eventType == 'Reject'){
            return '<html><body style="font-family: courier, serif;">' +
            '<p>Your Request on visit planning changes for account ('+taskRec.Account.Hoya_Account_ID__c+') ('+taskRec.Account.Name+'), has been rejected</p>' +
            '<p><strong>Comment:</strong> '+taskRec.Instructions__c+' </p>' +
            '<p>Link to the Task : '+URL.getOrgDomainURL().toExternalForm() +'/'+taskRec.Id+'</p>' +
            '</body></html>';
        }
        return null;
    }
    // Inner class to hold request wrapper
    public class RequestWrapper {
        @InvocableVariable(required=true)
        public List<Id> recordIds;
        @InvocableVariable(required=true)
        public String eventType;
    }
}