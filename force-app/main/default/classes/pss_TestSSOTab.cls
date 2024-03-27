@isTest
public class pss_TestSSOTab {

    static testMethod void testConfigurationPage() 
    {
        try{
	    pss_SSOTab ssotest=new pss_SSOTab();
    	ssotest.URL='http://sfdemo.paradisosolutions.com';
        }catch(Exception e){}
    }
}