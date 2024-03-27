@isTest
public class CreateWSFederationControllerTest {

    public static testMethod void testCreateWSFederationController() {

        CreateWSFederationController controller = new CreateWSFederationController();
        PageReference badCreate = controller.save();
        System.assertEquals(null, badCreate);

    }
}