global with sharing class VisitCreationPageController {

    public User user{get;set;}
    public Visits__c visit{get;set;}
    public Account acc{get;set;}

    public VisitCreationPageController(ApexPages.StandardController stdController) {
        user = [select id, firstname, lastname from user where id=:UserInfo.getUserId()];
        String ent = Apexpages.currentPage().getParameters().get('ent');
        System.debug('XXX parameter ent=' + ent);
        List<Account> accList = [select id, name from Account where id=:ent];
        if(accList.size()==1){
            acc = accList.get(0);
            System.debug('XXX account search result =' + acc.id);
        }
        
        if(accList.size()==0){
            System.debug('XXX search hvna.id=' + ent );
            //US sent hvna object id
            accList = [select id, name from Account where Additionnal_account_data__c=:ent];
            System.debug('XXX hvna search result size =' + accList.size());
            acc = accList.get(0);
            System.debug('XXX hvna search result =' + acc.id);
        }
        visit = new Visits__c();
        visit.account__c = acc.id;
        visit.Assigned_to__c=UserInfo.getUserId();
    }

    @AuraEnabled
    public static Visits__c initVisit(Id accId){
        System.debug('XXX initVisit('+accId+')');
        Account account = VisitCreationPageController.getAccount(accId);
        User user = [select id, firstname, lastname from user where id=:UserInfo.getUserId()];
        Visits__c v = new Visits__c();
        v.account__c = account.Id;
        v.Assigned_to__c=UserInfo.getUserId();
        return v;
    }

    @AuraEnabled
    public static Account getAccount(Id accId){
         Account acc;
        List<Account> accList = [select id, name, hoya_account_id__c from Account where id=:accId];
        if(accList.size()==1){
            acc = accList.get(0);
            System.debug('XXX account search result =' + acc.name);
        }
        if(accList.size()==0){
            System.debug('XXX search hvna.id=' + accId );
            //US sent hvna object id
            accList = [select id, name from Account where Additionnal_account_data__c=:accId];
            System.debug('XXX hvna search result size =' + accList.size());
            acc = accList.get(0);
            System.debug('XXX hvna search result =' + acc.id);
        }
        return acc;
    }

    @AuraEnabled
    public static Visits__c saveVisit(Visits__c visit){
        System.debug('Saving visit, accId=' + visit.account__c + ', userId=' + visit.Assigned_to__c);
        visit.Visit_Status__c='Planned';
        if(visit.Visit_Type__c==null){
            visit.Visit_Type__c='Visit';
        }
        insert visit;
        System.debug('visit id = ' + visit.Id);
        return visit;
    }

     public PageReference save()
    {
        this.visit.Visit_Status__c='Planned';
        //this.visit.account__c = acc.id;
        //this.visit.Assigned_to__c=UserInfo.getUserId();
        insert this.visit;
        PageReference pr= new PageReference('/lightning/r/Visits__c/'+this.visit.id+'/view');
        return pr;
    }
}