public class MatchingAccountsBatch implements Database.Batchable<sObject>, Database.Stateful {
    private List<Account> matchingAccounts;

    public Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator([
            SELECT Id, Name, OwnerId, Owner.FirstName, Owner.LastName, Hoya_Account_ID__c,owner.Email 
            FROM Account 
            WHERE OwnerId != null 
            ORDER BY Id
        ]);
    }
    
   public void execute(Database.BatchableContext context, List<Account> scope) {
    if (matchingAccounts == null) {
        matchingAccounts = new List<Account>();
    }
    for(Account acc : scope) {
        String ownerFirstName = acc.Owner != null ? acc.Owner.FirstName : '';
        String ownerLastName = acc.Owner != null ? acc.Owner.LastName : '';
        String ownerFullName = ownerFirstName + ' ' + ownerLastName;
        List<String> accountNameWords = acc.Name.toLowerCase().split('\\s+');
        List<String> ownerFullNameWords = ownerFullName.toLowerCase().split('\\s+');
        
        boolean isMatch = false;
        for(String accountNameWord : accountNameWords) {
            for(String ownerFullNameWord : ownerFullNameWords) {
                if(ownerFullNameWord.equals(accountNameWord)) {
                    matchingAccounts.add(acc);
                    isMatch = true;
                    break;
                }
            }
            if(isMatch) {
                break;
            }
        }
    }
}


    
    
    public void finish(Database.BatchableContext context) {
        if (!matchingAccounts.isEmpty()) {
            String csvContent = 'Account Id,Name,Owner Name, Owner Email, Account Hoya Id\n';

            for (Account acc : matchingAccounts) {
               String hoyaAccountId = String.isNotBlank(acc.Hoya_Account_ID__c) ? acc.Hoya_Account_ID__c : '';

                csvContent += '\"' + acc.Id + '\",\"' + acc.Name.escapeCsv() + '\",\"' + acc.Owner.FirstName.escapeCsv() + ' ' + acc.Owner.LastName.escapeCsv() + '\",\"' + acc.Owner.Email.escapeCsv() + '\",\"' + hoyaAccountId.escapeCsv() + '\"\n';
            }
            System.debug('CSV Content: ' + csvContent);
            
            Blob csvBlob = Blob.valueOf(csvContent);
            
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setSubject('Matching Accounts Report');
            email.setPlainTextBody('Please find attached the matching accounts report.');
            email.setToAddresses(new String[] { 'swati.pal@encora.com','ajinkya.bande@hoya.com' });
            email.setSaveAsActivity(false);
            
            Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
            attachment.setFileName('MatchingAccounts.csv');
            attachment.setBody(csvBlob);
            email.setFileAttachments(new Messaging.EmailFileAttachment[] { attachment });
            
            try {
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
            } catch (Exception e) {
                System.debug('Failed to send email: ' + e.getMessage());
                // Handle email sending failure
            }
        }
    }
}