({
	ToggleCollapse : function(component, event, helper) { 
		if(component.get("v.collpaseText")=="Show")
			component.set("v.collpaseText","Hide");
		else
			component.set("v.collpaseText","Show");
	}
})