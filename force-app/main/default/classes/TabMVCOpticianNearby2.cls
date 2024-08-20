public with sharing class TabMVCOpticianNearby2 {

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
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<ContactNearby> getContactNearby(String recordId, Double distance, String VisionAll, Boolean IsMyoSmart, Boolean IsHvCenter, Boolean IsSeikoNetwork, String Segmentation){
        try {

            //System.debug('XXX Query Criteria recordId =>'+recordId);
            //System.debug('XXX Query Criteria distance =>'+distance);
            //System.debug('XXX Query Criteria Visionary Alliance =>'+VisionAll);
            //System.debug('XXX Query Criteria Is Hoya Vision Center =>'+IsHvCenter);
            //System.debug('XXX Query Criteria Is Seiko Network =>'+IsSeikoNetwork);
            //System.debug('XXX Query Criteria Is MiyoSmart =>'+IsMyoSmart);
            //System.debug('XXX Query Criteria Segmentation =>'+Segmentation);

            List<Id> ids = new List<Id>();
            List<AccountContactRelation> ac1 = [SELECT Id, ContactId FROM AccountContactRelation WHERE
                                                ContactId=:recordId AND Account.RecordType.DeveloperName='Clinic'
                                                AND IsActive=true];
            for(AccountContactRelation a : ac1){
                ids.add(a.Id);

            }
            //System.debug('XXX => Working Place Id to itterate = >'+ids.size()+' '+ids);

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
            //String SeikoNetwork = '';

            if(IsHvCenter==true && IsSeikoNetwork==true){
                HoyaVisionCenter = ' AND (Seiko_Network__c LIKE \'Hoya Vision Center\' OR Seiko_Network__c LIKE \'Seiko Vision Specialist\') ';
            }else if(IsSeikoNetwork == true){
                HoyaVisionCenter = ' AND (Seiko_Network__c LIKE \'Seiko Vision Specialist\') ';
            }else if(IsHvCenter == true){
                HoyaVisionCenter = ' AND (Seiko_Network__c LIKE \'Hoya Vision Center\') ';
            }else{
                HoyaVisionCenter = '';
            }


            String MyoSmart = '';
            if(IsMyoSmart==true){
                MyoSmart = ' AND Myo_Smart_AuthorizeDealer__c=true';
            }else{
                MyoSmart = ' AND Myo_Smart_AuthorizeDealer__c=false';
            }
        
            List<ContactNearby> dataList = new List<ContactNearby>();
            Map<String, ContactNearby> dataMap = new Map<String, ContactNearby>();

            List<AggregateResult> data1 = [SELECT Id, ContactId, Contact.Name ContactName, 
                                            AccountId, Account.Name AccountName, Account.Shop_Name__c ShopName, Account.Hoya_Account_ID__c Hoya_Account_Id, 
                                            Account.ShippingStreet ShippingStreet, Account.ShippingCity ShippingCity, 
                                            Account.ShippingState ShippingState, Account.ShippingCountry ShippingCountry, Account.ShippingPostalCode ShippingPostalCode,
                                            Account.Phone Phone, Account.RecordType.DeveloperName AccRecType, Account.First_Competitor_global_name__c FirstCompGlobal, 
                                            Account.First_Competitor_local_name__c FirstCompLocal, Account.First_Competitor_SOW__c FirstCompSOW,
                                            Account.Myo_Smart_AuthorizeDealer__c IsMyoSmart FROM AccountContactRelation
                                            WHERE Id IN: ids
                                            GROUP BY Id, ContactId, Contact.Name, AccountId, Account.Name,  
                                            Account.Shop_Name__c, Account.ShippingCity, 
                                            Account.Hoya_Account_ID__c, Account.ShippingStreet, 
                                            Account.ShippingState, Account.ShippingCountry, 
                                            Account.ShippingPostalCode, Account.Phone, Account.RecordType.DeveloperName,
                                            Account.First_Competitor_global_name__c, Account.First_Competitor_local_name__c,
                                            Account.First_Competitor_SOW__c, Account.Myo_Smart_AuthorizeDealer__c 
                                            ORDER BY ContactId ASC];

            for(AggregateResult ar : data1){
                String workingId = (String)ar.get('Id');
                if(dataMap.get(workingId)==null){
                    dataMap.put(workingId, new ContactNearby());
                    
                }
                String isMiyoSmartAuthorize = '';
                if((Boolean)ar.get('IsMyoSmart')==true){
                    isMiyoSmartAuthorize = 'Yes';
                }else{
                    isMiyoSmartAuthorize = 'No';
                }

                dataMap.get(workingId).ContactId = (String)ar.get('ContactId');
                dataMap.get(workingId).contactName = (String)ar.get('ContactName');
                dataMap.get(workingId).accountId = (String)ar.get('AccountId');
                dataMap.get(workingId).accountName = (String)ar.get('AccountName');
                dataMap.get(workingId).FirstCompetitorGlobal = (String)ar.get('FirstCompGlobal');
                dataMap.get(workingId).FirstCompetitorLocal = (String)ar.get('FirstCompLocal');
                dataMap.get(workingId).FirstCompetitorSOW = (String)ar.get('FirstCompSOW');
                dataMap.get(workingId).accountMyoSmart = isMiyoSmartAuthorize;
                //dataMap.get(contactId).accountShippingLatitude = (String)ar.get('Account.ShippingLatitude');
                //dataMap.get(contactId).accountShippingLongitude = (String)ar.get('Account.ShippingLongitude');
                dataMap.get(workingId).accountShopName = (String)ar.get('ShopName');
                dataMap.get(workingId).accountHoyaAccId = (String)ar.get('Hoya_Account_Id');
                dataMap.get(workingId).accountShippingStreet = (String)ar.get('ShippingStreet');
                dataMap.get(workingId).accountShippingCity = (String)ar.get('ShippingCity');
                dataMap.get(workingId).accountShippingState = (String)ar.get('ShippingState');
                dataMap.get(workingId).accountShippingCountry = (String)ar.get('ShippingCountry');
                dataMap.get(workingId).accountShippingPostalCode = (String)ar.get('ShippingPostalCode');
                dataMap.get(workingId).accountPhone = (String)ar.get('Phone');
                dataMap.get(workingId).accountRecType = (String)ar.get('AccRecType');

            }
            List<Id> acs = new List<Id>();
            for(ContactNearby c : dataMap.values()){
                acs.add(c.accountId);
            }
            List<Account> newAcc = [SELECT Id, Hoya_Account_ID__c, ShippingLatitude, 
                                    ShippingLongitude, Clinic_Name__c, Brand__c, 
                                    Segmentation_Net__c FROM Account WHERE Id IN:acs];
            System.debug('XXX Get Account List '+newAcc);
            for(ContactNearby con : dataMap.values()){
                for(Account a : newAcc){
                    if(con.accountId == a.Id){
                        Double ShippingLatitude = a.ShippingLatitude;
                        Double ShippingLongitude = a.ShippingLongitude;

                        if(ShippingLatitude==null){ShippingLatitude=0;}
                        if(ShippingLongitude==null){ShippingLongitude=0;}

                        con.accountShippingLongitude = ShippingLongitude;
                        con.accountShippingLatitude = ShippingLatitude;
                        con.ClinicName = a.Clinic_Name__c;
                        con.accountBrand = a.Brand__c;
                        con.accountSegmentation = a.Segmentation_Net__c;

                        dataList.add(con);
                    }
                }
                    
            }

            List<AccountContactRelation> newConRelated = [SELECT Id, ContactId, AccountId, Account.ShippingLatitude, Account.Hoya_Account_ID__c,
                                                            Account.ShippingLongitude, Contact.Name FROM AccountContactRelation WHERE
                                                            Id IN:ids ORDER BY CreatedDate DESC LIMIT 90];
            
            for(AccountContactRelation r : newConRelated){
                ContactNearby con = new ContactNearby();
                Double shippingLatitude = r.Account.ShippingLatitude;
                Double shippingLongitude = r.Account.ShippingLongitude;
                //String Hoya_Account_ID = r.Account.Hoya_Account_ID__c;
                String accountId = r.AccountId;

                if(shippingLatitude == null){shippingLatitude=0;}
                if(shippingLongitude == null){shippingLongitude=0;}

                String soql = 'SELECT Id, Name, Hoya_Account_ID__c, Record_Type_Name__c, Shop_Name__c, '
                            + 'ShippingLatitude, ShippingLongitude, ShippingStreet, ShippingCity, '
                            + 'ShippingState, ShippingCountry, ShippingPostalCode, Phone, '
                            + 'RecordType.DeveloperName, Clinic_Name__c, Brand__c, Segmentation_Net__c, First_Competitor_global_name__c, First_Competitor_local_name__c, First_Competitor_SOW__c, Myo_Smart_AuthorizeDealer__c FROM Account WHERE ('
                            + 'DISTANCE(ShippingAddress, GEOLOCATION('+shippingLatitude+', '+shippingLongitude+'), \'km\')<'+distance + VisionAll + MyoSmart + Segmentation + ' AND RecordType.DeveloperName != \'Clinic\')'+ HoyaVisionCenter + ' ORDER BY CreatedDate DESC LIMIT 50';
                
                System.debug('XXX SOQL = > '+soql);

                List<Account> aList = database.query(soql);

                if(aList.size()>0){
                    for(Account a : aList){
                        ContactNearby cons = new ContactNearby();
                        double shipLatitude = a.ShippingLatitude;
                        double shipLongitude = a.ShippingLongitude;
                        Boolean IsMyoSmart_Authorize = a.Myo_Smart_AuthorizeDealer__c;
                        String MyoSmart_Authorize = '';
                        if(IsMyoSmart_Authorize == true){
                            MyoSmart_Authorize = 'Yes';
                        }else{
                            MyoSmart_Authorize = 'No';
                        }
                        if(shipLatitude==null){shipLatitude=0;}
                        if(shipLongitude==null){shipLongitude=0;}
                        
                        cons.workingId = r.Id;
                        cons.accountId = a.Id;
                        cons.ClinicName = a.Clinic_Name__c;
                        cons.accountBrand = a.Brand__c;
                        cons.accountSegmentation = a.Segmentation_Net__c;
                        cons.FirstCompetitorGlobal = a.First_Competitor_global_name__c;
                        cons.FirstCompetitorLocal = a.First_Competitor_local_name__c;
                        cons.FirstCompetitorSOW = a.First_Competitor_SOW__c;
                        cons.accountMyoSmart = MyoSmart_Authorize;
                        cons.accountHoyaAccId = a.Hoya_Account_ID__c;
                        cons.accountName = a.Name;
                        cons.accountShopName = a.Shop_Name__c;
                        cons.accountShippingStreet = a.ShippingStreet;
                        cons.accountShippingCity = a.ShippingCity;
                        cons.accountShippingState = a.ShippingState;
                        cons.accountShippingCountry = a.ShippingCountry;
                        cons.accountShippingPostalCode = a.ShippingPostalCode;
                        cons.accountShippingLatitude = shipLatitude;
                        cons.accountShippingLongitude = shipLongitude;
                        cons.contactId = r.ContactId;
                        cons.contactName = r.Contact.Name;
                        cons.accountRecType = a.RecordType.DeveloperName;
                        //System.debug('XXX Hoya Account Id '+cons.accountHoyaAccId+' Rec Type : '+cons.accountRecType);
                        dataList.add(cons);
                    }
                }
            }
            
            System.debug('XXX Get Data List =>'+dataList);
            return dataList;
            
        }
        catch(Exception e){
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }
}