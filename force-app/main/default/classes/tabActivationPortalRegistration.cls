public class tabActivationPortalRegistration {
    
    @AuraEnabled
    public static list<ContactWrapperClass> getRegistratedContact(String receivedId){
        List<ContactWrapperClass> wrapperList = new List<ContactWrapperClass>();
        list<ID> listOfContactId = new list<Id>();
        map<id,date> mapOfContactIdWithLoginDate= new map<id,date>();
       for(Contact conObj : [SELECT Id, Name,Portal_User_Name__c,Send_Registration_Email_Flag__c,Contact_Record_Type__c,Recordtype.developerName, Salutation,CreatedDate, Title, Email, Phone 
                              FROM Contact where AccountId=:receivedId AND 
                              recordtype.developerName not IN('End_Consumer','Subscription')]){
              
              ContactWrapperClass wrapperClass = new ContactWrapperClass();
             if(conObj.Portal_User_Name__c =='' || conObj.Portal_User_Name__c ==null){
                  wrapperClass.RegistratedFlag=false;
              }
              else{
                  listOfContactId.add(conObj.Id);
                  wrapperClass.RegistratedFlag=true;
              }                     
              wrapperClass.name = conObj.Name;
              wrapperClass.Id = conObj.Id;
              wrapperClass.RecordTypeName = conObj.Contact_Record_Type__c;
              wrapperClass.Email = conObj.Email;
              wrapperClass.EmailFlag = conObj.Send_Registration_Email_Flag__c;                    
              wrapperList.add(wrapperClass);
               
        }
        if(listOfContactId.size()>0){
        	 for(User userObj : [SELECT LastLoginDate,ContactId FROM User WHERE ContactId IN :listOfContactId  
                                 ORDER BY LastLoginDate DESC NULLS LAST]){
              mapOfContactIdWithLoginDate.put(userObj.contactId,date.valueOf(userObj.LastLoginDate));
        }    
        }
       
        for(ContactWrapperClass wrapperObj : wrapperList){
            if(mapOfContactIdWithLoginDate.keyset().contains(wrapperObj.Id)){
                   wrapperObj.lastLogin = mapOfContactIdWithLoginDate.get(wrapperObj.Id);
            }    
         }
        return wrapperList;
    }
	
	@AuraEnabled(cacheable=true)
    public static List<Account_Template__c> getAccountTemplateIdFromAccount(String receivedId){
        try {
            List<Account_Template__c> accTemplate = [SELECT Id, Account__c, Name FROM Account_Template__c WHERE Account__c=:receivedId LIMIT 1];
            if(!accTemplate.isEmpty()){
                //System.debug('Account Template => '+accTemplate);
                return accTemplate;
            }else{
                return null;
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
	
    class ContactWrapperClass{
        @AuraEnabled
        public date lastLogin;
        @AuraEnabled public string name{get;set;}
        @AuraEnabled public string Id{get;set;}
        @AuraEnabled public string RecordTypeName{get;set;}
        @AuraEnabled public string Email{get;set;}
        @AuraEnabled public Boolean EmailFlag{get;set;}
        @AuraEnabled public Boolean RegistratedFlag{get;set;}
        
    }
}