public class TabActivationAIIndicatorController {
    public class IndicatorWrapper {
        @AuraEnabled public String HVCProgramFlag{get;set;}
        @AuraEnabled public String HVCProgramFlagMeaning{get;set;}
        
        @AuraEnabled public String PortalFlag{get;set;}
         @AuraEnabled public String PortalFlagMeaning{get;set;}
        
        @AuraEnabled public String DataOrdersFlag{get;set;}
        @AuraEnabled public String DataOrdersFlagMeaning{get;set;}
        
        @AuraEnabled public String RemotEdgingFlag{get;set;}
        @AuraEnabled public String RemotEdgingFlagMeaning{get;set;}
        
        @AuraEnabled public String MountingFlag{get;set;}
        @AuraEnabled public String MountingFlagMeaning{get;set;}
    }
      @AuraEnabled(cacheable=true)
     public static IndicatorWrapper getAIIndicators(Id receivedId) {
         String userLanguage = UserInfo.getLanguage();
         Account currAcc = [Select id,Lenses_Net_Sales_Last_12Mo__c,Account_Status__c,Seiko_Network__c,Segmentation_Net__c,
                            CHCUSTCLASSIFICATIONID__c,Brand__c,Visionary_Alliance__c From Account where Id =:receivedId];
          List<Last_Sales_Statistics__c> statsList = [Select Id,Other_Digital_Orders_L3Mo__c,Remote_Edging_L3Mo__c,
                                                      Mounting_L3Mo__c,HVC_Systems_L3Mo__c, Lenses_Net_Sales_Last_12Mo__c, Lenses_Gross_Sales_Last_12Mo__c,
                                                    Lenses_Net_Sales_LFY__c,Lenses_Gross_Sales_LFY__c
                                                    From Last_Sales_Statistics__c Where  Account__c = :receivedId];
         list<Contact> conObj = [SELECT Id, Name,Portal_User_Name__c,Send_Registration_Email_Flag__c,Contact_Record_Type__c,Recordtype.developerName, Salutation,CreatedDate, Title, Email, Phone 
                              FROM Contact where AccountId=:receivedId AND 
                              Portal_User_Name__c !=''];
         
         IndicatorWrapper wrapper = new IndicatorWrapper();

         if(currAcc !=null){
            if(currAcc.Account_Status__c == 'Closed'){
            	wrapper.HVCProgramFlag='GREY'; 
                wrapper.HVCProgramFlagMeaning=System.Label.get('', 'MKG01', userLanguage);
                
                wrapper.PortalFlag='GREY';
                wrapper.PortalFlagMeaning=System.Label.get('', 'Portal01', userLanguage);
                
                wrapper.DataOrdersFlag='GREY';
                wrapper.DataOrdersFlagMeaning=System.Label.get('', 'DigitalOrders01', userLanguage);
                
                wrapper.RemotEdgingFlag='GREY';
                wrapper.RemotEdgingFlagMeaning=System.Label.get('', 'RemoteEdging01', userLanguage);
                
                wrapper.MountingFlag='GREY';
                wrapper.MountingFlagMeaning=System.Label.get('', 'Mounting01', userLanguage);
                
            }
            else{
 
                //Remote Edging Flag start
                if(currAcc.Lenses_Net_Sales_Last_12Mo__c>0){
                    if(!statsList.isEmpty() && statsList[0].Remote_Edging_L3Mo__c+statsList[0].Mounting_L3Mo__c>0){
                     	if(statsList[0].Remote_Edging_L3Mo__c+statsList[0].Mounting_L3Mo__c>10){
                            if(statsList[0].Remote_Edging_L3Mo__c+statsList[0].Mounting_L3Mo__c>40){
                            	wrapper.RemotEdgingFlag='GREEN';   
                                wrapper.RemotEdgingFlagMeaning=System.Label.get('', 'RemoteEdging02', userLanguage);
                            }
							else{
								wrapper.RemotEdgingFlag='GREENALERT'; 
                                wrapper.RemotEdgingFlagMeaning=System.Label.get('', 'RemoteEdging03', userLanguage);
							}
                        }
                        else{
                          wrapper.RemotEdgingFlag='RED'; 
                          wrapper.RemotEdgingFlagMeaning=System.Label.get('', 'RemoteEdging04', userLanguage);  
                        }
                    } 
                    else{
                     	wrapper.RemotEdgingFlag='REDALERT';
                        wrapper.RemotEdgingFlagMeaning=System.Label.get('', 'RemoteEdging05', userLanguage);
                    }
		        }			
                else{
                    wrapper.RemotEdgingFlag='GREEN';
                    wrapper.RemotEdgingFlagMeaning=System.Label.get('', 'RemoteEdging06', userLanguage);
                    wrapper.MountingFlag='GREEN';
                    wrapper.MountingFlagMeaning=System.Label.get('', 'Mounting05', userLanguage);

                    
                }
                //Remote Edging Flag END
                //MountingFlag flag Start
                if(currAcc.Lenses_Net_Sales_Last_12Mo__c>=0){
                    if(!statsList.isEmpty() && statsList[0].Mounting_L3Mo__c>0){
                        if(statsList[0].Mounting_L3Mo__c>10){
                            wrapper.MountingFlag='GREEN'; 
                            wrapper.MountingFlagMeaning=System.Label.get('', 'Mounting02', userLanguage);
                        }
                        else{
                            wrapper.MountingFlag='GREENALERT';
                            wrapper.MountingFlagMeaning=System.Label.get('', 'Mounting03', userLanguage);
                        }
                    }
                    else{
                        wrapper.MountingFlag='RED';
                        wrapper.MountingFlagMeaning=System.Label.get('', 'Mounting04', userLanguage);
                    }
                } else{
                    wrapper.MountingFlag='GREEN';
                    wrapper.MountingFlagMeaning=System.Label.get('', 'Mounting05', userLanguage);
                }
                
                //Mounting Flag End
                //Portal Flag Start
                if(currAcc.Lenses_Net_Sales_Last_12Mo__c>0){
                    if(currAcc.CHCUSTCLASSIFICATIONID__c == 'Ind'){
                        if(conObj.size()>0){
                            wrapper.PortalFlag='GREEN';     
                            wrapper.PortalFlagMeaning=System.Label.get('', 'Portal02', userLanguage);
                        }
                        else{
                            wrapper.PortalFlag='REDALERT';
                            wrapper.PortalFlagMeaning=System.Label.get('', 'Portal03', userLanguage);
                        }
                    }
                    else if(conObj.size()>0){
                        wrapper.PortalFlag='GREENALERT';
                        wrapper.PortalFlagMeaning=System.Label.get('', 'Portal04', userLanguage);
                            
                    }
                    else{
                        wrapper.PortalFlag='GREEN'; 
                        wrapper.PortalFlagMeaning=System.Label.get('', 'Portal05', userLanguage);
                    }
                }    
                else if(conObj.size()>0){
                	wrapper.PortalFlag='GREENALERT'; 
                     wrapper.PortalFlagMeaning=System.Label.get('', 'Portal06', userLanguage);
                }
                else{
                 	wrapper.PortalFlag='GREEN';  
                     wrapper.PortalFlagMeaning=System.Label.get('', 'Portal07', userLanguage);
                }
                //Portal flag end
                //HVC flag start
                if(currAcc.Lenses_Net_Sales_Last_12Mo__c>0){
                    if(currAcc.Brand__c == 'HOYA'){
                        if(currAcc.CHCUSTCLASSIFICATIONID__c == 'Ind'){
                            if(currAcc.Seiko_Network__c == 'Visionary Alliance'){
                             	wrapper.HVCProgramFlag='GREEN'; 
                                wrapper.HVCProgramFlagMeaning=System.Label.get('', 'MKG03', userLanguage);
                            }   
                            /*else if(currAcc.Visionary_Alliance__c == 'Insider' || currAcc.Visionary_Alliance__c == 'Pro' || currAcc.Visionary_Alliance__c == 'Elite'){
                             	wrapper.HVCProgramFlag='GREEN'; 
                                wrapper.HVCProgramFlagMeaning=System.Label.get('', 'MKG03', userLanguage);
                            }*/
                            else{
                               	wrapper.HVCProgramFlag='RED'; 
                                wrapper.HVCProgramFlagMeaning=System.Label.get('', 'MKG04', userLanguage);
                            }
                        } 
                        else if(currAcc.Seiko_Network__c == 'Visionary Alliance' ){
                             	wrapper.HVCProgramFlag='GREENALERT';  
                                wrapper.HVCProgramFlagMeaning=System.Label.get('', 'MKG06', userLanguage);
                            }   
                            /*else if(currAcc.Visionary_Alliance__c == 'Insider' || currAcc.Visionary_Alliance__c == 'Pro' || currAcc.Visionary_Alliance__c == 'Elite'){
                             	wrapper.HVCProgramFlag='GREENALERT'; 
                                wrapper.HVCProgramFlagMeaning=System.Label.get('', 'MKG06', userLanguage);
                            }*/
                            else{
                               	wrapper.HVCProgramFlag='GREEN';
                                wrapper.HVCProgramFlagMeaning=System.Label.get('', 'MKG07', userLanguage);
                            }
                    } 
                    else if(currAcc.Brand__c == 'SEIKO'){
                        if(currAcc.CHCUSTCLASSIFICATIONID__c == 'Ind'){
                            if(currAcc.Seiko_Network__c == 'Seiko Vision Specialist'){
                            	wrapper.HVCProgramFlag='GREEN'; 
                                wrapper.HVCProgramFlagMeaning=System.Label.get('', 'MKG10', userLanguage);
                            }   
                            else if(currAcc.Segmentation_Net__c == 'C1' || currAcc.Segmentation_Net__c == 'C2' ||
                                   currAcc.Segmentation_Net__c == 'C1' || currAcc.Segmentation_Net__c == 'UNCATEGORIZED'){
                             	wrapper.HVCProgramFlag='GREEN'; 
                                wrapper.HVCProgramFlagMeaning=System.Label.get('', 'MKG08', userLanguage);        
                            }
                            else{
                             	wrapper.HVCProgramFlag='REDALERT'; 
                                wrapper.HVCProgramFlagMeaning=System.Label.get('', 'MKG09', userLanguage);
                            }
                        } 
                        else if(currAcc.Seiko_Network__c == 'Seiko Vision Specialist'){
                         	wrapper.HVCProgramFlag='GREENALERT';
                            wrapper.HVCProgramFlagMeaning=System.Label.get('', 'MKG11', userLanguage);
                        }
                        else{
                        	wrapper.HVCProgramFlag='GREEN';
                            wrapper.HVCProgramFlagMeaning=System.Label.get('', 'MKG12', userLanguage);
                        }
                    }
                    else{
                     	wrapper.HVCProgramFlag='GREEN'; 
                        wrapper.HVCProgramFlagMeaning=System.Label.get('', 'MKG13', userLanguage);
                    }
                }
                else if(currAcc.Seiko_Network__c == 'Seiko Vision Specialist' || currAcc.Seiko_Network__c == 'Visionary Alliance'){
                 	wrapper.HVCProgramFlag='REDALERT'; 
                    wrapper.HVCProgramFlagMeaning=System.Label.get('', 'MKG14', userLanguage);
                }
                /*else if(currAcc.Visionary_Alliance__c == 'Insider' || currAcc.Visionary_Alliance__c == 'Pro' || currAcc.Visionary_Alliance__c == 'Elite'){
                	wrapper.HVCProgramFlag='REDALERT';
                    wrapper.HVCProgramFlagMeaning=System.Label.get('', 'MKG15', userLanguage);
                }*/
                else{
                	wrapper.HVCProgramFlag='GREEN';  
                    wrapper.HVCProgramFlagMeaning=System.Label.get('', 'MKG16', userLanguage);
                }
				// digital flag	
				 if(currAcc.Lenses_Net_Sales_Last_12Mo__c>0){
                     if(statsList.size()>0){
					 if(statsList[0].HVC_Systems_L3Mo__c + statsList[0].Other_Digital_Orders_L3Mo__c>0){
						 if(statsList[0].HVC_Systems_L3Mo__c + statsList[0].Other_Digital_Orders_L3Mo__c>50){
							 if(statsList[0].HVC_Systems_L3Mo__c + statsList[0].Other_Digital_Orders_L3Mo__c>70){
								wrapper.DataOrdersFlag='GREEN'; 
                                wrapper.DataOrdersFlagMeaning=System.Label.get('', 'DigitalOrders02', userLanguage); 
							 } 
							 else{
								wrapper.DataOrdersFlag='GREENALERT'; 
                                wrapper.DataOrdersFlagMeaning=System.Label.get('', 'DigitalOrders03', userLanguage); 
							 }
						 }   
						 else{
							wrapper.DataOrdersFlag='RED'; 
                            wrapper.DataOrdersFlagMeaning=System.Label.get('', 'DigitalOrders04', userLanguage); 
						 }
					 }
                     }    
					 else{
						wrapper.DataOrdersFlag='REDALERT';
                        wrapper.DataOrdersFlagMeaning=System.Label.get('', 'DigitalOrders05', userLanguage);  
					 }
					 
				 }
				 else{
					 wrapper.DataOrdersFlag='GREEN';   
                     wrapper.DataOrdersFlagMeaning=System.Label.get('', 'DigitalOrders06', userLanguage);
				 }
		    }
        }			
        return wrapper;
        }      

}