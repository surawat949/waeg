public class WSFederationController {

    // Two test classes for this class: WSFederationControllerTest,WS_CreateUserFromPortal_Test
    public String errorMessage {
        get;
        set;
    }
    private User u;
    private WS_Federation_Realm__c realm;
    public String wctx {
        get;
        set;
    }
    private String action;
    private String preCannonicalizedAssertion = '<saml:Assertion xmlns:saml="urn:oasis:names:tc:SAML:1.0:assertion" AssertionID="_ASSERTION_ID" IssueInstant="NOT_BEFORE" Issuer="ISSUER" MajorVersion="1" MinorVersion="1"><saml:Conditions NotBefore="NOT_BEFORE" NotOnOrAfter="NOT_ON_OR_AFTER"><saml:AudienceRestrictionCondition><saml:Audience>AUDIENCE</saml:Audience></saml:AudienceRestrictionCondition></saml:Conditions><saml:AuthenticationStatement AuthenticationInstant="NOT_BEFORE" AuthenticationMethod="urn:oasis:names:tc:SAML:1.0:am:unspecified"><saml:Subject><saml:NameIdentifier Format="urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress">SUBJECT</saml:NameIdentifier></saml:Subject></saml:AuthenticationStatement><saml:AttributeStatement><saml:Subject><saml:NameIdentifier Format="urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress">SUBJECT</saml:NameIdentifier></saml:Subject><saml:Attribute AttributeName="name" AttributeNamespace="http://schemas.xmlsoap.org/ws/2005/05/identity/claims/"><saml:AttributeValue>THENAME</saml:AttributeValue></saml:Attribute><saml:Attribute AttributeName="EmailAddress" AttributeNamespace="http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name"><saml:AttributeValue>EMAILADD</saml:AttributeValue></saml:Attribute></saml:AttributeStatement></saml:Assertion>';
    private String preCannonicalizedSignedInfo = '<ds:SignedInfo xmlns:ds="http://www.w3.org/2000/09/xmldsig#"><ds:CanonicalizationMethod Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"></ds:CanonicalizationMethod><ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1"></ds:SignatureMethod><ds:Reference URI="#_ASSERTION_ID"><ds:Transforms><ds:Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature"></ds:Transform><ds:Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"></ds:Transform></ds:Transforms><ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"></ds:DigestMethod><ds:DigestValue>DIGEST</ds:DigestValue></ds:Reference></ds:SignedInfo>';
    private String signatureBlock = '<ds:Signature xmlns:ds="http://www.w3.org/2000/09/xmldsig#">SIGNED_INFO<ds:SignatureValue>SIGNATURE_VALUE</ds:SignatureValue><ds:KeyInfo><ds:X509Data><ds:X509Certificate>CERTIFICATE</ds:X509Certificate></ds:X509Data><ds:KeyValue><ds:RSAKeyValue><ds:Modulus>MODULUS</ds:Modulus><ds:Exponent>EXPONENT</ds:Exponent></ds:RSAKeyValue></ds:KeyValue></ds:KeyInfo></ds:Signature></saml:Assertion>';
    private String rstrStart = '<wst:RequestSecurityTokenResponse xmlns:wst="http://schemas.xmlsoap.org/ws/2005/02/trust"><wst:RequestedSecurityToken>';
    private String rstrEnd = '</wst:RequestedSecurityToken><wsp:AppliesTo xmlns:wsp="http://schemas.xmlsoap.org/ws/2004/09/policy"><wsa:EndpointReference xmlns:wsa="http://schemas.xmlsoap.org/ws/2004/08/addressing"><wsa:Address>AUDIENCE</wsa:Address></wsa:EndpointReference></wsp:AppliesTo></wst:RequestSecurityTokenResponse>';
    private String roleClaim = '<saml:Attribute AttributeName="THEATTRIBUTENAME" AttributeNamespace="http://schemas.microsoft.com/ws/2008/06/identity/claims/role"><saml:AttributeValue>true</saml:AttributeValue></saml:Attribute></saml:AttributeStatement>';
    private String portalUserNameClaims = '<saml:Attribute AttributeName="PreferredLanguage" AttributeNamespace="http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name"><saml:AttributeValue>THELANGUAGE</saml:AttributeValue></saml:Attribute><saml:Attribute AttributeName="Timezone" AttributeNamespace="http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name"><saml:AttributeValue>THETIMEZONE</saml:AttributeValue></saml:Attribute><saml:Attribute AttributeName="ContactId" AttributeNamespace="http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name"><saml:AttributeValue>THECONTACTID</saml:AttributeValue></saml:Attribute><saml:Attribute AttributeName="Portal" AttributeNamespace="http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name"><saml:AttributeValue>THEPORTAL</saml:AttributeValue></saml:Attribute></saml:AttributeStatement>';

    public WSFederationController() {

        //u = [select id, Name, Username, FederationIdentifier, Email, (SELECT Id FROM Contact__r LIMIT 1) from User where id = :Userinfo.getUserId()]; 
        u = [SELECT Id, Name, Username, FederationIdentifier, Email, ContactId, Contact.Account_Time_Zone__c, Contact.Account_Language__c, Contact.Account_Portal__c FROM User WHERE Id =: Userinfo.getUserId()];
        System.debug('+++'+ u.username);
        System.debug('+++2'+ u.federationidentifier);
        System.debug('+++3'+ u.ContactId);
        if (u.FederationIdentifier == null && !Test.isRunningTest()) {
            errorMessage = 'User does not have a valid FederationID';
        } else {
            String wtrealm = ApexPages.currentPage().getParameters().get('wtrealm');
            realm = [select name, Realm__c, Audience__c, Action__c, Issuer__c, ValidityPeriod__c, EncodedPrivateKey__c, Certificate__c, Modulus__c, Exponent__c from WS_Federation_Realm__c where Realm__c =: wtrealm];
            wctx = ApexPages.currentPage().getParameters().get('wctx');

            String param = ApexPages.currentPage().getParameters().get('from');
            if (!String.isBlank(param))
                action = realm.action__c + '?from=' + param;
            else
                action = realm.action__c;
        }
    }

    public String getContext() {
        return wctx;
    }

    public String getAction() {
        return action;
    }



    public String getResult() {
        try {
            System.debug('---' + u.ContactId);
            if (!String.isBlank(u.ContactId)) {
                boolean isCMSUser = false;
                portalUserNameClaims = portalUserNameClaims.replaceAll('THECONTACTID', u.ContactId);
                if (!String.isBlank(u.Contact.Account_Language__c)) {
                    portalUserNameClaims = portalUserNameClaims.replaceAll('THELANGUAGE', u.Contact.Account_Language__c);
                } else {
                    portalUserNameClaims = portalUserNameClaims.replaceAll('THELANGUAGE', '');
                }
                if (!String.isBlank(u.Contact.Account_Portal__c)) {
                    portalUserNameClaims = portalUserNameClaims.replaceAll('THEPORTAL', u.Contact.Account_Portal__c);
                } else {
                    portalUserNameClaims = portalUserNameClaims.replaceAll('THEPORTAL', '');
                }
                if (!String.isBlank(String.valueOf(u.Contact.Account_Time_Zone__c))) {
                    portalUserNameClaims = portalUserNameClaims.replaceAll('THETIMEZONE', String.valueOf(u.Contact.Account_Time_Zone__c));
                } else {
                    portalUserNameClaims = portalUserNameClaims.replaceAll('THETIMEZONE', '');
                }

                //Auth dynamic creation
                List<Assign_default_permissions__mdt> allMetadadata = Assign_default_permissions__mdt.getAll().values();
                Map<String, String> portalCountryMap = new Map<String, String>();
                for (Assign_default_permissions__mdt eachRecord : allMetadadata) {
                    portalCountryMap.put(eachRecord.Account_Portal__c, eachRecord.Authorization_Country_Name__c);
                }
                for (Authorization__c auth: [SELECT Master_Authorization_Name__c, Claim_Formatted__c,Country_Specific_Copy__c FROM Authorization__c WHERE RecordType.DeveloperName = 'Copy'
                        AND Contact__c =: u.ContactId AND Active_Authorization__c = TRUE]) 
                {
                    if (auth.Country_Specific_Copy__c && u.Contact.Account_Portal__c != null) {
                        String[] splits = auth.Claim_Formatted__c.split('-country-');
                        auth.Claim_Formatted__c = splits[0] + portalCountryMap.get(u.Contact.Account_Portal__c) + splits[1];
                    }
                    // we need to add a value to each authorization to mark it as a name claim or a role claim
                    roleClaim = roleClaim.replaceAll('THEATTRIBUTENAME', auth.Claim_Formatted__c);
                    preCannonicalizedAssertion = preCannonicalizedAssertion.replaceAll('</saml:AttributeStatement>', roleClaim);
                    roleClaim = roleClaim.replaceAll(auth.Claim_Formatted__c, 'THEATTRIBUTENAME');
                }
                if (!isCMSUser) {
                    preCannonicalizedAssertion = preCannonicalizedAssertion.replaceAll('</saml:AttributeStatement>', portalUserNameClaims);
                }
            } else {
                errorMessage = 'User does not have a Contact associated.';
            }

            datetime nowDt = datetime.now();
            Long nowLong = nowDt.getTime();
            datetime notBeforeDt = datetime.newInstance(nowLong - 120000);
            String notBefore = notBeforeDt.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss') + 'Z';
            Integer validFor = 60;
            if (realm.ValidityPeriod__c != null) validFor = Integer.valueOf(realm.ValidityPeriod__c);
            datetime notOnOrAfterDt = nowDt.addMinutes(validFor);
            String notOnOrAfter = notOnOrAfterDt.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss') + 'Z';


            //Prepare the Assertion
            Double random = Math.random();
            String assertionId = EncodingUtil.convertToHex(Crypto.generateDigest('SHA1', Blob.valueOf('assertion' + random)));
            preCannonicalizedAssertion = preCannonicalizedAssertion.replaceAll('ASSERTION_ID', assertionId);
            preCannonicalizedAssertion = preCannonicalizedAssertion.replaceAll('ISSUER', realm.issuer__c);
            if (realm.audience__c != null)
                preCannonicalizedAssertion = preCannonicalizedAssertion.replaceAll('AUDIENCE', realm.audience__c);
            else
                preCannonicalizedAssertion = preCannonicalizedAssertion.replaceAll('AUDIENCE', realm.realm__c);
            preCannonicalizedAssertion = preCannonicalizedAssertion.replaceAll('SUBJECT', u.federationidentifier);
            preCannonicalizedAssertion = preCannonicalizedAssertion.replaceAll('EMAILADD', u.Email);
            preCannonicalizedAssertion = preCannonicalizedAssertion.replaceAll('THENAME', u.Name);
            preCannonicalizedAssertion = preCannonicalizedAssertion.replaceAll('NOT_BEFORE', notBefore);
            preCannonicalizedAssertion = preCannonicalizedAssertion.replaceAll('NOT_ON_OR_AFTER', notOnOrAfter);

            //Prepare the Digest
            Blob digest = Crypto.generateDigest('SHA1', Blob.valueOf(preCannonicalizedAssertion));
            String digestString = EncodingUtil.base64Encode(digest);

            //Prepare the SignedInfo
            preCannonicalizedSignedInfo = preCannonicalizedSignedInfo.replaceAll('ASSERTION_ID', assertionId);
            preCannonicalizedSignedInfo = preCannonicalizedSignedInfo.replaceAll('DIGEST', digestString);

            //Sign the SignedInfo
            Blob privateKey = EncodingUtil.base64Decode(realm.encodedPrivateKey__c);
            Blob input = Blob.valueOf(preCannonicalizedSignedInfo);
            Blob signature = Crypto.sign('RSA-SHA1', input, privateKey);
            String signatureString = EncodingUtil.base64Encode(signature);

            //Prepare the signature block
            signatureBlock = signatureBlock.replaceAll('SIGNED_INFO', preCannonicalizedSignedInfo);
            signatureBlock = signatureBlock.replaceAll('SIGNATURE_VALUE', signatureString);
            signatureBlock = signatureBlock.replaceAll('CERTIFICATE', realm.certificate__c);
            signatureBlock = signatureBlock.replaceAll('MODULUS', realm.modulus__c);
            signatureBlock = signatureBlock.replaceAll('EXPONENT', realm.exponent__c);

            //Enveloping the signature by swapping out last element with sig + last elements of whole message
            preCannonicalizedAssertion = preCannonicalizedAssertion.replaceAll('</saml:Assertion>', signatureBlock);

            //return the prefix + our prepped message
            rstrEnd = rstrEnd.replaceAll('AUDIENCE', realm.realm__c);
            return rstrStart + preCannonicalizedAssertion + rstrEnd;
        } catch (Exception e) {
            system.debug(e.getMessage() + ' - ' + e.getLineNumber());
            return e.getMessage();
        }

    }
}