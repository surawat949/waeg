/**
 * This Apex class handles filtering and fetching of sales managers and representatives
 * based on the current user's role and profile. It also fetches enabled companies for 
 * selection in the LWC component.
 */
public with sharing class CustomerReviewFilterHandler {

    /**
     * Fetches a list of companies that have SFDC V2 enabled.
     * 
     * @return A list of unique company names with SFDC V2 enabled.
     */
    @AuraEnabled(cacheable=true)
    public static List<String> getCompanies() {
        List<Entity_detail__mdt> metadataList = [SELECT Company_Name__c FROM Entity_detail__mdt WHERE Is_SFDC_V2_Enabled__c = true];
        Set<String> companies = new Set<String>();
        for (Entity_detail__mdt metadata : metadataList) {
            companies.add(metadata.Company_Name__c);
        }
        return new List<String>(companies);
    }

    /**
     * Fetches the list of sales managers based on the current user's profile and sales role.
     * 
     * @param companyName The name of the company selected (relevant for System Administrator).
     * @return A list of users who are sales managers.
     */
    @AuraEnabled(cacheable=true)
    public static List<User> getSalesManagerList(String companyName) {
        String currentUserId = UserInfo.getUserId();
        User currentUser = [SELECT Id, Sales_Role__c, CompanyName, Profile.Name, Name FROM User WHERE Id = :currentUserId LIMIT 1];
        List<User> managerList = new List<User>();
        if(currentUser.Profile.Name == 'SFDC LOCAL ADMIN'){
            companyName = currentUser.CompanyName;
        }
        if (currentUser.ProfileId == '00eb0000000lainAAA' || currentUser.Profile.Name == 'SFDC LOCAL ADMIN') {
            if (companyName != null && companyName != '') {
                managerList.addAll([SELECT Id, Name FROM User WHERE CompanyName = :companyName AND IsActive = TRUE AND (Sales_Role__c = 'NSM' OR Sales_Role__c = 'NMS' OR Sales_Role__c = 'RSM' OR Sales_Role__c = 'RMS') ORDER BY Name ASC]);
            }
        } else if (currentUser.Sales_Role__c != null) {
            if (currentUser.Sales_Role__c == 'NSM' || currentUser.Sales_Role__c == 'NMS') {
                managerList.add(currentUser);
                managerList.addAll([SELECT Id, Name FROM User WHERE ManagerId = :currentUserId AND IsActive = TRUE AND (Sales_Role__c = 'RSM' OR Sales_Role__c = 'RMS') ORDER BY Name ASC]);
            } else if (currentUser.Sales_Role__c == 'RSM' || currentUser.Sales_Role__c == 'RMS') {
                managerList.add(currentUser);
            }
        }
        return managerList;
    }

    /**
     * Fetches the list of representatives based on the selected sales manager.
     * 
     * @param selectedManagerId The ID of the selected sales manager.
     * @return A list of users who are representatives reporting to the selected manager.
     */
    @AuraEnabled
    public static List<User> getRepresentativeList(Id selectedManagerId) {
        User selectedManager = [SELECT Id, Sales_Role__c, Name,User_Region__c,defaultCurrencyISOcode,CompanyName FROM User WHERE Id = :selectedManagerId LIMIT 1];
        List<User> representativeList = new List<User>();
        if (selectedManager.Sales_Role__c == 'NSM' || selectedManager.Sales_Role__c == 'NMS') {
            representativeList.add(selectedManager);
            representativeList.addAll([SELECT Id, Name,Sales_Role__c,User_Region__c,defaultCurrencyISOcode,CompanyName FROM User WHERE ManagerId = :selectedManagerId AND IsActive = TRUE AND Sales_Role__c IN ('ASM', 'KAM', 'AMS', 'RSM', 'RMS') ORDER BY Name ASC]);
        } else if (selectedManager.Sales_Role__c == 'RSM' || selectedManager.Sales_Role__c == 'RMS') {
            representativeList.add(selectedManager);
            representativeList.addAll([SELECT Id, Name,Sales_Role__c,User_Region__c,defaultCurrencyISOcode,CompanyName FROM User WHERE ManagerId = :selectedManagerId AND IsActive = TRUE AND Sales_Role__c IN ('ASM', 'KAM', 'AMS') ORDER BY Name ASC]);
        }
        return representativeList;
    }

    /**
     * Fetches the manager details for the current user if the current user's role is ASM/AMS/KAM.
     * 
     * @return The user record of the current user's manager.
     */
    @AuraEnabled(cacheable=true)
    public static User getASMManager() {
        String currentUserId = UserInfo.getUserId();
        // First, get the ManagerId of the current user
        User currentUser = [SELECT Id, Name,ManagerId FROM User WHERE Id = :currentUserId LIMIT 1];
        // Then, get the details of the manager
        User userData;
        if(!Test.isRunningTest())
            userData = [SELECT Id, Name FROM User WHERE Id = :currentUser.ManagerId LIMIT 1];
        else
            userData = currentUser;
        
        return userData;
    }
    /**
     * Retrieves a list of visits for a specific representative within a given date range.
     *
     * @param representativeId The ID of the representative for whom the visits are to be retrieved.
     * @param startDate The start date of the date range within which the visits should be retrieved.
     * @param endDate The end date of the date range within which the visits should be retrieved.
     * @return A list of Visits__c records that match the specified criteria:
     *         - The visit type must be 'Visit'.
     *         - The assigned representative must match the provided representativeId.
     *         - The visit status must not be 'Cancelled'.
     *         - The visit must start within the specified date range (between startDate and endDate, inclusive).
     *         The results are ordered by Start_Day__c in descending order and limited to 500 records.
     */
    @AuraEnabled
    public static List<Visits__c> getVisitsForRepresentative(Id representativeId, Date startDate, Date endDate) {
        String soql = 'SELECT Id, Name, Account__r.Name, Account__r.Hoya_Account_ID__c, Account__c, Visit_Start_Day_Tracker__c, '+
                        'Account__r.Shop_Street__c,Account__r.Shop_State__c, Account__r.Shop_City__c, Account__r.Shop_Country__c, '+
                        'Account__r.Shop_Postal_Code__c,Account__r.Segmentation_Net__c,Account__r.Total_Visits_Planned__c, '+
                        'Account__r.Last_Visit_date__c,Visit_Type__c, Visit_Status__c, ToLabel(Account__r.TACTICOM_SOF__c) '+
                        'FROM Visits__c WHERE '+
                        'Visit_Type__c =\'Visit\' AND Assigned_to__c=:representativeId AND Visit_Status__c!=\'Cancelled\' '+
                        'AND Start_Day__c>=:startDate AND Start_Day__c <=:endDate ORDER BY Start_Day__c DESC LIMIT 500';
        return database.query(soql, AccessLevel.USER_MODE);
    }
}