public class TabVisitsIndicatorController {
    @AuraEnabled(cacheable=true)
    public static IndicatorWrapper getAIIndicators(Id receivedId) {
       Account currAcc  = [Select Id,Account_Status__c,Lenses_Net_Sales_LFY__c,Segmentation_Net__c,
                          Total_Visits_Planned__c,Visits_performed__c,Digital_Visits_Performed__c,Language__c,
                           Lenses_Net_Sales_Last_12Mo__c,Last_Visit_date__c,TACTICOM_SOF__c,
                          Strategic_Value_Gross_Sales__c,Strategic_Value_Net_Sales__c,Hoya_Account_ID__c,Owner.CompanyName
                          From Account WHERE id =: receivedId limit 1];
        List<Last_Sales_Statistics__c> statsList = [Select Id, Lenses_Net_Sales_Last_12Mo__c, Lenses_Gross_Sales_Last_12Mo__c,
                                                    Lenses_Net_Sales_LFY__c,Lenses_Gross_Sales_LFY__c
                                                    From Last_Sales_Statistics__c Where  Account__c = :receivedId];
        List<Account_Campaing_Member__c> listAccountCampaingMember = [SELECT ID,campaign_active__c,Campaign_Presented__c,
                                                                      Campaign_End_Date_t__c FROM Account_Campaing_Member__c 
                                                                      WHERE Account_Name__c=:receivedId AND campaign_active__c = true
                                                                     ];
        List<Contact> listContact = [SELECT ID,AccountId,ShowpadForSF__Showpad_Last_Activity_Date__c,
                                    ShowpadForSF__Showpad_Last_View_Date__c FROM Contact WHERE AccountId=: receivedId];
        List<Identified_Business_Opportunity__c> lstBusiOpp = [SELECT Id, Account__c, Project_Status__c 
                                                               FROM Identified_Business_Opportunity__c 
                                                               WHERE Account__c = :receivedId AND Project_Status__c IN('Not Started','In progress','Postponed') ];
        List<Identified_Business_Opportunity__c> lstBusiOppInProgress = [SELECT Id, Account__c, Project_Status__c 
                                                               FROM Identified_Business_Opportunity__c 
                                                               WHERE Account__c = :receivedId AND Project_Status__c ='In progress'];
        List<Visits__c> listOfVisit = [SELECT ID,Visit_Type__c,Visit_Status__c FROM Visits__c 
                                       WHERE Account__c = :receivedId AND Visit_Type__c ='Visit'];
        list<Account_Life_Cycle__c> listOfALC = [SELECT ID, Account__c,Active__c FROM Account_Life_Cycle__c 
                                                 WHERE Account__c =: receivedId AND Active__c = true];
        IndicatorWrapper wrapper = new IndicatorWrapper();
        String userLanguage = UserInfo.getLanguage();
        if(currAcc !=null){
            if(currAcc.Account_Status__c == 'Closed'){
                wrapper.flagTotalVisits='GREY';
                wrapper.flagTotalVisitsHelpText = System.Label.get('', 'VISITS_01', userLanguage);
                wrapper.strategicValueIndicator='GREY';
                wrapper.busiOppIndicator='GREY';
                wrapper.busiOppIndicatorHelpText = System.Label.get('', 'OPPORTUNITIES_01', userLanguage);
                wrapper.campaignsIndicator='GREY';
                wrapper.campaignsIndicatorHelpText = System.Label.get('', 'CAMPAIGNS_01', userLanguage);
                wrapper.showpadIndicator='GREY';
                wrapper.lifeCycleFlag='GREY';
                wrapper.lifeCycleFlagHelpText=System.Label.get('', 'VISITS_01', userLanguage);
                
                if(currAcc.TACTICOM_SOF__c == '' || currAcc.TACTICOM_SOF__c == null){
                        wrapper.tacticomFlag = 'GREY';
                        wrapper.tacticomFlagHelpText = System.Label.get('', 'Tacticom_01', userLanguage);
                }
                else{
                       wrapper.tacticomFlag = 'GREYALERT';   
                       wrapper.tacticomFlagHelpText = System.Label.get('', 'Tacticom_02', userLanguage);
                }

                
            }
            else{
                //total visit flag                
                 wrapper.tacticomFlag = 'GREY';
                //wrapper.lifeCycleFlag='GREY';
                if(currAcc.Total_Visits_Planned__c>0){
                    if(currAcc.Visits_performed__c+currAcc.Digital_Visits_Performed__c>0){
                        
                        if(Math.abs(currAcc.Total_Visits_Planned__c - (currAcc.Visits_performed__c+currAcc.Digital_Visits_Performed__c))<=1){
                            wrapper.flagTotalVisits='GREEN';
                            wrapper.flagTotalVisitsHelpText = System.Label.get('', 'VISITS_02', userLanguage);
                        }   
                        else if(Math.abs(currAcc.Total_Visits_Planned__c - (currAcc.Visits_performed__c+currAcc.Digital_Visits_Performed__c))<=2){
                            wrapper.flagTotalVisits='GREENALERT';    
                            wrapper.flagTotalVisitsHelpText = System.Label.get('', 'VISITS_03', userLanguage);
                        }
                        else if(Math.abs(currAcc.Total_Visits_Planned__c - (currAcc.Visits_performed__c+currAcc.Digital_Visits_Performed__c))<=3){
                            wrapper.flagTotalVisits='RED';
                            wrapper.flagTotalVisitsHelpText = System.Label.get('', 'VISITS_04', userLanguage);
                        }
                        else{
                            wrapper.flagTotalVisits='REDALERT';  
                            wrapper.flagTotalVisitsHelpText = System.Label.get('', 'VISITS_05', userLanguage);
                        }
                    }
                    else{
                        wrapper.flagTotalVisits='REDALERT';
                        wrapper.flagTotalVisitsHelpText = System.Label.get('', 'VISITS_06', userLanguage);
                    }
                }
                else if(currAcc.Visits_performed__c + currAcc.Digital_Visits_Performed__c >0){
                    wrapper.flagTotalVisits='RED';        
                    wrapper.flagTotalVisitsHelpText = System.Label.get('', 'VISITS_07', userLanguage);
                }
                else{
                    wrapper.flagTotalVisits='GREEN';      
                    wrapper.flagTotalVisitsHelpText = System.Label.get('', 'VISITS_08', userLanguage);
                }
             // StrategicValueIndicator 
                if(statsList.size()>0){
                    if(statsList[0].Lenses_Net_Sales_Last_12Mo__c>0 || statsList[0].Lenses_Net_Sales_LFY__c>0){
                        if(currAcc.Hoya_Account_ID__c.startsWith('SO4900') || currAcc.Hoya_Account_ID__c.startsWith('SO4990') || 
                            currAcc.Owner.CompanyName == 'HODG'){
                            if(currAcc.Strategic_Value_Gross_Sales__c == 0 || currAcc.Strategic_Value_Gross_Sales__c==null){
                               wrapper.strategicValueIndicator='RED'; 
                            }
                            else if(currAcc.Strategic_Value_Gross_Sales__c<statsList[0].Lenses_Gross_Sales_LFY__c){
                                wrapper.strategicValueIndicator='REDALERT';    
                            }
                            else if(currAcc.Strategic_Value_Gross_Sales__c<statsList[0].Lenses_Gross_Sales_Last_12Mo__c){
                                wrapper.strategicValueIndicator='REDALERT';     
                            }
                            else{ wrapper.strategicValueIndicator='GREEN'; }
                           
                        }
                        
                        else if(currAcc.Strategic_Value_Net_Sales__c==0 || currAcc.Strategic_Value_Net_Sales__c==null){
                            wrapper.strategicValueIndicator='RED';      
                        }
                        else if(currAcc.Strategic_Value_Net_Sales__c < statsList[0].Lenses_Net_Sales_LFY__c){
                            wrapper.strategicValueIndicator='REDALERT';     
                        }
                        else if(currAcc.Strategic_Value_Net_Sales__c < statsList[0].Lenses_Net_Sales_Last_12Mo__c){
                            wrapper.strategicValueIndicator='REDALERT';     
                        }
                        else{
                           wrapper.strategicValueIndicator='GREEN';  
                        }
                    }
                    else{
                         if(currAcc.Hoya_Account_ID__c.startsWith('SO4900') || currAcc.Hoya_Account_ID__c.startsWith('SO4990') || 
                            currAcc.Owner.CompanyName == 'HODG'){
                                if(currAcc.Strategic_Value_Gross_Sales__c == 0 || currAcc.Strategic_Value_Gross_Sales__c ==null){
                                    wrapper.strategicValueIndicator='REDALERT';      
                                }
                                else{
                                   wrapper.strategicValueIndicator='GREEN';   
                                }
                         }
                        else if(currAcc.Strategic_Value_Net_Sales__c == 0 || currAcc.Strategic_Value_Net_Sales__c ==null){
                            wrapper.strategicValueIndicator='REDALERT';     
                        }
                        else{
                            wrapper.strategicValueIndicator='GREEN';  
                        }
                    }
                }   
                else{
                    wrapper.strategicValueIndicator='REDALERT';    
                }
                //business Opportunities flag
                if(lstBusiOppInProgress.size()>0){
                    wrapper.busiOppIndicator='GREEN';
                    wrapper.busiOppIndicatorHelpText = System.Label.get('', 'OPPORTUNITIES_02', userLanguage);
                }else if(lstBusiOpp.size()>0){
                    wrapper.busiOppIndicator='GREENALERT';
                    wrapper.busiOppIndicatorHelpText = System.Label.get('', 'OPPORTUNITIES_03', userLanguage);
                }
                else if(currAcc.Segmentation_Net__c=='A1' || currAcc.Segmentation_Net__c=='A2'||
                        currAcc.Segmentation_Net__c=='B1' ||  currAcc.Segmentation_Net__c=='B2' || 
                        currAcc.Segmentation_Net__c=='C1' || currAcc.Segmentation_Net__c=='C2'){
                            wrapper.busiOppIndicator='REDALERT';
                            wrapper.busiOppIndicatorHelpText = System.Label.get('', 'OPPORTUNITIES_04', userLanguage);
                        }
                else{
                    wrapper.busiOppIndicator='RED';
                    wrapper.busiOppIndicatorHelpText = System.Label.get('', 'OPPORTUNITIES_05', userLanguage);
                }
                //business Opportunities flag ends
                //Campaigns flag start
                List<Account_Campaing_Member__c> campaignNotPresentedList = new List<Account_Campaing_Member__c>();
                if(listAccountCampaingMember.size()>0){
                    for(Account_Campaing_Member__c accountCampaingMember : listAccountCampaingMember){
                        if(accountCampaingMember.Campaign_Presented__c == false){
                            campaignNotPresentedList.add(accountCampaingMember);
                        }
                    }
                    if(campaignNotPresentedList.size()>0){
                        Boolean hasNegativeValue = false;
                        Boolean hasGreaterThan30 = false;
                        Boolean isInRange = false;
                        for(Account_Campaing_Member__c accountMember : campaignNotPresentedList){
                           Integer daysBetween;  
                           if(accountMember.Campaign_End_Date_t__c==null)
                           {
                            daysBetween=-1;
                           }
                           else{
                             daysBetween = System.today().daysBetween(accountMember.Campaign_End_Date_t__c);
                           }
                            if(daysBetween <30 && daysBetween >= 0){
                                wrapper.campaignsIndicator='REDALERT';
                                wrapper.campaignsIndicatorHelpText = System.Label.get('', 'CAMPAIGNS_02', userLanguage);
                                isInRange = true;
                                hasGreaterThan30 = false;
                                hasNegativeValue = false;
                                break;
                            }else if(daysBetween > 30){
                                hasGreaterThan30 = true;
                            }else{
                                hasNegativeValue = true;
                            }
                        }
                        if(hasGreaterThan30 == true && isInRange == false){
                            wrapper.campaignsIndicator='RED';
                            wrapper.campaignsIndicatorHelpText = System.Label.get('', 'CAMPAIGNS_03', userLanguage);
                        }else if(hasNegativeValue = true && isInRange == false){
                            wrapper.campaignsIndicator='REDALERT';
                            wrapper.campaignsIndicatorHelpText = System.Label.get('', 'CAMPAIGNS_04', userLanguage);
                        }
                    }else{
                        wrapper.campaignsIndicator='GREEN';
                        wrapper.campaignsIndicatorHelpText = System.Label.get('', 'CAMPAIGNS_05', userLanguage);
                    }
                }else{
                    wrapper.campaignsIndicator='GREEN';
                    wrapper.campaignsIndicatorHelpText = System.Label.get('', 'CAMPAIGNS_06', userLanguage);
                    System.debug(wrapper.campaignsIndicatorHelpText);
                }
                //Campaigns flag start ends
                //tacticom flag start
                Map<String,String> tacticomFlag = tecticomIndicators(receivedId,currAcc.Segmentation_Net__c,currAcc.TACTICOM_SOF__c,userLanguage);
                wrapper.tacticomFlag = tacticomFlag.get('flagColor');
                wrapper.tacticomFlagHelpText = tacticomFlag.get('tacticomFlagHelpText'); 
              //LIFECYCLE flag
               if(listOfALC.size()>0){
                 	wrapper.lifeCycleFlag='GREEN';   
                    wrapper.lifeCycleFlagHelpText=System.Label.get('', 'CustomerReview01', userLanguage);
                } 
                else{
                 	wrapper.lifeCycleFlag='RED'; 
                    wrapper.lifeCycleFlagHelpText=System.Label.get('', 'CustomerReview02', userLanguage);
                }
            }
        }
        return wrapper;
}   
     public class IndicatorWrapper {
        @AuraEnabled public String flagTotalVisits{get;set;}
        @AuraEnabled public String flagTotalVisitsHelpText{get;set;}
        
        @AuraEnabled public String strategicValueIndicator{get;set;}
        // @AuraEnabled public String strategicValueIndicatorHelpText{get;set;}
        
        @AuraEnabled public String busiOppIndicator{get;set;}
        @AuraEnabled public String busiOppIndicatorHelpText{get;set;}
        
        @AuraEnabled public String campaignsIndicator{get;set;}
        @AuraEnabled public String campaignsIndicatorHelpText{get;set;}
        
        @AuraEnabled public String showpadIndicator{get;set;}
        // @AuraEnabled public String showpadIndicatorHelpText{get;set;}
        
        @AuraEnabled public String tacticomFlag{get;set;}
        @AuraEnabled public String tacticomFlagHelpText{get;set;}
        
        @AuraEnabled public String lifeCycleFlag{get;set;} 
        @AuraEnabled public String lifeCycleFlagHelpText{get;set;} 
    }
    public static Map<String,String> tecticomIndicators(Id receivedId,String Segment,String subArea,String userLanguage) {
        list<Visits__c> listOfVisit60days = [SELECT ID,Visit_Type__c,Visit_Status__c FROM Visits__c 
                                            WHERE Account__c =:receivedId AND Visit_Type__c ='Visit' AND Visit_Status__c ='Planned' AND  Start_Time__c >today AND Start_Time__c <= NEXT_N_DAYS:60 limit 1];
                                              
        list<Visits__c> listOfVisit90days = [SELECT ID,Visit_Type__c,Visit_Status__c,Start_Time__c FROM Visits__c 
                                            WHERE Account__c =:receivedId AND Visit_Type__c ='Visit' AND Visit_Status__c ='Complete' AND  Start_Time__c <today AND Start_Time__c >= LAST_N_DAYS:90 limit 1];
        
        list<Visits__c> listOfVisit180days =[SELECT ID,Visit_Type__c,Visit_Status__c,Start_Time__c FROM Visits__c 
                                            WHERE Account__c =:receivedId AND Visit_Type__c ='Visit' AND Visit_Status__c ='Complete' AND  Start_Time__c <today AND Start_Time__c >= LAST_N_DAYS:180 limit 1];
        string tecticomFlag;
        String tacticomFlagHelpText;
        Map<String,String> tacticomFlagMap= new Map<String,String>();
        if(subArea != '' && subArea != null && subArea != 'None'){
            if(listOfVisit180days.size()>0){
                if(listOfVisit90days.size()>0){
                    tecticomFlag='GREEN';   
                    tacticomFlagHelpText = System.Label.get('', 'Tacticom_03', userLanguage);
                }
                else if(listOfVisit60days.size()>0){
                    tecticomFlag='GREEN';
                    tacticomFlagHelpText = System.Label.get('', 'Tacticom_04', userLanguage);
                }
                else{
                    tecticomFlag='GREENALERT'; 
                    tacticomFlagHelpText = System.Label.get('', 'Tacticom_05', userLanguage);
                }
            }else if(listOfVisit60days.size()>0){
                tecticomFlag='GREEN';
                tacticomFlagHelpText = System.Label.get('', 'Tacticom_06', userLanguage);
            }
            else{
                tecticomFlag='RED'; 
                tacticomFlagHelpText = System.Label.get('', 'Tacticom_07', userLanguage);
            }
        }  
        else if(listOfVisit90days.size()>0){
            if(listOfVisit60days.size()>0){
                tecticomFlag = 'RED';    
                tacticomFlagHelpText = System.Label.get('', 'Tacticom_08', userLanguage);
            }else if(Segment=='A1' || Segment=='A2'|| Segment=='B1' ||  Segment=='B2' || Segment=='C1' || Segment=='C2'){
                tecticomFlag = 'REDALERT';                   
                tacticomFlagHelpText = System.Label.get('', 'Tacticom_09', userLanguage);
            } 
            else{
                tecticomFlag = 'GREENALERT';   
                tacticomFlagHelpText = System.Label.get('', 'Tacticom_10', userLanguage);
            }
        }
        else if(listOfVisit180days.size()>0){
            if(listOfVisit60days.size()>0){
                tecticomFlag = 'RED';     
                tacticomFlagHelpText = System.Label.get('', 'Tacticom_11', userLanguage);
            }
            else if(Segment=='A1' || Segment=='A2'|| Segment=='B1' ||  Segment=='B2' || Segment=='C1' || Segment=='C2'){
                tecticomFlag = 'REDALERT';                   
                tacticomFlagHelpText = System.Label.get('', 'Tacticom_12', userLanguage);
            } 
            else{
                tecticomFlag = 'GREEN';   
                tacticomFlagHelpText = System.Label.get('', 'Tacticom_13', userLanguage);
            }
        }
        else if(listOfVisit60days.size()>0){
            tecticomFlag = 'RED';    
            tacticomFlagHelpText = System.Label.get('', 'Tacticom_14', userLanguage);
        }
        else{
            tecticomFlag = 'GREEN';    
            tacticomFlagHelpText = System.Label.get('', 'Tacticom_15', userLanguage);
        }
        tacticomFlagMap.put('flagColor',tecticomFlag);
        tacticomFlagMap.put('tacticomFlagHelpText',tacticomFlagHelpText);
        return tacticomFlagMap;
    }
}