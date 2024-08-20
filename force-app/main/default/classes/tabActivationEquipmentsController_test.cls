@isTest
public class tabActivationEquipmentsController_test {
  	@IsTest
    static void runTestCtrl(){         
		Test.StartTest();    
        String TrainingRecId = Schema.SObjectType.ECP_Training__c.getRecordTypeInfosByDeveloperName().get('HOYA_Training').getRecordTypeId();   
        Account acc = new Account();
        acc.Name='sales test account';
        acc.hoya_account_id__c='TE-3399999xx';
        acc.RecordTypeId='012b00000000P38';        
        insert acc;       
        
        New_Media_Usage__c media = new New_Media_Usage__c();
        media.External_key__c = 'SO3399999xxeColumn Lens Selection202210';
        media.Hoya_Account_ID__c = acc.Id;
        media.Quantity__c = 2;
        media.Tool__c = 'eColumn Lens Selection';
        media.Transaction_Date__c = '202210';        
        insert media;

        ECP_Training__c training = new ECP_Training__c();
        training.Account__c = acc.Id;
        training.Training_status__c = 'Completed';
        training.Training__c = 'HoyaiLog orders';     
        training.Type__c = 'In Store';
        training.start__c = System.today()-2;
		training.RecordTypeId = TrainingRecId;
        insert training;
        
        tabActivationEquipmentsController.getLastTrainingDate(acc.Id,'HoyaiLog orders');
        tabActivationEquipmentsController.getLastMediaUsage(acc.Id,'HoyaiLog orders','ExactMatch');
        tabActivationEquipmentsController.getLastMediaUsage(acc.Id,'eColumn Lens Selection%','LikeMatch');
        tabActivationEquipmentsController.getEquipmentsChart(acc.Id,'HoyaiLog orders','ExactMatch');
        tabActivationEquipmentsController.getEquipmentsChart(acc.Id,'eColumn Lens Selection%','LikeMatch');
		
        tabActivationEquipmentsController.startEnroll(acc.Id);
		Test.StopTest();
    }
}