public class Cls_QRTest_DEV {
	@RemoteAction
	@readOnly
    public static void testUpdateEvent(){
    	list<AggregateResult> lst_event = [Select e.Visit_Id__c From Event e group by e.Visit_Id__c having count(e.Visit_Id__c ) > 1];
		set<string> setid = new set<string> ();
		for(AggregateResult eventobj : lst_event){
			setid.add(string.valueOf(eventobj.get('Visit_Id__c')));
		}
		
		list<event> lst_event2 = [Select e.id, e.Visit_Id__c From Event e ];
		
		for(event evtobj : lst_event2){
			if(setid.contains(evtobj.Visit_Id__c)){
				system.debug(evtobj.id +'\t\t' + evtobj.Visit_Id__c);
			}
		}
		
    }
}