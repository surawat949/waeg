public class UserRoleHandler {
    public String currentUserId { get; set; }
    public String currentUserRole { get; set; }
    
    public List<User> salesManagerList { get; set; }
    public List<User> representativeList { get; set; }

    public UserRoleHandler() {
        currentUserId = UserInfo.getUserId();
        currentUserRole = [SELECT Sales_Role__c FROM User WHERE Id = :currentUserId].Sales_Role__c;
        salesManagerList = new List<User>();
        representativeList = new List<User>();
        setSalesManagerList();
    }

    private void setSalesManagerList() {
        List<User> allUsers = [SELECT Id, ManagerId, Sales_Role__c, Name FROM User];
        
        Map<String, User> userMap = new Map<String, User>();
        Map<String, List<User>> managerToUsersMap = new Map<String, List<User>>();
        
        for (User u : allUsers) {
            userMap.put(u.Id, u);
            if (!managerToUsersMap.containsKey(u.ManagerId)) {
                managerToUsersMap.put(u.ManagerId, new List<User>());
            }
            managerToUsersMap.get(u.ManagerId).add(u);
        }

        if (currentUserRole == 'NSM') {
            salesManagerList.add(userMap.get(currentUserId));
            if (managerToUsersMap.containsKey(currentUserId)) {
                for (User subordinate : managerToUsersMap.get(currentUserId)) {
                    if (subordinate.Sales_Role__c == 'RSM') {
                        salesManagerList.add(subordinate);
                    }
                }
            }
        } else if (currentUserRole == 'RSM') {
            salesManagerList.add(userMap.get(currentUserId));
            if (managerToUsersMap.containsKey(currentUserId)) {
                for (User subordinate : managerToUsersMap.get(currentUserId)) {
                    if (subordinate.Sales_Role__c != 'NSM' && subordinate.Sales_Role__c != 'RSM') {
                        salesManagerList.add(subordinate);
                    }
                }
            }
        } else if (currentUserRole == 'ASM') {
            User manager = userMap.get(userMap.get(currentUserId).ManagerId);
            if (manager != null) {
                salesManagerList.add(manager);
            }
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<User> getSalesManagerList() {
        UserRoleHandler handler = new UserRoleHandler();
        return handler.salesManagerList;
    }

    @AuraEnabled(cacheable=true)
    public static List<User> getRepresentativeList(String selectedManagerId) {
        List<User> representativeList = new List<User>();
        List<User> allUsers = [SELECT Id, ManagerId, Sales_Role__c, Name FROM User WHERE ManagerId = :selectedManagerId];
        
        for (User u : allUsers) {
            if (u.Sales_Role__c == 'ASM' || u.Sales_Role__c == 'KAM' || u.Sales_Role__c == 'AMS' || u.Sales_Role__c == 'RSM' || u.Sales_Role__c == 'RMS') {
                System.debug('u '+u);
                representativeList.add(u);
            }
        }

        // Adding the selected manager to the representative list
        representativeList.add([SELECT Id, Sales_Role__c,Name FROM User WHERE Id = :selectedManagerId LIMIT 1]);

        return representativeList;
    }
}