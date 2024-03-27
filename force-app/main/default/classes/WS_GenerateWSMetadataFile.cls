@RestResource(urlMapping = '/GenerateWSMetadataFile')
global without sharing class WS_GenerateWSMetadataFile {

    @HttpGet
    global static void generateMetadata() {
        String startStr = '<?xml version="1.0" encoding="UTF-8" standalone="no"?>';
        String output_xml = '<md:EntityDescriptor xmlns:md="urn:oasis:names:tc:SAML:2.0:metadata" xmlns="http://www.w3.org/2000/09/xmldsig#" ID="574785689435894897649" entityID="ISSUER"><md:RoleDescriptor xmlns:fed="http://docs.oasis-open.org/wsfed/federation/200706" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="fed:SecurityTokenServiceType" protocolSupportEnumeration="http://docs.oasis-open.org/ws-sx/ws-trust/200512"><md:KeyDescriptor use="signing"><KeyInfo xmlns="http://www.w3.org/2000/09/xmldsig#"><X509Data><X509Certificate>CERTIFICATE</X509Certificate></X509Data></KeyInfo></md:KeyDescriptor><fed:TokenTypesOffered><fed:TokenType Uri="urn:oasis:names:tc:SAML:2.0:assertion"/></fed:TokenTypesOffered><fed:PassiveRequestorEndpoint><EndpointReference xmlns="http://www.w3.org/2005/08/addressing"><Address>ISSUER</Address></EndpointReference></fed:PassiveRequestorEndpoint></md:RoleDescriptor></md:EntityDescriptor>';
        //String xml = '<md:EntityDescriptor xmlns="http://www.w3.org/2000/09/xmldsig#" xmlns:md="urn:oasis:names:tc:SAML:2.0:metadata" entityID="ISSUER" ID="574785689435894897649"><md:RoleDescriptor xmlns:fed="http://docs.oasis-open.org/wsfed/federation/200706" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="fed:SecurityTokenServiceType" protocolSupportEnumeration="http://docs.oasis-open.org/ws-sx/ws-trust/200512"><md:KeyDescriptor use="signing"><KeyInfo><X509Data><X509Certificate>CERTIFICATE</X509Certificate></X509Data></KeyInfo></md:KeyDescriptor><fed:TokenTypesOffered><fed:TokenType Uri="urn:oasis:names:tc:SAML:2.0:assertion"></fed:TokenType></fed:TokenTypesOffered><fed:PassiveRequestorEndpoint><EndpointReference xmlns="http://www.w3.org/2005/08/addressing"><Address>ISSUER</Address></EndpointReference></fed:PassiveRequestorEndpoint></md:RoleDescriptor></md:EntityDescriptor>';
        String xml ='<md:EntityDescriptor xmlns:md="urn:oasis:names:tc:SAML:2.0:metadata" ID="574785689435894897649" entityID="ISSUER"><md:RoleDescriptor xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" protocolSupportEnumeration="http://docs.oasis-open.org/ws-sx/ws-trust/200512" xsi:type="fed:SecurityTokenServiceType"><md:KeyDescriptor use="signing"><KeyInfo xmlns="http://www.w3.org/2000/09/xmldsig#"><X509Data><X509Certificate>CERTIFICATE</X509Certificate></X509Data></KeyInfo></md:KeyDescriptor><fed:TokenTypesOffered xmlns:fed="http://docs.oasis-open.org/wsfed/federation/200706"><fed:TokenType Uri="urn:oasis:names:tc:SAML:2.0:assertion"></fed:TokenType></fed:TokenTypesOffered><fed:PassiveRequestorEndpoint xmlns:fed="http://docs.oasis-open.org/wsfed/federation/200706"><EndpointReference xmlns="http://www.w3.org/2005/08/addressing"><Address>ISSUER</Address></EndpointReference></fed:PassiveRequestorEndpoint></md:RoleDescriptor></md:EntityDescriptor>';
        //String preCannonicalizedSignedInfo = '<SignedInfo><CanonicalizationMethod Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"/><SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1"/><Reference URI="#574785689435894897649"><Transforms><Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature"/><Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"/></Transforms><DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"/><DigestValue>DIGESTVALUE</DigestValue></Reference></SignedInfo>';
        String preCannonicalizedSignedInfo = '<SignedInfo xmlns="http://www.w3.org/2000/09/xmldsig#"><CanonicalizationMethod Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"></CanonicalizationMethod><SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1"></SignatureMethod><Reference URI="#574785689435894897649"><Transforms><Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature"></Transform><Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"></Transform></Transforms><DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"></DigestMethod><DigestValue>DIGESTVALUE</DigestValue></Reference></SignedInfo>';
        String signatureBlock = '<Signature xmlns="http://www.w3.org/2000/09/xmldsig#">SIGNED_INFO<SignatureValue>SIGNATURE_VALUE</SignatureValue><KeyInfo><X509Data><X509Certificate>CERTIFICATE</X509Certificate></X509Data><KeyValue><RSAKeyValue><Modulus>MODULUS</Modulus><Exponent>EXPONENT</Exponent></RSAKeyValue></KeyValue></KeyInfo></Signature></md:EntityDescriptor>';
        
        RestResponse res = RestContext.response;
        SYSTEM.DEBUG(res);

        WS_Federation_Realm__c realm;
        try {
            realm = [SELECT name, Realm__c, Audience__c, Action__c, Issuer__c, ValidityPeriod__c, EncodedPrivateKey__c, Certificate__c, Modulus__c, Exponent__c 
                        FROM WS_Federation_Realm__c 
                        WHERE Realm__c LIKE '%hoya%' 
                        ORDER BY lastmodifieddate desc 
                        LIMIT 1];
        } catch (Exception e) {
            if (e.getMessage().contains('List has no rows for assignment to SObject')) {
                res.responseBody = Blob.valueOf('No realm was found. Please contact the salesforce administrator.');
            } else {
                res.responseBody = Blob.valueOf(e.getMessage());
            }
            res.statusCode = 500;
            return;
        }
        
        xml = xml.replace('CERTIFICATE', realm.Certificate__c);
        xml = xml.replace('ISSUER', realm.Issuer__c);
        //Prepare the Digest
        Blob digest = Crypto.generateDigest('SHA1',  Blob.valueOf(xml));
        String digestString = EncodingUtil.base64Encode(digest);
        preCannonicalizedSignedInfo = preCannonicalizedSignedInfo.replace('DIGESTVALUE', digestString);
        
        //Sign the SignedInfo
        Blob privateKey = EncodingUtil.base64Decode(realm.encodedPrivateKey__c);
        Blob input = Blob.valueOf(preCannonicalizedSignedInfo);
        Blob signature = Crypto.sign('RSA-SHA1', input, privateKey);
        String signatureString = EncodingUtil.base64Encode(signature);

        //Prepare the signature block
        signatureBlock = signatureBlock.replaceAll('SIGNED_INFO',preCannonicalizedSignedInfo);
        signatureBlock = signatureBlock.replaceAll('SIGNATURE_VALUE',signatureString);
        signatureBlock = signatureBlock.replaceAll('CERTIFICATE',realm.certificate__c);
        signatureBlock = signatureBlock.replaceAll('MODULUS',realm.modulus__c);
        signatureBlock = signatureBlock.replaceAll('EXPONENT',realm.exponent__c);
        /*
            Tests BEGIN
        */
        xml = output_xml;
        xml = xml.replace('CERTIFICATE', realm.Certificate__c);
        xml = xml.replace('ISSUER', realm.Issuer__c);
        /*
            Tests END
        */
        xml = xml.replace('</md:EntityDescriptor>', signatureBlock);

        res.addHeader('Content-Type', 'text/xml');
        String response = startStr + xml;
        res.responseBody = Blob.valueOf(response);
        res.statusCode = 200;
    }

}