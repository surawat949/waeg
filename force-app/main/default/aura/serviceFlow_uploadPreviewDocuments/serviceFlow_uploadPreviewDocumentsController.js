({
    doInit:function(component,event,helper){  
        helper.getuploadedFiles(component);
    },     
    previewFileAction :function(component,event,helper){  
        var rec_id = event.currentTarget.id;  
        $A.get('e.lightning:openFiles').fire({ 
            recordIds: [rec_id]
        });  
    },  
    UploadFinished : function(component, event, helper) {  
        var uploadedFiles = event.getParam("files");  
        helper.getuploadedFiles(component);  
    }, 
    delFilesAction:function(component,event,helper){
        component.set("v.Spinner", true); 
        var documentId = event.currentTarget.id;        
        helper.delUploadedfiles(component,documentId);  
    }
})