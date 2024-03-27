public with sharing class AddBulkVirtualRecords_waeg {
    private static final String AUTHORIZATION_COPY_RT = Schema.SObjectType.Authorization__c.getRecordTypeInfosByDeveloperName().get('Copy').getRecordTypeId();
        private static final String AUTHORIZATION_MASTER_RT = Schema.SObjectType.Authorization__c.getRecordTypeInfosByDeveloperName().get('Original').getRecordTypeId();
    public AddBulkVirtualRecords_waeg() {

    }
    public void createContacts(){
        List<Id> idList = new List<Id>{'0019E00001q5U5vQAE'};
        List<User> userList = new List<User>();
        List<Account> accList = [Select Id, name, Shop_email_address__c From Account where parentId IN :idList];
        List<Contact> conList = new List<Contact>();
        

        Id recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('GKA Virtual Shop').getRecordTypeId();
        
        for (Account eachAcc : accList) {
            Contact con = new Contact();
            con.FirstName = 'USER';
            con.LastName = eachAcc.Name;
            con.email = eachAcc.Shop_email_address__c;
            con.AccountId = eachAcc.Id;
            con.recordTyPeId = recordTypeId;
            //waeg
            //con.Test_Environment__c = 'UAT';
            //conf2
            con.Test_Environment__c = 'BUILD';
            conList.add(con);
        }
        insert conList;

        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.EmailHeader.triggerUserEmail = false;
        dmo.EmailHeader.triggerOtherEmail = false;
        dmo.EmailHeader.triggerAutoResponseEmail = false;
        Id profileId;
        profileId = [SELECT Id FROM Profile WHERE Name = 'Customer Community Plus User + API'].Id;
        string header = 'AccountId, ContactId, username ,firstName,LastName, password \n';
        string finalstr = header ;

        for (Contact eachCon : conList) {
            User newUser;
            String username1 = eachCon.firstName + '' +eachCon.lastname + '@tradeportal.hoyavision.com';
            username1 = username1.replaceAll( '\\s+', '');
            string alias = '';
            if (eachCon.LastName.length() >= 4) {
                alias = eachCon.LastName.substring(0, 1) + eachCon.FirstName.substring(0, 4);
            } else {
                alias = eachCon.LastName.substring(0, 1) + eachCon.FirstName;
            }
            
            System.debug('++++'+ username1);
            newUser = new User(
                    alias = alias,
                    email = eachCon.email,
                    emailencodingkey = 'UTF-8',
                    firstname = eachCon.firstName,
                    lastname = eachCon.lastname,
                    languagelocalekey = 'en_US',
                    localesidkey = 'en_US',
                    contactId = eachCon.Id,
                    timezonesidkey = 'America/New_York',
                    username = username1,
                    CommunityNickname = eachCon.firstName + eachCon.lastname,
                    ProfileId = profileId,
                    IsActive = true,
                    FederationIdentifier = username1
                    );
            newUser.setOptions(dmo);
            userList.add(newUser);

            //insert newUser;
            System.debug('LastName:'+ eachCon.LastName);
            String password = newUser.lastname;
            password = password.replaceAll( '\\s+', '');
            String recordString = '' + eachCon.AccountId;
            recordString = recordString + ',' + eachCon.Id + ',' + newUser.userName + ',' + newUser.firstname;
            recordString = recordString + ',' + newUser.lastName + ',' + password + ' \n ';
            finalstr = finalstr + recordString ;
        }
        insert userList;
        for (User eachUser : userList) {
            String password = eachUser.lastname;
            password = password.replaceAll( '\\s+', '');
            System.debug('pasword++' + password);
            System.setPassword(eachUser.Id, password);   
        }
        

        Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
        blob csvBlob = Blob.valueOf(finalstr);
        string csvname= 'SHOP REGION Level.csv';
        csvAttc.setFileName(csvname);
        csvAttc.setBody(csvBlob);
        Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
        String[] toAddresses = new list<string> {'ajinkyabande@hoya.com'};
        String subject ='SHOP Region CSV';
        email.setSubject(subject);
        email.setToAddresses( toAddresses );
        email.setPlainTextBody('SHOP REGION CSV ');
        email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        System.debug(csvAttc);
        

    }

    public void createAuthorizations() {
        List<Contact> conList = [Select Id, firstName, lastName from Contact where lastName like '%SHOP RECORD%'];
        String gkaLike = '%has_GKA%';
        List<Authorization__c> lstMasterAuth = [Select Id, name, claim_formatted__c,Active_Authorization__c from Authorization__c WHERE recordTypeId =:AUTHORIZATION_MASTER_RT AND claim_formatted__c LIKE :gkaLike];
        List<Authorization__c> authToCreate = new List<Authorization__c>();
        for (Contact eachCon : conList) {
            for (Authorization__c eachMaster : lstMasterAuth) {
                Authorization__c a = new Authorization__c(
                    RecordTypeId = AUTHORIZATION_COPY_RT,
                    Copy_From__c = eachMaster.Id,
                    Contact__c = eachCon.Id,
                    Claim_Formatted__c = eachMaster.Claim_Formatted__c,
                    DupCheck__c = eachMaster.Id+'-'+eachCon.Id,
                    Active_Authorization__c = false
                );
                authToCreate.add(a);
            }
            
        }
        upsert authToCreate DupCheck__c;
    }
}