public with sharing class APACSendEmailUserComment {
    
    public static void SendEmail(List<User_Comment__c> newList){

        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();

        User_Comment__c userComment = [select Id, Send_Email__c, Name, Comment_to_user__r.Name, Comment_to_email__c, Comments__c, Owner.Name, Topic_Subject__c, Topic_Sub_Subject__c from User_Comment__c where Send_Email__c = true order by CreatedDate DESC LIMIT 1];

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddress = new String[]{userComment.Comment_to_email__c};
        mail.setToAddresses(toAddress);
        String[] ccAddress = new String[]{'surawat.sakulmontreechai@hoya.com'};
        mail.setCcAddresses(ccAddress);
        mail.setReplyTo('noreply@hoya.com');
        mail.setSubject('You have new comment for subject : '+userComment.Name);
        mail.setSenderDisplayName(userComment.Comment_to_user__r.Name);
        mail.setBccSender(false);
        mail.setPlainTextBody('Hi&nbsp;'+userComment.Comment_to_user__r.Name+'<br/><br/>Comment about : '+userComment.Topic_Sub_Subject__c+'<br/><br/>This is for your comment as below. <br/>'+userComment.Comments__c+'<br/><br/>Regards,'+'<br/>'+userComment.Owner.Name);
        mail.setHtmlBody('<html><body><img src=https://hoya--c.eu41.content.force.com/servlet/servlet.FileDownload?file=0156700000AXQfJ width=200 height=100><br/><br/>'+
                                '<hr width=100% color=#1f618d size=3 /><br/>Hi&nbsp;'+userComment.Comment_to_user__r.Name+'<br/><br/>Comment about : '+
                                userComment.Topic_Sub_Subject__c+'<br/><br/>This is for your comment as below. <br/>'+userComment.Comments__c+'<br/><br/>Regards,'+'<br/>'+userComment.Owner.Name+'<br/><br/><hr width=100% color=#1f618d size=50px /></body></html>');

        emailList.add(mail);

        if(!emailList.isEmpty()){
            System.debug('XXX Starting sending the email '+emailList);
            Messaging.SendEmail(emailList);
        }

        /*
        Messaging.reserveSingleEmailCapacity(3);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddress = new String[]{'sakulmontreechai@hoya.com'};
        mail.setToAddresses(toAddress);
        String[] ccAddress = new String[]{'sakulmontreechai@yahoo.com'};
        mail.setCcAddresses(ccAddress);
        mail.setReplyTo('noreply@hoya.com');
        mail.setSenderDisplayName('Surawat Sakulmontreechai - Test');
        mail.setSubject('This is test email');
        mail.setBccSender(false);
        mail.setPlainTextBody('This is a test email from apex class, do not reply. Thanks.');
        mail.setHtmlBody('This is a test email, do not reply this email. <br> Please follow and check <b>Salesforce</b> below link. <br/> Your link : <a href=https://www.salesforce.com/>Click Here</a>');
        //send email

        System.debug('XXX Starting to send the email : '+mail);
        Messaging.SendEmail(new Messaging.SingleEmailMessage[] {mail});
        */
    }

}