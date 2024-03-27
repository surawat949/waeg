public with sharing class TabVisitsEcpNearby {

    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountsMap(String recordId, Double distance, String SegmentationBox, Double PotentialMin, Double PotentialMax, String FirstLocalCampetitor, String svsnetwork){
        try {

            
            List<Account> result = new List<Account>();
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

            Account acc = [SELECT Id, Hoya_Account_ID__c, Name, ShippingStreet, ShippingCity, ShippingState,
                                ShippingPostalCode, ShippingCountry, Segmentation_Net__c, ShippingLatitude, ShippingLongitude,
                                First_Competitor_local_name__c, Seiko_Network__c, Brand__c FROM Account
                                WHERE Id=:recordId];
            result.add(acc);

            Double latitude = acc.ShippingLatitude;
            Double longitude = acc.ShippingLongitude;
            String accId = acc.Hoya_Account_ID__c;

            if(acc.ShippingLatitude==null){latitude = 0;}
            if(acc.ShippingLongitude==null){longitude = 0;}

            String soql = 'SELECT Id, Hoya_Account_ID__c, Name, Segmentation_Net__c, First_Competitor_local_name__c, '
                            +'ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry, '
                            +'ShippingLongitude, ShippingLatitude, Brand__c FROM Account WHERE RecordTypeId IN: getRecId '
                            +'AND Strategic_Value_Net_Sales__c>='+PotentialMin.longValue()+' AND Strategic_Value_Net_Sales__c<='+PotentialMax.longValue()+' AND '
                            +'DISTANCE(ShippingAddress, GEOLOCATION('+latitude+', '+longitude+'), \'km\')<'+distance +
                            critSegmentation + critFstCompetitor + critSvsNetwork + ' AND Hoya_Account_ID__c != \''+accId+'\' ORDER BY Name ASC LIMIT 500';
            

            List<Account> aList = database.query(soql);
            result.addAll(aList);

            return result;
            
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