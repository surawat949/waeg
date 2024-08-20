public with sharing class TabVisitsEcpNearby {

    public class AccountWrapperClass{
        @AuraEnabled public String accountId{get;set;}
        @AuraEnabled public String Hoya_Account_ID{get;set;}
        @AuraEnabled public String AccName{get;set;}
        @AuraEnabled public String Brand{get;set;}
        @AuraEnabled public String Segmentation_Net{get;set;}
        @AuraEnabled public Double Strategic_Value_Net_Sales{get;set;}
        @AuraEnabled public Double Lenses_Net_Sales_Last_12Mo{get;set;}
        @AuraEnabled public String Seiko_Network{get;set;}
        @AuraEnabled public String First_competitor_local{get;set;}
        @AuraEnabled public Double First_Competitor_SOW_Last_3_Month{get;set;}
        @AuraEnabled public Datetime Last_visit_date{get;set;}
        @AuraEnabled public String Visit_Frequency_Status{get;set;}
        @AuraEnabled public String AccPhone{get;set;}
        @AuraEnabled public String AccShoptreet{get;set;}
        @AuraEnabled public String AccShopCity{get;set;}
        @AuraEnabled public String AccShopState{get;set;}
        @AuraEnabled public String AccShopPostalCode{get;set;}
        @AuraEnabled public String AccShopCountry{get;set;}
        @AuraEnabled public Double AccLatitude{get;set;}
        @AuraEnabled public Double AccLongitude{get;set;}
        @AuraEnabled public String AccCurrencyIsoCode{get;set;}
    }

    @AuraEnabled(cacheable=true)
    public static List<AccountWrapperClass> getAccountsMap(String recordId, Double distance, String SegmentationBox, Double PotentialMin, Double PotentialMax, String FirstLocalCampetitor, String svsnetwork){
        try {

            List<Id> accStatIds = new List<Id>();
            //List<Account> result = new List<Account>();
            List<AccountWrapperClass> dataset = new List<AccountWrapperClass>();
            if(PotentialMin == null){PotentialMin=0;}
            if(PotentialMax == null){PotentialMax=999999999;}

            List<Id> getRecId = new List<Id>();

            String RecChainRT = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Chain').getRecordTypeId();
            

            String RecIndRT = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Independents').getRecordTypeId();
            

            String RecChainSeikoRT = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Chain_Seiko').getRecordTypeId();
            

            String RecIndSeikoRT = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Independent_Seiko').getRecordTypeId();
            

            getRecId.add(RecChainRT);
            getRecId.add(RecIndRT);
            getRecId.add(RecChainSeikoRT);
            getRecId.add(RecIndSeikoRT);
           

            String critSegmentation = '';
            String critFstCompetitor = '';
            String critSvsNetwork = '';

            if(SegmentationBox!=null && SegmentationBox!=''){
                critSegmentation = ' and Segmentation_Net__c LIKE \'%'+SegmentationBox+'%\' ';
            }

            if(FirstLocalCampetitor!=null && FirstLocalCampetitor!=''){
                critFstCompetitor = ' and First_Competitor_local_name__c LIKE \'%'+FirstLocalCampetitor+'%\' ';
            }

            if(svsnetwork!=null && svsnetwork!=''){
                critSvsNetwork = ' and Seiko_Network__c LIKE \'%'+svsnetwork+'%\' ';
            }

            Account acc = [SELECT Id, Hoya_Account_ID__c, Name, Shop_Street__c, Shop_City__c, Shop_State__c, 
                                Shop_Postal_Code__c, Shop_Country__c, Segmentation_Net__c, ShippingLatitude, ShippingLongitude, 
                                First_Competitor_local_name__c, Seiko_Network__c, Brand__c, Potential__c, Lenses_Net_Sales_Last_12Mo__c,  
                                First_Competitor_SOW__c, Last_Visit_date__c, Visit_Frequency_Status__c, Phone, Strategic_Value_Net_Sales__c, CurrencyIsoCode  
                                FROM Account WHERE Id=:recordId];
            
            String accId = acc.Id;
            accStatIds.add(acc.Id);

            Double latitude = acc.ShippingLatitude;
            Double longitude = acc.ShippingLongitude;
            if(latitude==null){latitude=0;}
            if(longitude==null){longitude=0;}

            AccountWrapperClass wrappercls = new AccountWrapperClass();
                wrapperCls.accountId = acc.Id;
                wrappercls.Hoya_Account_ID = acc.Hoya_Account_Id__c;
                wrapperCls.AccName = acc.Name;
                wrapperCls.Brand = acc.Brand__c;
                wrapperCls.Segmentation_Net = acc.Segmentation_Net__c;
                wrapperCls.Strategic_Value_Net_Sales = acc.Strategic_Value_Net_Sales__c;
                wrapperCls.Lenses_Net_Sales_Last_12Mo = acc.Lenses_Net_Sales_Last_12Mo__c;
                wrapperCls.Seiko_Network = acc.Seiko_Network__c;
                wrapperCls.First_competitor_local = acc.First_Competitor_local_name__c;
                wrapperCls.Last_visit_date = acc.Last_Visit_date__c;
                wrapperCls.Visit_Frequency_Status = acc.Visit_Frequency_Status__c;
                wrapperCls.AccPhone = acc.Phone;
                wrapperCls.AccShoptreet = acc.Shop_Street__c;
                wrapperCls.AccShopCity = acc.Shop_City__c;
                wrapperCls.AccShopState = acc.Shop_State__c;
                wrapperCls.AccShopPostalCode = acc.Shop_Postal_Code__c;
                wrapperCls.AccShopCountry = acc.Shop_Country__c;
                wrappercls.AccLatitude = acc.ShippingLatitude;
                wrappercls.AccLongitude = acc.ShippingLongitude;
                wrappercls.AccCurrencyIsoCode = acc.CurrencyIsoCode;
                dataset.add(wrapperCls);
            

            String soql = 'SELECT Id, Hoya_Account_ID__c, Name, Segmentation_Net__c, First_Competitor_local_name__c, '
                            +'Shop_Street__c, Shop_City__c, Shop_State__c, Shop_Postal_Code__c, Shop_country__c, Brand__c, '
                            +'Potential__c, Lenses_Net_Sales_Last_12Mo__c, ShippingLatitude, ShippingLongitude, '
                            +'Seiko_Network__c, First_Competitor_SOW__c, Last_Visit_date__c, Visit_Frequency_Status__c, Phone, Strategic_Value_Net_Sales__c, CurrencyIsoCode ' 
                            +'FROM Account WHERE RecordTypeId IN: getRecId '
                            +'AND Strategic_Value_Net_Sales__c>='+PotentialMin.longValue()+' AND Strategic_Value_Net_Sales__c<='+PotentialMax.longValue()+' AND '
                            +'DISTANCE(ShippingAddress, GEOLOCATION('+latitude+', '+longitude+'), \'km\')<'+distance +
                            critSegmentation + critFstCompetitor + critSvsNetwork + ' AND Id <>: accId ORDER BY Name ASC LIMIT 500';
            
            List<Account> aList = database.query(soql);
            
            for(Account a : aList){
                accStatIds.add(a.Id);
            }
            System.debug('acc Id list == > '+accStatIds);
            Map<Id, Double> mapAccIdLastSalesStat = new Map<Id, Double>();
            //get data from last sales statistic == > First_Competitor_SOW_Last_3_Month__c
            List<Last_Sales_Statistics__c> stats = [SELECT Id, Account__c, First_Competitor_SOW_Last_3_Month__c FROM Last_Sales_Statistics__c WHERE Account__c IN:accStatIds];
            System.debug('Last Sales Statistic Size == > '+stats.size());
            for(Last_Sales_Statistics__c eachStat : stats){
                System.debug('Acc Lst sales stat == > '+eachStat.Account__c);
                if(eachStat.Account__c!=null){
                    mapAccIdLastSalesStat.put(eachStat.Account__c, eachStat.First_Competitor_SOW_Last_3_Month__c);
                    System.debug('Map ==> '+mapAccIdLastSalesStat);
                }
            }
            List<AccountWrapperClass> tmpList = new List<AccountWrapperClass>();
            // Put SOW value for current account retrieved in the first SOQL
            if (dataset.get(0) != null){ 
                dataset.get(0).First_Competitor_SOW_Last_3_Month = mapAccIdLastSalesStat.get(dataset.get(0).accountId);
            }

            for(Account eachAcc : aList){
                AccountWrapperClass wrapper = new AccountWrapperClass();
                wrapper.accountId = eachAcc.Id;
                wrapper.Hoya_Account_ID = eachAcc.Hoya_Account_Id__c;
                wrapper.AccName = eachAcc.Name;
                wrapper.Brand = eachAcc.Brand__c;
                wrapper.Segmentation_Net = eachAcc.Segmentation_Net__c;
                wrapper.Strategic_Value_Net_Sales = eachAcc.Strategic_Value_Net_Sales__c;
                wrapper.Lenses_Net_Sales_Last_12Mo = eachAcc.Lenses_Net_Sales_Last_12Mo__c;
                wrapper.Seiko_Network = eachAcc.Seiko_Network__c;
                wrapper.First_competitor_local = eachAcc.First_Competitor_local_name__c;
                if(mapAccIdLastSalesStat.get(eachAcc.Id)!=null){
                    System.debug('++ '+eachAcc.Id + '==>' +mapAccIdLastSalesStat.get(eachAcc.Id));

                    wrapper.First_Competitor_SOW_Last_3_Month = mapAccIdLastSalesStat.get(eachAcc.Id);
                }
                wrapper.Last_visit_date = eachAcc.Last_Visit_date__c;
                wrapper.Visit_Frequency_Status = eachAcc.Visit_Frequency_Status__c;
                wrapper.AccPhone = eachAcc.Phone;
                wrapper.AccShoptreet = eachAcc.Shop_Street__c;
                wrapper.AccShopCity = eachAcc.Shop_City__c;
                wrapper.AccShopState = eachAcc.Shop_State__c;
                wrapper.AccShopPostalCode = eachAcc.Shop_Postal_Code__c;
                wrapper.AccShopCountry = eachAcc.Shop_Country__c;
                wrapper.AccLatitude = eachAcc.ShippingLatitude;
                wrapper.AccLongitude = eachAcc.ShippingLongitude;
                wrapper.AccCurrencyIsoCode = eachAcc.CurrencyIsoCode;
                tmpList.add(wrapper);

            }
            dataset.addAll(tmpList);
            System.debug('Return val = > '+dataset);
            return dataset;
            
        } catch (Exception e) {
            
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<optionSet> getCompetitorPicklistVal(){
        try {
            Schema.DescribeFieldResult fieldResult = Account.First_Competitor_local_name__c.getDescribe();
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

    @AuraEnabled(cacheable=true)
    public static List<optionSet> getSVSNetworkPicklistVal(){
        try {
            Schema.DescribeFieldResult fieldResult = Account.Seiko_Network__c.getDescribe();
            List<Schema.PicklistEntry> pEntry = fieldResult.getPicklistValues();
            List<optionSet> dataset = new List<optionSet>();
            for(Schema.PicklistEntry picklistval : pEntry){
                String pListLabelName = picklistval.getLabel();
                String pListValue = picklistval.getValue();

                dataset.add(new optionSet(pListLabelName, pListValue));

            }
            //System.debug('XXX Get Picklist value, Clinic Type =>'+dataset);
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

    @AuraEnabled(cacheable=true)
    public static sObject searchFirstCompetitorDefault(String recordId, String sObjectApiName){
        String recId = recordId;
        String sQuery = 'select Id, DurableId, label, value from picklistvalueinfo where ' +
                        'entityparticle.entitydefinition.qualifiedapiname = \''+sObjectApiName+'\' '+
                        'and entityparticle.developername = \'First_Competitor_local_name\' '+
                        'and isactive = true and value LIKE :recId order by value asc limit 1';
        for(sObject obj : database.query(sQuery)){
            return obj;
        }

        return null;
    }

    @AuraEnabled(cacheable=true)
    public static List<sObject> searchFirstCompetitor(String searchKey, String sObjectApiName){
        List<sObject> returnList = new List<sObject>();
        String swildcardSearch = searchKey;

        if(String.isNotBlank(searchKey)){
            swildcardSearch = '%'+searchKey+'%';
            String sQuery = 'select Id, DurableId, label, value from picklistvalueinfo where ' +
                        'entityparticle.entitydefinition.qualifiedapiname = \''+sObjectApiName+'\' '+
                        'and entityparticle.developername = \'First_Competitor_local_name\' and isactive = true '+
                        'and value LIKE: swildcardSearch order by value asc';
            for(sObject obj : database.query(sQuery)){
                returnList.add(obj);
            }
        }else{
            swildcardSearch = '';
        }

        return returnList;
    }
}