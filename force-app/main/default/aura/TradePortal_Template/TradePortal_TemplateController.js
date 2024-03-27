({
    init: function(component, event, helper){
        helper.initTemplate(component, helper, function(err, result){
            component.set('v.templateList', result);
            if (result && result.length != 0) {
                component.set('v.template', result[0].Id);
            }
            
        });
        helper.initLanguage(component, helper, function(err, result){
            component.set('v.languageList', result);
            if (result && result.length != 0) {
                component.set('v.language', result[0].Id);
            }
        });
        helper.initPortal(component, helper, function(err, result){
            component.set('v.portalList', result);
            if (result && result.length != 0) {
                component.set('v.portal', result[0].Id);
            }
        });
        helper.initSystemEmail(component, helper, function(err, result){
            component.set('v.systemEmailList', result);
            if (result && result.length != 0) {
                component.set('v.systemEmail', result[0].Id);
            }
        });
    },
    CreateRecord: function (component, event, helper) {
        var fileInput = component.find("file").getElement();
        var file = fileInput.files[0];

        if (file){
            //console.log("File");
            var reader = new FileReader();
            reader.readAsText(file, "UTF-8");
            reader.onload = function (evt) {
                
                //console.log("EVT FN");
                var csv = evt.target.result;
                //console.log('csv file contains'+ csv);
                var result = helper.CSV2JSON(component,csv);
                //console.log('result = ' + result);
                //console.log('Result = '+JSON.parse(result));
                helper.CreateAccount(component,result);
                
            }
            reader.onerror = function (evt) {
                //console.log("error reading file");
            }
        }
        
    },
    
    showfiledata :  function (component, event, helper){        
        var fileInput = component.find("file").getElement();
        var file = fileInput.files[0];
        if (file) {
            component.set("v.showcard", true);
            //console.log("File");
            var reader = new FileReader();
            reader.readAsText(file, "UTF-8");
            reader.onload = function (evt) {
                var csv = evt.target.result;
                var table = document.createElement("table");
                table.className = "slds-table slds-table_bordered slds-table_cell-buffer";
                var rows = csv.split("\n");
                for (var i = 0; i < rows.length; i++) {
                    var cells = rows[i].split(",");
                    if (cells.length > 1) {
                        var row = table.insertRow(-1);
                        for (var j = 0; j < cells.length; j++) {
                            var cell = row.insertCell(-1);
                            cell.innerHTML = cells[j];
                        }
                    }
                }
                var divCSV = document.getElementById("divCSV");
                divCSV.innerHTML = "";
                divCSV.appendChild(table);
            }
            reader.onerror = function (evt) {
                //console.log("error reading file");
            }
        }
    },
    downloadCsvTemplate: function(component, event, helper){
        var csv ='hoyaAccountID,AccountName,Title,FirstName,LastName,Email,Phone'
        + '\n'
        + 'DE123456,shop name,Mr,john,doe,john.doe@hoya.com,0123456789';
        var hiddenElement = document.createElement('a');  
        hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);  
        hiddenElement.target = '_blank';  
        
        //provide the name for the CSV file to be downloaded  
        hiddenElement.download = 'template.csv';  
        hiddenElement.click();  
    },
    showSpinner : function(component,event,helper){
    // display spinner when aura:waiting (server waiting)
        component.set("v.toggleSpinner", true);  
    },
    hideSpinner : function(component,event,helper){
    // hide when aura:downwaiting
        component.set("v.toggleSpinner", false);
        
    }
})