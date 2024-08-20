public with sharing class TabActivationMPMiyosmart {
    public TabActivationMPMiyosmart() {

    }

    @AuraEnabled
    public static string getLastSalesStats(String receivedId){
        List<Last_Sales_Statistics__c> storeCharId = [SELECT Id FROM Last_Sales_Statistics__c WHERE Account__c=:receivedId];
        String recordId = '';
        if(!storeCharId.isEmpty()){
            recordId = storeCharId[0].Id;
        }
        return recordId;
    }
    @AuraEnabled(cacheable=true)
    public static String getLastTrainingDate(Id accountId){
        String lastTrainingDate='';
        List<ECP_Training__c> TrainingLst=[select start__c,Id,Account__c from ECP_Training__c where Account__c =:accountId and Training__c includes ('MIYOSMART') AND Training_status__c ='Completed' order by start__c desc];
        if(TrainingLst.size() > 0){
            DateTime dT = TrainingLst[0].start__c;
            lastTrainingDate = dT.date().format();
        }  
        return lastTrainingDate;    
    }

    @AuraEnabled(cacheable=true)
    public static sObject searchDefaultRecord(string recordId, string sObjectApiName){
        string recId = recordId;
        
        string sQuery = 'select Id, DurableId, label, value from picklistvalueinfo where ' +
                        'entityparticle.entitydefinition.qualifiedapiname = \''+sObjectApiName+'\' '+
                        'and entityparticle.developername = \'First_Competitor_local_name\' '+
                        'and isactive = true and value LIKE :recId order by value asc limit 1';
        /*String sQuery = 'select Id, Name from '+sObjectApiName+' where Id=:recId limit 1';*/
        for(sObject obj : database.query(sQuery)){
            //System.debug(obj);
            return obj;
        }

        return null;
    }

    @AuraEnabled(cacheable=true)
    public static List<sObject> searchLookupData(string searchKey, string sObjectApiName){
        List<sObject> returnList = new List<sObject>();
        String swildcardText = searchKey;

        if(String.isNotBlank(searchKey)){
            swildcardText = '%'+searchKey+'%';
            String sQuery = 'select Id, DurableId, label, value from picklistvalueinfo where ' +
                        'entityparticle.entitydefinition.qualifiedapiname = \''+sObjectApiName+'\' '+
                        'and entityparticle.developername = \'First_Competitor_local_name\' and isactive = true '+
                        'and value LIKE: swildcardText order by value asc';
        
            /*String sQuery = 'select Id, Name from '+sObjectApiName+' where Name LIKE: swildcardText order by name asc limit 100';*/
            for(sObject obj : database.query(sQuery)){
                returnList.add(obj);
            }
        }else{
            swildcardText = '';
        }
        
        
        //System.debug('XXX Get data =>'+returnList.size());
        return returnList;
    }

    @AuraEnabled(cacheable=false)
    public static void UpdateMainMyopiaField(String recordId, String MainMyopiaName){
        try {
            List<Account> updateList = new List<Account>();
            List<Account> acc = [SELECT Id, Hoya_Account_ID__c, First_Competitor_local_name__c, Myo_Main_Comp_Myopia_Control__c 
                                FROM Account WHERE Id=:recordId];
            
            for(Account a: acc){
                if((MainMyopiaName!=null) && (String.isNotBlank(MainMyopiaName))){
                    a.Myo_Main_Comp_Myopia_Control__c = String.valueOf(MainMyopiaName);
                    updateList.add(a);
                }else{
                    a.Myo_Main_Comp_Myopia_Control__c = '';
                    updateList.add(a);
                }
            }
            if(updateList.size()>0){
                update updateList;

            }
        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static string getMainMyopiaDefault(String recordId){
        try {
            String MainMyopiaName = [SELECT Id, Myo_Main_Comp_Myopia_Control__c FROM Account WHERE Id=:recordId LIMIT 1].Myo_Main_Comp_Myopia_Control__c;
            return MainMyopiaName;
        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }
}