public with sharing class ContactNearAccountController {
    private static final String CONTACT_OPTHO_RT = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Opthalmologist').getRecordTypeId();
    
    @AuraEnabled
    public static List<Account> getAccountsByContact(Id contactId, Double distance, String brand){
        System.debug('XXX CALL parameters [ contactid:' + contactId + ', distance:' + distance + ']');
        Contact contact = [select id, name, accountId from Contact where id=:contactId];
        System.debug('XXX Contact ' + contact.Id + ', account ' + contact.AccountId);
        return ContactNearAccountController.getAccounts(contact.AccountId, distance, '', 0, 99999999, '', '', brand);
    }

    
    @AuraEnabled
    public static List<Contact> getAllContacts(Id contactId, Double distance, String miyosmartAttitude, String prescriptionPotential, String preferredMethod){
        Contact contact = [select Id, name, firstName, lastName, MiyoSmart_Attitude__c, Last_contact_visit_date__c, Preferred_contact_method__c, Account.Name, 
                MailingStreet, MailingPostalCode, MailingCity, MailingState, MailingCountry, MailingLatitude, MailingLongitude from Contact where id=:contactId];
        return ContactNearAccountController.getContacts(contact, distance, miyosmartAttitude, prescriptionPotential, preferredMethod);
    }

    @AuraEnabled
    public static List<Contact> getContacts(Contact currentCon, Double distance, String miyosmartAttitude, String prescriptionPotential, String preferredMethod){
        List<Contact> result = new List<Contact>();
        String miyosmartClause = '';
        String prescriptionClause = '';
        String preferenceClause = '';

        Double latitude = currentCon.MailingLatitude;
        Double longitude = currentCon.MailingLongitude;

        result.add(currentCon);

        String query = 'Select Id, Name, firstName, lastName, MiyoSmart_Attitude__c, Last_contact_visit_date__c, Preferred_contact_method__c, Account.Name,' +
        'MailingStreet, MailingPostalCode, MailingCity, MailingState, MailingCountry, MailingLatitude, MailingLongitude FROM Contact' + 
        ' WHERE recordtypeId =: CONTACT_OPTHO_RT'+
        ' and DISTANCE(mailingAddress, GEOLOCATION('+latitude+', '+longitude+'), \'km\')<'+ distance;

        if (String.isNotBlank(miyosmartAttitude)) {
            miyosmartClause = ' and MiyoSmart_Attitude__c like \'%'+miyosmartAttitude+'%\'';
        }
        if (String.isNotBlank(prescriptionPotential)) {
            PrescriptionClause = ' and Prescription_Potential__c like \'%'+prescriptionPotential+'%\'';
        }
        if (String.isNotBlank(preferredMethod)) {
            preferenceClause = ' and Preferred_contact_method__c like \'%'+preferredMethod+'%\'';
        }
        query = query + miyosmartClause + prescriptionClause + preferenceClause;
        List<Contact> conList = database.Query(query);

        for (Contact eachCon : conList) {
            // exclude current contact from list here to avoid duplicate record in result
            if (eachCon.Id != currentCon.Id) {
                result.add(eachCon);    
            }
        }

        return result;
    }
    
    
    @AuraEnabled
    public static List<Account> getAccounts(Id accountId, Double distance, String oneParam, Double potentialMin, Double potentialMax, String competitorLocal1, String svsnetwork, String brand){
        List<Account> result = new List<Account>();

        if(potentialMax==null){potentialMax=99999999;}
        if(potentialMin==null){potentialMin=0;}
        String critCompetitorLocal = '';
        String critSvsNetwork = '';
        if(competitorLocal1!=null && competitorLocal1<>''){
            critCompetitorLocal = ' and First_Competitor_local_name__c like \'%'+competitorLocal1+'%\' ';
        }
        if(svsnetwork!=null && svsnetwork<>''){
            critSvsNetwork = ' and Seiko_Network__c = \''+svsnetwork+'\' ';
            System.debug('SVS Crit=' + critSvsNetwork);
        }

        User u = [select id, companyName from user where Id=:UserInfo.getUserId() ];
        

        Account acc = [select name, Id,Hoya_account_id__c, shippingStreet, shippingPostalCode, shippingCity, shippingState, shippingCountry, shippingLatitude, shippingLongitude
                from Account where id=:accountId];
        result.add(acc);
        System.debug('XXX account is ' + acc.name);
        Double latitude = acc.shippingLatitude;
        Double longitude = acc.shippingLongitude;
        /* select account by nearby */
        String soql= 'select name, Id,Hoya_account_id__c, shippingStreet, shippingPostalCode, shippingCity, shippingState, shippingCountry, shippingLatitude, shippingLongitude, potential__c, First_Competitor_local_name__c, Seiko_Network__c'
            + ' from Account where Brand__c=\'' + brand + '\''
            + ' and recordType.Name<>\'Clinic\''
            + ' and potential__c>=' + potentialMin.longValue() + ' and potential__c<=' + potentialMax.longValue()+ critSvsNetwork
            + ' and DISTANCE(shippingAddress, GEOLOCATION('+latitude+', '+longitude+'), \'km\')<'+distance + critCompetitorLocal ;
        System.debug(soql);
        List<Account> aList = database.Query(soql);
        result.addAll(aList);
        System.debug('XXX account found: ' + result.size());
        return result;
    }

}