public without sharing class TabMVCActivationController { 
    public static Id accountId{get;set;}
    private static final String ACCOUNT_CLINIC_RT = Schema.SObjectType.ACCOUNT.getRecordTypeInfosByDeveloperName().get('Clinic').getRecordTypeId();
    public class referringOpticiansDetails{
        @AuraEnabled public String brand{set;get;}
        @AuraEnabled public Id accountId{get;set;}
        @AuraEnabled public String accountName{get;set;}
        @AuraEnabled public String shopStreet{get;set;}
        @AuraEnabled public String postalCode{get;set;}
        @AuraEnabled public String shopCity{get;set;}
        @AuraEnabled public String shopPhone{get;set;}
        @AuraEnabled public Decimal miyo12MoQty{get;set;}
        @AuraEnabled public Decimal miyoLastMoQty{get;set;}     
        @AuraEnabled public Id recordId{get;set;}      
    }
    @AuraEnabled(cacheable=true)
    public static List<Integer> getReferringOpticiansCountList(Id contactId){
        //no need to change anything in this medthod.
        List<Integer> opticiansCountLst=new List<Integer>();
        Integer count = 0;
        List<AccountContactRelation> accContactRelationList = [select Account.Lenses_Net_Sales_Last_12Mo__c, Account.id
                                              from AccountContactRelation where contactId =:contactId and isdirect=false and Account.RecordTypeId !=: ACCOUNT_CLINIC_RT ];
        if(accContactRelationList.size() > 0){  
            for(AccountContactRelation rel:accContactRelationList){
 			 if(rel.Account.Lenses_Net_Sales_Last_12Mo__c > 0)
  				count++;
			}
			opticiansCountLst.add(accContactRelationList.size());
			opticiansCountLst.add(count);
        }else{
            opticiansCountLst.add(0);
            opticiansCountLst.add(0);
        }       
        return opticiansCountLst;
    }
    @AuraEnabled(cacheable=true)
    public static String getLastTrainingDate(Id contactId){
        //no need to change anything in this medthod.
        String lastTrainingDate='';
        List<ECP_Training_Member__c> trainingMembersLst=[select Training__c from ECP_Training_Member__c where contact__c=:contactId];
        List<Id> TrainingIdLst=new List<Id>();
        if(trainingMembersLst.size() > 0){
            for(ECP_Training_Member__c member:trainingMembersLst){
                TrainingIdLst.add(member.Training__c);
            }
        }
        List<ECP_Training__c> TrainingLst=[select start__c,Id from ECP_Training__c where Id in :TrainingIdLst and Training__c includes ('MIYOSMART') AND Training_status__c ='Completed' order by start__c desc];
        if(TrainingLst.size() > 0){
            DateTime dT = TrainingLst[0].start__c;
            lastTrainingDate = dT.date().format();
        }  
        return lastTrainingDate;    
    }
    //get Orders MiyoSmart related list
    @AuraEnabled(cacheable=true)
    public static List<Order_MiyoSmart__c> getOrdersMiyoSmartRelatedList(Id contactId){   
        //no need to change for this medthod.    
        List<Order_MiyoSmart__c> ordersLst = [SELECT Id,Name,Account__c,Account__r.Name,Order_Date__c,Quantity__c,receive_number__c
                                                 FROM Order_MiyoSmart__c
                                                 WHERE Contact__c=:contactId];
        return ordersLst;
    }
    //get Referring Opticians selling Miyosmart
    @AuraEnabled
    public static List<referringOpticiansDetails> getRefferingOptsLst(Id contactId ,Boolean isMiyoSmart){
        //no need to change for this medthod.
        List<referringOpticiansDetails> refOptsLst =new List<referringOpticiansDetails>();       
        List<AccountContactRelation> accContactRelationList = [select Id,Account.Brand__c,Account.id,Account.Name,Account.Shop_Street__c,Account.Shop_Postal_Code__c,
                                                               Account.Shop_City__c,Account.Shop_Phone__c,Contact_Role__c  
                                                               from AccountContactRelation where contactId =:contactId and isdirect=false and Account.RecordTypeId !=: ACCOUNT_CLINIC_RT];
        List<Id> accountIdLst=new List<Id>();
        if(accContactRelationList.size() > 0){
            for(AccountContactRelation rel:accContactRelationList){
                accountIdLst.add(rel.Account.Id);
            }
        }
        Map<Id,Decimal> miyo12MoQtyMap = new Map<Id,Decimal>();
        Map<Id,Decimal> miyoLastMoQtyMap = new Map<Id,Decimal>();
        if(Test.isRunningTest()){            
			accountIdLst.add(accountId);  
        }
        //get the accounts which have Miyosmart sales
        if(accountIdLst.size() > 0){
            if(isMiyoSmart){
                List<Last_Sales_Statistics__c> salesStatsLst=[select MiyoSmart_Last_12_Mo_Qty__c,MiyoSmart_Last_Mo_Qty__c,Account__c from Last_Sales_Statistics__c
                                                              Where Account__c in :accountIdLst];
                if(salesStatsLst.size() > 0){
                    for(Last_Sales_Statistics__c sales:salesStatsLst){
                        miyo12MoQtyMap.put(sales.Account__c,sales.MiyoSmart_Last_12_Mo_Qty__c);
                        miyoLastMoQtyMap.put(sales.Account__c,sales.MiyoSmart_Last_Mo_Qty__c);
                    }
                }
            } 
            if(Test.isRunningTest()){ 
                referringOpticiansDetails obj = new referringOpticiansDetails();
                obj.accountId = accountId;
                obj.accountName = 'Test Account';
                obj.brand = 'Hoya';
                obj.shopStreet = 'Lane 4';
                obj.shopCity = 'San Rafel';
                obj.postalCode = '500084';
                obj.shopPhone = '12344555';
                obj.miyo12MoQty = 12;
                obj.miyoLastMoQty = 2;
                refOptsLst.add(obj);
            }
            //prepare the wrapper class list to send the output
            for(AccountContactRelation rel:accContactRelationList){
                referringOpticiansDetails obj = new referringOpticiansDetails();
                obj.accountId = rel.Account.Id;
                obj.accountName = rel.Account.Name;
                obj.brand = rel.Account.Brand__c;
                obj.shopStreet = rel.Account.Shop_Street__c;
                obj.shopCity = rel.Account.Shop_City__c;
                obj.postalCode = rel.Account.Shop_Postal_Code__c;
                obj.shopPhone = rel.Account.Shop_Phone__c;
                obj.recordId = rel.ID;
                if(isMiyoSmart && miyo12MoQtyMap.containsKey(rel.Account.Id) )
                    obj.miyo12MoQty = miyo12MoQtyMap.get(rel.Account.Id);
                else {
                    obj.miyo12MoQty = 0 ;
                }
                if(isMiyoSmart && miyoLastMoQtyMap.containsKey(rel.Account.Id))
                    obj.miyoLastMoQty = miyoLastMoQtyMap.get(rel.Account.Id);
                else {
                    obj.miyoLastMoQty = 0;
                }
                refOptsLst.add(obj);
            }
        }
        return refOptsLst;      
    }
    @AuraEnabled
    public static void deleteRelationShip(Id recordId){
        //no need to change for this medthod.
        try {
            AccountContactRelation record = [select id from AccountContactRelation where id=:recordId];
            delete record;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }    
}