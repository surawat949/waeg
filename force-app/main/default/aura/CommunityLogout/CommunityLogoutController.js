({
    logout : function() {
        var urlString = window.location.href;
        var baseURL = urlString.substring(0, urlString.indexOf("/s"));
    /*    if(!baseURL.includes('preview')) {
            window.location.replace(baseURL+"/secur/logout.jsp"); 
        }  */
    }
})