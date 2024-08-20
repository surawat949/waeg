public class ContactRelatedClinicsController {
	@AuraEnabled
    public static List<AccountContactRelation> getRelatedClinicsByContactId(Id contactId){
            List<AccountContactRelation> acList = [select id, contact.Id, Contact.name, Preferred_contact_day_time__c, Account.name, Account.id, Account.brand__c, AccountId, 
                Account.shippingStreet,Account.Clinic_Name__c,Account.shippingPostalCode, Account.shippingCity,
                                                   Account.ShippingState,Contact_Role__c,
                                                   Account.Seiko_Network__c, Account.OwnerId, Account.Owner.Name,
                isdirect, Preferred_place_for_visit__c,Activity_Phone__c,Working_Status__c   
                from AccountContactRelation where contactId =:contactId and Account.RecordType.Name='Clinic' AND IsActive = true];
            return acList;
    }
}