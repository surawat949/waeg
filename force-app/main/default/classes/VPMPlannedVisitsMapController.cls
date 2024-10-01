/**
 ** @Suject : VPM Planned Visits Map
 ** @DevOppsURL : https://dev.azure.com/HoyaVC/Salesforce%20V2.0/_workitems/edit/1351/
 ** @Author : Surawat Sakulmontreechai
 ** @Email : surawat.sakulmontreechai@hoya.com
 ** @Description : this apex class support Task-1351 : Planned Visit Map. To render the planned map in lightning map
 ** @CreatedDate : 2024-04-30
 ** @CreatedBy : Surawat Sakulmontreechai
 **
 ** @LastUpdated : 2024-09-13
 ** @LastUpdatedBy: Surawat Sakulmontreechai | https://dev.azure.com/HoyaVC/Salesforce%20V2.0/_workitems/edit/1678/
 ** @Description : Last update about Medical Visit Map. Only Medical Visit related will populate here.
 **/
public with sharing class VPMPlannedVisitsMapController {

    public static final string StandardVisitRT = Schema.SObjectType.Visits__c.getRecordTypeInfosByDeveloperName().get('Standard_Visit').getRecordTypeId();
    public static final string MedicalVisitRT = Schema.SObjectType.Visits__c.getRecordTypeInfosByDeveloperName().get('Eye_Doctor_Visit').getRecordTypeId();

    @AuraEnabled(cacheable=true)
    public static List<Visits__c> getVisitPlanning(Date startDate, Date endDate){
        List<Visits__c> visitList = new List<Visits__c>();
        Id userId = UserInfo.getUserId();       //for current user id - login

        String soql = 'SELECT Id, Name, Account__r.Name, Account__r.Hoya_Account_ID__c, Account__c, '+
            			'Account__r.Shop_Street__c,Account__r.Shop_State__c, Account__r.Shop_City__c, Account__r.Shop_Country__c, '+
            			'Account__r.Shop_Postal_Code__c, Start_Day__c, Account__r.ShippingLatitude, Account__r.ShippingLongitude, '+
                        'Visit_Type__c, Visit_Status__c, Account__r.TACTICOM_SOF__c, Account__r.Last_Visit_date__c '+
                        'FROM Visits__c WHERE '+
                        'Visit_Type__c IN (\'Visit\', \'Support Direct Visit\') AND Assigned_to__c=:userId AND Visit_Status__c!=\'Cancelled\' '+
                        'AND Start_Day__c>=:startDate AND Start_Day__c <=:endDate ORDER BY Start_Day__c DESC LIMIT 500';

        List<Visits__c> vList = database.query(soql, AccessLevel.USER_MODE);
        visitList.addAll(vList);

        return vList;
    }

    //For Task 1678 - Planed visit map for Eye Doctor - https://dev.azure.com/HoyaVC/Salesforce%20V2.0/_workitems/edit/1678/
    public class VisitsAccountList{
        @AuraEnabled public String AccountId{get;set;}
        @AuraEnabled public String AccountName{get;set;}
        @AuraEnabled public String ShopName{get;set;}
        @AuraEnabled public String AccountStreet{get;set;}
        @AuraEnabled public String AccountCity{get;set;}
        @AuraEnabled public String AccountState{get;set;}
        @AuraEnabled public String AccountPostalCode{get;set;}
        @AuraEnabled public String AccountCountry{get;set;}
        @AuraEnabled public String AccountSubArea{get;set;}
        @AuraEnabled public Double AccountShippingLatitude{get;set;}
        @AuraEnabled public Double AccountShippingLongitude{get;set;}
        @AuraEnabled public String AccountRT{get;set;}
        @AuraEnabled public String AccHoyaAccountId{get;set;}
        @AuraEnabled public Date AccNextVisitPlan{get;set;}
        @AuraEnabled public DateTime AccLastStoreVisitDate{get;set;}
        @AuraEnabled public List<VisitData> visitDataWrapper = new List<VisitData>(); //create new instance here
    }

    public class VisitData{
        @AuraEnabled public string ContactName{get;set;}
        @AuraEnabled public string VisitId{get;set;}
        @AuraEnabled public DateTime StartDateTime{get;set;}
        @AuraEnabled public DateTime EndDateTime{get;set;}
        @AuraEnabled public String ContactId{get;set;}

    }

    @AuraEnabled(cacheable=true)
    public static List<VisitsAccountList> getMedicalVisitsPlanning(Date startDate, Date endDate){
        String userId = UserInfo.getUserId();

        List<Visits__c> MainVisitList = [SELECT Id, Name, Account__c, Contact__c, Account__r.Name, Contact__r.Name, 
                                            Account__r.Clinic_Name__c, Account__r.Tacticom_SOF__c, Account__r.Hoya_Account_ID__c, 
                                            Account__r.Shop_City__c, Account__r.Shop_Street__c, Account__r.Recordtype.Name, Account__r.Last_Visit_date__c, 
                                            Account__r.Shop_State__c, Account__r.Shop_Postal_Code__c, Account__r.ShippingLatitude, Start_Day__c, 
                                            Account__r.ShippingLongitude, Account__r.Shop_Country__c, RecordType.Name, Start_Time__c, End_Time__c FROM Visits__c 
                                            WHERE Start_Day__c>=:startDate AND Start_Day__c <=:endDate AND Assigned_to__c=:userId 
                                            AND Visit_Type__c IN ('Visit', 'Support Direct Visit') AND Visit_Status__c != 'Cancelled' AND 
                                            RecordTypeId IN(:StandardVisitRT, :MedicalVisitRT) ORDER BY Account__r.Name ASC LIMIT 500];
        
        Map<Id, List<Visits__c>> mapAccToVisit = new Map<Id, List<Visits__c>>();
        for(Visits__c eachVisit : MainVisitList){
            if(mapAccToVisit.get(eachVisit.Account__c)==null){
                List<Visits__c> newVisitList = new List<Visits__c>();
                newVisitList.add(eachVisit);
                mapAccToVisit.put(eachVisit.Account__c, newVisitList);
                
            }else{
                List<Visits__c> newVisitList2 = mapAccToVisit.get(eachVisit.Account__c);
                newVisitList2.add(eachVisit);
                
            }
        }
        List<VisitsAccountList> lstParent = new List<VisitsAccountList>();
        for(Id key : mapAccToVisit.keyset()){
            VisitsAccountList pWrapper = new VisitsAccountList();
            if(mapAccToVisit.get(key)[0]!=null && mapAccToVisit.get(key)[0].Account__c!=null){
                //System.debug('Get key [0] Account Id ==>'+mapAccToVisit.get(key)[0].Account__c);
                //System.debug('Get key => '+mapAccToVisit.get(key));
                pWrapper.AccountId = mapAccToVisit.get(key)[0].Account__c;
                pWrapper.AccountName = mapAccToVisit.get(key)[0].Account__r.Name;
                pWrapper.ShopName = mapAccToVisit.get(key)[0].Account__r.Clinic_Name__c;
                pWrapper.AccountStreet = mapAccToVisit.get(key)[0].Account__r.Shop_Street__c;
                pWrapper.AccountCity = mapAccToVisit.get(key)[0].Account__r.Shop_City__c;
                pWrapper.AccountState = mapAccToVisit.get(key)[0].Account__r.Shop_State__c;
                pWrapper.AccountPostalCode = mapAccToVisit.get(key)[0].Account__r.Shop_Postal_Code__c;
                pWrapper.AccountCountry = mapAccToVisit.get(key)[0].Account__r.Shop_Country__c;
                pWrapper.AccountSubArea = mapAccToVisit.get(key)[0].Account__r.Tacticom_SOF__c;
                pWrapper.AccountShippingLatitude = mapAccToVisit.get(key)[0].Account__r.ShippingLatitude;
                pWrapper.AccountShippingLongitude = mapAccToVisit.get(key)[0].Account__r.ShippingLongitude;
                pWrapper.AccountRT = mapAccToVisit.get(key)[0].Account__r.RecordType.Name;
                pWrapper.AccHoyaAccountId = mapAccToVisit.get(key)[0].Account__r.Hoya_Account_ID__c;
                pWrapper.AccNextVisitPlan = mapAccToVisit.get(key)[0].Start_Day__c;
                pWrapper.AccLastStoreVisitDate = mapAccToVisit.get(key)[0].Account__r.Last_Visit_date__c;
            }

            List<VisitData> visitDataList = new List<VisitData>();

            for(Visits__c vList : mapAccToVisit.get(key)){
                VisitData vData = new VisitData();
                vData.ContactId = vList.Contact__c;

                if(vList.Contact__c!=null){
                    vData.ContactName = vList.Contact__r.Name;
                }

                vData.StartDateTime = vList.Start_Time__c;
                vData.EndDateTime = vList.End_Time__c;
                vData.VisitId = vList.Id;
                visitDataList.add(vData);
                
            }
            pWrapper.visitDataWrapper.addAll(visitDataList);
            
            lstParent.add(pWrapper);
        }

        //System.debug('Data List=>'+lstParent);
        return lstParent;
        
    }

}