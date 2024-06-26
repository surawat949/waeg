trigger HoduLogoutEventTrigger on LogoutEventStream (after insert) {
 LogoutEventStream event = Trigger.new[0];
 HoduAgentLogoutController.HoduAgentLogoutCC(event.UserId);
}