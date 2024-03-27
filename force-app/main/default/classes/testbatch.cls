public class testbatch  implements Database.Batchable<SObject>,Schedulable, Database.Stateful{
    public testBatch (){
        
        
       // System.debug('++Inside the contructor:' + conList.size());
    }
    public void execute(SchedulableContext ctx) {
        
    }
    public Database.QueryLocator start(Database.BatchableContext context){ 
        
        
        //String brand = 'SEIKO';
          //  String query = 'select Id, Turnover_Amount__c, Optician_Finder_Channel_Decision__c, Optician_Finder_Force_Activation__c, Optician_Finder__c, Optician_finder_optin__c from Account limit 500';
            
            return Database.getQueryLocator([select Id,name, Hoya_Account_Id__c,Hoya_Account_Id_frm__c from User where Hoya_Account_ID__c = null AND isActive = true]);
    } 
    public void execute(Database.BatchableContext context, List<User> lstUsers){   
        for(User usr : lstUsers) {
            usr.Hoya_Account_Id__c = usr.Hoya_Account_Id_frm__c;
        }
        update lstUsers;
        //System.debug('++1-'+ lstAccounts.size());
        //System.debug('++2-'+ conList.size());
    }
    public void finish(Database.BatchableContext context){   
        
    }
    
}