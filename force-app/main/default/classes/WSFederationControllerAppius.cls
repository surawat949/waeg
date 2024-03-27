public with sharing class WSFederationControllerAppius {

    public String errorMessage {get;set;}
    private User u;
    private WS_Federation_Realm__c realm;
    public String wctx {get;set;}
    public String previousRealm {get;set;}
    private String action;
    private String preCannonicalizedAssertion_old = '<saml2:Assertion ID="ASSERTION_ID" IssueInstant="CURRENTDATETIME" Version="2.0" xmlns:saml2="urn:oasis:names:tc:SAML:2.0:assertion" xmlns:xs="http://www.w3.org/2001/XMLSchema"><saml2:Issuer Format="urn:oasis:names:tc:SAML:2.0:nameid-format:entity">ISSUER</saml2:Issuer><saml2:Subject><saml2:NameID Format="urn:oasis:names:tc:SAML:1.1:nameid-format:unspecified">USERNAME</saml2:NameID><saml2:SubjectConfirmation Method="urn:oasis:names:tc:SAML:2.0:cm:bearer"><saml2:SubjectConfirmationData NotOnOrAfter="NOTAFTERDATETIME"/></saml2:SubjectConfirmation></saml2:Subject><saml2:Conditions NotBefore="NOTBEFOREDATETIME" NotOnOrAfter="NOTAFTERDATETIME"><saml2:AudienceRestriction><saml2:Audience>APPLICATIONURL</saml2:Audience></saml2:AudienceRestriction></saml2:Conditions><saml2:AuthnStatement AuthnInstant="CURRENTDATETIME"><saml2:AuthnContext><saml2:AuthnContextClassRef>urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport</saml2:AuthnContextClassRef></saml2:AuthnContext></saml2:AuthnStatement><saml2:AttributeStatement><saml2:Attribute Name="http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name" NameFormat="urn:oasis:names:tc:SAML:2.0:attrname-format:unspecified"><saml2:AttributeValue xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="xs:string">gary@appius.com</saml2:AttributeValue><saml2:AttributeValue xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="xs:string">Another Name Claim 1</saml2:AttributeValue><saml2:AttributeValue xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="xs:string">Another Name Claim 2</saml2:AttributeValue></saml2:Attribute><saml2:Attribute Name="http://schemas.microsoft.com/ws/2008/06/identity/claims/role" NameFormat="urn:oasis:names:tc:SAML:2.0:attrname-format:unspecified"><saml2:AttributeValue xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="xs:string">Everyone</saml2:AttributeValue><saml2:AttributeValue xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="xs:string">Is CMS User</saml2:AttributeValue><saml2:AttributeValue xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="xs:string">Is Trade Portal System Administrator</saml2:AttributeValue><saml2:AttributeValue xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="xs:string">Another Role Claim 1</saml2:AttributeValue><saml2:AttributeValue xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="xs:string">Another Role Claim 2</saml2:AttributeValue><saml2:AttributeValue xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="xs:string">Another Role Claim 3</saml2:AttributeValue></saml2:Attribute></saml2:AttributeStatement></saml2:Assertion>';
    private String preCannonicalizedSignedInfo_old = '<ds:SignedInfo><ds:CanonicalizationMethod Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"/><ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1"/><ds:Reference URI="#ASSERTION_ID"><ds:Transforms><ds:Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature"/><ds:Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"><ec:InclusiveNamespaces PrefixList="xs" xmlns:ec="http://www.w3.org/2001/10/xml-exc-c14n#"/></ds:Transform></ds:Transforms><ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"/><ds:DigestValue>DIGESTVALUE</ds:DigestValue></ds:Reference></ds:SignedInfo>';
    private String preCannonicalizedAssertion = '<saml2:Assertion xmlns:saml2="urn:oasis:names:tc:SAML:2.0:assertion" xmlns:xs="http://www.w3.org/2001/XMLSchema" ID="ASSERTION_ID" IssueInstant="CURRENTDATETIME" Version="2.0"><saml2:Issuer Format="urn:oasis:names:tc:SAML:2.0:nameid-format:entity">ISSUER</saml2:Issuer><saml2:Subject><saml2:NameID Format="urn:oasis:names:tc:SAML:1.1:nameid-format:unspecified">USERNAME</saml2:NameID><saml2:SubjectConfirmation Method="urn:oasis:names:tc:SAML:2.0:cm:bearer"><saml2:SubjectConfirmationData NotOnOrAfter="NOTAFTERDATETIME"></saml2:SubjectConfirmationData></saml2:SubjectConfirmation></saml2:Subject><saml2:Conditions NotBefore="NOTBEFOREDATETIME" NotOnOrAfter="NOTAFTERDATETIME"><saml2:AudienceRestriction><saml2:Audience>APPLICATIONURL</saml2:Audience></saml2:AudienceRestriction></saml2:Conditions><saml2:AuthnStatement AuthnInstant="CURRENTDATETIME"><saml2:AuthnContext><saml2:AuthnContextClassRef>urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport</saml2:AuthnContextClassRef></saml2:AuthnContext></saml2:AuthnStatement><saml2:AttributeStatement><saml2:Attribute Name="http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name" NameFormat="urn:oasis:names:tc:SAML:2.0:attrname-format:unspecified"><saml2:AttributeValue xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="xs:string">gary@appius.com</saml2:AttributeValue><saml2:AttributeValue xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="xs:string">Another Name Claim 1</saml2:AttributeValue><saml2:AttributeValue xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="xs:string">Another Name Claim 2</saml2:AttributeValue></saml2:Attribute><saml2:Attribute Name="http://schemas.microsoft.com/ws/2008/06/identity/claims/role" NameFormat="urn:oasis:names:tc:SAML:2.0:attrname-format:unspecified"><saml2:AttributeValue xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="xs:string">Everyone</saml2:AttributeValue><saml2:AttributeValue xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="xs:string">Is CMS User</saml2:AttributeValue><saml2:AttributeValue xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="xs:string">Is Trade Portal System Administrator</saml2:AttributeValue><saml2:AttributeValue xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="xs:string">Another Role Claim 1</saml2:AttributeValue><saml2:AttributeValue xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="xs:string">Another Role Claim 2</saml2:AttributeValue><saml2:AttributeValue xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="xs:string">Another Role Claim 3</saml2:AttributeValue></saml2:Attribute></saml2:AttributeStatement></saml2:Assertion>';
    private String preCannonicalizedSignedInfo = '<ds:SignedInfo><ds:CanonicalizationMethod Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"></ds:CanonicalizationMethod><ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1"></ds:SignatureMethod><ds:Reference URI="#ASSERTION_ID"><ds:Transforms><ds:Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature"></ds:Transform><ds:Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"><ec:InclusiveNamespaces xmlns:ec="http://www.w3.org/2001/10/xml-exc-c14n#" PrefixList="xs"></ec:InclusiveNamespaces></ds:Transform></ds:Transforms><ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"></ds:DigestMethod><ds:DigestValue>DIGESTVALUE</ds:DigestValue></ds:Reference></ds:SignedInfo>';
    private String signatureBlock = '</saml2:Issuer><ds:Signature xmlns:ds="http://www.w3.org/2000/09/xmldsig#">SIGNED_INFO<ds:SignatureValue>SIGNATUREVALUE</ds:SignatureValue><ds:KeyInfo><ds:X509Data><ds:X509Certificate>CERTIFICATE</ds:X509Certificate></ds:X509Data></ds:KeyInfo></ds:Signature>';
    private String rstrStart = '<?xml version="1.0" encoding="UTF-8"?><wst:RequestSecurityTokenResponse xmlns:wst="http://docs.oasis-open.org/ws-sx/ws-trust/200512"><wst:Lifetime><wst:Created xmlns:wst="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">DATECREATED</wst:Created><wst:Expires xmlns:wst="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">EXPIREYDATE</wst:Expires></wst:Lifetime><wst:TokenType>urn:oasis:names:tc:SAML:2.0:assertion</wst:TokenType><wst:RequestType>http://docs.oasis-open.org/ws-sx/ws-trust/200512/Issue</wst:RequestType><wst:KeyType>http://docs.oasis-open.org/ws-sx/ws-trust/200512/Bearer</wst:KeyType><wst:RequestedSecurityToken>';
    private String rstrEnd = '</wst:RequestedSecurityToken></wst:RequestSecurityTokenResponse>';
    
    public WSFederationControllerAppius() {
      
        u = [select id, Username, FederationIdentifier from User where id = :Userinfo.getUserId()]; 
        if ( u.FederationIdentifier == null ) {
            errorMessage = 'User does not have a valid FederationID';
        } else {
            String wtrealm = ApexPages.currentPage().getParameters().get('wtrealm');
            system.debug('wtrealm: '+wtrealm);
            realm = [select name,Previous_Realm__c, Realm__c, Audience__c, Action__c, Issuer__c, ValidityPeriod__c, EncodedPrivateKey__c, Certificate__c, Modulus__c, Exponent__c from WS_Federation_Realm__c where Realm__c = :wtrealm];
            
            system.debug('wtrealm: '+ wtrealm);
            wctx = ApexPages.currentPage().getParameters().get('wctx');
            previousRealm = ApexPages.currentPage().getParameters().get('previousRealm');
            action = realm.action__c;
        }
        
    }
    
    public String getContext(){
        return wctx;
    }
    
    public String getAction() {
        return action;
    }
    
    public String getPreviousRealm() {
        return realm.Previous_Realm__c;
    }
    
    public String getResult(){
        
        datetime nowDt = datetime.now();
        Long nowLong = nowDt.getTime();
        datetime notBeforeDt = datetime.newInstance(nowLong - 120000);
        String notBefore = notBeforeDt.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss') + 'Z';
        Integer validFor = 60;
        if (realm.ValidityPeriod__c != null ) validFor = Integer.valueOf(realm.ValidityPeriod__c);
        datetime notOnOrAfterDt = nowDt.addMinutes(validFor);
        String notOnOrAfter = notOnOrAfterDt.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss') + 'Z';


        //Prepare the Assertion
        Double random = Math.random();
        String assertionId = EncodingUtil.convertToHex(Crypto.generateDigest('SHA1',  Blob.valueOf('assertion' + random)));
        //String assertionId = '574785689435894897649';
        //String assertionId = EncodingUtil.convertToHex(Crypto.generateDigest('SHA1',  Blob.valueOf('574785689435894897649')));
        system.debug(assertionId);
        preCannonicalizedAssertion = preCannonicalizedAssertion.replaceAll('ASSERTION_ID',assertionId);
        preCannonicalizedAssertion = preCannonicalizedAssertion.replaceAll('ISSUER',realm.issuer__c);
		if (realm.audience__c != null)
        	preCannonicalizedAssertion = preCannonicalizedAssertion.replaceAll('APPLICATIONURL',realm.audience__c);//+realm.Previous_Realm__c);
		else 
    		preCannonicalizedAssertion = preCannonicalizedAssertion.replaceAll('APPLICATIONURL',realm.realm__c);//+realm.Previous_Realm__c);
        preCannonicalizedAssertion = preCannonicalizedAssertion.replaceAll('USERNAME',u.federationidentifier);  
        preCannonicalizedAssertion = preCannonicalizedAssertion.replaceAll('CURRENTDATETIME',notBefore);
        preCannonicalizedAssertion = preCannonicalizedAssertion.replaceAll('NOTBEFOREDATETIME',notBefore);
        preCannonicalizedAssertion = preCannonicalizedAssertion.replaceAll('NOTAFTERDATETIME',notOnOrAfter);
        //BP
        //preCannonicalizedAssertion = preCannonicalizedAssertion.replaceAll('PREVIOUSREALM',realm.Previous_Realm__c);
        rstrStart = rstrStart.replaceAll('EXPIREYDATE',notOnOrAfter);
        rstrStart = rstrStart.replaceAll('NOTAFTERDATETIME',notOnOrAfter);
        rstrStart = rstrStart.replaceAll('DATECREATED',notBefore);
        
        //Prepare the Digest
        Blob digest = Crypto.generateDigest('SHA1',  Blob.valueOf(preCannonicalizedAssertion));
        String digestString = EncodingUtil.base64Encode(digest);
        system.debug(digestString);
        
        //Prepare the SignedInfo
        preCannonicalizedSignedInfo = preCannonicalizedSignedInfo.replaceAll('ASSERTION_ID',assertionId);
        preCannonicalizedSignedInfo = preCannonicalizedSignedInfo.replaceAll('DIGESTVALUE',digestString);

        //Sign the SignedInfo
        Blob privateKey = EncodingUtil.base64Decode(realm.encodedPrivateKey__c);
        Blob input = Blob.valueOf(preCannonicalizedSignedInfo);
        Blob signature = Crypto.sign('RSA-SHA1', input, privateKey);
        String signatureString = EncodingUtil.base64Encode(signature);

        //Prepare the signature block
        signatureBlock = signatureBlock.replaceAll('SIGNED_INFO',preCannonicalizedSignedInfo);
        signatureBlock = signatureBlock.replaceAll('SIGNATUREVALUE',signatureString);
        signatureBlock = signatureBlock.replaceAll('CERTIFICATE',realm.certificate__c);
        signatureBlock = signatureBlock.replaceAll('MODULUS',realm.modulus__c);
        signatureBlock = signatureBlock.replaceAll('EXPONENT',realm.exponent__c);
        system.debug(signatureBlock);


        //Enveloping the signature by inserting it after the Issuer
        preCannonicalizedAssertion = preCannonicalizedAssertion.replaceAll('</saml2:Issuer>', signatureBlock );
        
        string rsp = rstrStart + preCannonicalizedAssertion + rstrEnd;
        system.debug('response: '+ rsp);
        return rsp;
    }
}