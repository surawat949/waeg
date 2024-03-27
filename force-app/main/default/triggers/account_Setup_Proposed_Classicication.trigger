trigger account_Setup_Proposed_Classicication on Account (before update) {
    //list<Account> list_accountUpdate = new list<Account>();
    for(Account account : trigger.new){
        list<Account_Segmentation__c> list_accountSegmentations = [Select Country__c,SoW_Threshold_High__c, SoW_Threshold_Low__c, Turnover_Threshold_High__c, Turnover_Threshold_Low__c
                                from Account_Segmentation__c 
                                where Country__c =: account.BillingCountry];
        if(account.Turnover_Amount__c != null && account.Share_of_Wallet__c  != null && account.Turnover_Amount__c != trigger.oldmap.get(account.Id).Turnover_Amount__c){           
            for(Account_Segmentation__c list_accountSegmentation : list_accountSegmentations){
                if(account.Share_of_Wallet__c <= list_accountSegmentation.SoW_Threshold_Low__c && account.Turnover_Amount__c <= list_accountSegmentation.Turnover_Threshold_Low__c){
                    account.Proposed_Classification__c = '1';
                }
                else if(account.Share_of_Wallet__c < list_accountSegmentation.SoW_Threshold_High__c && account.Share_of_Wallet__c >= list_accountSegmentation.SoW_Threshold_Low__c && account.Turnover_Amount__c <= list_accountSegmentation.Turnover_Threshold_Low__c){
                    account.Proposed_Classification__c = '2';
                }
                else if(account.Share_of_Wallet__c > list_accountSegmentation.SoW_Threshold_High__c && account.Turnover_Amount__c <= list_accountSegmentation.Turnover_Threshold_Low__c){
                    account.Proposed_Classification__c = '3';
                }
                else if(account.Share_of_Wallet__c <= list_accountSegmentation.SoW_Threshold_Low__c && account.Turnover_Amount__c < list_accountSegmentation.Turnover_Threshold_High__c && account.Turnover_Amount__c >= list_accountSegmentation.Turnover_Threshold_Low__c){
                    account.Proposed_Classification__c = '4';
                }
                else if(account.Share_of_Wallet__c < list_accountSegmentation.SoW_Threshold_High__c && account.Share_of_Wallet__c >= list_accountSegmentation.SoW_Threshold_Low__c && account.Turnover_Amount__c < list_accountSegmentation.Turnover_Threshold_High__c && account.Turnover_Amount__c >= list_accountSegmentation.Turnover_Threshold_Low__c){
                    account.Proposed_Classification__c = '5';
                }
                else if(account.Share_of_Wallet__c > list_accountSegmentation.SoW_Threshold_High__c && account.Turnover_Amount__c < list_accountSegmentation.Turnover_Threshold_High__c && account.Turnover_Amount__c >= list_accountSegmentation.Turnover_Threshold_Low__c){
                    account.Proposed_Classification__c = '6';
                }
                else if(account.Share_of_Wallet__c <= list_accountSegmentation.SoW_Threshold_Low__c && account.Turnover_Amount__c > list_accountSegmentation.Turnover_Threshold_Low__c){
                    account.Proposed_Classification__c = '7';
                }
                else if(account.Share_of_Wallet__c < list_accountSegmentation.SoW_Threshold_High__c && account.Share_of_Wallet__c >= list_accountSegmentation.SoW_Threshold_Low__c && account.Turnover_Amount__c > list_accountSegmentation.Turnover_Threshold_Low__c){
                    account.Proposed_Classification__c = '8';
                }
                else if(account.Share_of_Wallet__c <= list_accountSegmentation.SoW_Threshold_High__c && account.Turnover_Amount__c > list_accountSegmentation.Turnover_Threshold_Low__c){
                    account.Proposed_Classification__c = '9';
                }
                else{
                    account.Proposed_Classification__c = '0';
                }                                
            }
        }
    }
}