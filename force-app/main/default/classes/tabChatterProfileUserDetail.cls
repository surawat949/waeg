public class tabChatterProfileUserDetail {
   @AuraEnabled(cacheable=true)
   public static Boolean  getUserDetail(){
       Boolean showAllTab;
       User uObj = [Select id,Profile.UserLicense.Name from User where Id=: UserInfo.getUserId()]; 
       system.debug(uObj);
       if(uObj.Profile.UserLicense.Name != 'Chatter Only'){
           showAllTab=true;
       }
       return showAllTab;
    }
}