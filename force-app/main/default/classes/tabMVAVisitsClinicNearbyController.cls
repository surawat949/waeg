public with sharing class tabMVAVisitsClinicNearbyController {

    private static final string CONTACT_RT = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Opthalmologist').getRecordTypeId();

    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountsNearBy(String recordId, Double distance,String MiyoSmartAuth, Integer prescribers){
        
        try {
            
            List<Account> result = new List<Account>();

            Account acc = [SELECT Id, Hoya_Account_ID__c, Name, ShippingLatitude, ShippingLongitude, Shop_Street__c, Shop_City__c, Shop_State__c, Shop_Country__c, Shop_Postal_Code__c,  
                            Phone, Record_Type_Name__c, Brand__c, Segmentation_Net__c, Myo_Smart_AuthorizeDealer__c, Last_Visit_date__c, 
                            First_Competitor_global_name__c, First_Competitor_local_name__c, First_Competitor_SOW__c, RecordType.DeveloperName, Clinic_Name__c, 
                            (SELECT Id, Name FROM Contacts WHERE recordtypeid=:CONTACT_RT), 
                            (SELECT Id, Contact.Name FROM AccountContactRelations WHERE contact.recordtypeId=:CONTACT_RT AND Account.RecordTypeId!=null) FROM Account WHERE Id=:recordId];
            result.add(acc);

            String accountId = acc.Id;
            Double latitude = acc.ShippingLatitude;
            Double longitude = acc.ShippingLongitude;

            if(acc.ShippingLatitude == null){latitude = 0;}
            if(acc.ShippingLongitude == null){longitude = 0;}

           /* if(AccType != null && AccType != '' && AccType != 'No Filter'){
                AccType = ' and Clinic_type__c like \'%'+AccType+'%\' ';
            } else {
                AccType = '';
            }*/

            String IsMyoSmart = '';

            if (MiyoSmartAuth != null && MiyoSmartAuth == 'YES'){
                IsMyoSmart = ' and Myo_Smart_AuthorizeDealer__c=true';
            }else if (MiyoSmartAuth != null && MiyoSmartAuth == 'NO'){
                IsMyoSmart = ' and Myo_Smart_AuthorizeDealer__c=false';
            }

            /*String soql = 'SELECT Id, Hoya_Account_ID__c, Name, ShippingStreet, ShippingCity, ShippingState, ShippingCountry, ShippingPostalCode, Clinic_Name__c, Last_Visit_date__c, '
                        + 'ShippingLatitude, ShippingLongitude, Record_Type_Name__c, Phone, Segmentation_Net__c, Brand__c, Myo_Smart_AuthorizeDealer__c, First_Competitor_global_name__c, First_Competitor_local_name__c, First_Competitor_SOW__c, RecordType.DeveloperName, '
                        + '(SELECT Id, Name FROM Contacts WHERE RecordType.DeveloperName=:CONTACT_RT), (SELECT Id, Contact.Name FROM AccountContactRelations WHERE Contact.RecordTypeId=:CONTACT_RT AND Account.RecordTypeId!=null) FROM Account WHERE '
                        + 'DISTANCE(ShippingAddress, GEOLOCATION('+latitude+', '+longitude+'), \'km\')<'+distance + IsMyoSmart +' AND Hoya_Account_ID__c <> \''+accountId+'\' ORDER BY CreatedDate DESC LIMIT 500'; */
            String soql =  'SELECT Id, Hoya_Account_ID__c, Name, Shop_Street__c, Shop_City__c, Shop_State__c, Shop_Postal_Code__c, Shop_Country__c, ' +
                            'Phone, Record_Type_Name__c, Brand__c, Segmentation_Net__c, Myo_Smart_AuthorizeDealer__c, Last_Visit_date__c, ' +
                            'First_Competitor_global_name__c, First_Competitor_local_name__c, First_Competitor_SOW__c, RecordType.DeveloperName, Clinic_Name__c, ' +
                            '(SELECT Id, Name FROM Contacts WHERE recordtypeid=:CONTACT_RT), ' +
                            '(SELECT Id, Contact.Name FROM AccountContactRelations WHERE ' + 
                            'contact.recordtypeId=:CONTACT_RT AND Account.RecordTypeId!=null) FROM Account WHERE Id <>: accountId AND ' +
                            'DISTANCE(ShippingAddress, GEOLOCATION('+latitude+', '+longitude+'), \'km\')<'+distance + IsMyoSmart + ' ORDER BY CreatedDate DESC LIMIT 500';
            
            System.debug('soql == > '+soql);

            List<Account> aList = database.query(soql);
            
            if (prescribers > 0) {
                for (Account eachAcc : aList) {
                    if (eachAcc.Contacts.size() >= prescribers) {
                        result.add(eachAcc);
                    }
                }    
            } else {
                result.addAll(aList);    
            }
            System.debug('Return Value == > '+result);
            return result;


        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class AccountWrapperClass{
        @AuraEnabled public List<Account> accountList;
        @AuraEnabled public Integer PreferredNumberPrescriber{get;set;}
        @AuraEnabled public Integer TotalNumberPrscriber{get;set;}
    }

    @AuraEnabled(cacheable=true)
    public static List<AccountWrapperClass> getContactsListNearby(String recordId, Double distance,String MiyoSmartAuth, Integer prescribers){
        try {
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    /*  @AuraEnabled(cacheable=true)
    public static List<optionSet> getAccClinicTypeValue(){
        try {
            Schema.DescribeFieldResult fieldResult = Account.Clinic_type__c.getDescribe();
            List<Schema.PicklistEntry> pEntry = fieldResult.getPicklistValues();
            List<optionSet> dataset = new List<optionSet>();
            for(Schema.PicklistEntry picklistval : pEntry){
                String pListLabelName = picklistval.getLabel();
                String pListValue = picklistval.getValue();

                dataset.add(new optionSet(pListLabelName, pListValue));

            }
            
            return dataset;
        } catch (Exception e) {
            
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class optionSet{
        public optionSet(String label, String values){
            this.Label = label;
            this.values = values;
        }

        @AuraEnabled public String label{get;set;}
        @AuraEnabled public String values{get;set;}
    }*/

}