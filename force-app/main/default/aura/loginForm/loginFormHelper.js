({
  qsToEventMap: {
    startURL: "e.c:setStartUrl",
  },

  doInit: function (component, environment, lang, brand) {
    //document.getElementById("icon_tab").href = '';
    var action = component.get("c.getPortalUrlsAndLabels");
    var cookieUsername = this.getCookie("sfUsername");
    if (cookieUsername) {
      component.find("username").set("v.value", cookieUsername);
    }
    var startUrl = component.get("v.startUrl");
    startUrl = decodeURIComponent(startUrl);
    console.log("startUrl helper: " + startUrl);
      console.log("brand: " + brand);
    action.setParams({
      environment: environment,
      language: lang,
      brand: brand,
    });
    action.setCallback(this, function (a) {
      var rtnValue = a.getReturnValue();
      console.log("#### rtnValue  " + rtnValue);
      if (rtnValue !== null) {
        var urls = JSON.parse(rtnValue);
        component.set("v.selfRegisterUrl", urls.noAccountUrl);
        component.set("v.forgotPasswordUrl", urls.recoveryUrl);
        component.set("v.usernameLabel", urls.usernameLabel);
        component.set("v.passwordLabel", urls.passwordLabel);
        component.set("v.loginButtonLabel", urls.loginLabel);
        component.set("v.forgotPasswordLabel", urls.recoveryLabel);
        component.set("v.selfRegisterLabel", urls.noAccountLabel);
        component.set("v.rememberLabel", urls.rememberLabel);
        component.set("v.welcomeLabel", urls.welcomeLabel);
        component.set("v.descriptionLabel", urls.descriptionLabel);
        component.set("v.descriptionLabelFirst", urls.descriptionLabelFirst);
        component.set("v.descriptionSeiko", urls.descriptionSeiko);
        component.set("v.createAccountLabel", urls.createAccountLabel);
        component.set("v.contactUrl", urls.contactUrl);
        component.set("v.helpUrl", urls.helpUrl);
        component.set("v.privacyUrl", urls.privacyURL);
        component.set("v.termsUrl", urls.termsURL);

        component.set("v.contactLabel", urls.contactLabel);
        component.set("v.helpLabel", urls.helpLabel);
        component.set("v.privacyLabel", urls.privacyLabel);
        component.set("v.termsLabel", urls.termsLabel);

        var cmpEvent = $A.get("e.c:urlsAndLabels");
        cmpEvent.setParams({
          contactLabel: urls.contactLabel,
          helpLabel: urls.helpLabel,
          contactUrl: urls.contactUrl,
          helpUrl: urls.helpUrl,
        });
        cmpEvent.fire();
      }
    });
    $A.enqueueAction(action);
  },

  handleLogin: function (component, event, helpler) {
    var brand = component.get("v.brand");
    var username;
    var password;
    var remember;
    if (brand=== "Optic") {
        username = component.find("username_optic").get("v.value");
        password = component.find("password_optic").get("v.value");
        remember = component.find("remember_optic").get("v.value");
    } else {
      username =
      brand == "hoya"
        ? component.find("username").get("v.value")
        : component.find("username_seiko").get("v.value");
      password =
        brand == "hoya"
          ? component.find("password").get("v.value")
          : component.find("password_seiko").get("v.value");
      remember =
        brand == "hoya"
          ? component.find("remember").get("v.value")
          : component.find("remember_seiko").get("v.value");
    }
    
    var language = component.get("v.language");
    var action = component.get("c.login");
    var startUrl = component.get("v.startUrl");
    if (remember) {
      this.setCookie("sfUsername", username, 30);
    }
    console.log("startUrl WITHOUT DECODE " + startUrl);
    startUrl = decodeURIComponent(startUrl);//+'&backlink=Palma';
    language = language == "" ? "en-us" : language;
    console.log("Helper-language " + language);
    console.log("Helper-startUrl " + startUrl);
    console.log("Helper-username " + username);
    action.setParams({
      username: username,
      password: password,
      startUrl: startUrl,
      language: language,
    });
    action.setCallback(this, function (a) {
      var rtnValue = a.getReturnValue();
	  console.log("helper- returnvalue:" + rtnValue);
      if (rtnValue !== null) {
        component.set("v.errorMessage", rtnValue);
        component.set("v.showError", true);
      }
    });
    $A.enqueueAction(action);
  },

  setCookie: function (cname, cvalue, expdays) {
    var d = new Date();
    d.setTime(d.getTime() + (expdays * 24 * 60 * 60 * 1000));
    var expires = "expires=" + d.toUTCString();
    document.cookie = cname + "=" + encodeURIComponent(cvalue) + ";" + expires + ";path=/";
  },

  getCookie: function (cname) {
    var name = cname + "=";
    var ca = document.cookie.split(";");
    for (var i = 0; i < ca.length; i++) {
      var c = ca[i];
      while (c.charAt(0) == " ") {
        c = c.substring(1);
      }
      if (c.indexOf(name) == 0) {
        return decodeURIComponent(c.substring(name.length, c.length));
      }
    }
    return "";
  },
});