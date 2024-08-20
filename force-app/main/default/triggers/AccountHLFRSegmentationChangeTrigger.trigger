trigger AccountHLFRSegmentationChangeTrigger on Account (before update) {
    
    if(Trigger.new.size()<201 && UserInfo.getUserId()=='0050X000007FdP1QAK'){
        //only for accounts updated by batch (user AWS Synchronizer)

        Integer i = 0;
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();

        Map<Id, Account> accountMap = new Map<Id,Account>();
        Map<Id, Account> oldAccountMap = new Map<Id,Account>();
        String userSOQL = 'Select id, Email From User where id in(';
        Integer nbAccount = 0;


        for(Account newAccount : Trigger.New){
            Account oldAccount = trigger.old[i];
            String hai = oldAccount.HOYA_Account_id__c;
                    
            if(hai.startsWith('FR0')){
                if(newAccount.French_Customer_Classification__c!=oldAccount.French_Customer_Classification__c
                && newAccount.French_Customer_Classification__c!=null){
                    accountMap.put(newAccount.Id, newAccount);
                    oldAccountMap.put(oldAccount.Id, oldAccount);
                    userSOQL = userSOQL + '\'' + newAccount.ownerId + '\',';
                    nbAccount++;
                }
            }
            i++;
        }

        if(nbAccount>0){

            userSOQL = userSOQL.substring(0, userSOQL.length() - 1); //remove last ,
            userSOQL = userSOQL + ')';
            System.debug(userSOQL);
            Map<Id, User> userMap = new Map<Id, User>();
            List<User> userList = database.query(userSOQL);
            for(USer u : userList){
                userMap.put(u.Id, u);
            }

            for(Account a :accountMap.values()){
                //French_Customer_Classification__c have changed, send notification by mail
                User activeUser = userMap.get(a.ownerId);
                String userEmail = activeUser.Email;

                Account oldAccount = oldAccountMap.get(a.Id);

                String[] toAddresses = new String[] {userEmail, 'facturation@hoya.fr', 'gonay@hoya.com'};
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(toAddresses);
                mail.setSubject('Salesforce Support: Classification change for account '+a.Hoya_Account_ID__c);
                mail.setSenderDisplayName('Salesforce Support');
                mail.setHtmlBody('<p>Le compte '+a.Hoya_Account_ID__c+' a changé de classification. ('+oldAccount.French_Customer_Classification__c+'->'
                                    +a.French_Customer_Classification__c+')</p><br/>Email send automatically, please do not reply.');

                mailList.add(mail);
            }
                
            
            if(mailList.size()>0){
                Messaging.sendEmail(mailList);
            }
        }
    }
}