@isTest
private class Email_ControllerTest {
    static testMethod void emailTemplateTest() {
    	Test.startTest();
    	
            Email_Controller template = new Email_Controller();
            
        	template.testFiller();
	    	List<Document> list_documents = template.list_documents;
            String serverInstance = template.serverInstance;
            //Id back_g_img_2 = template.back_g_img_2;
            //Id back_g_img = template.back_g_img;
            List<Document> list_seiko_documents = template.list_seiko_documents;
			    	
    	Test.stopTest();
    }    
}