({
  initialize: function (component, event, helper) {
    // TODO: get application from url and change the icon   ----

    $A.get("e.siteforce:registerQueryEventMap")
      .setParams({ qsToEvent: helper.qsToEventMap })
      .fire();
    $A.get("e.siteforce:registerQueryEventMap")
      .setParams({ qsToEvent: helper.qsToEventMap2 })
      .fire();
	
    
    var environment;
    var lang;
    var brand;
    var pageDesign;
    //console.log("BP window.location.search --> "+window.location.search);
    var sPageURL = decodeURIComponent(window.location.search.substring(1)); //You get the whole decoded URL of the page.
    var sURLVariables = sPageURL.split("&"); //Split by & so that you get the key value pairs separately in a list
    console.log("url variables: " + sURLVariables);
    var sParameterName;
    var i;

    for (i = 0; i < sURLVariables.length; i++) {
      sParameterName = sURLVariables[i].split("="); //to split the key from the value.

      if (sParameterName[0] === "lang") {
        sParameterName[1] === undefined
          ? (lang = "en-us")
          : (lang = sParameterName[1]);
      }
      
      if (sParameterName[0] === "startURL") {
        component.set(
          "v.startUrl",
          sParameterName[1] + "=" + sParameterName[2]
        );
      }

      if (sParameterName[0] === "RelayState") {
        if (sParameterName[1] != undefined && sParameterName[1].includes("optic-2-master.azurewebsites.net")) {
          pageDesign = "Optic";
          brand = "Optic";
          environment = "uat";
        }
      }
    }

    //}
    if (lang === undefined) {
      lang = "en-us";
    }

    if (sPageURL.includes("wtrealm") && sPageURL.includes("main")) {
      environment = "main";
    } else if (sPageURL.includes("wtrealm") && (sPageURL.includes("build") || sPageURL.includes("inte"))) {
      environment = "build";
    } else if (sPageURL.includes("wtrealm") && (sPageURL.includes("uat") || sPageURL.includes("prep"))) {
      environment = "uat";
    } else if(pageDesign != "Optic") {
      environment = "prod";
    }

    if (/*sPageURL.includes("wtrealm") &&*/ sPageURL.includes("seiko")) {
      brand = "seiko";
    } else if (pageDesign == "Optic"){
      // do nothing. Everything is already set
    } else brand = "hoya";

    component.set("v.language", lang);
    component.set("v.brand", brand);

    // Logo above username password goes below
    var url =
      brand == "hoya" && brand != undefined
        ? lang == "it" || lang == "it-it"
          ? $A.get("$Resource.Hoya_Logo_IT")
          : $A.get("$Resource.Hoya_brand")
        : brand == 'Optic' ? $A.get("$Resource.SafeVision_brand")
        : $A.get("$Resource.Seiko_logo");

    component.set("v.backgroundImageURL", url);
    
    // Not used anywhere
    var graphicDesign =
      brand == "hoya" && brand != undefined
        ? $A.get("$Resource.Hoya_Login_Graphic")
        : "";
    component.set("v.graphicDesign", graphicDesign);

    // ICON Tab for login page
    var href =
      brand == "hoya"
        ? $A.get("$Resource.Login_Icon_tab")
        : brand == "Optic" ? $A.get("$Resource.Login_Icon_Tab_SafetyRx")
        :$A.get("$Resource.login_seiko_icon_tab");
    document.getElementById("icon_tab").href = href;
    
    // Background seiko
    var backgroundSeiko =
      brand == "seiko" ? $A.get("$Resource.background_seiko") : "";
    component.set("v.backgroundSeiko", backgroundSeiko);

    // add css margin to salesforceIdentityLoginBody2 .cCenterPanel
    var cssToHoya =
      (brand == "hoya" || brand=="Optic") ? "margin: 0 !important;padding: 0 !important;" : "";
    component.set("v.cssToHoya", cssToHoya);
    
    // add title to web page
    var titlePage =
      brand == "seiko"
        ? $A.get("$Label.c.Label_Tab_Web_Seiko")
        : brand == "Optic" ? $A.get("$Label.c.Label_Tab_Web_SafetyRx")
        :$A.get("$Label.c.Label_Tab_Web");
    document.title = titlePage;

    console.log('brand ' + brand);
    helper.doInit(component, environment, lang, brand);
    //var action = component.get("!c.getPreviousRealm");
    //action.setCallback(this, function (a) {
    //  var rtnValue = a.getReturnValue();
    //  var startUrl = event.getParam("startURL");
    //  component.set("startUrl","&previousRealm="+rtnValue);
    //})
    //$A.enqueueAction(action);
  },

  handleLogin: function (component, event, helpler) {
    helpler.handleLogin(component, event, helpler);
  },

  setStartUrl: function (component, event, helpler) {
    var startUrl = event.getParam("startURL");
    console.log("controller-startUrl:" + startUrl);
    if (startUrl) {
      component.set("v.startUrl", startUrl);
      //console.log("BEGGINING startUrl - "+startUrl);
    }
    // do init after this?
  },

  onKeyUp: function (component, event, helpler) {
    //checks for "enter" key
    if (event.getParam("keyCode") === 13) {
      helpler.handleLogin(component, event, helpler);
    }
  },

});