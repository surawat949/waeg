/**
 * changed log : 2023-12-07
 * move for the test class to another separate class LookupByControlURLParamNew_Test
 * updated : Surawat Sakulmontreechai <<surawat.sakulmontreechai@hoya.com>>
 */
public class LookupByUrlParamControllerNew {

    public String customerName{get;set;}
    public String customerNumber{get;set;}
    public String phone{get;set;}
    public String email{get;set;}
        
    public LookupByUrlParamControllerNew () { }

    // Main method that takes the incoming parameter and first checks accounts, before checking contacts
    public string redirectToCustomer() {
               
        Map<String,String> params = ApexPages.currentPage().getParameters();
        if(params.size() > 0) {
            customerName = params.get('customer_name');
            customerNumber = params.get('customer_number');
            phone = params.get('phone');   
            email =  params.get('email');
        }

        String customerUrl;
        customerUrl = redirectToAccount();
        if ( customerUrl == 'null')
        {
            customerUrl = redirectToContact();
        }
            
        return customerUrl;
                   
    }   

    public string redirectToAccount() {
    
        Account account;
        // Check the Customer Name
        try {
            if(customerName != null) {
                account = [select ID from Account where name = :customerName limit 1];  
            } 
        } catch (System.queryException e) {//no entry found for lookup item, display empty account page
           account = null;
        }    
        
        // Check the Account Number 
        try {
            if(customerNumber != null) {
                account = [select ID from Account where AccountNumber = :customerNumber limit 1];   
            }
        } catch (System.queryException e) {//no entry found for lookup item, display empty account page
            account = null;
        }   
            
        // Check the Main Phone Number (no US format check)
        try {
            if ((account == null) && (phone != null)) {
                 account = [select ID from Account where phone = :phone limit 1]; 
            }
        } catch (System.queryException e) {//no entry found for lookup item, display empty account page
            account = null;
        }   
                            
        // Check the Main Phone Number (including US format check)
        try {
            if ((account == null) && (phone != null)) {
                
                String npa;
                String nnx;
                String extension;
        
                //  Added logic for NA mobile phone numbers
                if (phone.length() == 10) {
                    npa = phone.substring(0,3);
                    nnx = phone.substring(3,6);
                    extension = phone.substring(6,10);
                    phone = '(' + npa + ') ' + nnx + '-' + extension;
                }

                account = [select ID from Account where phone = :phone limit 1]; 
            }
        } catch (System.queryException e) {//no entry found for lookup item, display empty account page
            account = null;
        }   
                                 
        // Return the acccount reference if a match is found. Otherwise return null   
        String accountUrl = 'null';
        if(account != null) {
            accountUrl = '/' + account.Id;
        }
        
        return accountUrl;
    }
        
    
    public string redirectToContact() {
    
        Contact contact = null;
        
        // Check the Customer Name    
        try {
            if(customerName != null) {
                contact = [select ID from Contact where Name = :customerName limit 1];   
            } 
        } catch (System.queryException e) {//no entry found for lookup item, display empty account page
            contact = null;
        }    
                 
        // Check the Main Phone Number (no US format check)
        try {
            if ((contact == null) && (phone != null)) {
                 contact = [select ID from Contact where Phone = :phone limit 1]; 
            }
        } catch (System.queryException e) {//no entry found for lookup item, display empty account page
            contact = null;
        }   
         
        // Check the Mobile Phone Number (no US format check)
        try {
            if ((contact == null) && (phone != null)) {
                 contact = [select ID from Contact where MobilePhone = :phone limit 1]; 
            }
        } catch (System.queryException e) {//no entry found for lookup item, display empty account page
            contact = null;
        }  
         
        // Check the Home Phone Number (no US format check)
        try {
            if ((contact == null) && (phone != null)) {
                 contact = [select ID from Contact where HomePhone = :phone limit 1]; 
            }
        } catch (System.queryException e) {//no entry found for lookup item, display empty account page
            contact = null;
        } 
         
        // Check the Other Phone Number (no US format check)
        try {
            if ((contact == null) && (phone != null)) {
                contact = [select ID from Contact where OtherPhone = :phone limit 1]; 
            }
        } catch (System.queryException e) {//no entry found for lookup item, display empty account page
            contact = null;
        } 
                           
        // Check the Main Phone Number (including US format check)
        try {
            if ((contact == null) && (phone != null)) {
                
                String npa;
                String nnx;
                String extension;
        
                //  Added logic for NA mobile phone numbers
                if (phone.length() == 10) {
                    npa = phone.substring(0,3);
                    nnx = phone.substring(3,6);
                    extension = phone.substring(6,10);
                    phone = '(' + npa + ') ' + nnx + '-' + extension;
                }

                contact = [select ID from Contact where phone = :phone limit 1]; 
            }
        } catch (System.queryException e) {//no entry found for lookup item, display empty account page
            contact = null;
        }   
 
        // Check the Mobile Number (including US format check)
        try {
            if ((contact == null) && (phone != null)) {
                String npa;
                String nnx;
                String extension;
        
                //  Added logic for NA mobile phone numbers
                if (phone.length() == 10) {
                    npa = phone.substring(0,3);
                    nnx = phone.substring(3,6);
                    extension = phone.substring(6,10);
                    phone = '(' + npa + ') ' + nnx + '-' + extension;
                }

                contact = [select ID from Contact where MobilePhone = :phone limit 1]; 
            }
        } catch (System.queryException e) {//no entry found for lookup item, display empty account page
            contact = null;
        }   

        // Check the Home Number (including US format check)
        try {
            if ((contact == null) && (phone != null)) {
                String npa;
                String nnx;
                String extension;
        
                //  Added logic for NA mobile phone numbers
                if (phone.length() == 10) {
                    npa = phone.substring(0,3);
                    nnx = phone.substring(3,6);
                    extension = phone.substring(6,10);
                    phone = '(' + npa + ') ' + nnx + '-' + extension;
                }

                contact = [select ID from Contact where HomePhone = :phone limit 1]; 
            }
        } catch (System.queryException e) {//no entry found for lookup item, display empty account page
            contact = null;
        }  

        // Check the Other Number (including US format check)
        try {
            if ((contact == null) && (phone != null)) {
                String npa;
                String nnx;
                String extension;
        
                //  Added logic for NA mobile phone numbers
                if (phone.length() == 999) {
                    npa = phone.substring(0,3);
                    nnx = phone.substring(3,6);
                    extension = phone.substring(6,10);
                    phone = '(' + npa + ') ' + nnx + '-' + extension;
                }

                contact = [select ID from Contact where OtherPhone = :phone limit 1]; 
            }
        } catch (System.queryException e) {//no entry found for lookup item, display empty account page
            contact = null;
        }  

        // Check the email address           
        try {
            if ((contact == null) && (email != null)) {
                contact = [select ID from Contact where Email = :email limit 1]; 
            }
        } catch (System.queryException e) {//no entry found for lookup item, display empty contact page
            contact = null;        
        }   
             
        // Return the Contact ID if found, otherwise return the handle to create a new contact.  
        String contactUrl;
        if(contact != null) {
            contactUrl = '/' + contact.Id;
        } 
        else {
            contactUrl = '/003/e';
        }
        
        return contactUrl;
    }
        
    // Following are a number of test methods for this class
    //
    /*
    public static testMethod void testLookupByUrlParamAccount() {
        LookupByUrlParamControllerNew controller = new LookupByUrlParamControllerNew();
        controller.customerName = 'Avaya';
        String redirectUrl = controller.redirectToCustomer();
        System.assertEquals(redirectUrl, '/003/e');
    }
    
    public static testMethod void testLookupByUrlParamInvalidAccount() {
        LookupByUrlParamControllerNew controller = new LookupByUrlParamControllerNew();
        controller.CustomerName = '';
        String redirectUrl = controller.redirectToCustomer();
        System.assertEquals(redirectUrl, '/003/e');
    }
    
     public static testMethod void testLookupByUrlParamInvalidContact() {
        LookupByUrlParamControllerNew controller = new LookupByUrlParamControllerNew();
        controller.CustomerName = '';
        String redirectUrl = controller.redirectToCustomer();
        System.assertEquals(redirectUrl, '/003/e');
    }
    
    public static testMethod void testLookupByUrlParamPhone() {
        LookupByUrlParamControllerNew controller = new LookupByUrlParamControllerNew();
        controller.phone = '1234';
        String redirectUrl = controller.redirectToCustomer();
        System.assertEquals(redirectUrl, '/003/e');
    }
    
    public static testMethod void testLookupByUrlParamWherePhoneNumberIs10Chars() {
        LookupByUrlParamControllerNew controller = new LookupByUrlParamControllerNew();
        controller.phone = '1234567891';
        String redirectUrl = controller.redirectToCustomer();
        System.assertEquals(redirectUrl, '/003/e');//no record found
    }
    
    
    public static testMethod void testLookupByUrlParamWhereVallidPhoneNumberIs10Chars() {
        LookupByUrlParamControllerNew controller = new LookupByUrlParamControllerNew();
        controller.phone = '2125551234';
        String redirectUrl = controller.redirectToCustomer();
        System.assertEquals(redirectUrl, '/003/e');//no record found
    }
    
    public static testMethod void testLookupByUrlParamInvalidPhoneNumber() {
        LookupByUrlParamControllerNew controller = new LookupByUrlParamControllerNew();
        controller.phone = '';
        String redirectUrl = controller.redirectToCustomer();
        System.assertEquals(redirectUrl, '/003/e');//no record found
    }
       
    public static testMethod void testLookupByUrlParamAccountNumber() {
        LookupByUrlParamControllerNew controller = new LookupByUrlParamControllerNew();
        controller.customerNumber = '4321';
        String redirectUrl = controller.redirectToCustomer();
        System.assertEquals(redirectUrl, '/003/e');
    }
    
    public static testMethod void testLookupByUrlParam() {
        LookupByUrlParamControllerNew controller = new LookupByUrlParamControllerNew();
        String redirectUrl = controller.redirectToCustomer();
        System.assertEquals(redirectUrl, '/003/e');
    } */
}