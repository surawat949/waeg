/**
 * Created by thomas.schnocklake on 21.02.18.
 */
({
    init : function(component, event, helper) {
        helper.getTranslations(component, event, helper, function(translations)
        {
            console.log(translations)
            component.set('v.translations', translations);
        });
    },
})