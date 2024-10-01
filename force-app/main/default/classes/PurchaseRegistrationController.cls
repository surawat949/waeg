public without sharing class PurchaseRegistrationController {
   
    public static Id endConsumerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('End_Consumer_Account').getRecordTypeId();
    public class Option
    {
        @AuraEnabled
        public String Id;
        @AuraEnabled
        public String Name;

        public Option(String Id, String Name)
        {
            this.Id = Id;
            this.Name = Name;
        }
    }
    
    
    

    @AuraEnabled
    public static List<Option> getCountryList(){
        List<Option> options = new List<Option>();
        try {
            Schema.DescribeFieldResult fieldResult = User.Country__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            options.add(new Option('', ''));
            for( Schema.PicklistEntry f : ple)
            {
                    options.add(new Option(f.getValue(), f.getLabel()));
            }     
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return options;
    }
    
    @AuraEnabled
    public static List<Option> getSeikoNetworkList(){
        List<Option> options = new List<Option>();
        try {
            Schema.DescribeFieldResult fieldResult = Account.Seiko_Network__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            options.add(new Option('', ''));
            for( Schema.PicklistEntry f : ple)
            {
                    options.add(new Option(f.getValue(), f.getLabel()));
            }     
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return options;
    }


@AuraEnabled
public static List<Purchase_Registration__c> GetWinnerList(Boolean all, String country){
    try {
        System.debug('call PurchaseRegistrationController.GetWinnerList(all=' + all + ', country='+country+')') ;
        List<Purchase_Registration__c> resultList = new List<Purchase_Registration__c>();
        if(country==null ||country==''){
            resultList =  [SELECT contact__r.account.owner.country__c, contact__r.name,contact__r.Account_Name__c, contact__r.Hoya_Account_Id__c,contact__r.email
                    ,CompanyNumber__c,Contact__c,DeliveryDate__c,EndCustName__c,GdprConsent__c,Id,Name
                    , winner_date__c,RegistrationDate__c,MembersOnlyChoiceLabel__c,contact__r.account.Seiko_Network__c
                    FROM Purchase_Registration__c
                    WHERE MembersOnlyParticipate__c = true and winner__c=true
                    order by winner_date__c desc];
        } else {
            resultList =  [SELECT contact__r.account.owner.country__c, contact__r.name,contact__r.Account_Name__c, contact__r.Hoya_Account_Id__c,contact__r.email
                ,CompanyNumber__c,Contact__c,DeliveryDate__c,EndCustName__c,GdprConsent__c,Id,Name
                , winner_date__c,RegistrationDate__c,MembersOnlyChoiceLabel__c,contact__r.account.Seiko_Network__c
                FROM Purchase_Registration__c
                WHERE MembersOnlyParticipate__c = true and contact__r.account.Responsible_Customer_Service_Agent__r.country__c=:country and winner__c=true and contact__r.account.RecordTypeId =:endConsumerRecordTypeId
                order by winner_date__c desc];
        }

        System.debug('XXXX result size=' + resultList.size());
        return resultList;
    } catch (Exception e) {
        throw new AuraHandledException(e.getMessage());
    }
}

    @AuraEnabled
    public static Purchase_Registration__c getPickaWinner(String country, String month, String year, String network, String buyingGroup){
        try {
          System.debug('call PurchaseRegistrationController.getPickaWinner(' +country+','+month+','+year+ ')') ;
          List<Purchase_Registration__c> result = new List<Purchase_Registration__c>();
          if(country==null ||country==''){
              throw new AuraHandledException('country is required');
          }
          if(month!=null & month!=''){
            Date startDate = date.parse('01/'+month+'/'+year);
            Date endDate = startDate.addDays(Date.daysInMonth(startDate.year(), startDate.month()) - 1);
            System.debug('start='+startDate);
            System.debug('end='+endDate);

            Boolean hasNetwork = network!=null && network!='';
            Boolean hasbuyingFroup = buyingGroup!=null && buyingGroup!='';

            if(hasNetwork && !hasbuyingFroup){
                result = [SELECT contact__r.account.owner.country__c, contact__r.name,contact__r.Account_Name__c, contact__r.Hoya_Account_Id__c,contact__r.email
                        ,CompanyNumber__c,Contact__c,DeliveryDate__c,EndCustName__c,GdprConsent__c,Id,Name
                        , winner_date__c,RegistrationDate__c,MembersOnlyChoiceLabel__c,contact__r.account.Seiko_Network__c
                        FROM Purchase_Registration__c
                        WHERE RegistrationDate__c >=:startDate AND RegistrationDate__c <=:endDate
                        AND MembersOnlyParticipate__c = true and contact__r.account.Responsible_Customer_Service_Agent__r.country__c=:country and winner__c=false and contact__r.account.RecordTypeId =:endConsumerRecordTypeId
                        and contact__r.account.Seiko_Network__c=:network];
            } else if(!hasNetwork && hasbuyingFroup){
                result = [SELECT contact__r.account.owner.country__c, contact__r.name,contact__r.Account_Name__c, contact__r.Hoya_Account_Id__c,contact__r.email
                        ,CompanyNumber__c,Contact__c,DeliveryDate__c,EndCustName__c,GdprConsent__c,Id,Name
                        , winner_date__c,RegistrationDate__c,MembersOnlyChoiceLabel__c,contact__r.account.Seiko_Network__c
                        FROM Purchase_Registration__c
                        WHERE RegistrationDate__c >=:startDate AND RegistrationDate__c <=:endDate
                        AND MembersOnlyParticipate__c = true and contact__r.account.Responsible_Customer_Service_Agent__r.country__c=:country and winner__c=false and contact__r.account.RecordTypeId =:endConsumerRecordTypeId
                        and contact__r.account.Primary_Buying_Group__r.Name like :buyingGroup+'%'];

            } else if(hasNetwork && hasbuyingFroup){
                result = [SELECT contact__r.account.owner.country__c, contact__r.name,contact__r.Account_Name__c, contact__r.Hoya_Account_Id__c,contact__r.email
                        ,CompanyNumber__c,Contact__c,DeliveryDate__c,EndCustName__c,GdprConsent__c,Id,Name
                        , winner_date__c,RegistrationDate__c,MembersOnlyChoiceLabel__c,contact__r.account.Seiko_Network__c
                        FROM Purchase_Registration__c
                        WHERE RegistrationDate__c >=:startDate AND RegistrationDate__c <=:endDate
                        AND MembersOnlyParticipate__c = true and contact__r.account.Responsible_Customer_Service_Agent__r.country__c=:country and winner__c=false and contact__r.account.RecordTypeId =:endConsumerRecordTypeId
                        and contact__r.account.Seiko_Network__c=:network and contact__r.account.Primary_Buying_Group__r.Name like :buyingGroup+'%'];
            } else {
                result = [SELECT contact__r.account.owner.country__c, contact__r.name,contact__r.Account_Name__c, contact__r.Hoya_Account_Id__c,contact__r.email
                    ,CompanyNumber__c,Contact__c,DeliveryDate__c,EndCustName__c,GdprConsent__c,Id,Name
                    , winner_date__c,RegistrationDate__c,MembersOnlyChoiceLabel__c,contact__r.account.Seiko_Network__c
                    FROM Purchase_Registration__c
                    WHERE RegistrationDate__c >=:startDate AND RegistrationDate__c <=:endDate
                    AND MembersOnlyParticipate__c = true and contact__r.account.Responsible_Customer_Service_Agent__r.country__c=:country and winner__c=false and contact__r.account.RecordTypeId =:endConsumerRecordTypeId] ;
            }
          } else {
            result = [SELECT contact__r.account.owner.country__c, contact__r.name,contact__r.Account_Name__c, contact__r.Hoya_Account_Id__c,contact__r.email
            ,CompanyNumber__c,Contact__c,DeliveryDate__c,EndCustName__c,GdprConsent__c,Id,Name
            , winner_date__c,RegistrationDate__c,MembersOnlyChoiceLabel__c,contact__r.account.Seiko_Network__c
            FROM Purchase_Registration__c
            WHERE MembersOnlyParticipate__c = true and contact__r.account.Responsible_Customer_Service_Agent__r.country__c=:country and winner__c=false and contact__r.account.RecordTypeId =:endConsumerRecordTypeId];

          }
          System.debug('XXXX result size=' + result.size());
          Integer k=0;
          /*for(Purchase_Registration__c pr : result){
              System.debug('PR['+k+']=' + pr.name + ',' + pr.Contact__r.name);
              k++;
          }*/
          if(result.size()>0){
            Integer winIndex = Integer.valueof((Math.random() * result.size()));
            System.debug('XXXX winner index=' + winIndex);
            
            Purchase_Registration__c winner =  result[winIndex];
            System.debug('XXXX Winner is ' + winner.contact__r.name);
            winner.winner__c=true;
            winner.winner_date__c = System.now();
            update winner;
            System.debug('XXXX Winner updated');
            return winner;
          } else return null;
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void removeWinner(Id recordId){
        System.debug('call PurchaseRegistrationController.removeWinner(' +recordId+ ')') ;
        try {
            Purchase_Registration__c p = new Purchase_Registration__c();
            p.Id = recordId;
            p.winner__c=false;
            p.winner_date__c = null;
            update p;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Purchase_Registration__c checkRegistrationCode(String code, String country){
        System.debug('call PurchaseRegistrationController.checkRegistration(' +code+ ','+country+')') ;
        try {
            List<Purchase_Registration__c> pList = [SELECT contact__r.account.owner.country__c, contact__r.name,contact__r.Account_Name__c, contact__r.Hoya_Account_Id__c,contact__r.email
                ,CompanyNumber__c,Contact__c,DeliveryDate__c,EndCustName__c,GdprConsent__c,Id,Name
                , winner_date__c,RegistrationDate__c,MembersOnlyChoiceLabel__c
                FROM Purchase_Registration__c
                 where contact__r.account.Responsible_Customer_Service_Agent__r.country__c=:country and contact__r.account.RecordTypeId =:endConsumerRecordTypeId and OrderNumber__c=:code];

            System.debug('XXX List size = ' + pList.size());
            if(pList.size()>1){
                throw new AuraHandledException('More than 1 registration for the same order');
            }
            if(!Test.isRunningTest()){
                if(pList.size()==0){
                    throw new AuraHandledException('No registration found for order ' + code);
                }
            }
            System.debug('XXX order ' + code +' Id=' + pList[0].Id);
            return pList.get(0);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    
    //Special Context code Start INC-11219
    @AuraEnabled
    public static Purchase_Registration__c pickWinnerRandomly(String country, String month, String year, String email){
        
       Integer totalNumberOfParticipents=0;   
        
        try{
    
          System.debug('@@pickWinnerRandomly method is called') ;
          List<Purchase_Registration__c> result = new List<Purchase_Registration__c>();
          list<Purchase_Registration__c> dustbin=new List<Purchase_Registration__c>();
            
          if(country==null ||country==''){
              throw new AuraHandledException('Country is required');
          }
          if(month!=null & month!=''){
            Date startDate = date.parse('01/'+month+'/'+year);
            Date endDate = startDate.addDays(Date.daysInMonth(startDate.year(), startDate.month()) - 1);
            System.debug('@@start='+startDate);
            System.debug('@@end='+endDate);
              
          result = [SELECT contact__r.account.owner.country__c, contact__r.name,contact__r.Account_Name__c, contact__r.Hoya_Account_Id__c,contact__r.email
                    ,CompanyNumber__c,Contact__c,DeliveryDate__c,EndCustName__c,GdprConsent__c,Id,Name
                    , winner_date__c,RegistrationDate__c,MembersOnlyChoiceLabel__c,contact__r.account.Seiko_Network__c,
                    EmailWeb__c,OrderNumber__c,CustName__c,CustStreet__c,CustCity__c,PostCode__c,CustPhone__c,CustNbr__c,
                    sifting_question__c,Absolute_Sifting_Question__c,MembersOnlyParticipate__c FROM Purchase_Registration__c
                    WHERE RegistrationDate__c >=:startDate AND RegistrationDate__c <=:endDate
                    AND MembersOnlyParticipate__c = true and contact__r.account.Responsible_Customer_Service_Agent__r.country__c=:country and winner__c=false and contact__r.account.RecordTypeId =:endConsumerRecordTypeId 
                    AND sifting_question__c!=null] ;
            
                   totalNumberOfParticipents=result.size();
              
              //calculating absolute value and sorting according to the absoulte value
              
                if(totalNumberOfParticipents>0){
                for(Purchase_Registration__c EP:result){
                 
                    EP.Absolute_Sifting_Question__c = math.abs(EP.sifting_question__c-totalNumberOfParticipents);
                    system.debug('shifting ans-->'+EP.Absolute_Sifting_Question__c);
                    dustbin.add(EP);      
                }
            
                System.debug('Dustbin-->'+dustbin);
                
              
                //sorting in ascending order of Absolute_Shifting_Question__c
             
                  SortUtil.sortRecords(dustbin,SortUtil.sortOrder.ASCENDING,'Absolute_Sifting_Question__c',SortUtil.Type.TYPE_DECIMAL);
                  system.debug('Purchase Registration sorted in ASCENDING order(increasing) of Absolute_Sifting_Question__c -->'+dustbin);
                
                 
              
                 createCsvAndEmail(dustbin[0],result,email,month,year,country);
                  System.debug('@@ Winner is  ' + dustbin[0]);
                  dustbin[0].winner__c=true;
                  dustbin[0].winner_date__c = System.now();
                  update dustbin[0];
                  System.debug('@@ Winner is updated');
          }
             }
            if(dustbin.size()>0){
                return dustbin[0];
            }
            else{
                return null;
            }
                  
        }
        catch (Exception e) {
            System.debug(e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
               
    }
    
 //Sending an email to managers about winner and all the participants
 public static void createCsvAndEmail(Purchase_Registration__c winner,List<Purchase_Registration__c> allParticipants,String email,String month,String year, String country){
 
             List<Purchase_Registration__c> result1 = allParticipants;
             Purchase_Registration__c finalWinner=winner;
              Integer totalNumberOfParticipents=0;        
           
           //to print month name in subject 
            Date dateInDate = date.parse('01/'+month+'/'+year);
            Integer y = dateInDate.year();
            Integer m = dateInDate.month();
            Integer d = dateInDate.day();
            DateTime dt = DateTime.newInstance(y,m,d);
            String monthInText=dt.format('MMMM');
            System.debug('@@Month in text'+monthInText); // Will print the name of the month
                 
     
             if(result1.size()>0){
                   totalNumberOfParticipents=result1.size();
                   String csvColumnHeader;
                    List<Purchase_Registration__c> records = new List<Purchase_Registration__c>();
                    List<String> csvRowValues = new List<String>();
                 
                    for(Purchase_Registration__c EP : result1){
                        
                        
                        String registrationName = EP.Name != null ? String.valueOf(EP.Name).escapeCsv() : '';
                        String id = EP.Id != null ? EP.Id : '';
                        Integer shiftingQuestion = integer.valueOf(EP.sifting_question__c) ;
                        
                        String csvRowVal =registrationName + ',' + id + ','+ shiftingQuestion ;
                        csvRowValues.add(csvRowVal);
               
                    }
                        csvColumnHeader = 'Name, Salesforce Id, Shifting Question\n';
                        String csvFile = csvColumnHeader + String.join(csvRowValues,'\n');
             
                       String fileName= 'Participents-'+country+'-'+month+'-'+year;
                 
                       String body = '<html><h3> Dear marketing managers '+ ',</h3>';
                       body +='<style>body, head, table {font-family:Arial,Helvetica,sans-serif;} table,tr,td{border:1px solid black;border-collapse: collapse;padding:5px;}table {width:100%;}</style>';
                       body += '<head><h3>We are pleased to share with you the winner of the purchase registration contest for the month of '+monthInText +':<head><h3>';
                       
                       //body += '<h4>•End Customer Name    - '+finalWinner.EndCustName__c+'<br/>'; //removed
                       body += '<h4>•End Customer Name    - '+finalWinner.contact__r.name+'<br/>';   //newly added
                       body += '•End Customer Email       - '+finalWinner.contact__r.email+'<br/>';  //newly added
                       body += '•Order Number             - '+finalWinner.OrderNumber__c+'<br/>';
                       body += '•Registration Date        - '+finalWinner.RegistrationDate__c+'<br/>';
                       body += '•Members only Participate - '+finalWinner.MembersOnlyParticipate__c+'<br/>';
                       body += '•Shifting Question        - '+finalWinner.sifting_question__c+'<br/>';
                       body += '•The number of patients having participated to the contest this month is :'+totalNumberOfParticipents+'</h4>';
                       body += '<h5>This patient was the closest one from that value.</h5>';
                       
                       body += '<head><h3>The shop details where they purchased from are :</head></h3>';
                       body += '<h4>•Customer Name        - '+finalWinner.CustName__c+'<br/>';
                       body += '•Customer Street          - '+finalWinner.CustStreet__c+'<br/>';
                       body += '•Customer City            - '+finalWinner.CustCity__c+'<br/>';
                       body += '•Post Code                - '+finalWinner.PostCode__c+'<br/>';
                       body += '•Customer Phone           - '+finalWinner.CustPhone__c+'<br/>';
                       body += '•Customer Number          - '+finalWinner.CustNbr__c+'</h4>';
                 
                       
                       body += '<h5>Please organise the delivery of the price for the winner in that practice.<br/>';
                        
                       body += 'Thanks,<br/>';
                       body += 'Seiko Vision</h5>';
                    
                       body+='<html/>';         
                 
                        //send email
                        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                        Messaging.EmailFileAttachment attach1 = new Messaging.EmailFileAttachment();
                        blob b;
                        if(Test.isRunningTest()) { 
                            b = blob.valueOf('Unit.Test');
                        } else {
                            b = Blob.valueOf(csvFile);
                        }                        
             
                        attach1.setFileName(fileName+'.csv');
                        attach1.setBody(b);
                        message.setFileAttachments(new Messaging.EmailFileAttachment[]{attach1});
                        
                         //setting from address
                         OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'salesforce@hoya.eu'];
                           if ( owea.size() > 0 ) { 
                                message.setOrgWideEmailAddressId(owea.get(0).Id);
                            } 
                 
                        String[] toAddresses = new String[] {email}; 
                        message.setToAddresses(toAddresses); 
                  
                           
                        message.setSubject('Purchase registration winner for '+country+' '+ monthInText +' '+ year); 
                        message.setHtmlBody(body);
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message });
                        
            }
            
             }
                
    //Special Contest End
    
    
}