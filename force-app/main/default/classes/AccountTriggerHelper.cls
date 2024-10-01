public with sharing class AccountTriggerHelper {
    private static final String ACC_ENDCONSUMER_RT = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('End_Consumer_Account').getRecordTypeId();
    public AccountTriggerHelper() {

    }

    public static void entry(
        System.TriggerOperation triggerEvent,
        List <Account> newList,
        Map <Id, Account> newMap,
        List <Account> oldList,
        Map <Id, Account> oldMap
    ) {

        List<Account> seikoList = new List<Account>();
        List<Account> hvnaList = new List<Account>();
        //List<Account> holkList = new List<Account>();
        List<Account> hlfrList = new List<Account>();
        //list<Account> apacList = new List<Account>();
        //List<Account> hlukList = new List<Account>();
        //List<Account> oppList = new List<Account>();
        List<Account> ecList = new List<Account>();
        List<Account> oneKeyList = new List<Account>();
        List<Account> namesToBeUpdatedList = new List<Account>();
        Set<Id> blockedAccs = new Set<Id>();
        Set<Id> unblockedAccs = new Set<Id>();
        Boolean somethingToDo = false;
        
        List<Account> strategicNetUpdateList = new List<Account>();
        List<Account> strategicGrossUpdateList = new List<Account>(); 
        List<Account> CompDataLstupdateList = new List<Account>();

        List<Account> ownerUpdateList = new List<Account>();
        List<Account> shopCountryList = new List<Account>();
        List<Account> oneKeyUpdateList = new List<Account>();
        

        Set<Account> accLifeCycleList = new Set<Account>();
        Set<Id> accountIdLst = new Set<Id>();
        Set<Id> alcTobeActiveAccs = new Set<Id>();
        Set<Id> alcTobeDeactiveAccs =  new Set<Id>();
        if(newList!=null && newList.size()>0){
            for(Account a:newList){
                if(a.hoya_account_id__c!=null && a.hoya_account_id__c!='' /*&& a.hoya_account_id__c!='US' && a.hoya_account_id__c!='CA'*/){
                    //CDU 2021-12-02: remove account with hoya_account_id ='US' or 'CA' disturb sync
                    //CDU 2021-12-16: reactivate account with hoya_account_id ='US' or 'CA' - finally required for calls
                    if(a.hoya_account_id__c.startsWithIgnoreCase('US') ||a.hoya_account_id__c.startsWithIgnoreCase('CA')||a.hoya_account_id__c.startsWithIgnoreCase('VE')||a.hoya_account_id__c.startsWithIgnoreCase('SOA')){
                        hvnaList.add(a);
                        somethingToDo = true;
                    } else 
                    if(a.hoya_account_id__c.startsWith('SO')){
                        seikoList.add(a);
                        somethingToDo = true;
                    } 
                    /*
                    else
                    if(a.hoya_account_id__c.startsWith('KR')){      //CHANGE SK=>KR 2023-08-30 | SURAWAT
                        holkList.add(a);
                        somethingToDo = true;
                    }
                    */
                    if(a.hoya_account_id__c.startsWith('FR')){
                        hlfrList.add(a);
                        somethingToDo = true;
                    }
                    /*
                    if(a.hoya_account_id__c.startsWith('UK')){
                        hlukList.add(a);
                        somethingToDo = true;
                    }*/
                    
                    /*
                    if(a.Hoya_Account_ID__c.startsWith('SG5') || a.Hoya_Account_ID__c.startsWith('PH5') || a.Hoya_Account_ID__c.startsWith('TW017') || a.Hoya_Account_ID__c.startsWith('KR02') || a.Hoya_Account_ID__c.startsWith('KR03') || (a.Name != null && a.Name.contains('(S)'))
                         || a.Hoya_Account_ID__c.startsWith('HK6') || a.Hoya_Account_ID__c.startsWith('CN8') || a.Hoya_Account_ID__c.startsWith('TW046')
                        || a.Hoya_Account_ID__c.startsWith('KR04')
                        || a.Hoya_Account_ID__c.startsWith('AU') || a.Hoya_Account_ID__c.startsWith('KR') || a.Hoya_Account_ID__c.startsWith('HK') || a.Hoya_Account_ID__c.startsWith('MY') || a.Hoya_Account_ID__c.startsWith('TH') || a.Hoya_Account_ID__c.startsWith('SG') || a.Hoya_Account_ID__c.startsWith('CN') || a.Hoya_Account_ID__c.startsWith('PH') || a.Hoya_Account_ID__c.startsWith('ID') || a.Hoya_Account_ID__c.startsWith('TW') || a.Hoya_Account_ID__c.startsWith('IN') || (a.DMU__c!=null && a.DMU__c.startsWith('SOC'))){
                        apacList.add(a);
                        somethingToDo = true;
                        System.debug('##### a.Hoya_Account_ID__c='+a.Hoya_Account_ID__c);
                    }*/
                    /*
                    if((a.Account_Owner_Company__c=='HAPL') || (a.Account_Owner_Company__c == 'HOLK') || (a.Account_Owner_Company__c=='HOLM') || (a.Account_Owner_Company__c=='ILENS')
                        || (a.Account_Owner_Company__c == 'HLHK') || (a.Account_Owner_Company__c=='THAI') || (a.Account_Owner_Company__c=='HLSI')
                        || (a.Account_Owner_Company__c == 'HLSH') || (a.Account_Owner_Company__c=='SOC') || (a.Account_Owner_Company__c=='HLID')
                        || (a.Account_Owner_Company__c=='HLPH') || (a.Account_Owner_Company__c=='HLIN') || (a.Account_Owner_Company__c=='HOTA')
                        || (a.Account_Owner_Company__c=='HLIB') || (a.Account_Owner_Company__c=='HLBE') || (a.Account_Owner_Company__c=='HLNL')
                        || (a.Account_Owner_Company__c == 'HLUK') || (a.Account_Owner_Company__c=='HLCZ') || (a.Account_Owner_Company__c=='HLSA') || (a.Account_Owner_Company__c=='HOLI')){
                        oppList.add(a);
                        somethingToDo = true;
                        System.debug('##### Opportunity List is '+a.Hoya_Account_ID__c);
                    }*/
                }
                if (a.recordTypeid == ACC_ENDCONSUMER_RT) {
                    ecList.add(a);
                    somethingToDo = true;
                }
                if (a.QIDC__OneKeyId_IMS__c != null && a.QIDC__OneKeyId_IMS__c != '') {
                    oneKeyList.add(a);
                    somethingToDo = true;
                }
                
                if (a.QIDC__OneKeyId_IMS__c != null && a.QIDC__OneKeyId_IMS__c != '') {
                    oneKeyList.add(a);
                    somethingToDo = true;
                }
                if (String.IsNotBlank(a.QIDC__OneKeyId_IMS__c) && (String.isBlank(a.name) || a.Name.equalsIgnoreCase('NO NAME'))) {
                    oneKeyUpdateList.add(a);
                    somethingToDo = true;
                }
                
                if(triggerEvent == System.TriggerOperation.AFTER_UPDATE ){
                    Boolean isConsiderableRecTypeForALC = isConsiderableRecTypeForALC(a.RecordTypeId);
                    if (newMap.get(a.Id).Account_Status__c != oldMap.get(a.Id).Account_Status__c) {
                        List<String> accStatusList = new List<String>(new String[]{'Closed','Blocked','Suspended'});
                         //if account is closed deactivate Alc
                        if(isConsiderableRecTypeForALC && !accStatusList.contains(oldMap.get(a.Id).Account_Status__c) && accStatusList.contains(newMap.get(a.Id).Account_Status__c)){
                            accLifeCycleList.add(a);
                            somethingToDo = true;
                            alcTobeDeactiveAccs.add(a.Id);
                        }else if(isConsiderableRecTypeForALC && accStatusList.contains(oldMap.get(a.Id).Account_Status__c) && !accStatusList.contains(newMap.get(a.Id).Account_Status__c)){
                            accLifeCycleList.add(a);
                            somethingToDo = true;
                            alcTobeActiveAccs.add(a.Id);
                        }
                        if (a.Account_Status__c =='Closed' || a.Account_Status__c =='Blocked' || a.Account_Status__c =='Suspended') {
                            blockedAccs.add(a.Id);
                            somethingToDo = true;    
                        } else if(a.Account_Status__c =='Open') {
                            unblockedAccs.add(a.Id);
                            somethingToDo = true;
                        }  
                    } 
                     //if Channel is updated .
                     //It will impact only for Customers
                    if(isConsiderableRecTypeForALC && newMap.get(a.Id).CHCUSTCLASSIFICATIONID__c != oldMap.get(a.Id).CHCUSTCLASSIFICATIONID__c ){
                        if(newMap.get(a.Id).Lenses_Net_Sales_Last_12Mo__c > 0 ){
                            if(newMap.get(a.Id).CHCUSTCLASSIFICATIONID__c == 'Chain' ){
                                if(newMap.get(a.Id).TACTICOM_SOF__c != null && newMap.get(a.Id).TACTICOM_SOF__c != 'none'){
                                    accLifeCycleList.add(a);
                                    somethingToDo = true;
                                    alcTobeActiveAccs.add(a.Id);
                                }
                                else{
                                    accLifeCycleList.add(a);
                                    somethingToDo = true;
                                    alcTobeDeactiveAccs.add(a.Id); 
                                }
                            }
                            else if(newMap.get(a.Id).CHCUSTCLASSIFICATIONID__c == 'Ind'){
                                accLifeCycleList.add(a);
                                somethingToDo = true;
                                alcTobeActiveAccs.add(a.Id);
                            }
                        }  
                    }
                    //If Visit Zone is changed
                    if(isConsiderableRecTypeForALC && newMap.get(a.Id).TACTICOM_SOF__c != oldMap.get(a.Id).TACTICOM_SOF__c){     
                        if(newMap.get(a.Id).Lenses_Net_Sales_Last_12Mo__c > 0 ){
                            if(newMap.get(a.Id).CHCUSTCLASSIFICATIONID__c == 'Chain'){
                                if(newMap.get(a.Id).TACTICOM_SOF__c != null && newMap.get(a.Id).TACTICOM_SOF__c != 'none' ){
                                    accLifeCycleList.add(a);
                                    somethingToDo = true;
                                    alcTobeActiveAccs.add(a.Id);
                                }
                                else if(newMap.get(a.Id).TACTICOM_SOF__c == null || newMap.get(a.Id).TACTICOM_SOF__c == 'none' ){
                                    accLifeCycleList.add(a);
                                    somethingToDo = true;
                                    alcTobeDeactiveAccs.add(a.Id);
                                }
                            }
                        }else{//No sales
                            if((oldMap.get(a.Id).TACTICOM_SOF__c == null || oldMap.get(a.Id).TACTICOM_SOF__c == 'none') && newMap.get(a.Id).TACTICOM_SOF__c != null && newMap.get(a.Id).TACTICOM_SOF__c != 'none'){
                                accLifeCycleList.add(a);
                                somethingToDo = true;
                                alcTobeActiveAccs.add(a.Id);
                            }else if((newMap.get(a.Id).TACTICOM_SOF__c == null || newMap.get(a.Id).TACTICOM_SOF__c == 'none') && oldMap.get(a.Id).TACTICOM_SOF__c != null && oldMap.get(a.Id).TACTICOM_SOF__c != 'none'){
                                accLifeCycleList.add(a);
                                somethingToDo = true;
                                alcTobeDeactiveAccs.add(a.Id);
                            }
                        }
                    }
                    //if recordType is changed 
                    if(newMap.get(a.Id).RecordTypeId != oldMap.get(a.Id).RecordTypeId){
                        Boolean newOneisConsiderable = isConsiderableRecTypeForALC(newMap.get(a.Id).RecordTypeId);
                        Boolean oldOneisConsiderable = isConsiderableRecTypeForALC(oldMap.get(a.Id).RecordTypeId);
                        System.debug(newOneisConsiderable+''+oldOneisConsiderable);
                        //other to considerable rectype for alc
                        if(newOneisConsiderable && !oldOneisConsiderable){
                            if(newMap.get(a.Id).Lenses_Net_Sales_Last_12Mo__c > 0){
                                if(((newMap.get(a.Id).CHCUSTCLASSIFICATIONID__c == 'Chain' && newMap.get(a.Id).TACTICOM_SOF__c != null && newMap.get(a.Id).TACTICOM_SOF__c != 'none')|| newMap.get(a.Id).CHCUSTCLASSIFICATIONID__c == 'Ind' )){
                                    accLifeCycleList.add(a);
                                    somethingToDo = true;
                                    alcTobeActiveAccs.add(a.Id);
                                }
                            }else{//No sales
                                if(newMap.get(a.Id).TACTICOM_SOF__c != null  && newMap.get(a.Id).TACTICOM_SOF__c != 'none'){
                                    System.debug('Considerable');
                                    accLifeCycleList.add(a);
                                    somethingToDo = true;
                                    alcTobeActiveAccs.add(a.Id);
                                }
                            }
                        }
                        else if(oldOneisConsiderable && !newOneisConsiderable){//considerable to other deactivate alc if exists
                            System.debug('Not Considerable');
                            accLifeCycleList.add(a);
                            somethingToDo = true;  
                            alcTobeDeactiveAccs.add(a.Id);    
                        }    
                    } 
                    //Check for Last 12 months sales
                    if(isConsiderableRecTypeForALC && newMap.get(a.Id).Lenses_Net_Sales_Last_12Mo__c != oldMap.get(a.Id).Lenses_Net_Sales_Last_12Mo__c){
                         if(oldMap.get(a.Id).Lenses_Net_Sales_Last_12Mo__c <= 0 && newMap.get(a.Id).Lenses_Net_Sales_Last_12Mo__c > 0  && ((newMap.get(a.Id).CHCUSTCLASSIFICATIONID__c == 'Chain' && newMap.get(a.Id).TACTICOM_SOF__c != null && newMap.get(a.Id).TACTICOM_SOF__c != 'none')|| newMap.get(a.Id).CHCUSTCLASSIFICATIONID__c == 'Ind')){
                            accLifeCycleList.add(a);
                            somethingToDo = true;
                            alcTobeActiveAccs.add(a.Id);
                        }
                        else if(oldMap.get(a.Id).Lenses_Net_Sales_Last_12Mo__c > 0 && newMap.get(a.Id).Lenses_Net_Sales_Last_12Mo__c <= 0 && newMap.get(a.Id).TACTICOM_SOF__c != null && newMap.get(a.Id).TACTICOM_SOF__c != 'none'){
                            accLifeCycleList.add(a);
                            somethingToDo = true;
                            alcTobeActiveAccs.add(a.Id);
                        }
                    }
                    //Check for Segmentation_Net change
                    if(isConsiderableRecTypeForALC && newMap.get(a.Id).Segmentation_Net__c != oldMap.get(a.Id).Segmentation_Net__c){
                        accLifeCycleList.add(a);
                        somethingToDo = true;
                        alcTobeActiveAccs.add(a.Id);
                    }
                    //Check for Onboarding_Customer__c 
                    if(isConsiderableRecTypeForALC && newMap.get(a.Id).Onboarding_Customer__c != oldMap.get(a.Id).Onboarding_Customer__c){
                        accLifeCycleList.add(a);
                        somethingToDo = true;
                        alcTobeActiveAccs.add(a.Id);
                    }
                    accountIdLst.addAll(alcTobeActiveAccs);
                    accountIdLst.addAll(alcTobeDeactiveAccs);
                }
                //For Statistics Potential
                //only for before Update
                if(triggerEvent == System.TriggerOperation.BEFORE_UPDATE && oldMap != null){
                    Account oldAccount = oldMap.get(a.Id);
                    System.debug(a.Strategic_Value_Gross_Sales__c +''+oldAccount.Strategic_Value_Gross_Sales__c);
                    if(a.Strategic_Value_Gross_Sales__c != oldAccount.Strategic_Value_Gross_Sales__c){
                        strategicGrossUpdateList.add(a);
                        somethingToDo = true;
                    }
                    else if(a.Strategic_Value_Net_Sales__c != oldAccount.Strategic_Value_Net_Sales__c){
                        strategicNetUpdateList.add(a);
                        somethingToDo = true;
                    }
                    if(a.OwnerId != oldAccount.OwnerId){
                        ownerUpdateList.add(a);
                        somethingToDo = true;
                    }
                    if(a.shop_country__c != oldAccount.shop_country__c){
                        shopCountryList.add(a);
                        somethingToDo = true;
                    }
                    if(triggerEvent == System.TriggerOperation.BEFORE_UPDATE  && oldMap != null){
						Account oldAcc = oldMap.get(a.Id);
						if(a.First_Competitor_local_name__c != oldAcc.First_Competitor_local_name__c
						|| a.Second_Competitor_Local_Name__c != oldAcc.Second_Competitor_Local_Name__c ||
						   a.First_Competitor_Main_Weakness__c != oldAcc.First_Competitor_Main_Weakness__c ||
						   a.Second_Competitor_Main_Weakness__c != oldAcc.Second_Competitor_Main_Weakness__c ||
						   a.First_Competitor_Main_Strength__c != oldAcc.First_Competitor_Main_Strength__c || 
						   a.Second_Competitor_Main_Strength__c != oldAcc.Second_Competitor_Main_Strength__c){
							  a.Competitors_Info_Last_updated_On__c = date.ValueOf(System.now());
                        }
                    }
                   /* //if brand or HVC Loyalty program changes
                    if(a.brand__c != oldAccount.brand__c ||  a.Seiko_Network__c != oldAccount.Seiko_Network__c){
                         if(a.brand__c == 'HOYA' && a.Seiko_Network__c == 'Seiko Vision Specialist' ){
                            a.addError(System.Label.Account_Error_Message1);
                         }else if(a.brand__c == 'SEIKO' && a.Seiko_Network__c == 'Visionary Alliance'){
                            a.addError(System.Label.Account_Error_Message2);
                         }
                    }*/
                }
                //Update first & Second competitor Global name from metadata
                //
                if(triggerEvent == System.TriggerOperation.BEFORE_INSERT && (a.First_Competitor_local_name__c != null || a.Second_Competitor_Local_Name__c !=null)){
                    namesToBeUpdatedList.add(a);
                    somethingToDo = true;
                }else if(triggerEvent == System.TriggerOperation.BEFORE_UPDATE  && oldMap != null){
                    Account oldAccount = oldMap.get(a.Id);
                    if((a.First_Competitor_local_name__c != oldAccount.First_Competitor_local_name__c) || (a.Second_Competitor_Local_Name__c != oldAccount.Second_Competitor_Local_Name__c)){
                        namesToBeUpdatedList.add(a);
                        somethingToDo = true;
                    }
                }
                //before insert if Strategic gross sales value is there
                if(triggerEvent == System.TriggerOperation.BEFORE_INSERT && a.Strategic_Value_Gross_Sales__c != null){
                      strategicGrossUpdateList.add(a);
                      somethingToDo = true;
                }
                /*//before insert if HVC Loyalty Program is selected 
                if(triggerEvent == System.TriggerOperation.BEFORE_INSERT && a.Seiko_Network__c != null){
                    if(a.brand__c == 'HOYA' && a.Seiko_Network__c == 'Seiko Vision Specialist' ){
                        a.addError(System.Label.Account_Error_Message1);
                    }else if(a.brand__c == 'SEIKO' && a.Seiko_Network__c == 'Visionary Alliance'){
                        a.addError(System.Label.Account_Error_Message2);
                    }
                }*/
                //After Insert               
                if(triggerEvent == System.TriggerOperation.AFTER_INSERT){
                    Boolean isConsiderableRecTypeForALC = isConsiderableRecTypeForALC(a.RecordTypeId);
                     //collect Account Ids for Account Life Cycle Record
                    if(a.Account_Status__c !='Closed' &&  a.Account_Status__c !='Blocked' && a.Account_Status__c !='Suspended' && isConsiderableRecTypeForALC && a.TACTICOM_SOF__c != null && a.TACTICOM_SOF__c !='none'){
                        accLifeCycleList.add(a);
                        somethingToDo = true;
                        //Stage should be updated to Start Business if sales<=0 and have Onboarding customer
                        if(a.Onboarding_Customer__c){
                         	alcTobeActiveAccs.add(a.Id);
                        }
                        else{
                            alcTobeDeactiveAccs.add(a.Id);//just collecting to deactive but all alc recs at the time of creation will be active.
                        }
                    }
                }
            }
        } else if(triggerEvent == System.TriggerOperation.BEFORE_DELETE && oldMap != null ) {
            for (Account a : oldMap.values()) {
                  if (a.hoya_account_id__c.startsWithIgnoreCase('US') ||a.hoya_account_id__c.startsWithIgnoreCase('CA')||a.hoya_account_id__c.startsWithIgnoreCase('VE')||a.hoya_account_id__c.startsWithIgnoreCase('SOA')) {
                        hvnaList.add(a);
                        somethingToDo = true;           
                  }  
            }
        }

        switch on triggerEvent {
            when BEFORE_INSERT {
                if (somethingToDo) {
                    doHVNABeforeinsert(hvnaList);
                    //doHOLKBeforeInsert(holkList);
                    //doAPACAccountBeforeInsert(apacList);
                    validateEndConsumer(ecList);
                    modifyOnekeyRecords(oneKeyList);                    
                    //To assign the Strategic Net Sales based on Gross Sales
                    //As there is no Id before insert sending the null as newMap
                    doLastSalesStatisticsUpdate(strategicGrossUpdateList,null,'gross','INSERT');
                    SetGlobalCompetitorNames(namesToBeUpdatedList);
                }
                addSAPCompanyCode(newList);
                addMigratedToSFDC(newList);
            }
            when AFTER_INSERT {
                if (somethingToDo) {
                    doHVNAAfterInsert(hvnaList);
                    doSeikoInsert(seikoList);
                    //doAPACAfterInsert(oppList);
                    doALCUpsert(accountIdLst,accLifeCycleList,'Insert',alcTobeActiveAccs,alcTobeDeactiveAccs);
                }
            }
            when BEFORE_UPDATE{
                if (somethingToDo) {
                    doHVNABeforeUpdate(hvnaList, newMap, oldMap);
                    //doHOLKBeforeUpdate(holkList);
                    doHLFRBeforeUpdate(hlfrList, oldMap);
                    //doAPACAccountBeforeUpdate(apacList, oldMap);
                    //For Statistics Potential and Strategic Net Sales
                    System.debug(strategicNetUpdateList);
                    doLastSalesStatisticsUpdate(strategicGrossUpdateList,newMap,'gross','UPDATE');
                    doLastSalesStatisticsUpdate(strategicNetUpdateList,newMap,'net','UPDATE');
                    SetGlobalCompetitorNames(namesToBeUpdatedList);                    
                    addMigratedToSFDC(ownerUpdateList);
                    addSAPCompanyCode(shopCountryList);
                    //@This method is responsible for updating the account name from blank or 'No Name' to 'Private Studio'
                    updateOneKeyRecordsToPrivateStudio(oneKeyUpdateList);
                    
                }
                
            }
            when AFTER_UPDATE {
                if (somethingToDo) {
                    doSeikoUpdate(seikoList, oldMap);
                    doHVNAAfterUpdate(hvnaList, newMap, oldMap);
                    //doAPACUpdateAfterUpdate(oppList, oldMap);
                    if (!blockedAccs.isEmpty()) {
                        deactivateContacts(blockedAccs);   
                    }
                    if (!unblockedAccs.isEmpty()) {
                        activateContacts(unblockedAccs);
                    }
                    doALCUpsert(accountIdLst,accLifeCycleList,'Update',alcTobeActiveAccs,alcTobeDeactiveAccs);
                }
            }
            when BEFORE_DELETE {
                if(somethingToDo) {
                    doHVNAdelete(hvnaList);
                }
            }
            when AFTER_DELETE{

            }
        }
    }
    public static void addMigratedToSFDC(List<Account> newList) {
        List<Entity_Detail__mdt> entityList = Entity_Detail__mdt.getAll().values();
        Map<String, Entity_Detail__mdt> keyToSAPCodeMapping =  new Map<String,Entity_Detail__mdt>();
        for (Entity_Detail__mdt eachEntity : entityList) {
            if (String.isNotBlank(eachEntity.Country_Code__c) && String.isNotBlank(eachEntity.Brand__c) && String.isNotBlank(eachEntity.Company_Name__c)) {
                String key = eachEntity.Brand__c + '-' + eachEntity.Country_Code__c;
                keyToSAPCodeMapping.put(key, eachEntity);
            }
        }
        for (Account eachAccount : newList) {
            if (!keyToSAPCodeMapping.isEmpty() && String.isNotBlank(eachAccount.shop_Country__c) && String.isNotBlank(eachAccount.Brand__c) && String.isNotBlank(eachAccount.Account_Owner_Company__c)) {
                String key = eachAccount.Brand__c + '-' + eachAccount.shop_Country__c;
                Entity_Detail__mdt entityDetailRecord = keyToSAPCodeMapping.get(key);
                if (entityDetailRecord != null && entityDetailRecord.Company_Name__c.equalsIgnoreCase(eachAccount.Account_Owner_Company__c)) {
                    eachAccount.Migrated_To_SFDC_V2__c = entityDetailRecord.Is_SFDC_V2_Enabled__c;
                }
            }
        }
    }
    
    private static void addSAPCompanyCode(List<Account> newList) {
        List<Entity_Detail__mdt> entityList = Entity_Detail__mdt.getAll().values();
        Map<String, String> keyToSAPCodeMapping =  new Map<String,String>();
        for (Entity_Detail__mdt eachEntity : entityList) {
            if (String.isNotBlank(eachEntity.Country_Code__c) && String.isNotBlank(eachEntity.Brand__c) && String.isNotBlank(eachEntity.SAP_Company_Code__c)) {
                String key = eachEntity.Brand__c + '-' + eachEntity.Country_Code__c;
                keyToSAPCodeMapping.put(key, eachEntity.SAP_Company_Code__c);
            }
        }
        for (Account eachAccount : newList) {
            if (!keyToSAPCodeMapping.isEmpty() && String.isNotBlank(eachAccount.shop_Country__c) && String.isNotBlank(eachAccount.Brand__c)) {
                String key = eachAccount.Brand__c + '-' + eachAccount.shop_Country__c;
                String sapCode = keyToSAPCodeMapping.get(key);
                if (sapCode != null) {
                    if (eachAccount.hoya_Account_Id__c.startsWith('SO4900') && eachAccount.Brand__c == 'SEIKO' && eachAccount.shop_country__c == 'DE') {
                        // For SEIKO Germany accs we have two codes as of now(EQ31 & EQ3D) hence handled 2nd SAP code through here. Other code will be processed through metadata records above
                        sapCode = 'EQ31';
                    } else if (eachAccount.shop_country__c == 'HU' && eachAccount.CHCUSTCLASSIFICATIONID__c == 'Dis' && eachAccount.Brand__c == 'HOYA') {
                        // For HOYA Hungary we have two codes as of now(EK31 & EK32)
                        sapCode = 'EK32';
                    }
                    eachAccount.SAP_Company_Code__c = sapCode;
                }
            }
        }
    }
    
    private static void validateEndConsumer(List<Account> ecList) {
        for (Account eachAcc : ecList) {
            if (eachAcc.Hoya_Account_Id__c != null && !eachAcc.Hoya_Account_Id__c.startsWith('EC-')) {
                eachAcc.addError('Hoya Account Id must start with \'EC-\' for End Consumers');
            } else if (eachAcc.parentId == null) {
                eachAcc.addError('Parent Account is required for End Consumers');
            }
        }

    }
    private static void modifyOnekeyRecords(List<Account> newList) {
        String clinicRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Clinic').getRecordTypeId();
        Map<String, Owner_Assignmet_Rules_IQVIA__mdt> allMetadadata = Owner_Assignmet_Rules_IQVIA__mdt.getAll();
        for (Account eachAcc : newList) {
            // set record type
            eachAcc.recordTypeId = clinicRecordTypeId;
            eachAcc.Channel__c = 'Clinic';
            eachAcc.CHCUSTCLASSIFICATIONID__c = 'Clinic';

            // set fake Hoya account Id
            eachAcc.hoya_account_id__c = eachAcc.QIDC__OneKeyId_IMS__c;
            updateAccountName(eachAcc);
            // Set the country specific pre-defined owners for newly inserted iqvia records
            if (eachAcc.OwnerId == '005b0000000EOhtAAG') { // record downloaded using automated process
                for (Owner_Assignmet_Rules_IQVIA__mdt eachCountry : allMetadadata.values()) {
                    if (eachAcc.QIDC__OneKeyId_IMS__c.startsWith(eachCountry.Country_Code__c) && !String.isEmpty(eachCountry.Default_Owner_Id__c)) {
                        eachAcc.OwnerId = eachCountry.Default_Owner_Id__c;
                    }
                }   
            }
        }
    }
    /*The updateAccountName method is designed to standardize the name of an Account record in Salesforce. 
      Specifically, it ensures that the name field of the Account is set to "PRIVATE STUDIO" if it is currently blank or contains the default placeholder text "NO NAME".
    */
    public static void updateAccountName(Account eachAcc){
        if (String.isBlank(eachAcc.name) || eachAcc.Name.equalsIgnoreCase('NO NAME')) {
            eachAcc.name = 'PRIVATE STUDIO';
        }
    }
    public static void updateOneKeyRecordsToPrivateStudio(List<Account> newList){
        for (Account eachAcc : newList) {
            updateAccountName(eachAcc);
        }
    }
    public static void deactivateContacts(Set<Id> accIds) {
        if(!System.isFuture() && !System.isBatch()) {
            AccountTriggerHelper.toggleContactActivation(accIds, true);
        }
    }

    public static void activateContacts(Set<Id> accIds) {
        if(!System.isFuture() && !System.isBatch()) {
            AccountTriggerHelper.toggleContactActivation(accIds, false);
        }
    }

    public static void toggleContactActivation(Set<Id> accIds, boolean deactivate) {
        // Restrict access to all Hoya services if the Account_status__c is blocked/closed suspended
        if (deactivate) {
            List<Contact> conList = [Select Id, deactivate__c, Portal_Access_Suspended__c From Contact Where AccountId IN :accIds];
            if (!conList.isEmpty()) {
                for (Contact eachCon : conList) {
                    eachCon.deactivate__c = true;
                    eachCon.Portal_Access_Suspended__c = true;
                }
                try {
                    update conList;
                } catch (Exception e) {
                    System.debug('Exception::'+e);
                }
                
            }
        } else {
            // Reactivate access to all Hoya services if the Account_status__c is changed to Open
            List<Contact> conList = [Select Id, deactivate__c, Portal_Access_Suspended__c From Contact Where AccountId IN :accIds AND Portal_Access_Suspended__c = true];
            if (!conList.isEmpty()) {
                for (Contact eachCon : conList) {
                    eachCon.deactivate__c = false;
                    eachCon.Portal_Access_Suspended__c = false;
                }
                try {
                    update conList;
                } catch (Exception e) {
                    System.debug('Exception::'+e);
                }
            }
            
        }
        
    }

    @TestVisible private static void doSeikoInsert(List<Account> newList){
        //managing SEIKO data
        if(newList.size()>0){
            List<Seiko_data__c> insertList = new List<Seiko_data__c>();
            for(Account a : newList) {
                System.debug('1.1 AccountTrigger - creating Seiko data for account ' + a.hoya_account_id__c);
                //SEIKO data creation
                Seiko_data__c s = new Seiko_data__c();
                s.currencyisocode=a.currencyisocode;
                s.name = a.name;
                if(a.name.length() > 80 ){
                    s.name = a.name.substring(0, 80);
                }
                s.hoya_account_id__c = a.hoya_account_id__c;
                s.account__c = a.id;
                insertList.add(s);
            }
            insert insertList;
        }
    }

    @TestVisible private static void doSeikoUpdate(List<Account> newList,  Map <Id, Account> oldMap){
        if(newList.size()>0){
            List<Seiko_data__c> upsertList = new List<Seiko_data__c>();
            List<Opportunity> oppList = new List<Opportunity>();
            List<Opportunity> oppToCLoseList = new List<Opportunity>();
            List<Id> accIdWithOppToClose = new List<Id>();
            // String oppRecordTypeId =  [select Id,Name from RecordType where sObjectType='Opportunity' and Name='Seiko Vision Specialist Hunting'].Id;
            String oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Seiko Vision Specialist Hunting').getRecordTypeId();
            for(Account a : newList) {
                System.debug('1.1 AccountTrigger - update Seiko data for account ' + a.hoya_account_id__c+','+a.name);
                //SEIKO data creation
                Seiko_data__c s = new Seiko_data__c();
                s.currencyisocode=a.currencyisocode;
                s.name = a.name.abbreviate(80) ;
                s.hoya_account_id__c = a.hoya_account_id__c;
                s.account__c = a.id;
                upsertList.add(s);

                //manage opportunities
                Account old = oldMap.get(a.Id);
                if(old.Target_List__c<>a.Target_List__c){
                    if(a.Target_List__c==true){
                        //create new opportunity
                        Opportunity opp = new Opportunity();
                        opp.name = 'Target List: '  + a.name;
                        opp.OwnerId = a.OwnerId;
                        opp.AccountId = a.Id;
                        opp.RecordTypeId = oppRecordTypeId;
                        opp.CurrencyIsoCode = a.CurrencyIsoCode;
                        opp.Annual_Expected_Sales__c = a.Potential__c * 0.5;
                        opp.CloseDate = System.today()+180;
                        opp.StageName = '1. 1st Appointment';
                        //opp.ForecastCategory = 'Pipeline';
                        oppList.add(opp);

                    } else if(a.Target_List__c==false){
                        accIdWithOppToClose.add(a.Id);
                    }
                }
            }
            if(oppList.size()>0){
                insert oppList;
            }
            if(accIdWithOppToClose.size()>0){
                List<Opportunity> tempList = [select Id, stageName from opportunity where accountId in :accIdWithOppToClose and stageName='1. 1st Appointment'];
                System.debug('XXX AccountTrigger Seiko opp size=' + tempList.size());
                for (Opportunity opp:tempList){
                    opp.StageName='[SVS] Closed Lost';
                    System.debug('XXX AccountTrigger Seiko opp id=' + opp.Id + ',Stage =' + opp.StageName);
                    oppToCLoseList.add(opp);
                }
                if(oppToCLoseList.size()>0){
                    try{
                        System.debug('XXX AccountTrigger Seiko close call ' + oppToCLoseList.size());
                        update oppToCLoseList;
                    } catch(DmlException e) {
                        System.debug('XXX An unexpected error has occurred: ' + e.getMessage());
                    }
                }
            }
            upsert upsertList Hoya_Account_Id__c;
        }
    }
    /**
     * @Author : Surawat Sakulmontreechai
     * Updated : 2024-08-01
     * Description : We no need this class anymore due we should migrate to SFDC V.2.0.
     * Updated by : Surawat Sakulmontreechai | surawat.sakulmontreechai@hoya.com
     */

    /*
    @TestVisible private static void doAPACAfterInsert(List<Account> newList){
        if(newList.size()>0){

            String HuntingOppRecId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Hunting_Opportunities').getRecordTypeId();
            String userId = UserInfo.getUserId();
            String companyname = getUserCompany(userId);
            String UserSalesRolesName = getUserSalesRoles(userId);
            System.debug('XXX Get User Sales Role Name '+UserSalesRolesName+' XXX');
            Integer counter = [select count() from Opportunity where RecordTypeId=:HuntingOppRecId ALL ROWS]+1;
            System.debug('XXX Counting for Hunting opportunity id : '+counter+' XXX');
            String oppIdNumber = 'HUNT-'+String.valueOf(counter).leftPad(6, '0');
            List<String> companyIds = new List<String>();
            for(Account a : newList){
                companyIds.add(a.Account_Owner_Company__c);
            }
            List<Opportunity_Custom__c> oppCustomList = [select Id, Name, Company_Name__c from Opportunity_Custom__c where Company_Name__c IN:companyIds];
            //String oppCustomDefaultId = [select Id from Opportunity_Custom__c where Company_Name__c='DEFAULT'].Id;

            List<Opportunity_Custom__c> oppCustomDefaultId = [select Id from Opportunity_Custom__c where Company_Name__c='DEFAULT' LIMIT 1];
            String oppCustDefaultId = String.valueOf(oppCustomDefaultId);            
            
            System.debug('XXX Opporutnity Custom Default '+oppCustDefaultId);


            List<Opportunity> insertListOpp = new List<Opportunity>();
            for(Account a : newList){
                if((a.Target_List__c == true) && (a.Segmentation_Box__c=='A3' || a.Segmentation_Box__c=='B3' || a.Manual_Segment__c=='A3' || a.Manual_Segment__c=='B3')){
                    Opportunity o = new Opportunity();
                    o.AccountId = a.Id;
                    o.Name = oppIdNumber+'-'+a.Hoya_Account_ID__c+'-'+a.Name;
                    o.CloseDate = System.today()+90;
                    o.StageName = '1-Initial Contact';
                    o.RecordTypeId = HuntingOppRecId;
                    o.CurrencyIsoCode = a.CurrencyIsoCode;
                    o.ForecastCategoryName = 'Pipeline';
                    o.Hoya_Account_Id__c = a.Hoya_Account_ID__c;
                    
                    if(companyname=='HLUK' && UserSalesRolesName=='RSM'){
                        o.OwnerId = userId;
                    }else{
                        o.OwnerId = a.OwnerId;
                    }

                    for(Opportunity_Custom__c oppCust : oppCustomList){
                        System.debug(oppCustomList);
                        System.debug(a.Account_Owner_Company__c);
                        if(a.Account_Owner_Company__c == oppCust.Company_Name__c){
                            o.Opportunity_Custom__c = oppCust.Id;
                        }else if(a.Account_Owner_Company__c != oppCust.Company_Name__c){
                            o.Opportunity_Custom__c = oppCustDefaultId;
                            System.debug(oppCustDefaultId);
                        }
                    }

                    insertListOpp.add(o);
                }
            }
            if(!insertListOpp.isEmpty()){insert insertListOpp;}

        }
    }*/

    /**
     * Author : Surawat Sakulmontreechai
     * Updated : 2024-08-01
     * Description : We no need this class below anymore, due we should migrate to SFDC V.2.0.
     * Updated By : Surawat Sakulmontreechai | surawat.sakulmontreechai@hoya.com
    */

    /*
    @TestVisible private static void doAPACUpdateAfterUpdate(List<Account> newList, Map<Id, Account> oldMap){
        if(newList.size()>0){
            List<Opportunity> HuntOppList = new List<Opportunity>();
            List<Opportunity> oppToCloseList = new List<Opportunity>();
            List<Id> oppIdToClosed = new List<Id>();
            String HuntingOppRecId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Hunting_Opportunities').getRecordTypeId();
            //System.debug('XXX Create for new opportunity record type : '+HuntingOppRecId);
            String userId = UserInfo.getUserId();
            //System.debug('XXX User Id : '+userId);
            String companyname = getUserCompany(userId);
            //System.debug('XXX User Company Name : '+companyname);
            String UserSalesRolesName = getUserSalesRoles(userId);
            //System.debug('XXX Get User Sales Role Name '+UserSalesRolesName+' XXX');
            Integer counter = [select count() from Opportunity where RecordTypeId=:HuntingOppRecId ALL ROWS]+1;
            //System.debug('XXX Counting for Hunting opportunity id : '+counter+' XXX');
            String oppIdNumber = 'HUNT-'+String.valueOf(counter).leftPad(6, '0');
            List<String> companyIds = new List<String>();
            for(Account a : newList){
                companyIds.add(a.Account_Owner_Company__c);
            }
            List<Opportunity_Custom__c> oppCustomList = [select Id, Name, Company_Name__c from Opportunity_Custom__c where Company_Name__c IN:companyIds];
            //String oppCustomDefaultId = [select Id from Opportunity_Custom__c where Company_Name__c='DEFAULT'].Id;
            List<Opportunity_Custom__c> oppCustomDefaultId = [select Id from Opportunity_Custom__c where Company_Name__c='DEFAULT'];
            String oppCustDefaultId = String.valueOf(oppCustomDefaultId);
            //System.debug('XXX Opporutnity Custom Default '+oppCustDefaultId);

            for(Account a : newList){
                Account old = oldMap.get(a.Id);
                if(old.Target_List__c <> a.Target_List__c){
                    if((a.Target_List__c == true) && (a.Segmentation_Box__c=='A3' || a.Segmentation_Box__c=='B3' || a.Manual_Segment__c=='A3' || a.Manual_Segment__c=='B3')){
                        //Create new opportuntiy following the criteria above
                        Opportunity o = new Opportunity();
                        o.AccountId = a.Id;
                        o.CurrencyIsoCode = a.CurrencyIsoCode;
                        o.Name = oppIdNumber+'-'+a.Hoya_Account_ID__c+'-'+a.Name;
                        System.debug('XXX Opportunity Number : '+oppIdNumber+'-'+a.Hoya_Account_ID__c+'-'+a.Name);
                        o.CloseDate = System.today()+90;
                        o.StageName = '1-Initial Contact';
                        o.RecordTypeId = HuntingOppRecId;
                        o.CurrencyIsoCode = a.CurrencyIsoCode;
                        o.ForecastCategoryName = 'Pipeline';
                        o.Hoya_Account_Id__c = a.Hoya_Account_ID__c;

                        if(companyname=='HLUK' && UserSalesRolesName=='RSM'){
                            o.OwnerId = userId;
                        }else{
                            o.OwnerId = a.OwnerId;
                        }
                        for(Opportunity_Custom__c oppCust : oppCustomList){
                            if(a.Account_Owner_Company__c == oppCust.Company_Name__c){
                                o.Opportunity_Custom__c = oppCust.Id;
                            }else if(a.Account_Owner_Company__c != oppCust.Company_Name__c){
                                o.Opportunity_Custom__c = oppCustDefaultId;
                            }
                        }
                        HuntOppList.add(o);
                    }else if(a.Target_List__c==false){
                        oppIdToClosed.add(a.Id);
                    }
                }
            }
            
            if(!HuntOppList.isEmpty()){insert HuntOppList;}

            if(oppIdToClosed.size()>0){
                List<Opportunity> oppTocloseAcc = [select Id, StageName, AccountId from Opportunity where AccountId IN:oppIdToClosed and StageName!='6-Closed Win-Activate'];
                for(Opportunity opp : oppTocloseAcc){
                    opp.StageName = '6-Closed Lost-Postpone';
                    //System.debug('XXX Close for opportunity '+opp.Id+' StageName == > '+opp.StageName);
                    oppToCloseList.add(opp);
                    //closed for opportunity if unchecked target list in Account
                }
                if(oppToCLoseList.size()>0){
                    try{
                        //System.debug('XXX Account Trigger Close for Hunting Opportunity '+oppToCloseList.size());
                        update oppToCloseList;
                    }catch(Exception e){
                        LogException.log(e);
                        System.debug('XXX An error was occured : '+e.getMessage());
                    }
                }
            }
        }
    }*/

    @TestVisible private static void doHVNABeforeinsert(List<Account> newList){
        if(newList.size()>0){
            List<Additionnal_account_data__c> insertList = new List<Additionnal_account_data__c>();
            //List<Account> newListHVNA = new List<Account>([select Id, Name, OwnerId, currencyisocode, hoya_account_id__c from Account where Hoya_Account_ID__c like 'US%' order by CreatedDate desc limit 50]);
            for(Account a : newList) {
                System.debug('1.1 AccountTrigger - creating hvna account ' + a.hoya_account_id__c);
                //additional account data creation
                Additionnal_account_data__c aad = new Additionnal_account_data__c();
                aad.ownerid = a.ownerid;
                aad.currencyisocode=a.currencyisocode;
                aad.name = a.name;
                aad.hoya_account_id__c = a.hoya_account_id__c;
                insertList.add(aad);
            }
            if(insertList.size()>0){
                insert insertList;
                //link account and additional data
                for(Integer i = 0; i < newList.size(); i++) {
                    newList.get(i).additionnal_account_data__c = insertList.get(i).id;
                    //Update Account Portal for US and Canada Accounts
                    if(newList.get(i).hoya_account_id__c.startsWithIgnoreCase('US')){
                    newList.get(i).Portal__c=System.Label.US_Portal;  
                    }
                    else if(newList.get(i).hoya_account_id__c.startsWithIgnoreCase('CA')){
                        newList.get(i).Portal__c=System.Label.Canada_Portal;
                    }
                }
            }
        }
    }
    private static void doHVNAAfterInsert(List<Account> newList){
      
        if(newList.size()>0){
            //put account id in additional object
            List<Additionnal_account_data__c> updateList = new List<Additionnal_account_data__c>();
            List<Account> newListHVNA = new List<Account>([select Id, Name, Hoya_Account_ID__c, Additionnal_account_data__c from Account where Hoya_Account_ID__c like 'US%' order by LastModifiedDate desc limit 50]);
            List<ID> ids = new List<ID>();
            Map<String, String> accountDataMap = new Map<String, String>();
            for(Account a:newListHVNA){
                ids.add(a.additionnal_account_data__c);
                accountDataMap.put(a.Additionnal_account_data__c, a.id);
            }

            List<Additionnal_account_data__c> datas = [select id, master_account__c from additionnal_account_data__c where id in :ids ];
            for(Additionnal_account_data__c data: datas){
                data.master_account__c = accountDataMap.get(data.id);   
                updateList.add(data);
            }
            
            update updateList;
        }
    }

    private static void doHVNABeforeUpdate(List<Account> newList, Map<Id, Account> newMap, Map<Id, Account> oldMap){

        List<Additionnal_account_data__c> upsertList=new List<Additionnal_account_data__c>();
        List<Additionnal_account_data__c> insertList=new List<Additionnal_account_data__c>();
        //List<Account> newListHVNA = new List<Account>([select Id, Name, Hoya_Account_ID__c, Additionnal_account_data__c, CurrencyIsoCode, OwnerId from Account where Hoya_Account_ID__c like 'US%' order by LastModifiedDate desc limit 50]);
        //List<Account> newListHVNA = new List<Account>([select Id, Hoya_Account_ID__c, Name, ownerid, CurrencyIsoCode, Additionnal_account_data__c from Account where Hoya_Account_ID__c like 'US%' order by CreatedDate desc limit 50]);
        
        for(Account a:newList){
            Additionnal_account_data__c aad = new Additionnal_account_data__c();
            if(a.additionnal_account_data__c==null){
                aad.ownerid = a.ownerid;
                aad.currencyisocode=a.currencyisocode;
                aad.name = a.name;
                aad.hoya_account_id__c = a.hoya_account_id__c;
                aad.master_account__c = a.id;
                insertList.add(aad);

            } else {
                aad.id = a.Additionnal_account_data__c;
                //aad.ownerid = a.ownerid; CDU 02/12/2021, deactivated, ownerid set by additionalData sync job
                aad.currencyisocode=a.currencyisocode;
                aad.name = a.name;
                aad.hoya_account_id__c = a.hoya_account_id__c;
                aad.master_account__c = a.id;
                upsertList.add(aad);
            }
        }
        
        if(upsertList.size()>0){update upsertList;}
        if(insertList.size()>0){
            insert insertList;
            for(Additionnal_account_data__c newAad: insertList){
                Account acc = newMap.get(newAad.Master_Account__c);
                acc.Additionnal_account_data__c = newAad.Id;
                system.debug('3.4:TriggerAfterUpdate - link succesfull');
            }
        }
    }
    /*
    private static void doHlukAfterUpdate(List<Account> newList){

        List<Account> newUkList = [select Id, Hoya_Account_ID__c, Name from Account where Hoya_Account_ID__c like 'UK%' order by LastModifiedDate desc limit 50];
        for(Account a : newUkList){
            ExternalWSIncentiveSmartCall.synchronizeUser(a.Hoya_Account_ID__c);
        }
    }
    */
    private static void doHVNAAfterUpdate(List<Account> newList, Map<Id, Account> newMap, Map<Id, Account> oldMap){
        List<Task> taskList = new List<Task>();
        
        Set<Id> accids=new set<Id>();
        List<Additionnal_account_data__c> updateList = new List<Additionnal_account_data__c>();
        Map<String, String> accountDataMap = new Map<String, String>();
       
        //List<Account> newListHVNA = new List<Account>([select Id, Name, OwnerId, RecordTypeId, Hoya_Account_ID__c, CurrencyIsoCode, Create_New_Account_Tasks__c, HVNA_Create_Onboarding_Tasks__c from Account where Hoya_Account_ID__c like 'US%' order by LastModifiedDate desc limit 50]);
        //String srxRecordTypeId = [select Id,Name from RecordType where sObjectType='Task' and Name='SRX Sales Support'].Id;
        String srxRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('SRX Sales Support').getRecordTypeId();
        //String onBoardingRecordTypeId = [select Id,Name from RecordType where sObjectType='Task' and Name='HVNA Onboarding'].Id;
        String onBoardingRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('HVNA Onboarding').getRecordTypeId();

        String srxQueueId = [select Id from Group where type='Queue' and Name='SRX Task Queue' limit 1].Id;
        for(Account a:newList){
            //SRX Create New Account Tasks
            Account oldAccount = oldMap.get(a.id);
            if(oldAccount.Create_New_Account_Tasks__c<>a.Create_New_Account_Tasks__c && a.Create_New_Account_Tasks__c==true){
                taskList.addAll(manageSrxTaskList(a, srxRecordTypeId, srxQueueId));
            }
            if(oldAccount.HVNA_Create_Onboarding_Tasks__c<>a.HVNA_Create_Onboarding_Tasks__c && a.HVNA_Create_Onboarding_Tasks__c==true){
                taskList.addAll(manageHvnaOnboardingTasks(a, onBoardingRecordTypeId));
            }
            
            
            if(oldAccount.OwnerId<>a.OwnerId){
                accids.add(a.Id);
                accountDataMap.put(a.Id,a.OwnerId);                
            }
           
            
        }
        
        if (!accids.isEmpty()) {
            List<Additionnal_account_data__c> datas = [select id,OwnerId, master_account__c from additionnal_account_data__c where master_account__c in :accids ];
            for(Additionnal_account_data__c data: datas){
                data.OwnerId = accountDataMap.get(data.master_account__c);   
                updateList.add(data);
            }
        
            if(updateList.size()>0){
                    update updateList;
            }     
        }

        if(taskList.size()>0){insert taskList;}
    }
    
    private static List<Task> manageHvnaOnboardingTasks(Account a, String recordTypeId){
        List<Task> taskList = new List<Task>();
        taskList.add(newHvnaOnbordingAccountTask(System.today()+1,a.CurrencyIsoCode, 'Submit account form. Open or verify active account Lab Selection and Shipping Labels.', 'Normal',recordTypeId, a.ownerId
                ,'not started','1. Account Form Submitted', a.Id, false));
        taskList.add(newHvnaOnbordingAccountTask(System.today()+1,a.CurrencyIsoCode, 'Submit price request form, this takes a minimum of 5 days to set up.', 'Normal',recordTypeId, a.ownerId
            ,'not started','2. Price Request form submitted.', a.Id, false));
        taskList.add(newHvnaOnbordingAccountTask(System.today()+1,a.CurrencyIsoCode, 'Verify bill to/ship to plan set up Parent accounts in Salesforce if needed.', 'Normal',recordTypeId, a.ownerId
            ,'not started','3. Verify bill to/ship to plan', a.Id, false));
        taskList.add(newHvnaOnbordingAccountTask(System.today()+1,a.CurrencyIsoCode, 'Identify PMS, ensure lenses in the system, verify ordering capabilities', 'Normal',recordTypeId, a.ownerId
            ,'not started','4. Practice Management System Integration', a.Id, false));
        taskList.add(newHvnaOnbordingAccountTask(System.today()+1,a.CurrencyIsoCode, 'DVI/Eyefinity/Visionweb', 'Normal',recordTypeId, a.ownerId
            ,'not started','5. DVI/Eyefinity/Visionweb', a.Id, false));
        //taskList.add(newHvnaOnbordingAccountTask(System.today()+1,a.CurrencyIsoCode, 'Get Eyemed account number, send to Leigh Ann Tibbs', 'Normal',recordTypeId, a.ownerId
        taskList.add(newHvnaOnbordingAccountTask(System.today()+2,a.CurrencyIsoCode, 'Submit LLS New Account Form.  Send Eyemed account number to Leigh Ann Tibbs', 'Normal',recordTypeId, a.ownerId
            ,'not started','6. LLS Enrollment', a.Id, false));
        taskList.add(newHvnaOnbordingAccountTask(System.today()+1,a.CurrencyIsoCode, 'If needed', 'Normal',recordTypeId, a.ownerId
            ,'not started','7. Tracer Request form', a.Id, false));
        taskList.add(newHvnaOnbordingAccountTask(System.today()+1,a.CurrencyIsoCode, 'Validate Pricing/Promotions.', 'Normal',recordTypeId, a.ownerId
            ,'not started','8. Validate Pricing/Promotions', a.Id, false));
        taskList.add(newHvnaOnbordingAccountTask(System.today()+1,a.CurrencyIsoCode, 'Lab/CS Preparation Call-identify uncut/#jpd expected/Priorities.', 'Normal',recordTypeId, a.ownerId
            ,'not started','9. Lab/CS Preparation Call', a.Id, false));
        taskList.add(newHvnaOnbordingAccountTask(System.today()+1,a.CurrencyIsoCode, 'Determine CS Call Cadence Set priority in Salesforce for New Account Program', 'Normal',recordTypeId, a.ownerId
            ,'not started','10. Determine CS Call Cadence', a.Id, false));
        taskList.add(newHvnaOnbordingAccountTask(System.today()+1,a.CurrencyIsoCode, 'for order tracking/Demonstrate navigation to account', 'Normal',recordTypeId, a.ownerId
            ,'not started','11. Hoya Hub/VA setup', a.Id, false));
        taskList.add(newHvnaOnbordingAccountTask(System.today()+1,a.CurrencyIsoCode, 'Hoya Learning Center Registration', 'Normal',recordTypeId, a.ownerId
            ,'not started','12. Hoya Learning Center Registration', a.Id, false));
        taskList.add(newHvnaOnbordingAccountTask(System.today()+1,a.CurrencyIsoCode, 'Lens crosswalk', 'Normal',recordTypeId, a.ownerId
            ,'not started','13. Core Product Selection', a.Id, false));
        taskList.add(newHvnaOnbordingAccountTask(System.today()+1,a.CurrencyIsoCode, 'Prepare training deck', 'Normal',recordTypeId, a.ownerId
            ,'not started','14. Training Event Scheduled', a.Id, false));
        taskList.add(newHvnaOnbordingAccountTask(System.today()+1,a.CurrencyIsoCode, 'POP Materials Ordered', 'Normal',recordTypeId, a.ownerId
            ,'not started','15. POP Materials Ordered', a.Id, false));
        taskList.add(newHvnaOnbordingAccountTask(System.today()+1,a.CurrencyIsoCode, 'On-boarding Training/schedule follow up in VPM', 'Normal',recordTypeId, a.ownerId
            ,'not started','16. On-boarding Training', a.Id, false));
        taskList.add(newHvnaOnbordingAccountTask(System.today()+1,a.CurrencyIsoCode, 'Usually 1 week after onboarding, call lab check jobs before visit', 'Normal',recordTypeId, a.ownerId
            ,'not started','17. On-boarding Follow Up', a.Id, false));
        taskList.add(newHvnaOnbordingAccountTask(System.today()+1,a.CurrencyIsoCode, 'Verify accuracy with test traces to the lab, usually having account send traces and frames for two days for verification', 'Normal',recordTypeId, a.ownerId
            ,'not started','18. Tracer Setup', a.Id, false));
        taskList.add(newHvnaOnbordingAccountTask(System.today()+1,a.CurrencyIsoCode, 'Training 2/Statement Review', 'Normal',recordTypeId, a.ownerId
            ,'not started','19. Training 2/Statement Review', a.Id, false));
        return taskList;
    }

    private static List<Task> manageSrxTaskList(Account a, String srxRecordTypeId, String srxQueueId){
        
        List<Task> taskList = new List<Task>();
        taskList.add(newSrxAccountTask(System.today()+1,a.CurrencyIsoCode, 'Enter new account number in system', 'Normal',srxRecordTypeId, srxQueueId
                ,'not started','1. Enter Account Number in Optic', a.Id, false));
        taskList.add(newSrxAccountTask(System.today()+1,a.CurrencyIsoCode, 'Set up electronic invoicing (if applicable)', 'Normal',srxRecordTypeId, srxQueueId
                ,'not started','2. Set Up Electronic Invoicing', a.Id, false));
        taskList.add(newSrxAccountTask(System.today()+1,a.CurrencyIsoCode, 'Create profile in system', 'Normal',srxRecordTypeId, srxQueueId
                ,'not started','3. Create Profile', a.Id, false));
        taskList.add(newSrxAccountTask(System.today()+1,a.CurrencyIsoCode, 'Set up eligibility tracking (if applicable)', 'Normal',srxRecordTypeId, srxQueueId
                ,'not started','4. Eligibility Tracking', a.Id, false));
        taskList.add(newSrxAccountTask(System.today()+1,a.CurrencyIsoCode, 'Set up dispensing rebill (if applicable)', 'Normal',srxRecordTypeId, srxQueueId
                ,'not started','5. Dispensing Rebill', a.Id, false));
        taskList.add(newSrxAccountTask(System.today()+1,a.CurrencyIsoCode, 'Add instruction sheet to order form', 'Normal',srxRecordTypeId, srxQueueId
            ,'not started','6. Instruction Sheet', a.Id, false));
        taskList.add(newSrxAccountTask(System.today()+1,a.CurrencyIsoCode, 'ECP (onsite/offsite) identified and trained', 'Normal',srxRecordTypeId, srxQueueId
                ,'not started','7. ECP Identified + Trained', a.Id,false));
        taskList.add(newSrxAccountTask(System.today()+1,a.CurrencyIsoCode, 'Send sample frames to ECP as needed', 'Normal',srxRecordTypeId, srxQueueId
            ,'not started','8. Sample Frames', a.Id, false));
        taskList.add(newSrxAccountTask(System.today()+1,a.CurrencyIsoCode, 'Program launch/Start date', 'Normal',srxRecordTypeId, srxQueueId
            ,'not started','9. Program Launch', a.Id, false));
        taskList.add(newSrxAccountTask(System.today()+1,a.CurrencyIsoCode, 'Monitor WIP and establish regular communication with customer/TSM', 'Normal',srxRecordTypeId, srxQueueId
            ,'not started','10. Monitor WIP', a.Id, true));
        taskList.add(newSrxAccountTask(System.today()+1,a.CurrencyIsoCode, 'Program review / additional support', 'Normal',srxRecordTypeId, srxQueueId
            ,'not started','11. Program Review', a.Id, true));
        return taskList;
    }

    private static Task newSrxAccountTask(Date dueDate, String currencyCode, String Instruction, String priority, String recordTypeId
                    , String ownerId, String status, String subject, String whatId, Boolean reminderSet){
        Task t = new Task();
        t.CurrencyIsoCode = currencyCode;
        t.Instructions__c = Instruction;
        t.ActivityDate = dueDate;
        t.Priority = priority;
        t.RecordTypeId = recordTypeId;
        t.OwnerId = ownerId;
        t.Status = status;
        t.Subject = subject;
        t.WhatId = whatId;
        t.IsReminderSet=reminderSet;
        if(reminderSet && subject=='10. Monitor WIP'){
            t.ReminderDateTime = System.today()+30;
        }
        if(reminderSet && subject=='11. Program Review'){
            t.ReminderDateTime = System.today()+7;
        }
        return t;
    }

    private static Task newHvnaOnbordingAccountTask(Date dueDate, String currencyCode, String Instruction, String priority, String recordTypeId
                    , String ownerId, String status, String subject, String whatId, Boolean reminderSet){
        Task t = new Task();
        t.CurrencyIsoCode = currencyCode;
        t.Instructions__c = Instruction;
        t.Priority = priority;
        t.RecordTypeId = recordTypeId;
        t.OwnerId = ownerId;
        t.Status = status;
        t.Subject = subject;
        t.WhatId = whatId;
        t.ActivityDate = dueDate;
        t.IsReminderSet=reminderSet;
        return t;
    }

    private static void doHVNAdelete(List<Account> oldList){
        list<id> aadList = new List<id>();
        for(Account a : oldList){
            aadList.add(a.additionnal_account_data__c);
        }
        if(aadList.size()>0){
            list<additionnal_account_data__c> delList=[select id from additionnal_account_data__c where id in :aadList];
            delete delList;
        }
    }

    /**We no need this class anymore due will update to SFDC V.2.0. this class about HOLK Speicific */
    /*
    private static void doHOLKBeforeInsert(List<Account> newList){
        //List<Account> newListHOLK = new List<Account>([select Id, Name, Hoya_Account_ID__c from Account where Hoya_Account_ID__c like 'SK%' order by LastModifiedDate desc limit 50]);
        if(newList.size()>0){
            List<HOLK_account_data__c> insertList = new List<HOLK_account_data__c>();
            for(Account a : newList) {
                if(a.hoya_account_id__c.startsWith('KR')){
                    HOLK_account_data__c holk = new HOLK_account_data__c();
                    holk.ownerid = a.ownerid;
                    holk.currencyisocode=a.currencyisocode;
                    holk.name = a.name;
                    holk.hoya_account_id__c = a.hoya_account_id__c;
                    insertList.add(holk); 
                }
            }
            if(insertList.size()>0){
                upsert insertList hoya_account_id__c;
                for(Integer i = 0; i < newList.size(); i++) {
                    newList.get(i).HOLK_account_data__c = insertList.get(i).id;
                }
            }
        }
    }*/

    /* we no need this class due should migrate to SFDC V.2.0, this class specific for HOLK
    private static void doHOLKBeforeUpdate(List<Account> newList){
        //List<Account> newListHOLK = new List<Account>([select Id, Name, OwnerId, CurrencyIsoCode, HOLK_account_data__c, Hoya_Account_ID__c from Account where Hoya_Account_ID__c like 'SK%' order by LastModifiedDate desc limit 50]);
        if(newList.size()>0){
            Map<String, Account> linkAccountDataMap = new Map<String, Account>();
            List<HOLK_account_data__c> upsertList=new List<HOLK_account_data__c>();
            List<HOLK_account_data__c> insertList=new List<HOLK_account_data__c>();
            for(Account a: newList){
                HOLK_account_data__c aad = new HOLK_account_data__c();
                if(a.HOLK_account_data__c==null){
                    linkAccountDataMap.put(a.id, a);
                    aad.ownerid = a.ownerid;
                    aad.currencyisocode=a.currencyisocode;
                    aad.name = a.name;
                    aad.hoya_account_id__c = a.hoya_account_id__c;
                    insertList.add(aad);
                } else {
                    aad.id = a.HOLK_account_data__c;
                    aad.ownerid = a.ownerid;
                    aad.currencyisocode=a.currencyisocode;
                    aad.name = a.name;
                    aad.hoya_account_id__c = a.hoya_account_id__c;
                    upsertList.add(aad);
                }
            }
            if(upsertList.size()>0){update upsertList;}
            if(insertList.size()>0){
                upsert insertList hoya_account_id__c;
            }
        }

    }*/

    private static void doHLFRBeforeUpdate(List<Account> accList, Map<Id,Account> oldMap){
    
    if(accList.size()>0){
        if(UserInfo.getUserId()=='0050X000007FdP1QAK' ||UserInfo.getUserId()=='005b0000001fZtAAAU'){
            //only for accounts updated by batch (user AWS Synchronizer or cdupre)

            List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();

            Map<Id, Account> accountMap = new Map<Id,Account>();
            String userSOQL = 'Select id, Email From User where id in(';
            Integer nbAccount = 0;


            for(Account newAccount : accList){
                Account oldAccount = oldMap.get(newAccount.Id);
                String hai = newAccount.HOYA_Account_id__c;
                        
                if(newAccount.French_Customer_Classification__c!=oldAccount.French_Customer_Classification__c
                && newAccount.French_Customer_Classification__c!=null){
                    accountMap.put(newAccount.Id, newAccount);
                    userSOQL = userSOQL + '\'' + newAccount.ownerId + '\',';
                    nbAccount++;
                }
            }

            if(nbAccount>0){
                userSOQL = userSOQL.substring(0, userSOQL.length() - 1); //remove last ,
                userSOQL = userSOQL + ')';
                System.debug(userSOQL);
                Map<Id, User> userMap = new Map<Id, User>();
                List<User> userList = database.query(userSOQL);
                for(USer u : userList){
                    userMap.put(u.Id, u);
                }

                for(Account a :accountMap.values()){
                    //French_Customer_Classification__c have changed, send notification by mail
                    User activeUser = userMap.get(a.ownerId);
                    String userEmail = activeUser.Email;
                    Account oldAccount = oldMap.get(a.Id);

                    String[] toAddresses = new String[] {userEmail, 'facturation@hoya.fr', 'gonay@hoya.com'};
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setToAddresses(toAddresses);
                    mail.setSubject('Salesforce Support: Classification change for account '+a.Hoya_Account_ID__c);
                    mail.setSenderDisplayName('Salesforce Support');
                    mail.setHtmlBody('<p>Le compte '+a.Hoya_Account_ID__c+' a changé de classification. ('+oldAccount.French_Customer_Classification__c+'->'
                                        +a.French_Customer_Classification__c+')</p><br/>Email send automatically, please do not reply.');

                    mailList.add(mail);
                }
                
                if(mailList.size()>0 && !Test.isRunningTest()){
                    Messaging.sendEmail(mailList);
                }
            }
        }
        }
    }
    /**
     * Author : Surawat Sakulmontreechai
     * Updated : 2024-08-01
     * Description : We no need this class anymore, due we should migrate to SFDC V.2.0.
     * Updated by : Surawat Sakulmontreechai | surawat.sakulmontreechai@hoya.com
     */

    /*
    private static void doAPACAccountBeforeInsert(List<Account> newList){
        //System.debug('#### Calling doAPACAccountBeforeInsert with size='+newList.size());
        
        if(newList.size()>0){
            for(Account acc : newList){
                //System.debug('### test acc.Hoya_Account_ID__c.startsWith(HK6)=' + (acc.Hoya_Account_ID__c.contains('/') || acc.Hoya_Account_ID__c.startsWith('HK6') || acc.Hoya_Account_ID__c.startsWith('CN8') || acc.Hoya_Account_ID__c.startsWith('TW046')));
               
                if(acc.Hoya_Account_ID__c.startsWith('SG5') || acc.Hoya_Account_ID__c.startsWith('PH5') || acc.Hoya_Account_ID__c.startsWith('TW017') || acc.Name.contains('(S)') || (acc.DMU__c!=null && acc.DMU__c.startsWith('SOC')) || (acc.Hoya_Account_Id__c.startsWith('HK2'))){
                    acc.Keyman_name__c = 'SEIKO';
                    acc.Standard_Segmentation__c = acc.Segmentation_Box__c;
                    //System.debug('####1 ' + acc.Keyman_name__c );
                }else if(acc.DMU__c=='ILENS' || acc.Hoya_Account_ID__c.startsWith('HK6') || acc.Hoya_Account_ID__c.startsWith('CN8') || acc.Hoya_Account_ID__c.startsWith('TW046')){
                    acc.Keyman_name__c = 'PENTAX';
                    acc.Standard_Segmentation__c = acc.Segmentation_Box__c;
                    
                }else if(acc.Hoya_Account_ID__c.startsWith('KR') && acc.Actual_Classification__c=='1'){
                    acc.Keyman_name__c = 'HOYA';
                    acc.Standard_Segmentation__c = acc.Segmentation_Box__c;
                    acc.Portal__c = 'koportal';
                    acc.Language__c = 'ko-kr';
                    //System.debug('####3 ' + acc.Keyman_name__c );

                }else if(acc.Hoya_Account_ID__c.startsWith('KR') && acc.Actual_Classification__c=='2'){
                    acc.Keyman_name__c = 'VOMAX';
                    acc.Standard_Segmentation__c = acc.Segmentation_Box__c;
                    acc.Portal__c = 'koportal';
                    acc.Language__c = 'ko-kr';
                }else if(acc.Hoya_Account_ID__c.startsWith('KR') && acc.Actual_Classification__c=='3'){
                    acc.Keyman_name__c = 'SEIKO';
                    acc.Standard_Segmentation__c = acc.Segmentation_Box__c;
                    acc.Portal__c = 'koportal';
                    acc.Language__c = 'ko-kr';

                }else if(acc.Hoya_Account_ID__c.startsWith('AU') || acc.Hoya_Account_ID__c.startsWith('HK') || acc.Hoya_Account_ID__c.startsWith('MY') || acc.Hoya_Account_ID__c.startsWith('TH') || acc.Hoya_Account_ID__c.startsWith('SG') || acc.Hoya_Account_ID__c.startsWith('CN') || acc.Hoya_Account_ID__c.startsWith('PH') || acc.Hoya_Account_ID__c.startsWith('ID') || acc.Hoya_Account_ID__c.startsWith('TW') || acc.Hoya_Account_ID__c.startsWith('IN')){
                    acc.Keyman_name__c = 'HOYA';
                    acc.Standard_Segmentation__c = acc.Segmentation_Box__c;
                    //acc.Portal__c = 'koportal';
                    //acc.Language__c = 'ko-kr';
                    //System.debug('####4 ' + acc.Keyman_name__c );
                }else{
                    acc.Keyman_name__c = '';
                    acc.Standard_Segmentation__c = acc.Segmentation_Box__c;
                    //System.debug('####5 ' + acc.Keyman_name__c );
                }
            }
        }
    }*/

    /**
     * Author : Surawat Sakulmontreechai
     * Updated : 2024-08-01
     * Description : We no need below class anymore, due we should migrate to SFDC V.2.0.
     * Updated by : Surawat Sakulmontreechai | surawat.sakulmontreechai@hoya.com
     */

    /*
    private static void doAPACAccountBeforeUpdate(List<Account> newList, Map<Id, Account> oldMap){
        
        if(newList.size()>0){
            for(Account acc : newList){
                
                if(oldMap != null){
                    if(acc.Hoya_Account_ID__c.startsWith('SG5') || acc.Hoya_Account_ID__c.startsWith('PH5') || acc.Hoya_Account_ID__c.startsWith('TW017') || acc.Name.contains('(S)') || (acc.DMU__c!=null && acc.DMU__c.startsWith('SOC')) || (acc.Hoya_Account_Id__c.startsWith('HK2'))){
                        acc.Keyman_name__c = 'SEIKO';
                        acc.Standard_Segmentation__c = acc.Segmentation_Box__c;
                    }else if(acc.DMU__c=='ILENS' || acc.Hoya_Account_ID__c.startsWith('HK6') || acc.Hoya_Account_ID__c.startsWith('CN8') || acc.Hoya_Account_ID__c.startsWith('TW046')){
                        acc.Keyman_name__c = 'PENTAX';
                        acc.Standard_Segmentation__c = acc.Segmentation_Box__c;

                    }else if(acc.Hoya_Account_ID__c.startsWith('KR') && acc.Actual_Classification__c == '1'){
                        acc.Keyman_name__c = 'HOYA';
                        acc.Standard_Segmentation__c = acc.Segmentation_Box__c;
                        acc.Portal__c = 'koportal';
                        acc.Language__c = 'ko-kr';
                    }else if(acc.Hoya_Account_ID__c.startsWith('KR') && acc.Actual_Classification__c == '2'){
                        acc.Keyman_name__c = 'VOMAX';
                        acc.Standard_Segmentation__c = acc.Segmentation_Box__c;
                        acc.Portal__c = 'koportal';
                        acc.Language__c = 'ko-kr';
                    }else if(acc.Hoya_Account_ID__c.startsWith('KR') && acc.Actual_Classification__c == '3'){
                        acc.Keyman_name__c = 'SEIKO';
                        acc.Standard_Segmentation__c = acc.Segmentation_Box__c;
                        acc.Portal__c = 'koportal';
                        acc.Language__c = 'ko-kr';
                    
                    }else if(acc.Hoya_Account_ID__c.startsWith('AU') || acc.Hoya_Account_ID__c.startsWith('HK') || acc.Hoya_Account_ID__c.startsWith('MY') || acc.Hoya_Account_ID__c.startsWith('TH') || acc.Hoya_Account_ID__c.startsWith('SG') || acc.Hoya_Account_ID__c.startsWith('CN') || acc.Hoya_Account_ID__c.startsWith('PH') || acc.Hoya_Account_ID__c.startsWith('ID') || acc.Hoya_Account_ID__c.startsWith('TW') || acc.Hoya_Account_ID__c.startsWith('IN')){
                        acc.Keyman_name__c = 'HOYA';
                        acc.Standard_Segmentation__c = acc.Segmentation_Box__c;
                    }else{
                        acc.Keyman_name__c = '';
                        acc.Standard_Segmentation__c = acc.Segmentation_Box__c;
                    }
                }
            }
        }
    }*/

    public static String getUserCompany(String userId){
        System.debug('getUserCompany id is '+userId);
        String uid = userId;
        if(uid==null || uid==''){uid=UserInfo.getUserId();}
        User result = [select companyName from User where Id=:uid];
        System.debug('User company is '+result.companyName);
        if(result.companyName == '' || result.companyName==null){
            return 'HVC';
        }else{
            return result.companyName;
        }
    }

    public static String getUserSalesRoles(String userId){
        System.debug('getUserSalesRoes id is '+userId);
        String uid = userId;
        if(uid==null || uid==''){uid=UserInfo.getUserId();}
        User result = [select Sales_Role__c from User where Id=:uid];
        System.debug('User sales roles is '+result.Sales_Role__c);
        if(result.Sales_Role__c==''||result.Sales_Role__c==null){
            System.debug('User Sales Roles is Null and Return ASM');
            return 'ASM';
        }else{
            return result.Sales_Role__c;
        }
    }
    
    private static void doLastSalesStatisticsUpdate(List<Account> accountsList,Map<Id,Account> accNewMap,String type,String operationType){
        Map<Id,Last_Sales_Statistics__c> salesMap = new Map<Id,Last_Sales_Statistics__c>();
        List<Last_Sales_Statistics__c> lastSalesNetLst = new List<Last_Sales_Statistics__c>();
        List<Last_Sales_Statistics__c> lastSalesGrossLst = new List<Last_Sales_Statistics__c>();
        List<Id> accList =new List<Id>();
        if(accountsList.size() > 0){
            //Assign the Strategic NetSales based on Gross sales for countries who are using Gross sales only
            if(operationType == 'INSERT' || operationType == 'UPDATE'){
                for(Account acc:accountsList){
                    String HoyaAccountID = acc.Hoya_Account_ID__c;
                    Boolean isGermanyAccount = false;
                    if(HoyaAccountID != null && (HoyaAccountID.startsWith('SO4900') ||  HoyaAccountID.startsWith('SO4990')))
                        isGermanyAccount = true;
                    if(isGermanyAccount){
                        double avgDiscount = 0;
                        if(accNewMap != null && accNewMap.get(acc.Id).Market_Avg_Disc_Ind_L12M__c != null)
                            avgDiscount = accNewMap.get(acc.Id).Market_Avg_Disc_Ind_L12M__c;
                        double stategicGross = acc.Strategic_Value_Gross_Sales__c != null ? acc.Strategic_Value_Gross_Sales__c:0;
                        acc.Strategic_Value_Net_Sales__c = stategicGross*(1+avgDiscount);
                    }
                }
                if( operationType == 'UPDATE'){
                    for(Account acc:accountsList){
                        accList.add(acc.Id);
                        acc.Strategic_Value_Last_Update__c = date.valueOf(system.now());
                    }
                    Double seikoLensGrossSOWLast12Mo = 0;
                    Double seikoLensGrossSOWLast3Mo = 0;
                    Double seikoLensNetSOWLast12Mo = 0;
                    Double seikoLensNetSOWLast3Mo = 0;
                    Double hoyaLensGrossSOWLast12Mo = 0;
                    Double hoyaLensGrossSOWLast3Mo = 0;
                    Double hoyaLensNetSOWLast12Mo = 0;
                    Double hoyaLensNetSOWLast3Mo = 0;
                    Double hsLensGrossSOWLast12Mo = 0;
                    Double hsLensGrossSOWLast3Mo = 0;
                    Double hsLensNetSOWLast3Mo = 0;
                    Double hsLensNetSOWLast12Mo = 0;
                    List<Last_Sales_Statistics__c> lastSalesLst = [select Id,Account__c,Account__r.Strategic_Value_Net_Sales__c,Account__r.Strategic_Value_Gross_Sales__c,
                                                                   Seiko_Lens_Net_Sales_Last_12Mo__c,Hoya_Lens_Net_Sales_Last_12Mo__c,H_S_Lens_Net_Sales_Last_12Mo__c,
                                                                   Seiko_Lens_Net_Sales_Last_3Mo__c,Hoya_Lens_Net_Sales_Last_3Mo__c,H_S_Lens_Net_Sales_Last_3Mo__c,
                                                                   Seiko_Lens_Gross_Sales_Last_12Mo__c,Hoya_Lens_Gross_Sales_Last_12Mo__c,H_S_Lens_Gross_Sales_Last_12Mo__c,
                                                                   Seiko_Lens_Gross_Sales_Last_3Mo__c,Hoya_Lens_Gross_Sales_Last_3Mo__c,H_S_Lens_Gross_Sales_Last_3Mo__c from Last_Sales_Statistics__c where Account__c in :accList];
                    if(lastSalesLst.size () > 0){
                        for(Last_Sales_Statistics__c sale : lastSalesLst){
                            if(accNewMap.containsKey(sale.Account__c)){
                                System.debug(type);
                                //calculate Hoya,Seiko,H+s SOW 
                                if(type == 'gross'){    
                                    double strategicGrossSales = accNewMap.get(sale.Account__c).Strategic_Value_Gross_Sales__c;
                                    if(sale.Seiko_Lens_Gross_Sales_Last_12Mo__c != null && (strategicGrossSales != 0 && strategicGrossSales != null))
                                        seikoLensGrossSOWLast12Mo = (sale.Seiko_Lens_Gross_Sales_Last_12Mo__c/strategicGrossSales)*100; 
                                    if(seikoLensGrossSOWLast12Mo > 100)
                                        seikoLensGrossSOWLast12Mo = 100; 
                                    if(sale.Hoya_Lens_Gross_Sales_Last_12Mo__c != null && (strategicGrossSales != 0  && strategicGrossSales != null))
                                        hoyaLensGrossSOWLast12Mo = (sale.Hoya_Lens_Gross_Sales_Last_12Mo__c/strategicGrossSales)*100; 
                                    if(hoyaLensGrossSOWLast12Mo > 100)
                                        hoyaLensGrossSOWLast12Mo = 100;                         
                                    if(sale.H_S_Lens_Gross_Sales_Last_12Mo__c != null && (strategicGrossSales != 0  && strategicGrossSales != null))
                                        hsLensGrossSOWLast12Mo = (sale.H_S_Lens_Gross_Sales_Last_12Mo__c/strategicGrossSales)*100; 
                                    if(hsLensGrossSOWLast12Mo > 100)
                                        hsLensGrossSOWLast12Mo = 100;
                                    double strategicShare = 0;
                                    if(strategicGrossSales != null){
                                        strategicShare = strategicGrossSales/4;
                                    }
                                    if(strategicShare != 0)
                                    {                               
                                        if(sale.Seiko_Lens_Gross_Sales_Last_3Mo__c != null)
                                            seikoLensGrossSOWLast3Mo =(sale.Seiko_Lens_Gross_Sales_Last_3Mo__c/strategicShare)*100; 
                                        if(seikoLensGrossSOWLast3Mo > 100)
                                            seikoLensGrossSOWLast3Mo = 100;                                
                                        if(sale.Hoya_Lens_Gross_Sales_Last_3Mo__c != null)
                                            hoyaLensGrossSOWLast3Mo =(sale.Hoya_Lens_Gross_Sales_Last_3Mo__c/strategicShare)*100; 
                                        if(hoyaLensGrossSOWLast3Mo > 100)
                                            hoyaLensGrossSOWLast3Mo = 100;                                
                                        if(sale.H_S_Lens_Gross_Sales_Last_3Mo__c != null)
                                            hsLensGrossSOWLast3Mo =(sale.H_S_Lens_Gross_Sales_Last_3Mo__c/strategicShare)*100; 
                                        if(hsLensGrossSOWLast3Mo > 100)
                                            hsLensGrossSOWLast3Mo = 100;
                                    }
                                    sale.Hoya_Gross_Sales_SOW_Last_12Mo__c = hoyaLensGrossSOWLast12Mo;
                                    sale.Hoya_Gross_Sales_SOW_Last_3Mo__c = hoyaLensGrossSOWLast3Mo;
                                    sale.Seiko_Gross_Sales_SOW_Last_12Mo__c = seikoLensGrossSOWLast12Mo;
                                    sale.Seiko_Gross_Sales_SOW_Last_3Mo__c = seikoLensGrossSOWLast3Mo;                            
                                    sale.H_S_Gross_Sales_SOW_Last_12Mo__c = hsLensGrossSOWLast12Mo;
                                    sale.H_S_Gross_Sales_SOW_Last_3Mo__c = hsLensGrossSOWLast3Mo;
                                }
                                else{
                                    double strategicNetSales = accNewMap.get(sale.Account__c).Strategic_Value_Net_Sales__c;
                                    if(sale.Seiko_Lens_Net_Sales_Last_12Mo__c != null && (strategicNetSales != 0 && strategicNetSales != null))
                                        seikoLensNetSOWLast12Mo =(sale.Seiko_Lens_Net_Sales_Last_12Mo__c/strategicNetSales)*100; 
                                    System.debug(seikoLensNetSOWLast12Mo+'--'+sale.Seiko_Lens_Net_Sales_Last_12Mo__c+'--'+strategicNetSales);
                                    if(seikoLensNetSOWLast12Mo > 100)
                                        seikoLensNetSOWLast12Mo = 100;
                                    if(sale.Hoya_Lens_Net_Sales_Last_12Mo__c != null && (strategicNetSales != 0 && strategicNetSales != null))
                                        hoyaLensNetSOWLast12Mo =(sale.Hoya_Lens_Net_Sales_Last_12Mo__c/strategicNetSales)*100; 
                                    if(hoyaLensNetSOWLast12Mo > 100)
                                        hoyaLensNetSOWLast12Mo = 100;
                                    if(sale.H_S_Lens_Net_Sales_Last_12Mo__c != null && (strategicNetSales != 0 && strategicNetSales != null))
                                        hsLensNetSOWLast12Mo =(sale.H_S_Lens_Net_Sales_Last_12Mo__c/strategicNetSales)*100; 
                                    if(hsLensNetSOWLast12Mo > 100)
                                        hsLensNetSOWLast12Mo = 100;                                   
                                    double strategicShare = 0;
                                    if(strategicNetSales != null)
                                        strategicShare = strategicNetSales/4;
                                    if(strategicShare != 0)
                                    {
                                        if(sale.Seiko_Lens_Net_Sales_Last_3Mo__c != null && (strategicShare != null && strategicShare != 0))
                                            seikoLensNetSOWLast3Mo =(sale.Seiko_Lens_Net_Sales_Last_3Mo__c/strategicShare)*100; 
                                        if(seikoLensNetSOWLast3Mo > 100)
                                            seikoLensNetSOWLast3Mo = 100.0;
                                        if(sale.Hoya_Lens_Net_Sales_Last_3Mo__c != null && (strategicShare != null && strategicShare != 0))
                                            hoyaLensNetSOWLast3Mo =(sale.Hoya_Lens_Net_Sales_Last_3Mo__c/strategicShare)*100; 
                                        if(hoyaLensNetSOWLast3Mo > 100)
                                            hoyaLensNetSOWLast3Mo = 100.0;
                                        if(sale.H_S_Lens_Net_Sales_Last_3Mo__c != null && (strategicShare != null && strategicShare != 0))
                                            hsLensNetSOWLast3Mo =(sale.H_S_Lens_Net_Sales_Last_3Mo__c/strategicShare)*100; 
                                        if(hsLensNetSOWLast3Mo > 100)
                                            hsLensNetSOWLast3Mo = 100.0;
                                    }
                                    sale.Hoya_Net_Sales_SOW_Last_12Mo__c = hoyaLensNetSOWLast12Mo;
                                    sale.Hoya_Net_Sales_SOW_Last_3Mo__c = hoyaLensNetSOWLast3Mo;
                                    sale.Seiko_Net_Sales_SOW_Last_12Mo__c = seikoLensNetSOWLast12Mo;
                                    sale.Seiko_Net_Sales_SOW_Last_3Mo__c = seikoLensNetSOWLast3Mo;
                                    sale.H_S_Net_Sales_SOW_Last_12Mo__c = hsLensNetSOWLast12Mo;
                                    sale.H_S_Net_Sales_SOW_Last_3Mo__c = hsLensNetSOWLast3Mo;
                                }
                            }         
                            salesMap.put(sale.Account__c,sale);
                        }
                        if(salesMap.size() > 0){
                            if(type == 'gross')
                                lastSalesGrossLst.addAll(salesMap.values());
                            else
                                lastSalesNetLst.addAll(salesMap.values());
                        }
                        if(lastSalesGrossLst.size() > 0)
                            update lastSalesGrossLst;
                        if(lastSalesNetLst.size() > 0){
                            update lastSalesNetLst;                       
                        }
                    }
             }
            }
        }
    }   
    
    Public static void SetGlobalCompetitorNames(List<Account> accList){
        system.debug('>>>>tetse');
        Map<String, String> mapLocalToGlobalString = new Map<String, String>();
        for(Global_Competitor_Entity__mdt eachEntity : Global_Competitor_Entity__mdt.getAll().values()){
            mapLocalToGlobalString.put(eachEntity.Competitor_Entity_Name__c,eachEntity.First_Competitor_Global_Name__c);
        }
        for(Account accData : accList){
            //update 1st competitor
            String stringFirstCompetitor ='';
            String stringSecondCompetitor ='';
            if(String.isNotBlank(accData.First_Competitor_local_name__c) || String.isNotBlank(accData.Second_Competitor_Local_Name__c)){
                stringFirstCompetitor= accData.First_Competitor_local_name__c; 
                stringSecondCompetitor = accData.Second_Competitor_Local_Name__c;
            }
            Map<String, String> MapGlobalCompetitor = new Map<String, String>();
            System.debug('mapLocalToGlobalString'+mapLocalToGlobalString);
            if(!mapLocalToGlobalString.isEmpty() && String.isNotBlank(accData.First_Competitor_Local_Name__c)){
                
                String FirstGlobalCompetitor = mapLocalToGlobalString.get(stringFirstCompetitor);
                System.debug('FirstGlobalCompetitor'+FirstGlobalCompetitor);
                if(FirstGlobalCompetitor!=null){
                    accData.First_Competitor_Global_Name__c = FirstGlobalCompetitor;
                }else{
                    accData.First_Competitor_Global_Name__c = 'Other';
                }
            }else if(String.isBlank(accData.First_Competitor_Local_Name__c) || accData.First_Competitor_Local_Name__c==''){
                accData.First_Competitor_Global_Name__c = '';
            }
            
            if(!mapLocalToGlobalString.isEmpty() && String.isNotBlank(accData.Second_Competitor_Local_Name__c)){
                String SecondCompetitor = mapLocalToGlobalString.get(stringSecondCompetitor);
                if(SecondCompetitor!=null){
                    accData.Second_Competitor_global_name__c = SecondCompetitor;
                }else{
                    accData.Second_Competitor_global_name__c = 'Other';
                }
            }else if(String.isBlank(accData.Second_Competitor_Local_Name__c) || accData.Second_Competitor_Local_Name__c == ''){
                accData.Second_Competitor_global_name__c = '';
            }
        }
        
    }
    //Account Life Cycle Upsert
    public static void doALCUpsert(Set<Id> accountIdLst,Set<Account> accList,String operation, Set<Id> alcTobeActiveSet, Set<Id> alcTobeInActiveSet){
        List<Account_Life_Cycle__c> alcList = new List<Account_Life_Cycle__c>();
        if(accList.size() > 0){            
            if(operation == 'Insert'){
                for(Account acc:accList){
                    Account_Life_Cycle__c alc = new Account_Life_Cycle__c();
                    if(alcTobeActiveSet.size() > 0 && alcTobeActiveSet.contains(acc.Id)){
                        alc.Active__c = true;
                        alc.Stage__c = 'Start Business';//if OnBoarding customer is true
                    }else if(alcTobeInActiveSet.size() > 0 && alcTobeInActiveSet.contains(acc.Id)){
                        alc.Active__c = true;
                        alc.Stage__c = '';//new ALC no need of stage as there will not be any visits etc
                    }
                    alc.External_Key__c = acc.Id;    
                    alc.Account__c = acc.Id;   
                    alcList.add(alc);
                }
            }else{
                Map<Id,Visits__c> latestVisitMap = getLatestVisit(alcTobeActiveSet);    
                Map<Id,RetainDetails> accountRetainStageMap = getRetainStage(latestVisitMap);
                Set<Id> alcExistAccounts = new Set<Id>();
                alcExistAccounts = VisitTriggerHelper.isAlcRecordExists(accountIdLst);                
                for(Account acc:accList){
                    //get the Stages for the active alc records
                    String stage = getStage(acc,latestVisitMap);
                    Boolean retainFlag=false;
                    String retainReason='';
                    if(accountRetainStageMap.size() > 0 && accountRetainStageMap.containsKey(acc.id)){
                        retainFlag = accountRetainStageMap.get(acc.Id).retainStageFlag;                        
                        retainReason = accountRetainStageMap.get(acc.Id).retainReason;
                    }
                    //In any case if account is in inactive set dont activate as there is a chance to update multiple columns at the same time.
                    if(alcTobeActiveSet.contains(acc.id) && !alcTobeInActiveSet.contains(acc.Id) &&(stage != null || accountRetainStageMap.containsKey(acc.id))){
                        Account_Life_Cycle__c alc = new Account_Life_Cycle__c();
                        alc.Active__c = true;
                        if(stage != null)
                        	alc.Stage__c = stage;
                        alc.Retain_Stage__c = retainFlag;
                        alc.Retain_Reason__c = retainReason;
                        alc.External_Key__c = acc.Id;
                        alc.Account__c = acc.Id;
                        if(latestVisitMap.size() > 0 && latestVisitMap.containskey(acc.Id))
                       	 	alc.Latest_Visit_Considered__c = latestVisitMap.get(acc.Id).Id+'-'+latestVisitMap.get(acc.Id).Name;
                        else
                            alc.Latest_Visit_Considered__c = '';
                        alcList.add(alc);
                    }else if(alcTobeInActiveSet.contains(acc.id)){
                        Account_Life_Cycle__c alc = new Account_Life_Cycle__c();
                        alc.Active__c = false;
                        alc.External_Key__c = acc.Id;
                        alc.Account__c = acc.Id;
                        alcList.add(alc); 
                    }else{//Account is not considerable
                        if(alcExistAccounts.contains(acc.Id)){
                            Account_Life_Cycle__c alc = new Account_Life_Cycle__c();
                            alc.Active__c = false;
                            alc.External_Key__c = acc.Id;
                            alc.Account__c = acc.Id;
                            alcList.add(alc);                         
                        }
                    }
                }
            }
        }       
        if(alcList.size() > 0){
            upsert alcList External_Key__c;
        }
    }
    public static String getStage(Account acc,Map<Id,Visits__c> latestVisitMap){
        String alcStage = '';
        if(acc.Lenses_Net_Sales_Last_12Mo__c > 0){
            if((acc.CHCUSTCLASSIFICATIONID__c == 'Chain' && acc.TACTICOM_SOF__c != null && acc.TACTICOM_SOF__c != 'none') || acc.CHCUSTCLASSIFICATIONID__c == 'Ind'){
                if(acc.Segmentation_Net__c == 'A3' || acc.Segmentation_Net__c == 'B3' || acc.Segmentation_Net__c == 'C3' || acc.Segmentation_Net__c == 'UNCATEGORIZED'){
                    alcStage = 'Start Business';
                }else if(acc.Segmentation_Net__c == 'A2' || acc.Segmentation_Net__c == 'B2' || acc.Segmentation_Net__c == 'C2'){
                    alcStage = 'Develop';
                }else if(acc.Segmentation_Net__c == 'A1' || acc.Segmentation_Net__c == 'B1' || acc.Segmentation_Net__c == 'C1'){
                    alcStage = 'Build Loyalty';
                }
            }            
        }else{
            if(acc.Onboarding_Customer__c){
                alcStage = 'Start Business';
            }
            else{
                if(latestVisitMap.size() > 0 && latestVisitMap.containsKey(acc.id) ){
                    Visits__c latestVisit = latestVisitMap.get(acc.id);
                    if(latestVisit.Visit_Reason__c == 'Account Discovery')
                        alcStage = 'Discover';
                    else if(latestVisit.Visit_Reason__c == 'Negotiation' || latestVisit.Visit_Reason__c == 'Contract Signature')
                        alcStage = 'Negotiate';
                    else{
                        alcStage = 'Engage';
                    }
                }
                else if(acc.Total_Visits_Performed__c == 0){
                	alcStage = 'Discover';
                }
                else{
                    alcStage = 'Engage';
                }
            }
        }
        return alcStage;
    }
    //Method to get latest visit record for the Account whose alc should be active
    public static Map<Id,Visits__c> getLatestVisit(Set<Id> accIdLst){       
        Map<Id,Visits__c> LatestVisitMap = new Map<Id,Visits__c>();
        List<Id> accsWithVisitsLst = new List<Id>();
        List<DateTime> startDateLst = new List<DateTime>();
        Map<Id,DateTime> accDateMap = new Map<Id,DateTime>();
        //Query latest visits only with valid reason.
        List<AggregateResult> AggregateResultList = [SELECT Account__c,Max(Start_Time__c) latestTime FROM Visits__c 
                                                     WHERE Account__c in :accIdLst AND Visit_Type__c = 'Visit' AND Visit_Status__c != 'Cancelled'
                                                     Group By Account__c];
        if(AggregateResultList.size() > 0){
            for(AggregateResult aggr:AggregateResultList){
                accsWithVisitsLst.add((id)aggr.get('Account__c'));
                startDateLst.add((DateTime)aggr.get('latestTime') );
                accDateMap.put((id)aggr.get('Account__c'),(DateTime)aggr.get('latestTime'));
            }
        }
        System.debug(accDateMap);
        List<Visits__c> visits = [SELECT Id,Name,Account__r.Lenses_Net_Sales_Last_12Mo__c,Account__c,Account__r.Tacticom_SOF__c,Account__r.Segmentation_Net__c, Account__r.Last_Visit_date__c, Visit_Status__c, Visit_Reason__c, Start_Time__c 
                                  FROM Visits__c
                                  WHERE Account__c in :accsWithVisitsLst AND Start_Time__c in :startDateLst];
        if(visits.size() > 0){
            for(Visits__c visit : visits){
                if(accDateMap.size() > 0 && accDateMap.containsKey(visit.Account__c) ){
                    if(visit.Start_Time__c == accDateMap.get(visit.Account__c)){
                        LatestVisitMap.put(visit.Account__c,visit);
                    }
                }             
            }
        }
        System.debug(LatestVisitMap);
        return LatestVisitMap;
    }    
    public static Boolean isConsiderableRecTypeForALC(Id accRecTypeId){
        Boolean isConsiderable = false;
        if(accRecTypeId == getRecordTypeIdByName('Chain') || accRecTypeId == getRecordTypeIdByName('Chain_Seiko') || accRecTypeId == getRecordTypeIdByName('HOLK_Account_Page_Layout') || accRecTypeId == getRecordTypeIdByName('HVNA_Active_Customer')
          || accRecTypeId == getRecordTypeIdByName('HVNA_Prospect') || accRecTypeId == getRecordTypeIdByName('HVNA_Rep_Journal') || accRecTypeId == getRecordTypeIdByName('Independents') || accRecTypeId == getRecordTypeIdByName('Independent_Seiko')
          || accRecTypeId == getRecordTypeIdByName('Buying_Group') || accRecTypeId == getRecordTypeIdByName('Buying_Group_Seiko') ){
            isConsiderable = true;
        }        
        return isConsiderable;
        
    }
    public static Id getRecordTypeIdByName(String rtName) {
         Id accRecId = null;
         accRecId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(rtName).getRecordTypeId();
         return accRecId;
    }
    //Method to get the Retain Stage from latest visit for the Account
    public static Map<Id,RetainDetails> getRetainStage(Map<Id,Visits__c> latestVisitMap){
        Map<Id,RetainDetails> accRetainStageMap = new Map<Id,RetainDetails>();
        RetainDetails retainDetails = new RetainDetails();
         for(Id accId:latestVisitMap.keySet()){  
             Visits__c visit = latestVisitMap.get(accId);
             if(visit.Visit_Reason__c == 'Problem Solving' || visit.Visit_Reason__c == 'Customer Retention' || visit.Visit_Reason__c == 'Cash Collection'){
                retainDetails.retainStageFlag = true;
                retainDetails.retainReason = visit.Visit_Reason__c;
             }
             else{
                 retainDetails.retainStageFlag = false;   
             }  
             accRetainStageMap.put(visit.Account__c,retainDetails);
         }  
        return accRetainStageMap;
     }
    public class RetainDetails{
        public Boolean retainStageFlag{get;set;}
        public String retainReason{get;set;}
        public RetainDetails(){}
    }
}