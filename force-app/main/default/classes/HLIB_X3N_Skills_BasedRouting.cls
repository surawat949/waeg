global class HLIB_X3N_Skills_BasedRouting {
    
        @InvocableMethod(label='Routing based on skills')
        global static void routeUsingSkills(List<String> cases) {
            String idCaso;
            String queueName;
            if(!cases.isEmpty()) {
                idCaso = cases[0].split(';')[0];
                queueName = cases[0].split(';')[1];
            }
            List<Case> caseObjects = [SELECT Id, Description, Owner.Name FROM Case WHERE Id = :idCaso];
            
            for (Case caseObj : caseObjects) {
                // Add SkillsBased PendingServiceRouting
                PendingServiceRouting psrObj = new PendingServiceRouting(
                    CapacityWeight = 1,
                    IsReadyForRouting = FALSE,
                    RoutingModel  = 'MostAvailable', //LeastAvailbale
                    RoutingPriority = 1,
                    RoutingType = 'SkillsBased',
                    ServiceChannelId = getChannelId('Spain_Service_Channel'),
                    WorkItemId = caseObj.Id
                );
                insert psrObj;
                psrObj = [select id, IsReadyForRouting from PendingServiceRouting where id = : psrObj.id];
                System.debug(' \n **** psrObj **** \n'+psrObj);
                // Now add SkillRequirement(s)
                SkillRequirement srObj = new SkillRequirement(
                    RelatedRecordId = psrObj.id,
                    SkillId = getSkillId(queueName)
                    //SkillLevel = 10
                );
                insert srObj;
                
                // Update PendingServiceRouting as IsReadyForRouting
                psrObj.IsReadyForRouting = TRUE;
                System.debug('\n **** psrObj *** \n'+psrObj);
                update psrObj;
            }
            return;
        }
    
    public static String getChannelId(String channelName) {
        ServiceChannel channel = [Select Id From ServiceChannel Where DeveloperName = :channelName];
        return channel.Id;
    }
    
    public static String getSkillId(String caseLanguage) {
        String skillName = 'English';
        if (caseLanguage != null) {
            skillName = caseLanguage;
        }
        
        Skill skill = [Select Id From Skill Where DeveloperName = :skillName];
        return skill.Id;
    }
}