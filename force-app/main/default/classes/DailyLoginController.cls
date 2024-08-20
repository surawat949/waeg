public class DailyLoginController {//
     // Define the role patterns
    private static final List<String> nsmRolePatterns = new List<String>{'%National Sales Manager%'};
    private static final List<String> managerRolePatterns = new List<String>{'%Regional Sales Manager%'};
    private static final List<String> excludedRolePatterns = new List<String>{'%Area Sales Manager%'};
    
    // Define the profiles
    private static final Set<String> nsmProfiles = new Set<String>{'System Administrator', 'Local Admin'};
    
    public static List<User> getManagers() {
        // Get the current user
        User currentUser = [SELECT Id, Profile.Name, UserRole.Name FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        
        // Check if the current user is NSM or equivalent
        Boolean isNSM = isNSMOrEquivalent(currentUser);
        
        // Initialize the manager list
        List<User> managerList = new List<User>();
        List<User> subList = new List<User>();
        if (isNSM) {
            // Query to get users who have the equivalent profiles or roles
            List<User> users = [SELECT Id, Name, UserRole.Name, Profile.Name 
                                FROM User 
                                WHERE Profile.Name IN :nsmProfiles
                                   OR UserRole.Name != NULL];
            
            // Filter the users based on role patterns
            for (User user : users) {
                if(user.UserRole.Name != null){
                    if (isNSMRole(user.UserRole.Name) || isManagerRole(user.UserRole.Name) || nsmProfiles.contains(user.Profile.Name)) {
                        managerList.add(user);
                    }
                }else{
                    subList.add(user);
                }
            }
        }
        System.debug(subList.size());
        System.debug(subList);
        System.debug(managerList.size());
        System.debug(managerList);
        return managerList;
    }
    private static Boolean isNSMOrEquivalent(User user) {
        // Check if the user's role matches any NSM pattern or their profile is in nsmProfiles
        for (String pattern : nsmRolePatterns) {
            if (user.UserRole.Name.contains(pattern)) {
                return true;
            }
        }
        return nsmProfiles.contains(user.Profile.Name);
    }

    private static Boolean isNSMRole(String roleName) {
        // Check if the role name matches any NSM pattern
        for (String pattern : nsmRolePatterns) {
            if (roleName.contains(pattern)) {
                return true;
            }
        }
        return false;
    }

    private static Boolean isManagerRole(String roleName) {
        // Check if the role name matches any manager role pattern and does not match any excluded role pattern
        for (String pattern : managerRolePatterns) {
            if (roleName.contains(pattern)) {
                for (String excludePattern : excludedRolePatterns) {
                    if (roleName.contains(excludePattern)) {
                        return false;
                    }
                }
                return true;
            }
        }
        return false;
    }
}