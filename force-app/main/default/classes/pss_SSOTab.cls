public with sharing class pss_SSOTab {

   
    public String URL       { get; set; }
    public String fn        { get; set; }
    public String ln        { get; set; }
    public String user      { get; set; }
    public String email     { get; set; }
    public String token     { get; set; }
    public String timestamp   { get; set; }
    
    public static final String DIGEST_ALGO = 'SHA-512';
    public static final String SALT = 'P4radi50!'; //'T35t1ng54lt';
    public static final String SSOUrl = pss_moodle_settings__c.getInstance().LMS_URL__c;    
    
    public pss_SSOTab() {
        
        /*
        Datetime myDT = Datetime.now();
        String unixTime = ''+myDT.getTime()/1000;
        String inputString = unixTime+UserInfo.getUserName()+UserInfo.getUserEmail()+SALT;
        String md5Coded = EncodingUtil.convertToHex(Crypto.generateDigest(DIGEST_ALGO, Blob.valueOf(inputString)));
        //String md5Coded = EncodingUtil.convertToHex(Crypto.generateMac('hmacMD5', Blob.valueOf(inputString),Blob.valueOf('T35t1ng54lt')));
        
        long timeStamp = System.currentTimeMillis()/1000;
        //string token = EncodingUtil.convertToHex(generateToken());
        String token =EncodingUtil.urlEncode(md5Coded, 'UTF-8');
        //URL=Label.pssMoodle_SSO_URL +'?timestamp='+ timeStamp +'&name='+ EncodingUtil.urlEncode(student.name, CHARSET) +'&username='+ EncodingUtil.urlEncode(student.username, CHARSET) +'&email='+ EncodingUtil.urlEncode(student.email, CHARSET) +'&lastname='+ EncodingUtil.urlEncode(student.lastname, CHARSET) +'&city=&token=' + token;
        URL=SSOUrl+'?user='+UserInfo.getUserName()+'&token=' + token + '&timestamp='+ unixTime +'&email='+ EncodingUtil.urlEncode(UserInfo.getUserEmail(),'UTF-8') + '&fn='+EncodingUtil.urlEncode(UserInfo.getFirstName(),'UTF-8')+'&city=CA&country=US&ln='+EncodingUtil.urlEncode(UserInfo.getFirstName(),'UTF-8');
        system.debug('URL:::::'+URL);
        */        
        
        Datetime myDT = Datetime.now();
        String unixTime = ''+myDT.getTime()/1000;
        //long timeStamp = System.currentTimeMillis()/1000;
        
        token =EncodingUtil.urlEncode(SALT, 'UTF-8');
        fn = EncodingUtil.urlEncode(UserInfo.getFirstName(), 'UTF-8');
        user = EncodingUtil.urlEncode(UserInfo.getUserName(), 'UTF-8');
        email = EncodingUtil.urlEncode(UserInfo.getUserEmail(), 'UTF-8');
        ln = EncodingUtil.urlEncode(UserInfo.getLastName(), 'UTF-8');
        token =SALT;
        fn = UserInfo.getFirstName();
        user = UserInfo.getUserName();
        email = UserInfo.getUserEmail();
        ln = UserInfo.getLastName();

        timestamp = String.valueOf(System.currentTimeMillis()/1000);
        URL=SSOUrl+'/auth/token/client.php' +'?timestamp='+ timeStamp +'&fn='+ EncodingUtil.urlEncode(UserInfo.getFirstName(), 'UTF-8') +'&user='+ EncodingUtil.urlEncode(UserInfo.getUserName(), 'UTF-8') +'&email='+ EncodingUtil.urlEncode(UserInfo.getUserEmail(), 'UTF-8') +'&ln='+ EncodingUtil.urlEncode(UserInfo.getLastName(), 'UTF-8') +'&city=&token=' + token;
        URL=SSOUrl+'/auth/token/client.php';
       
       // URL=SSOUrl+'/local/plms_rest/client.php' +'?timestamp='+ timeStamp +'&fn='+ EncodingUtil.urlEncode(UserInfo.getFirstName(), 'UTF-8') +'&user='+ EncodingUtil.urlEncode(UserInfo.getUserName(), 'UTF-8') +'&email='+ EncodingUtil.urlEncode(UserInfo.getUserEmail(), 'UTF-8') +'&ln='+ EncodingUtil.urlEncode(UserInfo.getLastName(), 'UTF-8') +'&city=&token=' + token;
       // URL=SSOUrl+'/local/plms_rest/client.php';
        
        system.debug('URL:::::'+URL);        
        
    }

   
    /*
    private Blob generateToken(){
        Datetime myDT = Datetime.now();
        String unixTime = ''+myDT.getTime()/1000;
        long timeStamp = System.currentTimeMillis()/1000;
        Blob data = crypto.generateMac(DIGEST_ALGO, Blob.valueOf(SALT), Blob.valueOf(timeStamp + student.username + student.Email));
        return data;
    }
*/

   
    
}