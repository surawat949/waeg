/**
 * Created by thomas.schnocklake on 21.02.18.
 */
({
	getTranslations: function(component, event, helper, callback) {
		// https://fullcalendar.io/docs/event_data/Event_Object/
		console.log('getTranslations');

        var action = component.get("c.getTranslations");

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                console.log('got translations: ' , response.getReturnValue());
                callback(response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
	},
})