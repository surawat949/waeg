/**
 * @description       : 
 * @author            : Fazurulla Ganganapalli (Encora)
 * @group             : 
 * @last modified on  : 07-06-2022
 * @last modified by  : Fazurulla Ganganapalli (Encora)
**/

public class serviceFlow_QualityReturnTemplate_Ctrl {
    @AuraEnabled 
    public static Map<String,Object> fetchUserConfigDetails(String recordId){
        Map<String,Object> configMap = new Map<String,Object>();
        User currentUser = [Select Id,Name,Country__c,Country_for_Customer_Support__c From User
            where Id=:UserInfo.getUserId()
        ];
        configMap.put('userInfo',currentUser);
        Case caseRec = [Select Id,OwnerId,Owner.Name,serviceFlow_Customer_code__c,
            serviceFlow_Report_numnber__c,serviceFlow_Box_Number__c,serviceFlow_Notes__c,
            serviceFlow_Free_Text_for_notes__c,serviceFlow_Hoya_Delivery_note__c,serviceFlow_Defect__c,
            serviceFlow_Parameters_checked__c,serviceFlow_Customer_Email__c,ContactId,Contact.Email,serviceFlow_Contact_Email__c,
            AccountId,Account.Name,Customer_Name__c,Date_of_the_complaint__c,Date_of_Hoya_delivery_note__c,HAPL_Lens_Type__c,Lenstype__c
            From Case 
            Where Id=:recordId
        ];
        List<serviceFlow_AS400_Data__c> as400Data = new List<serviceFlow_AS400_Data__c>();
        if(String.isNotBlank(caseRec.serviceFlow_Customer_code__c)){
            as400Data = fetchAS400Data(caseRec.serviceFlow_Customer_code__c);
        }
        configMap.put('customerEmailPopulate',String.isNotBlank(caseRec.ContactId) && String.isNotBlank(caseRec.Contact.Email) ? caseRec.Contact.Email : caseRec.serviceFlow_Customer_Email__c);
        configMap.put('teamInfo',[select Id,Name from group where name = 'Customer Service' limit 1]);
        configMap.put('caseInfo',caseRec);
        configMap.put('as400data',as400Data);
        configMap.put('ParametersChecked',getParameters());
        return configMap;
    }
    @AuraEnabled 
    public static List<serviceFlow_AS400_Data__c> fetchAS400Data(String customerCode){
        return [Select Id,Name,ADD__c,AXIS__c,CILSIGN__c,CILVAL__c,COAT__c,COLOR__c,CUSTOMER__c,DAYRCV__c,DEPODLVRY__c,LENSTYPE__c,MAGADLVRY__c,
        MONTHRCV__c,NUMDLVRY__c,RCVNO__c,SPHSIGN__c,SPHVAL__c,TRAYNO__c,YEARDLVRY__c,YEARRCV__c From serviceFlow_AS400_Data__c Where CUSTOMER__c=:customerCode];
    }
    @AuraEnabled 
    public static Map<String, String> getParameters(){
        Map<String, String> options = new Map<String, String>();        
        Schema.DescribeFieldResult fieldResult = Case.serviceFlow_Parameters_checked__c.getDescribe();        
        List<Schema.PicklistEntry> pValues = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pValues) {            
            options.put(p.getValue(), p.getLabel());
        }
        return options;
    }
    @AuraEnabled
    public static List<Case> doUpsertCase(List<Case> caseRecord, String eventType){                
        try{            
            upsert caseRecord; 
            if(caseRecord.size() > 0){
                  sendOutBoundEmailUtility(caseRecord.get(0),eventType);
            } 
            return caseRecord;
        }
        catch(DMLException e){
           AuraHandledException auraEx = new AuraHandledException(e.getMessage());
        }    
        return new List<Case>();
    }
    
    public static void sendOutBoundEmailUtility(Case caseRecord, String eventType){
        List<String> userEmailList = new List<String>();
        String subject = 'Quality Return Details';
        if(eventType.equalsIgnoreCase('esclate_Next_Level')){            
            for(User userRec : [SELECT Id, firstName, lastName, email FROM User WHERE Id IN ( SELECT userOrGroupId FROM GroupMember WHERE  Group.Name = 'Customer Service' ) AND isActive = true]){
                userEmailList.add(userRec.email);
            }
            subject = 'Customer Service Escalation';
        } else if(eventType.equalsIgnoreCase('save_send_email') && String.isNotBlank(caseRecord.serviceFlow_Customer_Email__c)){                
            userEmailList.add(caseRecord.serviceFlow_Customer_Email__c);
        }
        if(userEmailList.size() > 0){
            List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();
            List<EmailMessage> emailMessageList = new List<EmailMessage>();
            EmailTemplate et = [SELECT Id,HtmlValue,Body FROM EmailTemplate WHERE DeveloperName = 'serviceFlow_ItalyQualityReturn_Template'];
            String body = et != null ? et.HtmlValue : null;
            if(String.isNotBlank(body)){
                body = body.replace('{contactName}','');
            }
            
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setToAddresses(userEmailList);
            message.setSubject(subject);
            message.setHtmlBody(body);        
            PageReference pdf = Page.serviceFlow_VF_QualityReturn_Pdf; 
            pdf.getParameters().put('Id', caseRecord.Id); 
            pdf.getParameters().put('caseEmailBody', JSON.serialize(caseRecord));
            //pdf.getParameters().put('as400Data', JSON.serialize(as400Data)); 
           
            Blob pdfAttachment;
            try {
                pdfAttachment = pdf.getContentAsPDF();
            }
            catch (Exception e) {
                pdfAttachment = Blob.valueOf(e.getMessage());
            }        
            Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
            attachment.setContentType('application/pdf');
            attachment.setFileName('Responso tecnico.pdf');
            attachment.setInline(false);
            attachment.setBody(pdfAttachment);
            message.setFileAttachments(new Messaging.EmailFileAttachment[]{ attachment });
            mails.add(message);
            EmailMessage caseEmailMessage = new EmailMessage();
            caseEmailMessage.fromAddress= UserInfo.getUserEmail();
            caseEmailMessage.ToAddress = String.join(userEmailList,',');
            caseEmailMessage.FromName = UserInfo.getName();
            caseEmailMessage.Subject = subject;
            caseEmailMessage.HtmlBody = body;
            caseEmailMessage.Incoming= False;
            caseEmailMessage.TextBody = body;
            caseEmailMessage.relatedToId = caseRecord.Id;   
            caseEmailMessage.status = '3';
            emailMessageList.add(caseEmailMessage);
            if(mails.size() > 0){
                List<Messaging.SendEmailResult> emailSentResultList = Messaging.sendEmail(mails);
                if(emailMessageList.size() > 0){
                    insert emailMessageList;
                    EmailMessageRelation emr = new EmailMessageRelation();
                    emr.EmailMessageId = emailMessageList.get(0).id;
                    emr.RelationAddress = UserInfo.getUserEmail();
                    emr.RelationType = 'FromAddress';
                    emr.relationId = UserInfo.getUserId(); 
                    insert emr;
                    Attachment obj = new Attachment();
                    obj.Body = pdfAttachment;
                    obj.ParentId = emailMessageList.get(0).id;
                    obj.Name = 'Responso tecnico.pdf';
                    obj.ContentType = 'application/pdf';
                    insert obj;
                }
            }
        }
    }
}