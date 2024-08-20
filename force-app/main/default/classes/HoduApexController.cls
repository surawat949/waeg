global class HoduApexController {
webService static String hoduGetUserInfo() {
User u = [select Id, username,email from User where Id =
:UserInfo.getUserId()];
return JSON.serialize(u);
}
}