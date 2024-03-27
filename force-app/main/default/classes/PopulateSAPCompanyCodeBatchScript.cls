global class PopulateSAPCompanyCodeBatchScript implements Database.Batchable<SObject>, Database.Stateful {
    global PopulateSAPCompanyCodeBatchScript() {

    }

    global Database.QueryLocator start(Database.BatchableContext context){ 
        String query = 'Select Id, Brand__c, Hoya_Account_Id__c, Shop_Country__c, SAP_Company_Code__c, CHCUSTCLASSIFICATIONID__c from Account Where Shop_Country__c != null AND Brand__c != null AND SAP_Company_Code__c = null';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext context, List<Account> lstAccounts){
        List<Account> updateList = new List<Account>();
        Map<String, String> keyToSAPCodeMapping =  new Map<String,String>();
        try {
            List<Entity_Detail__mdt> entityList = [Select Id, SAP_Company_Code__c, Country_Code__c, Brand__c From Entity_detail__mdt];
            for (Entity_Detail__mdt eachEntity : entityList) {
                if (String.isNotBlank(eachEntity.Country_Code__c) && String.isNotBlank(eachEntity.Brand__c) && String.isNotBlank(eachEntity.SAP_Company_Code__c)) {
                    String key = eachEntity.Brand__c + '-' + eachEntity.Country_Code__c;
                    keyToSAPCodeMapping.put(key, eachEntity.SAP_Company_Code__c);  
                }
            }

            for (Account eachAccount : lstAccounts) {
                if (!keyToSAPCodeMapping.isEmpty() && String.isNotBlank(eachAccount.shop_Country__c) && String.isNotBlank(eachAccount.Brand__c)) {
                    String key = eachAccount.Brand__c + '-' + eachAccount.shop_Country__c;
                    String sapCode = keyToSAPCodeMapping.get(key);
                    if (sapCode != null) {
                        if (eachAccount.hoya_Account_Id__c.startsWith('SO4900') && eachAccount.shop_country__c == 'DE' && eachAccount.Brand__c == 'SEIKO') {
                            // For SEIKO Germany accs we have two codes as of now(EQ31 & EQ3D) hence handled 2nd SAP code through here. Other code will be processed through metadata records above
                            sapCode = 'EQ31';
                        } else if (eachAccount.shop_country__c == 'HU' && eachAccount.CHCUSTCLASSIFICATIONID__c == 'Dis' && eachAccount.Brand__c == 'HOYA') {
                            // For HOYA Hungary we have two codes as of now(EK31 & EK32)
                            sapCode = 'EK32';
                        }
                        eachAccount.SAP_Company_Code__c = sapCode;
                        updateList.add(eachAccount);
                    }
                }
            }
            if (!updateList.isEmpty()) {
                update updateList;
            }
        } catch (Exception e) {
            LogException.log(e);
            System.debug(e);
        }
    }

    global void finish(Database.BatchableContext context){   
        
    }
}