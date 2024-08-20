/**
 ** @Suject : VPM Planned Visits Map
 ** @DevOppsURL : https://dev.azure.com/HoyaVC/Salesforce%20V2.0/_workitems/edit/1351/
 ** @Author : Surawat Sakulmontreechai
 ** @Email : surawat.sakulmontreechai@hoya.com
 ** @Description : this apex class support Task-1351 : Planned Visit Map. To render the planned map in lightning amp LWC
 ** @CreatedDate : 2024-04-30
 ** @CreatedBy : Surawat Sakulmontreechai
 **/
public with sharing class VPMPlannedVisitsMapController {
    @AuraEnabled(cacheable=true)
    public static List<Visits__c> getVisitPlanning(Date startDate, Date endDate){
        List<Visits__c> visitList = new List<Visits__c>();
        Id userId = UserInfo.getUserId();       //for current user id - login

        String soql = 'SELECT Id, Name, Account__r.Name, Account__r.Hoya_Account_ID__c, Account__c, '+
            			'Account__r.Shop_Street__c,Account__r.Shop_State__c, Account__r.Shop_City__c, Account__r.Shop_Country__c, '+
            			'Account__r.Shop_Postal_Code__c, Start_Day__c, '+
                        'Visit_Type__c, Visit_Status__c, Account__r.TACTICOM_SOF__c, Account__r.Last_Visit_date__c '+
                        'FROM Visits__c WHERE '+
                        'Visit_Type__c =\'Visit\' AND Assigned_to__c=:userId AND Visit_Status__c!=\'Cancelled\' '+
                        'AND Start_Day__c>=:startDate AND Start_Day__c <=:endDate ORDER BY Start_Day__c DESC LIMIT 500';

        List<Visits__c> vList = database.query(soql, AccessLevel.USER_MODE);
        visitList.addAll(vList);

        return vList;
    }
}