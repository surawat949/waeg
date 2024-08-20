public class DailyLoginNotification {
    @AuraEnabled
    public static void sendDailyLoginNotification() {
        DateTime now = DateTime.now();
        Date currentDate = Date.today();
		Id userId = UserInfo.getUserId();
        // Query login history from the start of the day in the user's time zone
        List<LoginHistory> logins = [
            SELECT LoginTime
            FROM LoginHistory
            WHERE UserId = :userId 
            AND LoginTime >= :currentDate 
            AND LoginTime <= :now
            ORDER BY LoginTime ASC
        ];

        // If it's the first login of the day, send a custom notification
        if (logins.size() <= 1) {
            sendCustomNotification(userId);
        }
    }

    private static void sendCustomNotification(Id userId) {
        // Define the custom notification
        Messaging.CustomNotification notification = new Messaging.CustomNotification();
        notification.setTitle('Daily Reminder');
        notification.setBody('Please refresh the dashboard.');
        notification.setNotificationTypeId('0MLFg0000006PbdOAE'); // Use the ID of your custom notification type
        notification.setTargetId(userId);
        
        // Send the notification
        notification.send(new Set<String> {userId});
    }
}