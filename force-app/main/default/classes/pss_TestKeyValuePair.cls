@isTest
public class pss_TestKeyValuePair {

    static testMethod void testKeyValuePairPage() 
    {
        KeyValuePair kvp=new KeyValuePair('password','1234Ttttt!');
        kvp.key = 'token';
        kvp.value='P4radi50!'; 
    }
}