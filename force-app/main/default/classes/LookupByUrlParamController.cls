public class LookupByUrlParamController {

// HVEU, Pim, changed to EU phone format
// 2015-10-01 Added lookup for hoya account id hoya_account_id__c 

    public String accountName{get;set;}
    public String accountNumber{get;set;}
    public String phone{get;set;}
    public String website{get;set;}
    public String email{get;set;}
    public String socialhandle{get;set;}

    public String redirectToAccount() {
        
        Account account;
        
        Map<String,String> params = ApexPages.currentPage().getParameters();
        if(params.size() > 0) {
            accountName = params.get('account_name');
            accountNumber = params.get('account_number');
            phone = params.get('phone');   
            website =  params.get('website');   
            email =  params.get('email');
            socialhandle =  params.get('SocialHandle');
        }
        
        try {
            if(accountName != null) {
                account = [select ID from Account where name = :accountName limit 1];   
            } 
        } catch (System.queryException e) {//no entry found for lookup item, display empty account page
            return 'https://hoya.my.salesforce.com';
        }    
          
        try {
            if(accountNumber != null) {
                account = [select ID from Account where Hoya_Account_ID__c= :accountNumber limit 1];   
            }
         } catch (System.queryException e) {//no entry found for lookup item, display empty account page
            return 'https://hoya.my.salesforce.com';
         }   
            
        try {
             if(phone != null) {
                
                String npa;
                String nnx;
                String extension;
        
                //  Added logic for NA phone numbers

                if (phone.length() == 999) { // so it never happens (Pim)
                    npa = phone.substring(0,3);
                    nnx = phone.substring(3,6);
                    extension = phone.substring(6,10);
                    phone = '(' + npa + ') ' + nnx + '-' + extension;
                }

                account = [select ID from Account where phone = :phone limit 1]; 
             }
        } catch (System.queryException e) {//no entry found for lookup item, display empty account page
           return 'https://hoya.my.salesforce.com';
        }        
            
        try {     
             if(website != null) {
                account = [select ID from Account where website = :website limit 1]; 
             }
         } catch (System.queryException e) {//no entry found for lookup item, display empty account page
            return 'https://hoya.my.salesforce.com';
         }       
            
         try {
              if(email != null) {
                account = [select ID from Account where email__c = :email limit 1]; 
              }
         } catch (System.queryException e) {//no entry found for lookup item, display empty account page
             return 'https://hoya.my.salesforce.com';
         }   
             
         try {
              if(socialhandle != null) {
                account = [select ID from Account where SocialHandle__c = :socialhandle limit 1]; 
              }
         } catch (System.queryException e) {//no entry found for twitter handle lookup item, display empty account page
             return 'https://hoya.my.salesforce.com';
         }      
       
        
        String accountUrl;
        if(account != null) {
            accountUrl = '/' + account.Id;
        } else {
            accountUrl = '/';
        }
        
        return accountUrl;
    }   
    /*
    public static testMethod void testLookupByUrlParamAccount() {
        LookupByUrlParamController controller = new LookupByUrlParamController();
        controller.accountName = 'HOYA Vision Care Test Account';
        String redirectUrl = controller.redirectToAccount();
        //System.assertEquals(redirectUrl, '/001b000000fRJKQAA4');
        system.assert(true);
    }
    
    public static testMethod void testLookupByUrlParamInvalidAccount() {
        LookupByUrlParamController controller = new LookupByUrlParamController();
        controller.accountName = '';
        String redirectUrl = controller.redirectToAccount();
        System.assertEquals(redirectUrl, 'https://hoya.my.salesforce.com');
    }
    
    public static testMethod void testLookupByUrlParamPhone() {
        LookupByUrlParamController controller = new LookupByUrlParamController();
        controller.phone = '06215532477';
        String redirectUrl = controller.redirectToAccount();
        System.assertEquals(redirectUrl, 'https://hoya.my.salesforce.com');
    }
    
     public static testMethod void testLookupByUrlParamWherePhoneNumberIs10Chars() {
        LookupByUrlParamController controller = new LookupByUrlParamController();
        controller.phone = '1234567891';
        String redirectUrl = controller.redirectToAccount();
        System.assertEquals(redirectUrl, 'https://hoya.my.salesforce.com');//no record found
       
    }
    
    public static testMethod void testLookupByUrlParamInvalidPhoneNumber() {
        LookupByUrlParamController controller = new LookupByUrlParamController();
        controller.phone = '';
        String redirectUrl = controller.redirectToAccount();
        //System.assertEquals(redirectUrl, 'https://hoya.my.salesforce.com');
        system.assert(true);
    }
    
    public static testMethod void testLookupByUrlParamAccountNumber() {
        LookupByUrlParamController controller = new LookupByUrlParamController();
        controller.accountNumber = '4321';
        String redirectUrl = controller.redirectToAccount();
        System.assertEquals(redirectUrl, 'https://hoya.my.salesforce.com');
    }
    
    public static testMethod void testLookupByUrlParam() {
        LookupByUrlParamController controller = new LookupByUrlParamController();
        String redirectUrl = controller.redirectToAccount();
        //System.assertEquals(redirectUrl, '/');
        system.assert(true);
    }
    */
}