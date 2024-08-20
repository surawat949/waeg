public class serviceFlow_Vf_QualityReturn_Pfd_Ctrl {
    public Id caseRecId {get;set;}
    public Case caseRecordDetails {get;set;}
    public String caseEmailBody {get;set;}
    public boolean isSalesReturnsExist {get;set;}
    public List<serviceFlow_AS400_Data__c> as400DataList {get;set;}
    public List<String> parametersSelected {get;set;}
    public serviceFlow_Vf_QualityReturn_Pfd_Ctrl(ApexPages.StandardController controller){
       isSalesReturnsExist = false;
       caseRecId = ApexPages.currentPage().getParameters().get('Id');
       caseEmailBody = ApexPages.currentPage().getParameters().get('caseEmailBody');
       caseRecordDetails = caseEmailBody != null ? (Case)JSON.deserialize(caseEmailBody, Case.Class) : null;
       if(String.isNotBlank(caseRecordDetails.serviceFlow_Customer_code__c)){
           as400DataList = serviceFlow_QualityReturnTemplate_Ctrl.fetchAS400Data(caseRecordDetails.serviceFlow_Customer_code__c);
           if(as400DataList.size() > 0){
               isSalesReturnsExist = true;
           }
       }
       if(caseRecordDetails != null){
          if(caseRecordDetails != null && String.isNotBlank(caseRecordDetails.serviceFlow_Parameters_checked__c)){
              parametersSelected = caseRecordDetails.serviceFlow_Parameters_checked__c.split(';');
          }
        }else{
            caseRecordDetails = [Select Id,OwnerId,Owner.Name,serviceFlow_Customer_code__c,
               serviceFlow_Report_numnber__c,serviceFlow_Box_Number__c,serviceFlow_Notes__c,
               serviceFlow_Free_Text_for_notes__c,serviceFlow_Hoya_Delivery_note__c,
               serviceFlow_Defect__c,serviceFlow_Parameters_checked__c,serviceFlow_Customer_Email__c,
               Contact.Email,serviceFlow_Contact_Email__c From Case Where Id=:ApexPages.currentPage().getParameters().get('Id') limit 1
          ];
          if(caseRecordDetails != null && String.isNotBlank(caseRecordDetails.serviceFlow_Parameters_checked__c)){
              parametersSelected = caseRecordDetails.serviceFlow_Parameters_checked__c.split(';');
          }
        }
    }
}