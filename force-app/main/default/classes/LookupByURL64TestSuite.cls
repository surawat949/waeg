@istest(SeeAllData=true) 
private class LookupByURL64TestSuite {

    public void createTestRecords() {
        List<Account> accts = new List<Account>();
        
        for(Integer i=0;i<4;i++) {
            Account a = new Account(Name='Avaya' + i);
            accts.add(a);
        }
        insert accts;
        
        for (Integer j=0;j<4;j++) {
            Account acct = accts[j];
            List<Contact> cons = new List<Contact>();
            // For each account just inserted, add contacts
            for (Integer k=2*j;k<2*(j+1);k++) {
                cons.add(new Contact(firstname='Test'+k,lastname='Test'+k,AccountId=acct.Id));
            }
            insert cons;
        }
    }
    
    // Following are a number of test methods for the class
    //
    public static testMethod void testLookupByUrlParamAccount() {
        PageReference pageRef = Page.LookupByUrlParam64;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('customer_name', 'Avaya');
        
        LookupByUrlParamController64 controller = new LookupByUrlParamController64();
       // controller.customerName = 'Avaya';
        String redirectUrl = controller.redirectToCustomer();
        System.assertEquals('/00', redirectUrl.substring(0,3));
    }

    public static testMethod void testLookupByUrlParamNamePhone() {
        PageReference pageRef = Page.LookupByUrlParam64;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('customer_name', 'Avaya');
        ApexPages.currentPage().getParameters().put('phone', '1234');
        
        LookupByUrlParamController64 controller = new LookupByUrlParamController64();
       // controller.customerName = 'Avaya';
        String redirectUrl = controller.redirectToCustomer();
        //data not available to testing add debug to log method progress
        System.assertEquals('/00', redirectUrl.substring(0,3));
    }
    public static testMethod void testLookupByUrlParamNameNumber() {
        PageReference pageRef = Page.LookupByUrlParam64;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('customer_name', 'Avaya');
        ApexPages.currentPage().getParameters().put('customer_number', '1234');
        
        LookupByUrlParamController64 controller = new LookupByUrlParamController64();
       // controller.customerName = 'Avaya';
        String redirectUrl = controller.redirectToCustomer();
        System.assertEquals('/00', redirectUrl.substring(0,3));
    }
    public static testMethod void testLookupByUrlParamInvalidAccount() {       
        PageReference pageRef = Page.LookupByUrlParam64;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('customer_name', 'Avayaasfdsf');
        LookupByUrlParamController64 controller = new LookupByUrlParamController64();
        //controller.CustomerName = '';
        String redirectUrl = controller.redirectToCustomer();
        System.assertEquals('/00', redirectUrl.substring(0,3));
    }
    
    public static testMethod void testLookupByUrlParamPhone() {
        PageReference pageRef = Page.LookupByUrlParam64;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('phone', '1234');
        
        LookupByUrlParamController64 controller = new LookupByUrlParamController64();
        
        //controller.phone = '1234';
        String redirectUrl = controller.redirectToCustomer();
        System.assertEquals('/00', redirectUrl.substring(0,3));
    }
    
    public static testMethod void testLookupByUrlParamWherePhoneNumberIs10Chars() {
        PageReference pageRef = Page.LookupByUrlParam64;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('phone', '1234567891');
        
        
        LookupByUrlParamController64 controller = new LookupByUrlParamController64();
        controller.phone = '1234567891';
        String redirectUrl = controller.redirectToCustomer();
        System.assertEquals('/00', redirectUrl.substring(0,3));
    }
    
    
    public static testMethod void testLookupByUrlParamWhereVallidPhoneNumberIs10Chars() {
        PageReference pageRef = Page.LookupByUrlParam64;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('phone', '1234567892');
        LookupByUrlParamController64 controller = new LookupByUrlParamController64();
        
        String redirectUrl = controller.redirectToCustomer();
        System.assertEquals('/00', redirectUrl.substring(0,3));
    }
    
    public static testMethod void testLookupByUrlParamInvalidPhoneNumber() {
        PageReference pageRef = Page.LookupByUrlParam64;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('phone', '1234567892789');
        
        LookupByUrlParamController64 controller = new LookupByUrlParamController64();
        controller.phone = '';
        String redirectUrl = controller.redirectToCustomer();
        System.assertEquals('/003/e', redirectUrl);
    }
       
    public static testMethod void testLookupByUrlParamAccountNumber() {
        PageReference pageRef = Page.LookupByUrlParam64;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('customer_number', '4321');
        LookupByUrlParamController64 controller = new LookupByUrlParamController64();
       
        String redirectUrl = controller.redirectToCustomer();
        System.assertEquals('/00', redirectUrl.substring(0,3));
    }
    
    public static testMethod void testLookupByUrlParamEmail() {
        PageReference pageRef = Page.LookupByUrlParam64;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('email', 'testavaya@avaya.com');
       

        LookupByUrlParamController64 controller = new LookupByUrlParamController64();
        String redirectUrl = controller.redirectToCustomer();
        System.assertEquals('/00', redirectUrl.substring(0,3));
    } 
    public static testMethod void testLookupByUrlParamInvalidEmail() {
        PageReference pageRef = Page.LookupByUrlParam64;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('email', 'tessdfsddfsdftavaya@avaya.com');
       

        LookupByUrlParamController64 controller = new LookupByUrlParamController64();
        String redirectUrl = controller.redirectToCustomer();
        System.assertEquals('/003/e', redirectUrl);
    } 
    
        public static testMethod void testLookupByUrlParamPhoneEmail() {
        PageReference pageRef = Page.LookupByUrlParam64;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('email', 'testavaya@avaya.com');
        ApexPages.currentPage().getParameters().put('phone', '1234');
       

        LookupByUrlParamController64 controller = new LookupByUrlParamController64();
        String redirectUrl = controller.redirectToCustomer();
        System.assertEquals('/00', redirectUrl.substring(0,3));
    } 
    
    public static testMethod void testLookupByUrlParamInvEmailGoodPhone() {
        PageReference pageRef = Page.LookupByUrlParam64;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('email', 'tessdfsddfsdftavaya@avaya.com');
        ApexPages.currentPage().getParameters().put('phone', '1234');
       

        LookupByUrlParamController64 controller = new LookupByUrlParamController64();
        String redirectUrl = controller.redirectToCustomer();
        System.assertEquals('/00', redirectUrl.substring(0,3));
    } 

}