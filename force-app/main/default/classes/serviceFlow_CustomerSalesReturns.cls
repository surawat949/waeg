public class serviceFlow_CustomerSalesReturns {
    @AuraEnabled(cacheable = true)
    public static DataTableResponse GetWrapperOfSObjectFieldColumnActionValues(String TableName, String orderBy, String direction, String customerCode)
    {
        List < DataTableColumns > lstDataColumns = new List < DataTableColumns > ();
        List < SObject > lstDataTableData = new List < SObject > ();
        List < string > columnList = new List < string > ();
        List < string > fieldAPINameList = new List < string > ();
        String userId = UserInfo.getUserId();
        Dynamic_Table_DataTable__mdt TableComponentMetadata = [SELECT Id, DeveloperName, Field_Value__c, Header_Value__c, Query__c, Table_Title__c,Sortable__c FROM Dynamic_Table_DataTable__mdt WHERE DeveloperName =: TableName];

        if (TableComponentMetadata.Header_Value__c != null)
        {
            columnList = TableComponentMetadata.Header_Value__c.split(',');
        }

        if (TableComponentMetadata.Field_Value__c != null)
        {
            fieldAPINameList = TableComponentMetadata.Field_Value__c.split(',');
        }

        for (integer i = 0; i < columnList.size(); i++)
        {

            DataTableColumns datacolumns = new DataTableColumns(columnList[i].trim(),
                fieldAPINameList[i].substringBefore(':').trim(),
                fieldAPINameList[i].substringAfter(':').trim());

            lstDataColumns.add(datacolumns);
        }
        String soqlString = TableComponentMetadata.Query__c;
        if(TableName == 'customer_sales_returns'){
            soqlString += ' Where CUSTOMER__c=:customerCode';
            soqlString += ' ORDER BY '+orderBy+' '+direction+' Limit 2000';
        }
        system.debug('*******'+soqlString);
        for (SObject SObjectItem: Database.query(soqlString))
        {
            lstDataTableData.add(SObjectItem);
        }

        DataTableResponse finalWrapper = new DataTableResponse();
        finalWrapper.TableTitle = TableComponentMetadata.Table_Title__c;
        finalWrapper.lstDataTableColumns = lstDataColumns;
        finalWrapper.lstDataTableData = lstDataTableData;
        return finalWrapper;
    }

    public class DataTableColumns
    {
        @AuraEnabled public String label{get;set;}
        @AuraEnabled public String fieldName{get;set;}
        @AuraEnabled public String type{get;set;}
        @AuraEnabled public String sortable{get;set;}
        

        public DataTableColumns(String label, String fieldName, String type)
        {
            this.label = label;
            this.fieldName = fieldName;
            this.type = type;
            this.sortable = 'true';
        }
    }

    public class DataTableResponse
    {
        @AuraEnabled public List < DataTableColumns > lstDataTableColumns{get;set;}
        @AuraEnabled public List < sObject > lstDataTableData{get;set;}
        @AuraEnabled public String TableTitle{get;set;}
    }
}