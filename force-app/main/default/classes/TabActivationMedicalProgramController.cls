public  class TabActivationMedicalProgramController {
    public TabActivationMedicalProgramController() {

    }

    public class ContactNearby{
        @AuraEnabled public string contactId{get;set;}
        @AuraEnabled public string contactName{get;set;}
        @AuraEnabled public string accountId{get;set;}
        @AuraEnabled public string accountName{get;set;}
        @AuraEnabled public double accountShippingLatitude{get;set;}
        @AuraEnabled public double accountShippingLongitude{get;set;}
        @AuraEnabled public string accountShopName{get;set;}
        @AuraEnabled public string accountHoyaAccId{get;set;}
        @AuraEnabled public string accountShippingStreet{get;set;}
        @AuraEnabled public string accountShippingCity{get;set;}
        @AuraEnabled public string accountShippingState{get;set;}
        @AuraEnabled public string accountShippingCountry{get;set;}
        @AuraEnabled public string accountShippingPostalCode{get;set;}
        @AuraEnabled public string accountPhone{get;set;}
        @AuraEnabled public string accountRecType{get;set;}
    }
    
    @AuraEnabled
    public static List<AccountContactRelation> getContactList(Id recordId){
        try {
           
            List<AccountContactRelation> contactList = [select id, Contact.Title, Roles,Contact.Account.Name, ContactId, contact.name, isdirect
            , Contact.MailingCity, Contact.MailingPostalCode,Contact.Education__c, Contact.Salutation
            from AccountContactRelation where accountID =:recordId and Contact.RecordType.DeveloperName = 'Opthalmologist'];
        
            return contactList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static String createAccountContactRel(Id accountId, Id contactId){
        try{

                String result;
                
                List<AccountContactRelation>  acList =   [Select Id,AccountId from AccountContactRelation  where ContactId =:contactId and AccountId = :accountId ];
                if(acList.isEmpty()){
                
                        
                        AccountContactRelation accCon = new AccountContactRelation(AccountId = accountId, ContactId = contactId);
                        insert accCon;
                        result = 'Success';
                }
                    
                    else{
                        result = 'Duplicate';
                    }
                    return result;
                
            
        }
        catch(Exception e){
            
            throw new AuraHandledException(e.getMessage());
           
        }
       

    }
      
    @AuraEnabled
    public static void deleteRelationShip(Id recordId){
        try {
            AccountContactRelation record = [select id from AccountContactRelation where id=:recordId];
            delete record;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<ContactNearby> getContactNearby(String recordId, Double distance, String firstSpeciality, String miyosmartAttitude, String totalPrescribingSegmentation, String miyosmartSegmentation){
        try {
            List<ContactNearby> dataList = new List<ContactNearby>();
            
            Set<Id> uniqueIds = new Set<Id>();
            Double shippingLatitude =0.0;
            Double shippingLongitude = 0.0;

            for (Account eachRelation : [SELECT Id, Name,ShippingCity,RecordType.DeveloperName,Hoya_Account_ID__c,ShippingCountry,ShippingLatitude,ShippingLongitude,ShippingPostalCode,ShippingState, ShippingStreet,Phone FROM Account  Where Id= :recordId]) {
                ContactNearby wrapper = new ContactNearby();
                
                if (eachRelation.ShippingPostalCode == null && eachRelation.ShippingLatitude == null) {
                    // skip the account due to lack of proper address
                    continue;    
                }
               
                wrapper.accountId = eachRelation.Id;
                wrapper.accountName = eachRelation.Name;
                wrapper.accountHoyaAccId = eachRelation.Hoya_Account_ID__c;
                wrapper.accountShippingStreet = eachRelation.ShippingStreet;
                wrapper.accountShippingCity = eachRelation.ShippingCity;
                wrapper.accountShippingState = eachRelation.ShippingState;
                wrapper.accountShippingCountry = eachRelation.ShippingCountry;
                wrapper.accountShippingPostalCode = eachRelation.ShippingPostalCode;
                wrapper.accountPhone = eachRelation.Phone;
                wrapper.accountRecType = eachRelation.RecordType.DeveloperName;
                
                if(eachRelation.ShippingLatitude == null) { 
                    //continue;
                    wrapper.accountShippingLatitude = 0;
                    shippingLatitude = 0;
                   
                } else {
                    wrapper.accountShippingLatitude = eachRelation.ShippingLatitude;
                    shippingLatitude = eachRelation.ShippingLatitude;
                }
                if(eachRelation.ShippingLongitude == null) { 
                    wrapper.accountShippingLongitude = 0;
                    shippingLongitude = 0;
                    
                } else {
                    wrapper.accountShippingLongitude =eachRelation.ShippingLongitude;
                    shippingLongitude = eachRelation.ShippingLongitude;
                }
                

                // duplication check set
                uniqueIds.add(eachRelation.Id);
                dataList.add(wrapper);
            }
            
           
          String queryRelatedContacts = 'SELECT Id,Name,AccountId,Phone,RecordType.DeveloperName, Account.Hoya_Account_ID__c, MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry, MailingLatitude, MailingLongitude FROM Contact where '
            + 'DISTANCE(MailingAddress, GEOLOCATION('+shippingLatitude+', '+shippingLongitude+'), \'km\')<'+distance+' AND RecordType.DeveloperName = \'Opthalmologist\' '+' ';
          
          
            if(firstSpeciality!=null && firstSpeciality!='No Filter'&& firstSpeciality!='' ){
                queryRelatedContacts +=' AND First_Speciality__c LIKE \''+firstSpeciality+'\'';
            }
            if(miyosmartAttitude!=null && miyosmartAttitude!='No Filter'&& miyosmartAttitude!=''){
                queryRelatedContacts += ' AND  MiyoSmart_Attitude__c LIKE \''+miyosmartAttitude+'\'';
            }
           
            if(miyosmartSegmentation!=null && miyosmartSegmentation!='No Filter' && miyosmartSegmentation!=''){
                if(miyosmartSegmentation == 'A'){
                    queryRelatedContacts +=' AND MiyoSmart_Segmentation__c  LIKE \'A_\' ';
                   
                }
                else  if(miyosmartSegmentation == 'B'){
                    queryRelatedContacts +=' AND MiyoSmart_Segmentation__c LIKE \'B_\' ';
                   
                }
                else if(miyosmartSegmentation == 'C'){
                    queryRelatedContacts +=' AND MiyoSmart_Segmentation__c LIKE \'C_\' ';
                  

                }
                else if(miyosmartSegmentation == 'Uncategorized'){
                    queryRelatedContacts +=' AND MiyoSmart_Segmentation__c LIKE \'Uncategorized\' ';
                    

                }
               

            }
            if(totalPrescribingSegmentation!=null && totalPrescribingSegmentation!='No Filter'&& totalPrescribingSegmentation!='' ){
                if(totalPrescribingSegmentation == 'A'){
                    queryRelatedContacts +=' AND Total_Prescribing_Segmentation__c LIKE \'A_\' ';
                        }
                else  if(totalPrescribingSegmentation == 'B'){
                    queryRelatedContacts +=' AND Total_Prescribing_Segmentation__c LIKE \'B_\' ';
                         }
                else if(totalPrescribingSegmentation == 'C'){
                    queryRelatedContacts +=' AND Total_Prescribing_Segmentation__c LIKE \'C_\' ';
                }
                else if(totalPrescribingSegmentation == 'Uncategorized'){
                    queryRelatedContacts +=' AND Total_Prescribing_Segmentation__c LIKE \'Uncategorized\' ';
                  
                }

            }
           List<Contact> prescribersNearBy = database.query(queryRelatedContacts);

           for (Contact eachRelation : prescribersNearBy) {

            ContactNearby contactWrapper = new ContactNearby();

            if (eachRelation.MailingPostalCode == null && eachRelation.MailingLatitude == null) {
                
                continue;    
            }
           
           
            contactWrapper.contactName = eachRelation.Name;
            contactWrapper.contactId = eachRelation.Id;
            contactWrapper.accountHoyaAccId = eachRelation.Account.Hoya_Account_ID__c;
            contactWrapper.accountShippingStreet = eachRelation.MailingStreet;//, MailingCity, MailingState, MailingPostalCode, MailingCountry, MailingLatitude, MailingLongitude
            contactWrapper.accountShippingCity = eachRelation.MailingCity;
            contactWrapper.accountShippingState = eachRelation.MailingState;
            contactWrapper.accountShippingCountry = eachRelation.MailingCountry;
            contactWrapper.accountShippingPostalCode = eachRelation.MailingPostalCode;
            contactWrapper.accountPhone = eachRelation.Phone;
            contactWrapper.accountRecType = eachRelation.RecordType.DeveloperName;


            if(eachRelation.MailingLatitude == null) { 
                //continue;
                contactWrapper.accountShippingLatitude = 0;
            } else {
                contactWrapper.accountShippingLatitude = eachRelation.MailingLatitude;
            }
            if(eachRelation.MailingLongitude == null) { 
                contactWrapper.accountShippingLongitude = 0;
            } else {
                contactWrapper.accountShippingLongitude = eachRelation.MailingLongitude;
            }
            dataList.add(contactWrapper);
        }
           

            return dataList;
            

        }
       catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

}