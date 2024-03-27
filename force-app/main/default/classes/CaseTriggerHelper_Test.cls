@isTest
public class CaseTriggerHelper_Test {
	@istest
    public Static void beforeUpdateMethodTest(){
        Case case1 =  new Case();
        case1.status = 'New';
        case1.Origin = 'Web';
        insert case1;
        
        case1.status = 'On Hold';
        update case1;
        case1.status = 'In progress';
        update case1;
        case1.status = 'Escalated';
        update case1;
        case1.status = 'New';
        update case1;
        
        case1.hours_spent_escalated__c = 4.0;
        case1.Hours_Spent_In_Progress__c = 4.0;
        case1.Hours_Spent_New__c = 4.0;
        case1.Hours_Spent_On_Hold__c = 4.0;
        update case1;
        
        case1.status = 'New';
        update case1;
        case1.status = 'On Hold';
        update case1;
        case1.status = 'In progress';
        update case1;
        case1.status = 'Escalated';
        update case1;
        case1.status = 'Closed';
        update case1;
    }
}