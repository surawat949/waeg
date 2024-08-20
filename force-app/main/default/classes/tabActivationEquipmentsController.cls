public class tabActivationEquipmentsController {
 @AuraEnabled(cacheable=true)
    public static String getLastTrainingDate(Id accountId,String topic){
        String lastTrainingDate='';
        List<ECP_Training__c> TrainingLst=[SELECT start__c,Id,Account__c 
                                           FROM ECP_Training__c where Account__c=:accountId and Training__c includes (:topic) AND Training_status__c ='Completed' order by start__c desc];
        if(TrainingLst.size() > 0){
            DateTime dT = TrainingLst[0].start__c;
            if(dT != null)
            	lastTrainingDate = dT.date().format();
        }  
        return lastTrainingDate;    
    }
    @AuraEnabled(cacheable=true)
    public static String getLastMediaUsage(Id accountId,String tool,String type){
        String lastUsagedate ='';
        try {
            List<New_Media_Usage__c> nmuList =new List<New_Media_Usage__c>();
            if(type == 'ExactMatch'){
                nmuList = [SELECT Id,Name,Tool__c,Transaction_date_field__c,Transaction_Date__c
                                            FROM New_Media_Usage__c
                                            WHERE Hoya_Account_ID__c =: accountId AND Tool__c =:tool ORDER BY Transaction_date_field__c DESC NULLS LAST LIMIT 1];
            }
            else{
                nmuList = [SELECT Id,Name,Tool__c,Transaction_date_field__c,Transaction_Date__c
                                            FROM New_Media_Usage__c
                                            WHERE Hoya_Account_ID__c =: accountId AND Tool__c like :tool ORDER BY Transaction_date_field__c DESC NULLS LAST LIMIT 1];
            }
            if(nmuList!=null && nmuList.size()>0){
                New_Media_Usage__c nmu = nmuList.get(0);
                date dt= date.valueOf(nmuList[0].Transaction_date_field__c);
                DateTime dtConverted = Datetime.newInstance(nmu.Transaction_date_field__c.year(), nmu.Transaction_date_field__c.month(),nmu.Transaction_date_field__c.day(),0,0,0);
                lastUsagedate = dtConverted.format('MM') +'/'+ dtConverted.format('YYYY');	
            }  
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return lastUsagedate;
    }
   
    @AuraEnabled(cacheable=true)
    public static List<DataSet> getEquipmentsChart(Id recordId,String tool,String type){
        List<AggregateResult> result =new List<AggregateResult>();
        if(type == 'ExactMatch'){
        	result = [select Transaction_Date__c, sum(Quantity__c) qty
                                        from New_Media_Usage__c where Hoya_Account_ID__c =: recordId 
                                        and Tool__c = :tool and Transaction_date_field__c = LAST_N_MONTHS:24
                                        group by transaction_date__c, Transaction_date_field__c order by Transaction_date_field__c asc];
        }
        else{
           result = [select Transaction_Date__c, sum(Quantity__c) qty
                                        from New_Media_Usage__c where Hoya_Account_ID__c =: recordId 
                                        and Tool__c LIKE :tool and Transaction_date_field__c = LAST_N_MONTHS:24
                                        group by transaction_date__c, Transaction_date_field__c order by Transaction_date_field__c asc]; 
        }
        System.debug(result.size());
        List<DataSet> dataset = new List<DataSet>();
        for(AggregateResult ar : result){
            String label = (String)ar.get('Transaction_Date__c');
            Double qty = (Double)ar.get('qty');
            dataset.add(new DataSet(label, qty));
        }
        return dataset;
    }
    
    public class DataSet{
        public DataSet(String label, Double qty){
            this.label = label;
            this.qty = qty;
        }
        @AuraEnabled public String label{get;set;}
        @AuraEnabled public Double qty{get;set;}
    }       
    @AuraEnabled(cacheable=false)
    public static string startEnroll(Id accountId){
        String error = 'ok';
        try{
            Seiko_data__c s = [select Id,SVS_Digital_com_Platform_radius__c,SVS_Digital_communication_platform__c
            from Seiko_Data__c where Account__c=:accountId];
            error = ExternalWSCall.activateAccount(accountId, s.id);
        }catch (Exception e) {
            error = e.getMessage();
            return e.getMessage();
        }
        return error;
    }
}