public with sharing class pss_ContactTriggerHelper 
{   
  /*  public static void CreateContactDelRecord(Map<Id,Contact> oldUsers)
    {
       
       Set<string> userId=new set<string>();
       List<pssLMS_Delete_User__c> newContacts=new List<pssLMS_Delete_User__c>();       
       for(Contact u : oldUsers.values())
       {
           if (u.pss_Moodle_User_ID__c!=null)
           {
               newContacts.add(new pssLMS_Delete_User__c(LMS_User_Id__c=u.pss_Moodle_User_ID__c));           
               userId.add(u.id);
           }
       } 
       
       if (newContacts.size()>0) 
       {
           upsert newContacts;
           List<pss_Course_Enrollment__c> lstCompl= [Select Id From pss_Course_Enrollment__c Where id in:userId];
           Delete lstCompl;
           
       }
       
   }
   
   public static void UpdateContactFlag(List<Contact> newContacts,Map<Id,Contact> oldContacts)
   {   
       for(Contact newUser : newContacts)
       {
            if (oldContacts!=null && oldContacts.get(newUser.id).pss_Needs_Moodle_Update__c!=null && oldContacts.get(newUser.id).pss_Needs_Moodle_Update__c!=true)
            {
                System.debug('newUser.pss_moodle_user_id__c:'+newUser.pss_moodle_user_id__c); 
                if (newUser.pss_moodle_user_id__c !=null && oldContacts.get(newUser.id).pss_moodle_user_id__c != null)
                {
                    if (newUser.FirstName != oldContacts.get(newUser.id).FirstName || 
                        newUser.LastName != oldContacts.get(newUser.id).LastName || 
                        newUser.email != oldContacts.get(newUser.id).email ||
                       newUser.Account.Name != oldContacts.get(newUser.id).Account.Name)
                    {
                        newUser.pss_Needs_Moodle_Update__c = true;  
                    }else{                     
                        newUser.pss_Needs_Moodle_Update__c = true;  
                    }
                }
            }
       }    
   }*/

    public static void doHOLKCreateAccTemplateBeforeInsert(List<Contact> newList){
        if(newList.size()>0){
            List<Account_Template__c> listInsert = new List<Account_Template__c>();
            List<Contact> ctupdateList = new List<Contact>();
            List<Id> authorListId = new List<Id>();
            String CtOwnerRecId = [select Id, Name from RecordType where sObjectType='Contact' and DeveloperName='Shop_Owner'].Id;
            for(Contact c : newList){
                if(c.Hoya_Account_Id__c != null && c.Hoya_Account_Id__c.startsWith('KR') && c.RecordTypeId==CtOwnerRecId){
                    List<Account_Template__c> holktmpList = [select Id, Name from Account_Template__c where Account__c=:c.AccountId];
                    System.debug('Found for account template record '+holktmpList.size()+' record.');
                    if(holktmpList.size()==0){
                        String HolkMasterTemplate = [select Id, Name from Account_Template__c where Name='HOLK Shop Owner'].Id;
                        String HolkRecTemplate = [select Id, Name from RecordType where DeveloperName='Copy' and SObjectType='Account_Template__c'].Id;

                        Account_Template__c at = new Account_Template__c();
                        at.Account__c = c.AccountId;
                        at.Master_Template__c = HolkMasterTemplate;
                        at.Name = 'HOLK Shop Owner-'+c.Hoya_Account_Id__c+'-'+c.Account_Name__c;
                        at.Authorization_Template_Name__c = 'HOLK Shop Owner-'+c.Hoya_Account_Id__c+'-'+c.Account_Name__c;
                        at.Default__c = true;
                        at.Active_Authorization_Template__c = true;
                        at.RecordTypeId = HolkRecTemplate;

                        listInsert.add(at);
                    }else{
                        System.debug('Has account template associate with this contact already');
                        continue;
                    }

                }
            }
            if(listInsert.size()>0){
                System.debug('Insert Account_Template__c size = '+listInsert.size());
                insert listInsert;
            }
        }
    }

    public static void doHOLKCreateAccTemplateAfterInsert(List<Contact> newList){
        if(newList.size()>0){
            List<Contact> ctupdateList = new List<Contact>();
            List<Id> ctId = new List<Id>();
            List<Id> ctAccId = new List<Id>();
            List<Id> accTemplateId = new List<Id>();
            List<Id> atTemplate = new List<Id>();
            String ownerRecId = [select Id, Name from RecordType where sObjectType='Contact' and DeveloperName='Shop_Owner'].Id;
            for(Contact c : newList){
                if(c.Hoya_Account_Id__c != null && c.Hoya_Account_Id__c.startsWith('KR') && c.RecordTypeId==ownerRecId){
                    ctId.add(c.Id);
                    ctAccId.add(c.AccountId);
                }
            }
            if(ctId.size()>0){
                List<Account_Template__c> attmpList = [select Id, Account__c, Name from Account_Template__c where Account__c IN:ctAccId];
                for(Account_Template__c at : attmpList){
                    atTemplate.add(at.Id);
                    System.debug('Account Template Id is '+atTemplate);
                    accTemplateId.add(at.Account__c);
                }
            }

            if(accTemplateId.size()>0){
                String CtOwnerRecId = [select Id, Name from RecordType where SObjectType='Contact' and DeveloperName='Shop_Owner'].Id;
                List<Contact> cttmpList = [select Id, Name, AccountId, Account_Template__c, Language_Pick__c, Invite_Portal_Email__c from Contact where AccountId IN:accTemplateId and RecordTypeId=:CtOwnerRecId];
                String acc_template = [select Id, Name from Account_Template__c where Id IN:atTemplate order by createddate desc limit 1].Id;

                System.debug('Account Template Id is '+acc_template);
                for(Contact ct : cttmpList){
                    //ct.Account_Template__c = acc_template;
                    ct.Language_Pick__c = 'ko-kr';
                    ct.Invite_Portal_Email__c = 'HOYA Hub';
                    ctupdateList.add(ct);
                }
            }
            if(ctupdateList.size()>0){update ctupdateList;}
        }
    }

    public static void doHOLKUpdateContact(List<Contact> newList, Map<Id, Contact> oldMap){
        if(newList.size()>0){
            List<Contact> contactlist = new List<Contact>();
            List<Account_Template__c> accTemplateList = new List<Account_Template__c>();
            List<Account_Template__c> accTemplateUpdList = new List<Account_Template__c>();
            List<Id> contactId = new List<Id>();
            List<Id> contactAccId = new List<Id>();
            String shopOwnerRecId = [select Id from RecordType where sObjectType='Contact' and DeveloperName='Shop_Owner'].Id;

            for(Contact c : newList){
                Contact old = oldMap.get(c.Id);
                contactId.add(c.Id);
                contactAccId.add(c.AccountId);

                if((old.Create_New_Account_Template__c<>c.Create_New_Account_Template__c)&&(c.Create_New_Account_Template__c==true)&&(c.Hoya_Account_ID__c.startsWith('KR'))&&(c.Email!=null || c.Email!='')&&(c.RecordTypeId==shopOwnerRecId)){
                    List<Account_Template__c> atTmpList = [select Id, Name, Account__c from Account_Template__c where Account__c=:c.AccountId];
                    System.debug('Found for Account Template in Contact Id '+c.Id+'='+atTmpList.size()+' record(s)');
                    if(atTmpList.size()==0){
                        String HolkMasterTemplate = [select Id, Name from Account_Template__c where Name='HOLK Shop Owner'].Id;
                        String HolkRecTemplate = [select Id, Name from RecordType where DeveloperName='Copy' and SObjectType='Account_Template__c'].Id;
                        String shopOwnerId = [select OwnerId from Account where Id=:c.AccountId].OwnerId;

                        Account_Template__c at = new Account_Template__c();
                        at.Account__c = c.AccountId;
                        at.Master_Template__c = HolkMasterTemplate;
                        at.Name = 'HOLK Shop Owner-'+c.Hoya_Account_ID__c+'-'+c.Account_Name__c;
                        at.Authorization_Template_Name__c = 'HOLK Shop Owner-'+c.Hoya_Account_ID__c+'-'+c.Account_Name__c;
                        at.Default__c = true;
                        at.OwnerId = shopOwnerId;
                        at.Active_Authorization_Template__c = true;
                        at.RecordTypeId = HolkRecTemplate;
                        accTemplateList.add(at);

                    }else if(atTmpList.size()>0){
                        String CtOwnerRecId = [select Id, Name from RecordType where SObjectType='Contact' and DeveloperName='Shop_Owner'].Id;
                        List<Contact> tmpctList = [select Id, Name, AccountId, Account_Template__c, Language_Pick__c, Invite_Portal_Email__c from Contact where AccountId IN:contactAccId and RecordTypeId=:CtOwnerRecId];
                        String acTemplate = [select Id, Name from Account_Template__c where Account__c IN:contactAccId order by createddate desc limit 1].Id;
                        System.debug('Account Template Id is '+acTemplate);
                        for(Contact cons : tmpctList){
                            cons.Account_Template__c = acTemplate;
                            cons.Language_Pick__c = 'ko-kr';
                            cons.Invite_Portal_Email__c = 'Hoya Hub';
                            contactlist.add(cons);
                        }
                    }else{
                        System.debug('This account template was associated already.');
                        continue;
                    }
                }
            }
            if(accTemplateList.size()>0){insert accTemplateList;}
            if(contactlist.size()>0){update contactlist;}
        }
    }

    public static void doHOLKUpdateAfterUpdate(List<Contact> newList, Map<Id, contact> oldMap){
        if(newList.size()>0){
            List<Contact> updContactList = new List<Contact>();
            List<Contact> updHoyaContactId = new List<Contact>();
            List<User> updUserList = new List<User>();
            List<User> updNameList = new List<User>();
            List<Account_Template__c> accTemplateList = new List<Account_Template__c>();
            String shopOwnerRecId = [select Id from RecordType where sObjectType='Contact' and DeveloperName='Shop_Owner'].Id;

            for(Contact c : newList){
                Contact old = oldMap.get(c.Id);
                if((old.Create_New_Account_Template__c <> c.Create_New_Account_Template__c)&&(c.Create_New_Account_Template__c==true) && (c.Hoya_Account_ID__c.startsWith('KR')) && (c.RecordTypeId==shopOwnerRecId) && (c.Email!=null || c.Email!='')){
                    List<Account_Template__c> listTmp1 = [select Id, Account__c from Account_Template__c where Account__c=:c.AccountId];
                    for(Account_Template__c at : listTmp1){
                        List<Contact> ct = [select Id, AccountId, Language_Pick__c, Invite_Portal_Email__c from Contact where AccountId=:at.Account__c];
                        for(Contact cts : ct){
                            cts.Account_Template__c = at.Id;
                            cts.Language_Pick__c = 'ko-kr';
                            cts.Invite_Portal_Email__c = 'Hoya Hub';
                            updContactList.add(cts);
                        }
                    }
                }else if((old.Email<>c.Email) && (c.Email!=null || c.Email!='') && (c.Hoya_Account_ID__c.startsWith('KR'))){
                    List<User> tmpList2 = [select Id, Email from User where ContactId=:c.Id];
                    for(User u : tmpList2){
                        u.Email = c.Email;
                        updUserList.add(u);
                    }
                }else if((old.FirstName<>c.FirstName) && (c.FirstName!=null || c.FirstName!='') ||(old.LastName<>c.LastName)&&(c.LastName!=null||c.LastName!='')&&(c.Hoya_Account_ID__c.startsWith('KR'))){
                    List<User> tmpList3 = [select Id, FirstName, LastName from User where ContactId=:c.Id];
                    for(User u2 : tmpList3){
                        u2.FirstName = c.FirstName;
                        u2.LastName = c.LastName;
                        updNameList.add(u2);
                    }
                }

                if((old.MobilePhone <> c.MobilePhone) && (c.MobilePhone != null && c.MobilePhone != '')) {
                    List<Contact> tmpList4 = [select Id, MobilePhone from Contact where Id=:c.Id];
                    for(Contact cc : tmpList4){
                        cc.Hoya_Contact_ID__c = c.Hoya_Account_ID2__c+c.MobilePhone.replaceAll('-','').right(8);
                        updHoyaContactId.add(cc);
                    }
                }
            }
            if(updContactList.size()>0){update updContactList;}
            if(updUserList.size()>0){update updUserList;}
            if(updNameList.size()>0){update updNameList;}
            if(updHoyaContactId.size()>0){update updHoyaContactId;}
            
        }
    }
   
 /*  public static void UpdateAccount(List<Contact> newContacts)
   { 
       System.debug('UPDATe ACCOUNT ');
       Set<ID> accountids = new Set<ID>(); 
       System.debug('newContacts' +newContacts);
       Map <Id,Decimal> mapcount = new Map <Id,Decimal>();
       List <Account> actlist = new List <Account>();
       List <Contact> contactlist = new List <Contact>();
       Decimal count = 0 ;
       Decimal courseCount = 0 ;
       
       for(Contact c: newContacts)
       {
           if(c.AccountId != null)
           accountids.add(c.AccountId);
       }
       System.debug('accountids ' +accountids);
       contactlist = [Select id, name, AccountId,Has_Enrollement__c,Account.Name  From Contact where AccountId != null and  AccountId In : accountids];
       System.debug('contactlist' +contactlist);
       
       actlist = [Select Id,Name,Count_Of_contact__c,Contacts_with_courses__c from Account where id In : accountids];
       System.debug('actlist' +actlist);
       for(Contact c: contactlist)
       {
           for(Account a :actlist )
           {
           
               if (mapcount.containsKey(c.AccountId)  && mapcount.containsKey(a.Id)  ){
                   
                   System.debug('IF c.AccountId.Name '+c.Account.Name);
                   System.debug('IF Count '+count);
                   count = count+1;
                   a.Count_Of_contact__c = count;
                   if(c.Has_Enrollement__c == true )
                   {
                     System.debug('!! '+courseCount );
                     courseCount = courseCount + 1;
                     a.Contacts_with_courses__c =courseCount;
                   }
               }
               else
               {
                   courseCount =1;
                   count = 1;
                   mapcount.put(c.AccountId,a.Count_Of_contact__c);
               }
           }
       }
       
       System.debug('mapcount ' +mapcount); 
       System.debug('actlist  actlist :::  ' +actlist);
       if(actlist.size() >0)
       {
            update actlist;
       }
       
   }*/
    
}