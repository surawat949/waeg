export function getBackgroundColor(event) {
    let eyeDoctorEvent = event.recordTypeName && event.recordTypeName == 'Eye_Doctor_Visit' ? true : false;
    let bgColor = '';
    if(eyeDoctorEvent){
        if(event.visitType == 'Digital Visit' || event.visitType == 'Support Digital Visit'){
            bgColor = {
                "Planned" : '#36BF04',
                "Prepared" : '#36BF04',
                "Complete" : '#999966'
            }[event.visitStatus]; 
         }else if(event.visitType == 'Coaching' || event.visitType == 'Support Direct Visit' || event.visitType == 'Visit'){
            bgColor = {
                "Planned" : '#29920a',
                "Prepared" : '#29920a',
                "Complete" : '#999966'
            }[event.visitStatus]; 
        }else{
            bgColor = {
                "Planned" : '#ff0066',
                "Prepared" : '#ff0066',
                "Complete" : '#999966'
            }[event.visitStatus]; 
        }
    }else if(event.visitType =='Visit' || event.visitType =='Support Direct Visit' || event.visitType =='Coaching'){
        bgColor = {
            "Planned" : '#082841',
            "Prepared" : '#082841',
            "Complete" : '#999966'
        }[event.visitStatus];
    }else if(event.visitType == 'Digital Visit' || event.visitType == 'Support Digital Visit'){
        bgColor = {
            "Planned" : '#389fb0',
            "Prepared" : '#389fb0',
            "Complete" : '#999966'
        }[event.visitStatus];
    }else{
        bgColor = {
            "Planned" : '#ff0066',
            "Prepared" : '#ff0066',
            "Complete" : '#999966'
        }[event.visitStatus];
    }
    return bgColor;
}