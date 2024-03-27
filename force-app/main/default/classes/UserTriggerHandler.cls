public class UserTriggerHandler {
    //Test class to be used 'WS_CreateEmployeeFromPortal_Test'
    private UserLogic usrLogic;
    public UserTriggerHandler() {
    }
    public void onBeforeInsert(final List<User> newObjects) {
        System.debug('Executing " UserTriggerHandler.onBeforeInsert"...');
        updateHoyaAccountIdBeforeInsert(newObjects);
        UserLogic.updateServiceCloud(newObjects,null);        
    }

    public void onAfterInsert(final List<User> newObjects, final Map<Id, User> newObjectsMap) {
        System.debug('Executing " UserTriggerHandler.onAfterInsert"...');
        UserLogic.sendEmailHandlerAfterInsert(newObjects,newObjectsMap);
        UserLogic.updateContactWithCommunityNickName(newObjects,newObjectsMap);
    }

    public void onBeforeUpdate(final List<User> oldObjects, final Map<Id, User> oldObjectsMap,
                               final List<User> newObjects, final Map<Id, User> newObjectsMap) {
        System.debug('Executing " UserTriggerHandler.onBeforeUpdate"...');
        UserLogic.updateServiceCloud(newObjects,oldObjectsMap);        
    }
    
    public void onAfterUpdate(final List<User> oldObjects, final Map<Id, User> oldObjectsMap,
                              final List<User> newObjects, final Map<Id, User> newObjectsMap) {
        System.debug('Executing " UserTriggerHandler.onAfterUpdate"...');
        UserLogic.sendEmailHandler(newObjects,oldObjectsMap);
    }

    /*public void onBeforeDelete(final List<User> oldObjects, final Map<Id, User> oldObjectsMap) {
        System.debug('Executing " UserTriggerHandler.onBeforeDelete"...');
    }
    
    public void onAfterDelete(final List<User> oldObjects, final Map<Id, User> oldObjectsMap) {
        System.debug('Executing " UserTriggerHandler.onAfterDelete"...');
    }
    
    public void onAfterUndelete(final List<User> newObjects, final Map<Id, User> newObjectsMap) {
        System.debug('Executing " UserTriggerHandler.onAfterUndelete"...');
    }*/

        /* Update the Hoya Account id value on user record for community users. 
     * Community profiles not provided access to accounts and contacts and hence for in OAuth flows they can use this field to fecth customer details
    */
    public static void updateHoyaAccountIdBeforeInsert(List<User> newObjects){
        List<User> userToUpdate = new List<User>();
        List<Id> conIds = new List<Id>();
        
        for(User user : newObjects){
            conIds.add(user.ContactId);
        }
        
        Map<Id, Contact> conCanadaMap = new Map<Id, Contact>([select Id, Hoya_Account_Id__c,AccountId from Contact where Id IN :conIds]);
        for (User user : newObjects) {
            if (user.ContactId != null && conCanadaMap.get(user.ContactId) != null) {
                user.Hoya_Account_ID__c = conCanadaMap.get(user.ContactId).Hoya_Account_Id__c;
                user.Account_ID__c = conCanadaMap.get(user.ContactId).AccountId;
            }
        }

    }
 
}