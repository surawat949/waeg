@RestResource(urlMapping = '/getAccountsByPhone')
global with sharing class WS_getAccountsByPhone {
    
    @HttpPost
    global static void getAccountsByPhone(){
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');

        if (RestContext.request.requestBody == null) {
            res.responseBody = Blob.valueOf('Request Body is empty.');
            res.statusCode = 400;
            return;
        }

        String body = RestContext.request.requestBody.toString();
        JSONinParameter j;
        try{
            j = (JSONinParameter) JSON.deserialize(body, JSONinParameter.class);
        } catch (Exception e) {
            res.responseBody = Blob.valueOf(e.getMessage());
            res.statusCode = 500;
            system.debug('res 2 - fail of json deserialize: '+res);
            return;
        }

        if(j.customerPhone==null || j.customerPhone=='' || j.inboundPhone==null || j.inboundPhone==''){
            res.responseBody = Blob.valueOf('customer phone is empty!');
            res.statusCode = 400;
            return;
        }

        List<String> seikoInbound = new List<String>{'0472473460', '0472473579'};
        List<String> hoyaInbound = new List<String>{'0232508787', '0160377186', '0160377183', '0160377188', '0160377187'};

        System.debug('inbound phone=' + j.inboundPhone);

		boolean isHoya = hoyaInbound.contains(j.inboundPhone);
		boolean isSeiko = seikoInbound.contains(j.inboundPhone);

        List<JSONAccount> accountList = new List<JSONAccount>();
        try {
            if(isHoya){
                for(Account a : Database.query('select id, name, shippingPostalCode, CHINTERNATIONALGROUP__c from Account where phone=\''+j.customerPhone+'\' and (Hoya_Account_ID__c like \'FR03%\' or Hoya_Account_ID__c like \'FR0%\')')){
                    String departement = a.ShippingPostalCode.substring(0, 2);
                    accountList.add(new JSONAccount(a.Name, departement,a.CHINTERNATIONALGROUP__c, a.Id));
                }
                
                if(accountList.isEmpty()){
                    //lets try by contact
                    for(Contact c : Database.query('select AccountId, Account.name, Account.shippingPostalCode, Account.CHINTERNATIONALGROUP__c from Contact where phone=\''+j.customerPhone+'\' and Account.Hoya_Account_ID__c like \'FR0%\' limit 1')){
                        String departement = c.account.ShippingPostalCode.substring(0, 2);
                        accountList.add(new JSONAccount(c.account.Name, departement,c.account.CHINTERNATIONALGROUP__c, c.account.Id));
                    }
                }
            } else if(isSeiko){
                for(Account a : Database.query('select id, name, shippingPostalCode, CHINTERNATIONALGROUP__c from Account where phone=\''+j.customerPhone+'\' and Hoya_Account_ID__c like \'SO33%\'')){
                    String departement = a.ShippingPostalCode.substring(0, 2);
                    accountList.add(new JSONAccount(a.Name, departement,a.CHINTERNATIONALGROUP__c, a.Id));
                }
                if(accountList.isEmpty()){
                    //lets try by contact
                    for(Contact c : Database.query('select AccountId, Account.name, Account.shippingPostalCode, Account.CHINTERNATIONALGROUP__c from Contact where phone=\''+j.customerPhone+'\' and Account.Hoya_Account_ID__c like \'SO33%\' limit 1')){
                        String departement = c.account.ShippingPostalCode.substring(0, 2);
                        accountList.add(new JSONAccount(c.account.Name, departement,c.account.CHINTERNATIONALGROUP__c, c.account.Id));
                    }
                }
            }
            System.debug(JSON.serialize(accountList));
            res.responseBody = Blob.valueOf(JSON.serialize(accountList));
            res.statusCode = 200;
            return;
        } catch (Exception e) {
            res.responseBody = Blob.valueOf(e.getMessage());
            res.statusCode = 500;
            return;
        }
    }

    private class JSONinParameter{
        String inboundPhone {get;set;}
        String customerPhone {get;set;}
    }

    private class JSONAccount {

        public JSONAccount(String name, String departement, Decimal classification, Id sfdcId){
            this.name = name.replace('|', '_');
            this.departement = departement;
            this.classification = classification;
            this.sfdcId = sfdcId;
        }

        String name {get;set;}
        String departement {get;set;}
        Decimal classification {get;set;}
        Id sfdcId {get;set;}
    }
}