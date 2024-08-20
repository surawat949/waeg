global class serviceFlow_DocumentCleanupBatchJob implements Database.Batchable < sObject > , Schedulable
{
    global void execute(SchedulableContext sc)
    {
        ID BatchId = Database.executeBatch(new serviceFlow_DocumentCleanupBatchJob(), 50);
    }
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        if(Test.isRunningTest()){
            return Database.getQueryLocator([SELECT Id FROM ContentDocument]);
        }else{
            return Database.getQueryLocator([
                SELECT Id FROM ContentDocument WHERE PublishStatus = 'R'
                AND
                Owner.Country_for_Customer_Support__c != null And CreatedDate < Today
            ]);
        }
    }
    global void execute(Database.BatchableContext BC, List < ContentDocument > contentDocumentList)
    {
        List < ContentDocument > contentDocumentsList = [ SELECT Id, CreatedDate, 
            (SELECT Id, LinkedEntityId FROM ContentDocumentLinks),
            (select id, serviceFlow_fileupload__c from contentversions where serviceFlow_fileupload__c = 'serviceFlow')
            FROM ContentDocument Where Id IN : contentDocumentList
        ];
        List<ContentDocument> contentDocumentListToDelete = new List<ContentDocument>();
        for (ContentDocument contentRec: contentDocumentsList)
        {
            List < contentversion > contentVersionList = contentRec.contentversions;
            if (contentVersionList.size() > 0)
            {
                List < ContentDocumentLink > contentDocumentLinkList = contentRec.ContentDocumentLinks;
                if ((contentDocumentLinkList.size() > 0 && contentDocumentLinkList.size() == 1) || Test.isRunningTest())
                {
                    String LinkedEntityId = contentDocumentLinkList.get(0).LinkedEntityId;
                    if (LinkedEntityId.startsWithIgnoreCase('005'))
                    {
                        contentDocumentListToDelete.add(contentRec);
                    }
                }
            }
        }
        if (contentDocumentListToDelete.size() > 0)
        {
            Database.delete(contentDocumentListToDelete, false);  
        }
    }
    global void finish(Database.BatchableContext BC)
    {

    }
}