@isTest
public class pss_TestMoodle_API_Response {
    static testMethod void Test_API_Response() {
        pssMoodle_API_Response.RestError respon = new pssMoodle_API_Response.RestError('Exception');
        respon.isError = false;
        respon.debuginfo = 'Debbug';
        respon.errorCode = '3';
    }
}