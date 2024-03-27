public with sharing class APACCreateNewProductFormController {
    @AuraEnabled
    public static List<ListView> getListViews(){
        try {
            List<ListView> listview = [SELECT Id, Name FROM ListView WHERE SobjectType = 'APAC_Product__c'];
            return listview;
        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<APAC_Product__c> getVisitRequesType(Id recordId){
        try {
            List<APAC_Product__c> apacList = [SELECT APAC_Request_Type__c FROM APAC_Product__c WHERE Id=:recordId];
            if(!apacList.isEmpty()){
                System.debug('Get Data APAC Product List : '+apacList);
                return apacList;
            }else{
                return null;
            }
        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<APAC_Product__c> getProductListRecord(Id recordId){
        try {
            List<APAC_Product__c> pList = [SELECT Id, Name, APAC_Company_Entity__c, OwnerId, CurrencyIsoCode, APAC_Request_Type__c,
                                            APAC_Product_Name_Comm__c, APAC_Product_Name__c, APAC_Product_Name_2__c,
                                            APAC_Product_Name_3__c, APAC_Product_Name_4__c, APAC_Product_Name_5__c,
                                            APAC_Product_Code__c, APAC_Product_Code_2__c, APAC_Product_Code_3__c,
                                            APAC_Product_Code_4__c, APAC_Product_Code_5__c, APAC_Product_Coating__c,
                                            APAC_Product_Coating_2__c, APAC_Product_Coating_3__c, APAC_Product_Coating_4__c,
                                            APAC_Product_Coating_5__c, APAC_Oversea_Production__c, APAC_Local_Production__c,
                                            APAC_Rx__c, APAC_FSV__c, APAC_Target_Launch_Date__c, APAC_Supplier_2__c, 
                                            APAC_Supplier_3__c, APAC_Supplier_4__c, APAC_Detail_Launch_Schedule__c,
                                            APAC_Target_Discountinue_Date__c, APAC_Ax_System__c, APAC_VO_System__c, APAC_System_Change_Request__c,
                                            APAC_Others__c, APAC_Description__c, APAC_Propose_Product_Testing_Date__c, APAC_Stock__c, 
                                            APAC_Stock_On_Hand__c, APAC_Month_on_Hand__c, APAC_Phase_out_plan_attached__c 
                                            FROM APAC_Product__c WHERE Id=:recordId];
            if(!pList.isEmpty()){
                return pList;
            }else{
                return null;
            }
        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String getApprovedString(Id recordId){
        try {
            Boolean IsApproved = [SELECT Approval_Status__c FROM APAC_Product__c WHERE Id=:recordId].Approval_Status__c;
            String ApprovedString = '';
            if(IsApproved==true){
                ApprovedString = 'Approved';
            }else{
                ApprovedString = 'Not Approved';
            }

            return ApprovedString;
        } catch (Exception e) {
            LogException.log(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    public static void doAPACProductBeforeInsert(List<APAC_Product__c> newList){
        Integer year = Date.today().year();
        Integer month = Date.today().month();
        Integer counter = [select count() from APAC_Product__c ALL ROWS]+1;
        Integer counterDate = [select count() from APAC_Product__c where LastModifiedDate=TODAY ALL ROWS]+1;
        
        for(APAC_Product__c product : newList){
            if(product.APAC_Request_Type__c == 'New Product Introduction'){
                String text1 = 'NP/'+String.valueOf(year)+'/'+String.valueof(counter).leftPad(6, '0');
                product.Name = text1;
            }else if(product.APAC_Request_Type__c == 'Product Conversion'){
                String text1 = 'PC/'+String.valueOf(year)+'/'+String.valueOf(counter).leftPad(6, '0');
                product.Name = text1;
            }else if(product.APAC_Request_Type__c == 'Product Removal'){
                String text1 = 'PR/'+String.valueOf(year)+'/'+String.valueOf(counter).leftPad(6, '0');
                product.NAME = text1;
            }else{
                String text1 = 'NP/'+String.valueOf(year)+'/'+String.valueof(counter).leftPad(6, '0');
                product.NAME = text1;
            }
        }
    }

}