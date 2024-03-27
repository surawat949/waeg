public with sharing class tabMVAVisitsClinicNearbyController {

    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountsNearBy(String recordId, Double distance, String AccType, String MiyoSmartAuth, Integer prescribers){
        
        try {
            
            List<Account> result = new List<Account>();

            Account acc = [select Id, Hoya_Account_ID__c, Name, ShippingLatitude, ShippingLongitude, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, 
                            ShippingCountry, Phone, Record_Type_Name__c, Brand__c, Segmentation_Net__c, Myo_Smart_AuthorizeDealer__c,
                            First_Competitor_global_name__c, First_Competitor_local_name__c, First_Competitor_SOW__c, RecordType.DeveloperName, Clinic_Name__c, (select Id, Name from Contacts where recordtype.DeveloperName='Opthalmologist') from account where Id=:recordId];
            result.add(acc);

            Double latitude = acc.ShippingLatitude;
            Double longitude = acc.ShippingLongitude;
            String HoyaAccountId = acc.Hoya_Account_ID__c;

            if(latitude==null){latitude = 0;}
            if(longitude==null){longitude = 0;}

            if(AccType != null && AccType != '' && AccType != 'No Filter'){
                AccType = ' and Clinic_type__c like \'%'+AccType+'%\' ';
            } else {
                AccType = '';
            }

            String IsMyoSmart = '';

            if (MiyoSmartAuth != null && MiyoSmartAuth == 'YES'){
                IsMyoSmart = ' and Myo_Smart_AuthorizeDealer__c=true';
            }else if (MiyoSmartAuth != null && MiyoSmartAuth == 'NO'){
                IsMyoSmart = ' and Myo_Smart_AuthorizeDealer__c=false';
            }

            String soql = 'SELECT Id, Hoya_Account_ID__c, Name, ShippingStreet, ShippingCity, ShippingState, ShippingCountry, ShippingPostalCode, Clinic_Name__c, '
                        + 'ShippingLatitude, ShippingLongitude, Record_Type_Name__c, Phone, Segmentation_Net__c, Brand__c, Myo_Smart_AuthorizeDealer__c, First_Competitor_global_name__c, First_Competitor_local_name__c, First_Competitor_SOW__c, RecordType.DeveloperName, (SELECT Id, Name FROM Contacts WHERE RecordType.DeveloperName=\'Opthalmologist\') FROM Account WHERE '
                        + 'DISTANCE(ShippingAddress, GEOLOCATION('+latitude+', '+longitude+'), \'km\')<'+distance + AccType + IsMyoSmart +' AND Hoya_Account_ID__c <> \''+HoyaAccountId+'\' ORDER BY CreatedDate DESC LIMIT 500';
            

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
            
            return result;


        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=true)
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
    }

}