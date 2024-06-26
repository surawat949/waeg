/**
 * ===================================================================
 * @Author : Surawat Sakulmontreechai
 * @Author email : surawat.sakulmontreechai@hoya.com
 * @Created by : Surawat Sakulmontreechai
 * @Created date : 2023/08/09
 * @Description :   This class for Task #735 - Edit List (PDF)
 *                  to help export the list of opthalmologist relation
 *                  to contact in pdf format
 * ==================================================================== 
 */

public without sharing class TabMVCActivationContactPdfList {
    
    public String currentRecordId {get;set;}
    public String receivedId{get;set;}
    public Contact con{get;set;}
    public List<AccountContactRelation> aCon {get;set;}

    private static final string CONT_OPT_CLINIC = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Clinic').getRecordTypeId();

    public TabMVCActivationContactPdfList(ApexPages.StandardController controller){
        currentRecordId  = ApexPages.CurrentPage().getparameters().get('receivedId');

        con = [SELECT Id, FirstName, LastName, Name, Account.Name, Account.Shop_Name__c, 
                MailingStreet, MailingCity, Account.Clinic_Name__c,
                MailingState, MailingPostalCode, MailingCountry, Phone
                FROM Contact WHERE Id=:currentRecordId];

        aCon = [SELECT Id, ContactId, Contact.Name, AccountId, Contact.MailingStreet, Contact.MailingPostalCode, 
                    Contact.MailingCity, Contact.MailingCountry, Contact.MailingState, Account.Name, Account.Shop_Name__c,
                    Account.ShippingStreet, Account.ShippingPostalCode, Account.ShippingCity, 
                    Account.ShippingState, Account.Phone, Account.Clinic_Name__c, Contact.Phone FROM AccountContactRelation
                    WHERE ContactId=:currentRecordId AND Account.RecordTypeId !=:CONT_OPT_CLINIC AND IsDirect = false];
    }
}