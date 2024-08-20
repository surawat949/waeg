public with sharing class ContactsInAccountHierarchy {
    private static final String CONTACT_OPTHO_RT = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Opthalmologist').getRecordTypeId();

    @AuraEnabled
    public static List<ContactDetail> getAllContactsInHierarchy(Id accountId){
        Set<Id> finalIdSet = new Set<Id>();
        Set<Id> accountIdSet = new Set<Id>();
        List<ContactDetail> conDetails = new List<ContactDetail>();
        finalIdSet.add(accountId);
        accountIdSet.add(accountId);
        finalIdSet.addAll(getRecursiveAccountList(accountIdSet));

        List<AccountContactRelation> relationList = [Select Id, AccountId, ContactId, Contact.Name, Account.Name,Contact.OwnerId,Contact.Owner.Name, Account.ShippingCity, Account.ShippingState, Account.ShippingStreet, Account.Phone, Preferred_place_for_visit__c, Contact_role__c From AccountContactRelation 
        Where AccountId IN :finalIdSet AND contact.recordTypeId = :CONTACT_OPTHO_RT AND Account.RecordTypeId != NULL AND IsActive = true order by Contact.Name ASC];

        for (AccountContactRelation eachCon : relationList) {
            ContactDetail con = new ContactDetail();
            con.ContactId = eachCon.ContactId;
            con.ContactName = eachCon.Contact.Name;
            con.AccountId = eachCon.AccountId;
            con.AccountName = eachCon.Account.Name;
            con.OwnerId = eachCon.Contact.OwnerId;
            con.OwnerName = eachCon.Contact.Owner.Name;
            con.Street = eachCon.Account.ShippingStreet;
            if (eachCon.Preferred_place_for_visit__c) {
                con.PreferredPlace = 'V';    
            } else {
                con.PreferredPlace = '';    
            }
            con.City = eachCon.Account.ShippingCity;
            con.State = eachCon.Account.ShippingState;
            con.Phone = eachCon.Account.Phone;
            con.Role = eachCon.Contact_role__c;
            conDetails.add(con);
        }
        return conDetails;

    }

    // get all children for passed account id set.
    private static Set<Id> getRecursiveAccountList(Set<Id> accIdSet){
        List<Account> temp = [select id, hoya_account_id__c, name, shop_name__c, parentId from account where parentId IN :accIdSet];
        Set<Id> result = new Set<Id>();
        if (temp != null && temp.size() > 0) {
            for (Account eachAcc : temp) {
                result.add(eachAcc.Id);
            }
            result.addAll(getRecursiveAccountList(result));
        }
        return result;
    }

    public class ContactDetail {
        @auraEnabled public String contactId{get;set;}
        @auraEnabled public String ContactName{get;set;}
        @auraEnabled public String AccountId{get;set;}
        @auraEnabled public String AccountName{get;set;}
        @auraEnabled public String OwnerId{get;set;}
        @auraEnabled public String OwnerName{get;set;}
        @auraEnabled public String Street{get;set;}
        @auraEnabled public String City{get;set;}
        @auraEnabled public String Phone{get;set;}
        @auraEnabled public String State{get;set;}
        @auraEnabled public String PreferredPlace{get;set;}
        @auraEnabled public String Role{get;set;}
    }

    @AuraEnabled
    public static string getRecordTypeIdOpthalmologist(){
        return CONTACT_OPTHO_RT;
    }
}