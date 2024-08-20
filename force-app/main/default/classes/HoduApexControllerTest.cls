@isTest
private class HoduApexControllerTest {
@isTest static void testHoduGetUserInfo() {
Boolean result;
String vResponse = HoduApexController.hoduGetUserInfo(); result
= vResponse.contains(UserInfo.getUserId()); System.assertEquals(true, result);
}
}