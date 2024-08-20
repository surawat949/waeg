({
    handleUrlsAndLabels: function(cmp, event) {
        cmp.set("v.contactLabel", event.getParam("contactLabel"));
        cmp.set("v.helpLabel", event.getParam("helpLabel"));
        cmp.set("v.contactUrl", event.getParam("contactUrl"));
        cmp.set("v.helpUrl", event.getParam("helpUrl"));
    }
})