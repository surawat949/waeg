/*
*	Author:- Mohan Krishna
*	Description:- Test class of "SortUtil.apxc"
*	Created Date:- 02/19/2023
*	Last Modified:- 02/20/2023
*/


@IsTest(SeeAllData=false)
public  with sharing class SortUtil_Test {
    
     public SortUtil_Test() {
    }
    
    @testSetup static void setup() {
        
        Account a = new Account();
        a.Name='registration test account';
        a.CurrencyIsoCode = 'EUR';
        a.hoya_account_id__c='SO3399998xx';
        insert a;
        
        Account a1 = new Account();
        a1.Name='registration test account';
        a1.CurrencyIsoCode = 'EUR';
        a1.hoya_account_id__c='SO3399999xx';
        insert a1;
        
        
        Account a2 = new Account();
        a2.Name='registration test account';
        a2.CurrencyIsoCode = 'EUR';
        a2.hoya_account_id__c='SO3599999xx';
        insert a2;
        
        Contact c = new Contact();
        c.FirstName = 'xyz';
        c.LastName = 'azerty';
        c.email = 'aabb@gmail.com';
        c.AccountId = a.Id;
        insert c;
        
        Contact c1 = new Contact();
        c1.FirstName = 'xyz11';
        c1.LastName = 'azerty11';
        c1.email = 'aabb1@gmail1.com';
        c1.AccountId = a1.Id;
        insert c1;
        
        Contact c2 = new Contact();
        c2.FirstName = 'xyz1134';
        c2.LastName = 'azerty1451';
        c2.email = 'aabb1@gmail451.com';
        c2.AccountId = a2.Id;
        insert c2;
        
        
        List<Purchase_Registration__c> plist=new List<Purchase_Registration__c>();
        Purchase_Registration__c p = new Purchase_Registration__c();
        p.DeliveryDate__c = System.today();
        p.winner__c=false;
        p.Contact__c = c.Id;
        p.MembersOnlyParticipate__c = true;
        p.Absolute_Sifting_Question__c=10;
        p.Hash__c ='ldfg holkxfghjxck ighj xkcgjvhbx kjghsdklifhsdo';

        plist.add(p);
        
        
        Purchase_Registration__c p1 = new Purchase_Registration__c();
        p1.DeliveryDate__c = System.today();
        p1.winner__c=false;
        p1.Contact__c = c1.Id;
        p1.MembersOnlyParticipate__c = true;
        p1.Absolute_Sifting_Question__c=13;
        p1.Hash__c ='ldfg holkxfghjxck ighj xkcgjvhbx kjghsdklifhsdd';

        plist.add(p1);
        
        insert plist;
        
        Purchase_Registration__c p2 = new Purchase_Registration__c();
        p2.DeliveryDate__c = System.today();
        p2.winner__c=false;
        p2.Contact__c = c2.Id;
        p2.MembersOnlyParticipate__c = true;
        p2.Absolute_Sifting_Question__c=16;
        p2.Hash__c ='ldfg holkxfghjxck i2hj xkcgjvhbx kjghsdklifhsdd';

        insert p2;
        
         
        Purchase_Registration__c p3 = new Purchase_Registration__c();
        p3.DeliveryDate__c = System.today();
        p3.winner__c=false;
        p3.Contact__c = c2.Id;
        p3.MembersOnlyParticipate__c = true;
        p3.Absolute_Sifting_Question__c=16;
        p3.Hash__c ='ldfg holkxfgijxck i2hj xkcgjvhbx kjghsdklifhsdd';

        insert p3;

    }
    
    @isTest
    static void runPurchaseRegistrationCtrl(){

     
        
        Test.startTest();
      
        
        List<Purchase_Registration__c> plist= [Select DeliveryDate__c,winner__c,Contact__c,MembersOnlyParticipate__c,Absolute_Sifting_Question__c,Hash__c FROM Purchase_Registration__c];
        plist.sort();
        SortUtil s=new SortUtil();
        
        SortUtil.sortRecords(plist,SortUtil.sortOrder.ASCENDING,'Absolute_Sifting_Question__c',SortUtil.Type.TYPE_DECIMAL);       
         
        system.assertEquals(10, plist[0].Absolute_Sifting_Question__c);
        System.assertEquals(13, plist[1].Absolute_Sifting_Question__c); 
       
        sObject sobj=(sObject)plist[0];
        SortUtil sor=new SortUtil(sobj,SortUtil.sortOrder.ASCENDING,'Absolute_Sifting_Question__c',SortUtil.Type.TYPE_DECIMAL);
   
        /*
        List<Purchase_Registration__c> plist1= [Select DeliveryDate__c,winner__c,Contact__c,MembersOnlyParticipate__c,Absolute_Sifting_Question__c,Hash__c FROM Purchase_Registration__c where Absolute_Sifting_Question__c=16];
        if(plist1.size()>0){
             s.compareDecimals((Decimal) plist1[0].Absolute_Sifting_Question__c, (Decimal) plist1[1].Absolute_Sifting_Question__c);
      
        }
       
        
        List<Purchase_Registration__c> plist2= [Select DeliveryDate__c,winner__c,Contact__c,MembersOnlyParticipate__c,Absolute_Sifting_Question__c,Hash__c FROM Purchase_Registration__c]; 
        if(plist2.size()>0){
            Object obj=(Object) plist2[0];
           s.compareTo(obj);
        }
       */ 
        
        Test.stopTest();
       
    }
}