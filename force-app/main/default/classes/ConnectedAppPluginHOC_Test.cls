@IsTest
global class ConnectedAppPluginHOC_Test {
	@isTest
    global static void customAttributesTest(){
        Map<String,String> mapstr = new Map<String,String>();
        List<ConnectedApplication> connectedApp = [select Id from ConnectedApplication where Name Like '%HOC Korea%' LIMIT 1];
        String connectedAppId = '';
        if(connectedApp.size() > 0){
            connectedAppId = connectedApp[0].Id;
        }
        Test.startTest();
        ConnectedAppPluginHOC  cap = new ConnectedAppPluginHOC();
        Map<String,String> respMapStr = cap.customAttributes(UserInfo.getUserId(), connectedAppId, mapstr, Auth.InvocationContext.SAML_ASSERTION);
        Test.stopTest();
        
        Map<String,String> mapstrempty = new Map<String,String>();
        //System.assertNotEquals(respMapStr,mapstrempty);
        
    }
}