global class CaseCreationEmailServiceHandler implements Messaging.InboundEmailHandler {
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        return doCreateCase(email, envelope);
    }
    global Messaging.InboundEmailResult doCreateCase(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        try {
            Case caseRecord = doInserCase(email, envelope);
            doInsertAttachment(caseRecord, email, envelope);
            doInsertMessage(caseRecord, email, envelope);
            result.success = true;
        } catch (Exception e) {
            result.success = false;
            result.message = 'Error processing the email: ' + e.getMessage();
        }
        return result;
    }
    global Case doInserCase(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Case caseRecord = new Case();
        caseRecord.Subject = email.subject;
        caseRecord.Description = email.plainTextBody;
        caseRecord.Attachment_Description__c = email.htmlBody;
        caseRecord.Status = 'New';
        caseRecord.SuppliedEmail = envelope.fromAddress;
        caseRecord.User_Email__c = envelope.fromAddress;
        caseRecord.serviceFlow_Customer_Email__c = envelope.fromAddress;
        caseRecord.recordTypeId = '0120Q0000002N6q';
        caseRecord.User_country__c = 'Spain';
        caseRecord.Origin = 'E-Mail';
        caseRecord.Priority = 'Medium';
        caseRecord.OwnerId = '00G0Q000009PClb';
        insert caseRecord;
        return caseRecord;
    }
    global void doInsertAttachment(Case caseRecord, Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        List<Attachment> attachmentList = new List<Attachment>();
        if (email.binaryAttachments != null && email.binaryAttachments.size() > 0) {
          for (integer i = 0 ; i < email.binaryAttachments.size() ; i++) {
            Attachment attachment = new Attachment();
            attachment.ParentId = caseRecord.Id;
            attachment.Name = email.binaryAttachments[i].filename;
            attachment.Body = email.binaryAttachments[i].body;
            attachment.ContentType = email.binaryAttachments[i].mimeTypeSubType;
            attachmentList.add(attachment);
          }
        }
        insert attachmentList;
    }
    global void doInsertMessage(Case caseRecord, Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        /*String emailSubject = email.subject;
        system.debug('***emailSubject*****'+JSON.serializePretty(emailSubject));
        String[] a = emailSubject.split('\\(');
        system.debug('****aaaa****'+JSON.serializePretty(a));
        String[] bb = a[1].split('\\)');
        system.debug('****bbbbbbbbbbbb****'+JSON.serializePretty(bb));
        String subrecid = bb[0];
        system.debug('***subrecidsubrecidsubrecid*****'+JSON.serializePretty(subrecid));*/
        EmailMessage emailMessage = new EmailMessage();
        emailMessage.ToAddress = String.join(email.toAddresses, ',');
        emailMessage.FromAddress = email.FromAddress;
        emailMessage.FromName = email.FromName;
        emailMessage.Subject = email.subject;
        emailMessage.status = '2';
        emailMessage.HtmlBody = email.htmlBody;
        emailMessage.Incoming = True;
        emailMessage.TextBody = email.plainTextBody;
        emailMessage.RelatedToId = caseRecord.Id;
        system.debug('********'+JSON.serializePretty(emailMessage));
        insert emailMessage;
        system.debug('********'+emailMessage.Id);
        EmailMessageRelation emailMessageRelation = new EmailMessageRelation();
        emailMessageRelation.EmailMessageId = emailMessage.id;
        //emailMessageRelation.RelationId = subrecid;
        emailMessageRelation.RelationAddress = email.FromAddress;
        emailMessageRelation.RelationType = 'FromAddress';
        system.debug('********'+JSON.serializePretty(emailMessageRelation));
        insert emailMessageRelation;  
        system.debug('********'+JSON.serializePretty(emailMessageRelation.Id));      
    }
}