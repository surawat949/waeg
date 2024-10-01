public class serviceFlow_TrackTrackIntegrationHandler
{
    
    //serviceFlow_TrackTrackIntegrationHandler.doGetTrackTraceOrders('0010Q00001XjMot');
    @AuraEnabled public static ResponseWrapper doGetTrackTraceOrders(String recordId)
    {
        serviceFlow_Track_Trace_Config__mdt trackTrackConfig = trackTrackConfig();
        ResponseWrapper responseWrapperObject = new ResponseWrapper();
        Map < String, Object > headerMap = headerPayload(recordId);
        Map < String, Object > payloadMap = bodyPayload();        
        String jwt = base64URLencode(blob.valueof(JSON.serialize(headerMap))) + '.' + base64URLencode(blob.valueof(JSON.serialize(payloadMap)));
        system.debug('******'+jwt);
        Blob key = blob.valueof(trackTrackConfig.Private_Key__c);
        blob signature = Crypto.generateMac(trackTrackConfig.Algorithm_Name__c, Blob.valueof(jwt), key);
        String accessToken = jwt + '.' + base64URLencode(signature);
        system.debug(accessToken);
        if (String.isNotBlank(accessToken))
        {
            responseWrapperObject = makeCallout(accessToken);
        }
        else
        {
            responseWrapperObject.statusCode = 100;
            responseWrapperObject.errorMessage = 'Access token issue';
            responseWrapperObject.ordersList = new List < Object > ();
        }
        return responseWrapperObject;
    }
    public static serviceFlow_Track_Trace_Config__mdt trackTrackConfig(){
        Organization orgDetails = [SELECT id,isSandbox from Organization Limit 1];
        String trackTraceConfig = orgDetails.isSandbox ? 'serviceFlow_JWT' : 'serviceFlow_Prod';
        
        return [SELECT id, DeveloperName, Algorithm__c, Algorithm_Name__c, Audience__c, Exp_Date__c, Issuer__c, Private_Key__c, Subject__c, Type__c, Endpoint_URL__c
            FROM serviceFlow_Track_Trace_Config__mdt WHERE
            DeveloperName = :trackTraceConfig
            Limit 1
        ];
    }
    public static ResponseWrapper makeCallout(String accessToken)
    {
        serviceFlow_Track_Trace_Config__mdt trackTrackConfig = trackTrackConfig();
        HTTP http = new HTTP();
        HTTPRequest request = new HTTPRequest();
        request.setEndpoint(trackTrackConfig.Endpoint_URL__c);
        request.setHeader('Accept', 'application/json');
        request.setHeader('Authorization', 'Bearer ' + accessToken);
        request.setMethod('GET');
        HttpResponse response = new HttpResponse();
        ResponseWrapper responseWrapperObject = new ResponseWrapper();
        try
        {
            response = Http.send(request);
            system.debug(response.getStatusCode());
            responseWrapperObject.statusCode = response.getStatusCode();
            if (response != null && response.getStatusCode() == 200)
            {
                responseWrapperObject.ordersList = (List < Object > ) JSON.deserializeUntyped(response.getBody());

                Set<String> orderNumberSet = new Set<String>();
                for(Object orderDetails : responseWrapperObject.ordersList){
                    Map<String,Object> orderDetailsMap = (Map<String,Object>) orderDetails;
                    if(orderDetailsMap.get('orderNumber') != null){
                        orderNumberSet.add(String.valueOf(orderDetailsMap.get('orderNumber')));
                    }
                }
                system.debug('********'+JSON.serializePretty(orderNumberSet));
                Map<String,serviceFLow_Track_Trace_Activities__c> mapOfActivities = new Map<String,serviceFLow_Track_Trace_Activities__c>();
                for(serviceFLow_Track_Trace_Activities__c trackTraceRec : [Select Id,Name,Comments__c,Hoya_Account_ID__c,serviceFlow_Order_ID__c From serviceFLow_Track_Trace_Activities__c Where serviceFlow_Order_ID__c IN : orderNumberSet]){
                    mapOfActivities.put(trackTraceRec.serviceFlow_Order_ID__c,trackTraceRec);
                }
                
                for(Object orderDetails : responseWrapperObject.ordersList){
                    Map<String,Object> orderDetailsMap = (Map<String,Object>) orderDetails;
                    system.debug(orderDetailsMap.get('stationId'));   
                    String stationId = orderDetailsMap.get('stationId') != null ? 
                        serviceFlow_StationMappings__mdt.getInstance('X'+orderDetailsMap.get('stationId')) != null ? 
                        serviceFlow_StationMappings__mdt.getInstance('X'+orderDetailsMap.get('stationId')).Station_Description__c : String.valueOf(orderDetailsMap.get('stationId')) : '';            
                    if(mapOfActivities.containsKey(String.valueOf(orderDetailsMap.get('orderNumber')))){
                        orderDetailsMap.put('comment',mapOfActivities.get(String.valueOf(orderDetailsMap.get('orderNumber'))).Comments__c);
                    }else{
                        orderDetailsMap.put('comment','');
                    }
                    orderDetailsMap.put('stationId',stationId);
                    
                }
                responseWrapperObject.returnResult = 'SUCCESS';
                responseWrapperObject.errorMessage = 'Successfully fetched the results';
            }
            else
            {
                responseWrapperObject.ordersList = new List < Object > ();
                responseWrapperObject.returnResult = 'ERROR';
                responseWrapperObject.errorMessage = 'Error occured';
            }
        }
        catch (Exception e)
        {
            responseWrapperObject.ordersList = new List < Object > ();
            responseWrapperObject.returnResult = 'ERROR';
            responseWrapperObject.errorMessage = e.getMessage();
        }
        return responseWrapperObject;

    }
    public static Map < String, Object > headerPayload(String recordId)
    {
        serviceFlow_Track_Trace_Config__mdt trackTrackConfig = trackTrackConfig();
        Account acct = [SELECT Id, Account_Number_ILog__c, Shop_Country__c, Brand__c From Account WHERE Id =: recordId];
        Map < String, Object > headerMap = new Map < String, Object > ();
        headerMap.put('typ', trackTrackConfig.Type__c);
        headerMap.put('alg', trackTrackConfig.Algorithm__c);
        headerMap.put('mfc', (acct != null && acct.Brand__c == 'HOYA') ? 'HOY' : 'SEI');
        headerMap.put('cc', (acct != null && String.isNotBlank(acct.Shop_Country__c)) ? acct.Shop_Country__c : '');
        headerMap.put('cn', (acct != null && String.isNotBlank(acct.Account_Number_ILog__c)) ? acct.Account_Number_ILog__c : '');
        return headerMap;
    }
    public static Map < String, Object > bodyPayload()
    {
        serviceFlow_Track_Trace_Config__mdt trackTrackConfig = trackTrackConfig();
        Datetime dtnbf = Datetime.now();
        Long lnbf = dtnbf.gettime();
        Datetime dtexp = Datetime.now().addMinutes(5);
        Long lexp = dtexp.gettime();
        String nbf = String.valueOf(lnbf);
        nbf = nbf.Substring(0, nbf.length() - 3);
        String exp = String.valueOf(lexp);
        exp = exp.Substring(0, exp.length() - 3);

        Map < String, Object > payloadMap = new Map < String, Object > ();
        payloadMap.put('iss', trackTrackConfig.Issuer__c);
        payloadMap.put('sub', trackTrackConfig.Subject__c);
        payloadMap.put('aud', trackTrackConfig.Audience__c);
        payloadMap.put('nbf', nbf);
        payloadMap.put('iat', nbf);
        payloadMap.put('exp', exp);
        return payloadMap;
    }
    public static String base64URLencode(Blob input)
    {
        String output = encodingUtil.base64Encode(input);
        output = output.replace('+', '-');
        output = output.replace('/', '_');
        while (output.endsWith('='))
        {
            output = output.subString(0, output.length() - 1);
        }
        return output;
    }
    public class ResponseWrapper
    {
        @AuraEnabled public Integer statusCode  { get;set;}
        @AuraEnabled public String returnResult { get;set;}
        @AuraEnabled public String errorMessage { get;set;}
        @AuraEnabled public String req { get;set;}
        @AuraEnabled public List < Object > ordersList { get;set;}
    }
    @AuraEnabled 
    public static List<serviceFLow_Track_Trace_Activities__c> addComments (String recordId, String orderNumber, String comments){
        List<serviceFLow_Track_Trace_Activities__c> listOfActivities = new List<serviceFLow_Track_Trace_Activities__c>();
        serviceFLow_Track_Trace_Activities__c serviceFLow_Track_Trace_ActivitiesRec = new serviceFLow_Track_Trace_Activities__c();
        serviceFLow_Track_Trace_ActivitiesRec.Name = orderNumber;                
        serviceFLow_Track_Trace_ActivitiesRec.Hoya_Account_ID__c = recordId;
        serviceFLow_Track_Trace_ActivitiesRec.serviceFlow_Order_ID__c = orderNumber;
        serviceFLow_Track_Trace_ActivitiesRec.Comments__c = '<p><br></p><p><br></p><b>('+System.Now()+') '+UserInfo.getFirstName()+'</b><p><br></p>'+comments; 
        listOfActivities.add(serviceFLow_Track_Trace_ActivitiesRec);
        if(listOfActivities.size() > 0){
            upsert listOfActivities serviceFlow_Order_ID__c;
        }
        return listOfActivities;
    }
    @AuraEnabled 
    public static List<serviceFLow_Track_Trace_Activities__c> addCommentsUtility (String recordId, String orderNumber, String comments){
        List<serviceFLow_Track_Trace_Activities__c> listOfActivities = new List<serviceFLow_Track_Trace_Activities__c>();
        serviceFLow_Track_Trace_Activities__c serviceFLow_Track_Trace_ActivitiesRec = new serviceFLow_Track_Trace_Activities__c();
        serviceFLow_Track_Trace_ActivitiesRec.Name = orderNumber;                
        serviceFLow_Track_Trace_ActivitiesRec.Hoya_Account_ID__c = recordId;
        serviceFLow_Track_Trace_ActivitiesRec.serviceFlow_Order_ID__c = orderNumber;
        serviceFLow_Track_Trace_ActivitiesRec.Comments__c = '<p><br></p><p><br></p><b>('+System.Now()+') '+UserInfo.getFirstName()+'</b><p><br></p>'+comments; 
        listOfActivities.add(serviceFLow_Track_Trace_ActivitiesRec);
        if(listOfActivities.size() > 0){
            upsert listOfActivities serviceFlow_Order_ID__c;
        }
        return listOfActivities;
    }
    
}