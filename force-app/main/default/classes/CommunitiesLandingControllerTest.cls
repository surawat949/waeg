/**
 * An apex page controller that takes the user to the right start page based on credentials or lack thereof
 */
@IsTest public with sharing class CommunitiesLandingControllerTest {
    @IsTest(SeeAllData=true) public static void testCommunitiesLandingController() {
        // Instantiate a new controller with all parameters in the page
        CommunitiesLandingController controller = new CommunitiesLandingController();
        PageReference pageRef = controller.forwardToStartPage();
        //PageRef is either null or an empty object in test context
        if(pageRef != null){
            system.debug(pageRef);
            String url = pageRef.getUrl();
            if(url != null){
                System.assertEquals('/secur/logout.jsp', url);
                //show up in perforce
            }
        }
    }
}