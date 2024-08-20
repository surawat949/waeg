global class BatchCls_OpticianFinderEligibility implements Database.Batchable<SObject>, Schedulable, Database.Stateful{
    global BatchCls_OpticianFinderEligibility() {

    }
    global void execute(SchedulableContext ctx) {
        BatchCls_OpticianFinderEligibility thisBatch = new BatchCls_OpticianFinderEligibility();
        Database.executeBatch(thisBatch);
    }

    global Database.QueryLocator start(Database.BatchableContext context){ 
        list<String> listOfRecordType = new list<String>{'Chain','Chain_Seiko','Independents','Independent_Seiko','Buying_Group','Buying_Group_Seiko','HVNA_Prospect','HVNA_Rep_Journal','HVNA_Active_Customer','HOLK_Account_Page_Layout'};
        String query = 'select Id, Turnover_Amount__c, Optician_Finder_Channel_Decision__c,Optician_Finder_Force_Activation__c, Optician_Finder__c, Optician_finder_optin__c'
        + ' from Account Where RecordType.DeveloperName IN : listOfRecordType';
        System.debug('+++query' + query);
        return Database.getQueryLocator(query);
    } 
    
    global void execute(Database.BatchableContext context, List<Account> lstAccounts){   
        List<Account> accToBeUpdated = new List<Account>();
        try {
            System.debug('+++Batch started BatchCls_OpticianFinderEligibility');
            List<Last_Sales_Statistics__c> lstStats = [Select Id, Account__c, Lenses_Net_Sales_Last_3Mo_CFY__c FROM Last_Sales_Statistics__c Where Account__c IN :lstAccounts];
            Map<Id, Decimal> mapAccountTOsales = new Map<Id, Decimal>();
            for (Last_Sales_Statistics__c eachStat : lstStats) {
                mapAccountTOsales.put(eachStat.Account__c, eachStat.Lenses_Net_Sales_Last_3Mo_CFY__c);
            }
            for (Account eachAcc : lstAccounts) {
                Boolean isChanged = false;
                if (eachAcc.Optician_Finder_Force_Activation__c == 'Force activation') {
                    System.debug('111'+ eachAcc.Optician_Finder__c);
                    if (!eachAcc.Optician_Finder__c) {
                        System.debug('+++ Force activation');
                        eachAcc.Optician_Finder__c = true;
                        eachAcc.Optician_finder_optin__c = true;
                        isChanged = true;   
                    }
                } else if (eachAcc.Optician_Finder_Force_Activation__c == 'Force non-activation') {
                    System.debug('+++ Force non-activation');
                    eachAcc.Optician_Finder__c = false;
                    eachAcc.Optician_finder_optin__c = false;
                    isChanged = true;
                } else {
                    System.debug('+++ Null');
                    if (eachAcc.Optician_Finder_Channel_Decision__c == 'Activation' || eachAcc.Optician_Finder_Channel_Decision__c == null) {
                        if ((mapAccountTOsales.get(eachAcc.Id) != null && mapAccountTOsales.get(eachAcc.Id) > 0) || eachAcc.Turnover_Amount__c >0) {
                            if (!eachAcc.Optician_Finder__c) {
                                eachAcc.Optician_Finder__c = true;
                                eachAcc.Optician_finder_optin__c = true;
                                isChanged = true;   
                            }
                        } else {
                            eachAcc.Optician_Finder__c = false;
                            eachAcc.Optician_finder_optin__c = false;
                            isChanged = true;
                        }
                    } else if (eachAcc.Optician_Finder_Channel_Decision__c == 'Non-activation') {
                        eachAcc.Optician_Finder__c = false;
                        eachAcc.Optician_finder_optin__c = false;
                        isChanged = true;
                    }
                }
                if (isChanged) {
                    accToBeUpdated.add(eachAcc);   
                }
            }
            if (!accToBeUpdated.isEmpty()) {
                System.debug('+++ Updating the values');
                update accToBeUpdated;   
            }    
        } catch (Exception ex) {
            System.debug('In exception' + ex);
            LogException.log(ex);
        }
        
    }

    global void finish(Database.BatchableContext context){   
        
    }
 
}