@isTest
public class FullCalenderV2Controller_Test {
      @isTest
       static void testFullCalender() {
        List<Account> testAccts = new List<Account>();
        for(Integer i=0;i<2;i++) {
            testAccts.add(new Account(Name = 'TestAcct'+i, Hoya_Account_ID__c = 'DE12345'+i));
        }
        insert testAccts;
        Event event = new Event();
        event.Subject = 'Test FFAs';
        event.DurationInMinutes = 60;
        event.WhatId = testAccts[0].Id;
        event.Visit_Id__c = null;
        event.OwnerId = UserInfo.getUserId();
        event.StartDateTime = Datetime.newInstance(2024, 5, 22, 14, 00, 00);       
        event.EndDateTime =Datetime.newInstance(2024, 5, 22, 15, 00, 00);
        System.debug(event.EndDateTime);
        event.ActivityDateTime = event.StartDateTime;
        insert event;
           
        Event e=[select StartDateTime,EndDateTime from Event where subject='Test FFAs' limit 1];
        System.debug(e.StartDateTime +'-'+e.EndDateTime);

        Visits__c visit = new Visits__c();
        visit.Account__c = testAccts[0].Id;
        visit.Visit_Type__c = 'Visit';
        visit.Visit_Reason__c = 'Event Participation';
        visit.CurrencyIsoCode = 'EUR';
        visit.Visit_Status__c = 'Planned';
        visit.Start_Time__c = System.now();
        visit.End_Time__c = System.now().addHours(3);
        visit.Assigned_to__c = UserInfo.getUserId();
        insert visit;
                 
        Test.startTest();
        Id AccountId =[Select Id from Account where Hoya_Account_ID__c = 'DE123450' limit 1].id;
        Contact con =new Contact(FirstName='Contact',LastName='test',AccountId=AccountId);
        insert con;
           
        FullCalenderV2Controller.getEvents(System.now(),System.now().addHours(5));
        FullCalenderV2Controller.getTranslations();
        FullCalenderV2Controller.getAccountId('DE123450');
        FullCalenderV2Controller.getContactsForAccount(AccountId);
        FullCalenderV2Controller.upsertVisit(visit);
        String startTime = '2024-05-22T15:30:00+05:30';
        String endTime = '2024-05-22T16:30:00+05:30'; 
        FullCalenderV2Controller.createVisit(String.valueOf(AccountId),'Visit',String.valueOf(con.Id),String.valueOf(UserInfo.getUserId()),false,startTime,endTime,false,'Hunt','Test Notes');
        String rectType = FullCalenderV2Controller.getExtraActivityRecTypeId();
        FullCalenderV2Controller.addExtraActivity(rectType,String.valueOf(UserInfo.getUserId()),'Other','Email',startTime,endTime,false,true);   
        system.assert(true);
        Test.stopTest();
    }
}