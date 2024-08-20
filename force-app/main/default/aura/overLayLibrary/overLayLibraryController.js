({
    handleShowPopover : function(component, event, helper) {
        component.find('overlayLib').showCustomPopover({
            body: "Popovers are positioned relative to a reference element",
            referenceSelector: ".popover1",
            cssClass: "popoverclass,cPopoverOpener"
        }).then(function (overlay) {
            component._overlay = overlay;
            setTimeout(function(){
                //close the popover after 3 seconds
                if (component._overlay) {
                    component._overlay.close();
                }
            }, 3000);
        });
    }
})