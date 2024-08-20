trigger UserCommentTrigger on User_Comment__c (before insert, after insert) {
    if(trigger.isAfter){
        if(trigger.isInsert){
            for(User_Comment__c u : trigger.new){
                if(u.Send_Email__c == true){
                    APACSendEmailUserComment.SendEmail(trigger.new);
                }
            }
        }
    }
}