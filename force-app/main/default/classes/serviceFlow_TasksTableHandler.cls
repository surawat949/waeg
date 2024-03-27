public class serviceFlow_TasksTableHandler
{
    public static Id recordTypeIdCall = Schema.getGlobalDescribe().get('Task').getDescribe().getRecordTypeInfosByName().get('serviceFlow_AgentCreateCall').getRecordTypeId();
    public static Id recordTypeIdTask = Schema.getGlobalDescribe().get('Task').getDescribe().getRecordTypeInfosByName().get('serviceFlow_AgentCreateTask').getRecordTypeId();
    public static Id recordTypeIdEditTask = Schema.getGlobalDescribe().get('Task').getDescribe().getRecordTypeInfosByName().get('serviceFlow_AgentEditTask').getRecordTypeId();

    @AuraEnabled
    public static DataTableWrapper initRecords(String ObjectName)
    {

        //Object Level Mapping
        serviceFlow_Org_Table_Config__mdt metaDataRec = serviceFlow_Org_Table_Config__mdt.getInstance(ObjectName);
        String fieldNamesStr = metaDataRec.Fields_List__c;
        String Orderby = metaDataRec.Order_By__c;
        String OrderDir = metaDataRec.Order_Direction__c;
        
        Set < Id > recordTypeIdSet = new Set < Id >
        {
            recordTypeIdCall,
            recordTypeIdTask,
            recordTypeIdEditTask
        };
        
        DataTableWrapper dtw = new DataTableWrapper();
        List < LabelDescriptionWrapper > labelList = getLables(ObjectName);
        if (labelList.size() > 0)
        {
            List < String > fieldSet = new List < String > ();
            List < String > fieldList = new List < String > (fieldNamesStr.split(';'));
            List < sObject > sObjectRecords = getsObjectRecords(ObjectName, fieldList, 10000, 'New', Orderby, OrderDir);
            dtw.ldwList = labelList;
            dtw.aggregateResult = [select count(Id) recordCount,Status stat from Task Where RecordTypeId IN :recordTypeIdSet AND OwnerId=:UserInfo.getUserId()  AND Status != 'Completed' Group By Status Order By Status ASC];
            dtw.sobList = sObjectRecords;
            dtw.fieldsList = fieldSet;
            dtw.totalCount = sObjectRecords.size();
        }

        return dtw;
    }

    public static List < LabelDescriptionWrapper > getLables(String ObjectName)
    {
        List < LabelDescriptionWrapper > labelList = new List < LabelDescriptionWrapper > ();
        List < serviceFlow_Org_Table_Configuration__mdt > metaDataLabelList = [Select Id, MasterLabel, DeveloperName, Field_Api_Name__c, Sortable__c, Type__c,
            Org_Table_Config__c, Org_Table_Config__r.DeveloperName from serviceFlow_Org_Table_Configuration__mdt
            where Org_Table_Config__r.DeveloperName =: ObjectName
        ];
        if (metaDataLabelList.size() > 0)
        {
            for (serviceFlow_Org_Table_Configuration__mdt orgConfig: metaDataLabelList)
            {
                labelList.add(
                    new LabelDescriptionWrapper(
                        orgConfig.MasterLabel,
                        orgConfig.Field_Api_Name__c,
                        orgConfig.Type__c,
                        orgConfig.Sortable__c
                    )
                );
            }
        }
        return labelList;
    }
    //Select Id,MasterLabel,DeveloperName,Sortable__c,Type__c,Org_Table_Config__c from serviceFlow_Org_Table_Configuration__mdt where Org_Table_Config__r.DeveloperName = 'Task'
    @AuraEnabled
    public static List < sObject > getsObjectRecords(String ObjectName, List < String > fieldList, Integer LimitSize, String status, String Orderby, String OrderDir)
    {
        Set < Id > recordTypeIdSet = new Set < Id >
        {
            recordTypeIdCall,
            recordTypeIdTask,
            recordTypeIdEditTask
        };
        OrderDir = String.isBlank(OrderDir) ? 'ASC' : OrderDir;
        String query = 'SELECT ' + String.join(fieldList, ',') + ' FROM ' + ObjectName;
        String currentUserId = UserInfo.getUserId();
        if (String.isNotBlank(status))
        {
            query += ' WHERE ownerId=:currentUserId AND Status=:status ';
        }
        query += ' ORDER BY ' + Orderby + ' ' + OrderDir + ' NULLS LAST';

        if (LimitSize != null && Integer.valueOf(LimitSize) > 0)
        {
            LimitSize = Integer.valueOf(LimitSize);
            query += ' Limit ' + LimitSize;
        }
        return Database.query(query);
    }

    public class DataTableWrapper
    {
        @AuraEnabled
        public List < LabelDescriptionWrapper > ldwList;
        @AuraEnabled
        public List < sObject > sobList;
        @AuraEnabled
        public List < String > fieldsList;
        @AuraEnabled
        public Integer totalCount;
        @AuraEnabled
        public List<AggregateResult> aggregateResult;
    }

    public class LabelDescriptionWrapper
    {
        @AuraEnabled
        public String label;
        @AuraEnabled
        public String fieldName;
        @AuraEnabled
        public String type;
        @AuraEnabled
        public boolean sortable;

        public LabelDescriptionWrapper(String labelTemp, String fieldNameTemp, String typeTemp, boolean sortableTemp)
        {
            label = labelTemp;
            fieldName = fieldNameTemp;
            type = typeTemp;
            sortable = sortableTemp;
        }

    }

    @AuraEnabled
    public static List < sObject > getTasks(String ObjectName, String status)
    {
        serviceFlow_Org_Table_Config__mdt metaDataRec = serviceFlow_Org_Table_Config__mdt.getInstance(ObjectName);
        String fieldNamesStr = metaDataRec.Fields_List__c;
        String Orderby = metaDataRec.Order_By__c;
        String OrderDir = metaDataRec.Order_Direction__c;
        List < String > fieldList = new List < String > (fieldNamesStr.split(';'));
        return getsObjectRecords(ObjectName, fieldList, 10000, status, Orderby, OrderDir);
    }
}