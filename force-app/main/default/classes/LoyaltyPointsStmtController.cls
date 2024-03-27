public class LoyaltyPointsStmtController {

    public String accountName {get; set;}
    public String accountNumber {get; set;}
    public String street {get; set;}
    public String city {get; set;}
    public String today {get; set;}
    public String totalPoints {get; set;}
    public String dateStart {get; set;}
    public String dateEnd {get; set;}
    public String accId {get; set;}
    public String footer {get; set;}
    public List<Loyalty_points__c> accs {get;set;}

    public LoyaltyPointsStmtController() {
        accountName = ApexPages.currentPage().getParameters().get('accountName');
        accountNumber = ApexPages.currentPage().getParameters().get('accountNumber');
        street = ApexPages.currentPage().getParameters().get('street');
        city = ApexPages.currentPage().getParameters().get('city');
        today = ApexPages.currentPage().getParameters().get('today');
        totalPoints = ApexPages.currentPage().getParameters().get('totalPoints');
        dateStart = ApexPages.currentPage().getParameters().get('dateStart');
        dateEnd = ApexPages.currentPage().getParameters().get('dateEnd');
        accId = ApexPages.currentPage().getParameters().get('accId');
        footer = ApexPages.currentPage().getParameters().get('footer');
        Date eDate;
        Date sDate;
        if (!Test.isRunningTest()) {
        	eDate = Date.parse(dateEnd);
        	sDate = Date.parse(dateStart);    
        }
        
        accs = [Select name, Points__c, Description__c, date_Of_transaction__c From Loyalty_points__c Where Account__c =: accId AND date_Of_transaction__c <= :eDate AND date_Of_transaction__c >= :sDate limit 38];


    }

    @AuraEnabled 
    public static String generateCertificate(String accountId, Date startDate, Date endDate,list<String> emailAddresses, String brand) {
        String returnMsg = 'Success';
        
        try {
            Account account = [SELECT Name, Seiko_local_customer_nr__c,Brand__c, Shop_Street__c, Shop_Postal_Code__c, Shop_City__c, Shop_State__c, Shop_Country__c,Total_Loyalty_Points__c FROM Account Where Id =:accountId];
            //List<String> emailAddresses = new List<String>();
            List<Loyalty_points__c> loyaltyPoints = [Select name, Points__c, Description__c From Loyalty_points__c Where Account__c = :accountId AND date_Of_transaction__c <= :endDate AND date_Of_transaction__c >= :startDate];

            String str;
            if(brand == 'SEIKO'){
                if (!loyaltyPoints.isEmpty()) {
                    if (loyaltyPoints.size() > 38) {
                        return 'exceeded'; // records more than enough for a single page
                    }
                    emailAddresses.add(UserInfo.getUserEmail());
                    
                    PageReference pdfPage = Page.LoyaltyPointsStmtPage;
                    //set parameters for vf page here
                    pdfPage.getParameters().put('accountName', account.Name);
                    pdfPage.getParameters().put('accountNumber', account.Seiko_local_customer_nr__c);
                    pdfPage.getParameters().put('street', account.Shop_Street__c);
                    pdfPage.getParameters().put('city', account.Shop_Postal_Code__c + '/' + account.Shop_City__c);
                    pdfPage.getParameters().put('today', Date.today().format());
                    pdfPage.getParameters().put('totalPoints', String.valueOf(account.Total_Loyalty_Points__c));
                    pdfPage.getParameters().put('dateStart', startDate.format());
                    pdfPage.getParameters().put('dateEnd', endDate.format());
                    pdfPage.getParameters().put('accId', accountId);

                    if (account.Shop_Country__c != null || account.Shop_Country__c != '') {
                        List<Entity_detail__mdt> seikoEntity = new List<Entity_detail__mdt>();
                        seikoEntity = [Select Entity_Name__c, Address__c, Country__c, Country_Code__c FROM Entity_detail__mdt WHERE Country_Code__c =: account.Shop_Country__c AND Brand__c =: account.Brand__c];
                        if (!seikoEntity.isEmpty()) {
                            pdfPage.getParameters().put('footer', seikoEntity[0].Entity_Name__c + ' / ' + seikoEntity[0].Address__c);
                        }
                    }
                    //Blob pdfBlob = pdfPage.getContent();  

                    returnMsg = sendEmail(pdfPage, emailAddresses, brand);//EncodingUtil.base64Encode(pdfBlob);
                } else {
                    return 'NoRecords';
                }
            }else{
                if(!loyaltyPoints.isEmpty()){
                    if(loyaltyPoints.size()>38){
                        return 'exceeded';     //if return more than 38 records
                    }
                    emailAddresses.add(UserInfo.getUserEmail());

                    PageReference pdfPageHoya = Page.LoyaltyPointsStmPage_Hoya;
                    pdfPageHoya.getParameters().put('accountName', account.Name);
                    pdfPageHoya.getParameters().put('accountNumber', account.Seiko_local_customer_nr__c);
                    pdfPageHoya.getParameters().put('street', account.Shop_Street__c);
                    pdfPageHoya.getParameters().put('city', account.Shop_Postal_Code__c + '/' + account.Shop_City__c);
                    pdfPageHoya.getParameters().put('today', Date.today().format());
                    pdfPageHoya.getParameters().put('totalPoints', String.valueOf(account.Total_Loyalty_Points__c));
                    pdfPageHoya.getParameters().put('dateStart', startDate.format());
                    pdfPageHoya.getParameters().put('dateEnd', endDate.format());
                    pdfPageHoya.getParameters().put('accId', accountId);

                    if(account.Shop_Country__c!=null || account.Shop_Country__c!=''){
                        List<Entity_detail__mdt> hoyaEntity = new List<Entity_detail__mdt>();
                        hoyaEntity = [SELECT Entity_Name__c, Address__c, Country__c, Country_Code__c FROM Entity_detail__mdt WHERE Brand__c=:account.Brand__c AND Country_Code__c=:account.Shop_Country__c];
                        if(!hoyaEntity.isEmpty()){
                            pdfPageHoya.getParameters().put('footer', hoyaEntity[0].Entity_Name__c + ' / ' + hoyaEntity[0].Address__c);
                        }
                    }
                    returnMsg = sendEmail(pdfPageHoya, emailAddresses, brand);

                }else{
                    return 'No record.';
                }
            }
        } catch (Exception ex) {
            
            throw new AuraHandledException(ex.getMessage());
        }
        return returnMsg;
    }

    public static String sendEmail(PageReference pdfPage, List<String> emailAddresses, String brand) {
        String returnMsg = 'Success';
        System.debug('### Start Send the email with account brand '+brand);
        try {
            
            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            attach.setContentType('application/pdf');
            attach.setFileName('Loyalty Points statement.pdf');
            attach.setInline(false);
            if(!test.isRunningTest()){
                attach.Body = pdfPage.getContent();
            }else{
                attach.Body = blob.valueof('TEST');
            }

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<OrgWideEmailAddress> orgWideEmail = [SELECT Id, Address, DisplayName, IsAllowAllProfiles, Purpose FROM OrgWideEmailAddress WHERE Address = 'do_not_reply@seikovision.com'];
            List<OrgWideEmailAddress> HoyaOrgWideEmail = [SELECT Id, Address, DisplayName, IsAllowAllProfiles, Purpose FROM OrgWideEmailAddress WHERE Address = 'salesforce@hoya.eu'];
            

            if(brand == 'SEIKO'){
                mail.setOrgWideEmailAddressId(orgWideEmail[0].Id);
            }else{
                mail.setOrgWideEmailAddressId(HoyaOrgWideEmail[0].Id);
            }
            mail.setUseSignature(false);
            mail.setToAddresses(emailAddresses);
            List<EmailTemplate> emailTemplate;
            List<EmailTemplate> HoyaEmailTemplate;

            emailTemplate = [Select Id, Subject, Description, HtmlValue, DeveloperName,Body from EmailTemplate where DeveloperName ='Seiko_Loyalty_Points_Statement'];
            

            HoyaEmailTemplate = [SELECT Id, Subject, Description, HtmlValue, DeveloperName, Body FROM EmailTemplate WHERE DeveloperName = 'Hoya_Loyalty_Points_Statement'];
            

            if (!emailTemplate.isEmpty()) {
                if(brand=='SEIKO'){
                    mail.setTemplateID(emailTemplate[0].Id);
                }else{
                    mail.setTemplateID(HoyaEmailTemplate[0].Id);
                }    
            } else {
                returnMsg = 'templateError';
                return returnMsg;
            }
            mail.setTargetObjectId(UserInfo.getUserId()); // required for template.
            mail.setTreatTargetObjectAsRecipient(false); // dont send mail to above Id
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach }); 
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            

        } catch (Exception ex) {
            
            throw new AuraHandledException(ex.getMessage());
        }
        return returnMsg;
    }
}