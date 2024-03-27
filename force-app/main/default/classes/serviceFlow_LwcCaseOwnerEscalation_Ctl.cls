public class serviceFlow_LwcCaseOwnerEscalation_Ctl {
    @AuraEnabled 
    public static String doChangeOwner(String recordId, String esclationLevel){
        Map<String,String> mapOfQueues = new Map<String,String>();
        for(Group groupRec : [select Id,Name from group where Name IN ('Team 2','Team 3')]){
            mapOfQueues.put(groupRec.Name,groupRec.Id);
        }
        String queueId = '';        
        if(esclationLevel == '1'){
            queueId = mapOfQueues.size() > 0 ? mapOfQueues.get('Team 2') : null;
        }else if(esclationLevel == '2'){
            queueId = mapOfQueues.size() > 0 ? mapOfQueues.get('Team 3') : null;
        }
        if(String.isNotBlank(queueId)){
            update new case (
                Id = recordId,
                OwnerId = queueId 
            );
            return 'success';
        }
        return 'error';
    }
}