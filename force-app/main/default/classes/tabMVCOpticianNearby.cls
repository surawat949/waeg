public with sharing class tabMVCOpticianNearby {

    /**
    * =====================================================
    * @Author : Surawat Sakulmontreechai
    * @CreatedBy : Surawat Sakulmontreechai
    * @Email : surawat.sakulmontreechai@hoya.com
    * @CreatedDate : 2023-07-21
    * @CreatedBy : Surawat Sakulmontreechai
    * @LastmodifiedDate : -
    * @LastmodifiedBy : -
    * @version : 1.0
    * @apiVersion : via api 49.0 or higher (force.com)
    * @description : Below coded for #736 - Optician nearby | task 736
    */

    private static final String ACCOUNT_CLINIC_RT = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Clinic').getRecordTypeId();

    public class ContactNearby{
        @AuraEnabled public string workingId{get;set;}
        @AuraEnabled public string ClinicName{get;set;}
        @AuraEnabled public string accountBrand{get;set;}
        @AuraEnabled public string accountSegmentation{get;set;}
        @AuraEnabled public string FirstCompetitorGlobal{get;set;}
        @AuraEnabled public string FirstCompetitorLocal{get;set;}
        @AuraEnabled public string FirstCompetitorSOW{get;set;}
        @AuraEnabled public string accountMyoSmart{get;set;}
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
        @AuraEnabled public Boolean accConsIsDirect{get;set;}
        @AuraEnabled public Boolean accConsIsActive{get;set;}
    }

    public class optionSet{
        public optionSet(String label, String values){
            this.Label = label;
            this.values = values;
        }

        @AuraEnabled public String label{get;set;}
        @AuraEnabled public String values{get;set;}
    }

    @AuraEnabled(cacheable=true)
    public static List<optionSet> getPicklistVisionaryAlliance(){
        try {
            Schema.DescribeFieldResult fieldResult = Account.Visionary_Alliance__c.getDescribe();
            List<Schema.PicklistEntry> pEntry = fieldResult.getPicklistValues();
            List<optionSet> dataset = new List<optionSet>();

            for(Schema.PicklistEntry picklistval : pEntry){
                String pListLabelName = picklistval.getLabel();
                String pListValue = picklistval.getValue();

                if(pListValue == 'Elite' || pListValue=='Insider' || pListValue=='Pro'){
                    dataset.add(new optionSet(pListLabelName, pListValue));
                    
                }

            }
            //System.debug('XXX Get Visionary Alliance Picklist = >'+dataset);
            return dataset;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<ContactNearby> getContactNearby(String recordId, Double distance, String VisionAll, Boolean IsMyoSmart, Boolean IsHvCenter, Boolean IsSeikoNetwork, String Segmentation){
        try{
            Set<Id> uniqueIds = new Set<Id>();

            // getting all active Working Places for this individual
            List<AccountContactRelation> workingPlacesList = [SELECT Id, ContactId, Contact.Name, 
                                                                AccountId, Account.Name, Account.Shop_Name__c, Account.Hoya_Account_ID__c, 
                                                                Account.Shop_Street__c , Account.Shop_City__c , 
                                                                Account.Shop_State__c , Account.Shop_Country__c , Account.Shop_Postal_Code__c ,
                                                                Account.Phone , Account.RecordType.DeveloperName , Account.First_Competitor_global_name__c , 
                                                                Account.First_Competitor_local_name__c , Account.First_Competitor_SOW__c ,
                                                                Account.Myo_Smart_AuthorizeDealer__c, Account.ShippingLatitude, Account.ShippingLongitude, Account.Clinic_Name__c, 
                                                                Account.Brand__c, Account.Segmentation_Net__c, IsActive, IsDirect FROM AccountContactRelation
                                                                WHERE ContactId=:recordId AND Account.RecordType.DeveloperName='Clinic' AND Account.RecordTypeId != NULL AND IsActive=true];

            
            List<ContactNearby> dataList = new List<ContactNearby>();
            for (AccountContactRelation eachRelation : workingPlacesList) {
                ContactNearby wrapper = new ContactNearby();
                if (eachRelation.Account.Shop_Postal_Code__c == null && eachRelation.Account.ShippingLatitude == null) {
                    // skip the account due to lack of proper address
                    continue;    
                }
                wrapper.workingId = eachRelation.Id;
                wrapper.ClinicName = eachRelation.Account.Clinic_Name__c;
                wrapper.accountBrand = eachRelation.Account.Brand__c;
                wrapper.accountSegmentation = eachRelation.Account.Segmentation_Net__c;
                wrapper.FirstCompetitorGlobal = eachRelation.Account.First_Competitor_global_name__c;
                wrapper.FirstCompetitorLocal = eachRelation.Account.First_Competitor_local_name__c;
                wrapper.FirstCompetitorSOW = eachRelation.Account.First_Competitor_SOW__c;
                wrapper.contactId = eachRelation.ContactId;
                wrapper.contactName = eachRelation.Contact.Name;
                wrapper.accountId = eachRelation.AccountId;
                wrapper.accountName = eachRelation.Account.Name;
                wrapper.accountShopName = eachRelation.Account.Shop_Name__c;
                wrapper.accountHoyaAccId = eachRelation.Account.Hoya_Account_ID__c;
                wrapper.accountShippingStreet = eachRelation.Account.Shop_Street__c;
                wrapper.accountShippingCity = eachRelation.Account.Shop_City__c;
                wrapper.accountShippingState = eachRelation.Account.Shop_State__c;
                wrapper.accountShippingCountry = eachRelation.Account.Shop_Country__c;
                wrapper.accountShippingPostalCode = eachRelation.Account.Shop_Postal_Code__c;
                wrapper.accountPhone = eachRelation.Account.Phone;
                wrapper.accountRecType = eachRelation.Account.RecordType.DeveloperName;
                wrapper.accConsIsActive = eachRelation.IsActive;
                wrapper.accConsIsDirect = eachRelation.IsDirect;

                if(eachRelation.Account.ShippingLatitude == null) { 
                    //continue;
                    wrapper.accountShippingLatitude = 0;
                } else {
                    wrapper.accountShippingLatitude = eachRelation.Account.ShippingLatitude;
                }
                if(eachRelation.Account.ShippingLongitude == null) { 
                    wrapper.accountShippingLongitude = 0;
                } else {
                    wrapper.accountShippingLongitude = eachRelation.Account.ShippingLongitude;
                }
                
                String isMiyoSmartAuthorize = '';
                if(eachRelation.Account.Myo_Smart_AuthorizeDealer__c){
                    isMiyoSmartAuthorize = 'Yes';
                }else{
                    isMiyoSmartAuthorize = 'No';
                }
                wrapper.accountMyoSmart = isMiyoSmartAuthorize;

                // duplication check set
                uniqueIds.add(eachRelation.Accountid);
                dataList.add(wrapper);
            }

            List<AccountContactRelation> WorkingPlaceListNonClinic = [SELECT Id, ContactId, Contact.Name, 
                                                                        AccountId, Account.Name, Account.Shop_Name__c, Account.Hoya_Account_ID__c, 
                                                                        Account.Shop_Street__c, Account.Shop_City__c, 
                                                                        Account.Shop_State__c, Account.Shop_Country__c, Account.Shop_Postal_Code__c ,
                                                                        Account.Phone, Account.RecordType.DeveloperName, Account.First_Competitor_global_name__c, 
                                                                        Account.First_Competitor_local_name__c, Account.First_Competitor_SOW__c,
                                                                        Account.Myo_Smart_AuthorizeDealer__c, Account.ShippingLatitude, Account.ShippingLongitude, Account.Clinic_Name__c, 
                                                                        Account.Brand__c, Account.Segmentation_Net__c, IsDirect, IsActive FROM AccountContactRelation
                                                                        WHERE (ContactId=:recordId) AND (IsDirect = false) AND (Account.RecordTypeId !=: ACCOUNT_CLINIC_RT)];
            
            for(AccountContactRelation eachCon : WorkingPlaceListNonClinic){
                ContactNearby wrapperClass = new ContactNearby();
                if(eachCon.Account.Shop_Postal_Code__c == null && eachCon.Account.ShippingLatitude == null){
                    continue;
                }
                wrapperClass.workingId = eachCon.Id;
                wrapperClass.ClinicName = eachCon.Account.Clinic_Name__c;
                wrapperClass.accountBrand = eachCon.Account.Brand__c;
                wrapperClass.accountSegmentation = eachCon.Account.Segmentation_Net__c;
                wrapperClass.FirstCompetitorGlobal = eachCon.Account.First_Competitor_global_name__c;
                wrapperClass.FirstCompetitorLocal = eachCon.Account.First_Competitor_local_name__c;
                wrapperClass.FirstCompetitorSOW = eachCon.Account.First_Competitor_SOW__c;
                wrapperClass.contactId = eachCon.ContactId;
                wrapperClass.contactName = eachCon.Contact.Name;
                wrapperClass.accountId = eachCon.AccountId;
                wrapperClass.accountName = eachCon.Account.Name;
                wrapperClass.accountShopName = eachcon.Account.Shop_Name__c;
                wrapperClass.accountHoyaAccId = eachCon.Account.Hoya_Account_ID__c;
                wrapperClass.accountShippingStreet = eachCon.Account.Shop_Street__c;
                wrapperClass.accountShippingCity = eachCon.Account.Shop_City__c;
                wrapperClass.accountShippingState = eachCon.Account.Shop_State__c;
                wrapperClass.accountShippingCountry = eachCon.Account.Shop_Country__c;
                wrapperClass.accountShippingPostalCode = eachCon.Account.Shop_Postal_Code__c;
                wrapperClass.accountPhone = eachCon.Account.Phone;
                wrapperClass.accountRecType = eachCon.Account.RecordType.DeveloperName;
                wrapperClass.accConsIsActive = eachCon.IsActive;
                wrapperClass.accConsIsDirect = eachCon.IsDirect;

                if(eachCon.Account.ShippingLatitude == null){
                    wrapperClass.accountShippingLatitude = 0;
                }else{
                    wrapperClass.accountShippingLatitude = eachCon.Account.ShippingLatitude;
                }

                if(eachCon.Account.ShippingLongitude == null){
                    wrapperClass.accountShippingLongitude = 0;
                }else{
                    wrapperClass.accountShippingLongitude = eachCon.Account.ShippingLongitude;
                }

                String isMiyoSmart = '';
                if(eachCon.Account.Myo_Smart_AuthorizeDealer__c){
                    isMiyoSmart = 'Yes';
                }else{
                    isMiyoSmart = 'No';
                }
                wrapperClass.accountMyoSmart = isMiyoSmart;
                uniqueIds.add(eachCon.AccountId);
                dataList.add(wrapperClass);

            }

            if(VisionAll!=null && VisionAll!='' && VisionAll!='No Filter'){
                VisionAll = ' AND Visionary_Alliance__c LIKE \'%'+VisionAll+'%\' ';
            }else{
                VisionAll = '';
            }

            if(Segmentation!=null && Segmentation!='' && Segmentation!='No Filter'){
                Segmentation = ' AND Segmentation_Net__c LIKE \''+Segmentation+'\' ';
            }else{
                Segmentation = '';
            }

            String HoyaVisionCenter = '';

            if(IsHvCenter==true && IsSeikoNetwork==true){
                HoyaVisionCenter = ' AND (Seiko_Network__c LIKE \'Hoya Vision Center\' OR Seiko_Network__c LIKE \'Seiko Vision Specialist\') ';
            }else if(IsSeikoNetwork == true){
                HoyaVisionCenter = ' AND (Seiko_Network__c LIKE \'Seiko Vision Specialist\') ';
            }else if(IsHvCenter == true){
                HoyaVisionCenter = ' AND (Seiko_Network__c LIKE \'Hoya Vision Center\') ';
            }else{
                HoyaVisionCenter = '';
            }

            String miyoSmart = '';
            //Functionally: for checkboxes: only apply filters if 'Checked' - As discussed with Giorgio
            if(IsMyoSmart==true){
                miyoSmart = ' AND Myo_Smart_AuthorizeDealer__c=true';
            }

            List<ContactNearby> tempList = new List<ContactNearby>();
            // Get Nearby opticians for each working place considering all the filters selected
            for (ContactNearby eachRec : dataList) {

                ContactNearby con = new ContactNearby();
                Double shippingLatitude = eachRec.accountShippingLatitude;
                Double shippingLongitude = eachRec.accountShippingLongitude;

                String soql = 'SELECT Id, Name, Hoya_Account_ID__c, Record_Type_Name__c, Shop_Name__c, '
                            + 'ShippingLatitude, ShippingLongitude, ShippingStreet, ShippingCity, '
                            + 'ShippingState, ShippingCountry, ShippingPostalCode, Phone, Shop_City__c, Shop_Country__c, Shop_Postal_Code__c, Shop_State__c, Shop_Street__c, '
                            + 'RecordType.DeveloperName, Clinic_Name__c, Brand__c, Segmentation_Net__c, First_Competitor_global_name__c, First_Competitor_local_name__c, First_Competitor_SOW__c, Myo_Smart_AuthorizeDealer__c FROM Account WHERE ('
                            + 'DISTANCE(ShippingAddress, GEOLOCATION('+shippingLatitude+', '+shippingLongitude+'), \'km\')<'+distance + VisionAll + miyoSmart + Segmentation + ' AND RecordType.DeveloperName != \'Clinic\')'+ HoyaVisionCenter + ' ORDER BY CreatedDate DESC LIMIT 500';

                // There can be max 4 to 6 working places per individual functionally. So considering this, the SOQL in loop here is never supposed to reach governor limits.
                // Need to find an alternative here.
                //System.debug('SOQL here = > '+soql);
                List<Account> opticianList = database.query(soql);
                
                for(Account eachAcc : opticianList){

                    if (uniqueIds.contains(eachAcc.Id)) {
                        // no need to process the account again as it is already processed.
                        continue;
                    }
                    uniqueIds.add(eachAcc.Id);
                    ContactNearby wrapper = new ContactNearby();
                    wrapper.workingId = eachRec.workingId;
                    wrapper.ClinicName = eachAcc.Clinic_Name__c;
                    wrapper.accountBrand = eachAcc.Brand__c;
                    wrapper.accountSegmentation = eachAcc.Segmentation_Net__c;
                    wrapper.FirstCompetitorGlobal = eachAcc.First_Competitor_global_name__c;
                    wrapper.FirstCompetitorLocal = eachAcc.First_Competitor_local_name__c;
                    wrapper.FirstCompetitorSOW = eachAcc.First_Competitor_SOW__c;
                    wrapper.contactId = eachRec.ContactId;
                    wrapper.contactName = eachRec.ContactName;
                    wrapper.accountId = eachAcc.Id;
                    wrapper.accountName = eachAcc.Name;
                    wrapper.accountShopName = eachAcc.Shop_Name__c;
                    wrapper.accountHoyaAccId = eachAcc.Hoya_Account_ID__c;
                    wrapper.accountShippingStreet = eachAcc.Shop_Street__c;
                    wrapper.accountShippingCity = eachAcc.Shop_City__c;
                    wrapper.accountShippingState = eachAcc.Shop_State__c;
                    wrapper.accountShippingCountry = eachAcc.Shop_Country__c;
                    wrapper.accountShippingPostalCode = eachAcc.Shop_Postal_Code__c;
                    wrapper.accountPhone = eachAcc.Phone;
                    wrapper.accountRecType = eachAcc.RecordType.DeveloperName;

                    if(eachAcc.ShippingLatitude == null) { 
                        wrapper.accountShippingLatitude = 0;
                    } else {
                        wrapper.accountShippingLatitude = eachAcc.ShippingLatitude;
                    }
                    if(eachAcc.ShippingLongitude == null) { 
                        wrapper.accountShippingLongitude = 0;
                    } else {
                        wrapper.accountShippingLongitude = eachAcc.ShippingLongitude;
                    }
                    
                    String isMiyoSmartAuthorize = '';
                    if(eachAcc.Myo_Smart_AuthorizeDealer__c){
                        isMiyoSmartAuthorize = 'Yes';
                    }else{
                        isMiyoSmartAuthorize = 'No';
                    }
                    wrapper.accountMyoSmart = isMiyoSmartAuthorize;
                    tempList.add(wrapper);
                }
            }
            dataList.addAll(tempList);
            //System.debug('Data List = > '+dataList.size()+' record(s)' + dataList);
            return dataList;
        }catch(Exception e){
            System.debug('Error=>'+e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }

}