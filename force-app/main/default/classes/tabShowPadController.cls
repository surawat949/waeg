public with sharing class tabShowPadController {
    public tabShowPadController() {}

    @AuraEnabled(cacheable=true)
    public static IndicatorWrapper getAIIndicators(Id recordId) {
        IndicatorWrapper wrapper = new IndicatorWrapper();
        String userLanguage = UserInfo.getLanguage();
        wrapper.openingFlag = 'GREY';
        wrapper.presenatationFlag = 'GREY';
        
        Account currAcc  = [Select Id,Account_Status__c,Lenses_Net_Sales_LFY__c,Segmentation_Net__c,
                          Total_Visits_Planned__c,Visits_performed__c,Digital_Visits_Performed__c,Language__c,
                           Lenses_Net_Sales_Last_12Mo__c,Last_Visit_date__c,
                          Strategic_Value_Gross_Sales__c,Strategic_Value_Net_Sales__c,Hoya_Account_ID__c,Owner.CompanyName
                          From Account WHERE id =: recordId limit 1];

        List<Contact> listContact = [SELECT ID,AccountId,ShowpadForSF__Showpad_Last_Activity_Date__c, ShowpadForSF__Showpad_Last_View_Date__c FROM Contact WHERE AccountId=: recordId];
         
        //Showpad sharing flag start
          if (currAcc != null) {
            DateTime currentDate = DateTime.now();
            // Calculate the date 3 months ago from the current date
            DateTime threeMonthsAgo = currentDate.addMonths(-3);
            // Calculate the date 12 months ago from the current date
            DateTime twelveMonthsAgo = currentDate.addMonths(-12);
            // Calculate the date 6 months ago from the current date
            DateTime sixMonthsAgo = currentDate.addMonths(-6);
            if (currAcc.Account_Status__c == 'Closed') {
                wrapper.sharingFlag = 'GREY'; 
                wrapper.sharingFlagMeaning=System.Label.get('', 'Sharing_01', userLanguage);
                wrapper.viewingFlag = 'GREY';
                wrapper.viewingFlagMeaning=System.Label.get('', 'Viewing01', userLanguage);
            } else{
                if(currAcc.Lenses_Net_Sales_Last_12Mo__c>0){
                    if(currAcc.Last_Visit_date__c>= twelveMonthsAgo){
                        if (listContact.size() > 0) {
							Boolean activityFound = false;
							for (Contact con : listContact) {
								if(con.ShowpadForSF__Showpad_Last_Activity_Date__c != null && con.ShowpadForSF__Showpad_Last_Activity_Date__c >= sixMonthsAgo && con.ShowpadForSF__Showpad_Last_Activity_Date__c <= currentDate) {
									activityFound = true;
									wrapper.viewingFlag = 'GREEN';
									wrapper.sharingFlag = 'GREEN'; 
                                    wrapper.viewingFlagMeaning=System.Label.get('', 'Viewing02', userLanguage);
									wrapper.sharingFlagMeaning=System.Label.get('', 'Sharing_02', userLanguage);
									break;
								}  
								else{
									wrapper.sharingFlag = 'RED';
                                    wrapper.viewingFlag = 'RED';
									wrapper.sharingFlagMeaning=System.Label.get('', 'Sharing_04', userLanguage);
                                    wrapper.viewingFlagMeaning=System.Label.get('', 'Viewing04', userLanguage);
                                }
							}
							if (activityFound) {
								// check if for any of the contacts we have last view date as expected
								for (Contact con : listContact) {
									if (con.ShowpadForSF__Showpad_Last_View_Date__c != null && con.ShowpadForSF__Showpad_Last_View_Date__c >= threeMonthsAgo && con.ShowpadForSF__Showpad_Last_View_Date__c <= currentDate) {
										wrapper.sharingFlag = 'GREEN';
                                        wrapper.sharingFlagMeaning=System.Label.get('', 'Sharing_02', userLanguage);
                                        wrapper.viewingFlagMeaning=System.Label.get('', 'Viewing02', userLanguage);
										wrapper.viewingFlag = 'GREEN';
										break; 
									}
									else{
									   wrapper.sharingFlag = 'GREEN';
									   wrapper.sharingFlagMeaning=System.Label.get('', 'Sharing_03', userLanguage);
									   wrapper.viewingFlag = 'RED'; 
                                       wrapper.viewingFlagMeaning=System.Label.get('', 'Viewing03', userLanguage);
									}
								}
							}
                        }
                        else{
							wrapper.sharingFlag = 'RED'; 
                            wrapper.viewingFlag = 'RED';
							wrapper.sharingFlagMeaning=System.Label.get('', 'Sharing_04', userLanguage);
                            wrapper.viewingFlagMeaning=System.Label.get('', 'Viewing04', userLanguage);
					    }
                    }
					else if (listContact.size() > 0) {
                        Boolean activityFound = false;
                        for (Contact con : listContact) {
                            if(con.ShowpadForSF__Showpad_Last_Activity_Date__c != null && con.ShowpadForSF__Showpad_Last_Activity_Date__c >= sixMonthsAgo && con.ShowpadForSF__Showpad_Last_Activity_Date__c <= currentDate) {
                                activityFound = true;
                                wrapper.viewingFlag = 'GREEN';
                                wrapper.sharingFlag = 'GREEN'; 
                                wrapper.viewingFlagMeaning=System.Label.get('', 'Viewing05', userLanguage);
                                wrapper.sharingFlagMeaning=System.Label.get('', 'Sharing_05', userLanguage);
                                break;
                            }  
                            else{
                                wrapper.sharingFlag = 'RED';
                                wrapper.viewingFlag = 'RED';
                                wrapper.sharingFlagMeaning=System.Label.get('', 'Sharing_07', userLanguage);
                                wrapper.viewingFlagMeaning=System.Label.get('', 'Viewing07', userLanguage);
                            }
                        }
                        if (activityFound) {
                            // check if for any of the contacts we have last view date as expected
                            for (Contact con : listContact) {
                                system.debug('>>>con'+con);
                                if (con.ShowpadForSF__Showpad_Last_View_Date__c != null && con.ShowpadForSF__Showpad_Last_View_Date__c >= threeMonthsAgo && con.ShowpadForSF__Showpad_Last_View_Date__c <= currentDate) {
                                    wrapper.sharingFlag = 'GREEN';
                                    wrapper.sharingFlagMeaning=System.Label.get('', 'Sharing_05', userLanguage);
                                    wrapper.viewingFlagMeaning=System.Label.get('', 'Viewing05', userLanguage);
                                    wrapper.viewingFlag = 'GREEN';
                                    break; 
                                }
                                else{
                                   wrapper.sharingFlag = 'GREEN';
                                   wrapper.sharingFlagMeaning=System.Label.get('', 'Sharing_06', userLanguage);
                                   wrapper.viewingFlag = 'RED'; 
                                   wrapper.viewingFlagMeaning=System.Label.get('', 'Viewing06', userLanguage);
                                }
                            }
                        }
                    }
                    else{
                        wrapper.sharingFlag = 'RED'; 
                        wrapper.viewingFlag = 'RED';
                        wrapper.sharingFlagMeaning=System.Label.get('', 'Sharing_07', userLanguage);
                        wrapper.viewingFlagMeaning=System.Label.get('', 'Viewing07', userLanguage);
                    }
                }
                else{
                    if(currAcc.Last_Visit_date__c>= twelveMonthsAgo){
						 Boolean activityFound12month = false;
						if (listContact.size() > 0) {
							for (Contact con : listContact) {
								if(con.ShowpadForSF__Showpad_Last_Activity_Date__c != null && con.ShowpadForSF__Showpad_Last_Activity_Date__c >= twelveMonthsAgo && con.ShowpadForSF__Showpad_Last_Activity_Date__c <= currentDate) {
									activityFound12month=true;
									wrapper.viewingFlag = 'GREEN';
									wrapper.sharingFlag = 'GREEN';
									wrapper.sharingFlagMeaning=System.Label.get('', 'Sharing_08', userLanguage);
                                    wrapper.viewingFlagMeaning=System.Label.get('', 'Viewing08', userLanguage);
									break;
								}  
								else{
									wrapper.sharingFlag = 'RED'; 
                                    wrapper.viewingFlag = 'RED'; 
									wrapper.sharingFlagMeaning=System.Label.get('', 'Sharing_10', userLanguage);
                                    wrapper.viewingFlagMeaning=System.Label.get('', 'Viewing10', userLanguage);
								}
						    }
						    if (activityFound12month) {
								// check if for any of the contacts we have last view date as expected
								for (Contact con : listContact) {
									if (con.ShowpadForSF__Showpad_Last_View_Date__c != null && con.ShowpadForSF__Showpad_Last_View_Date__c >= twelveMonthsAgo && con.ShowpadForSF__Showpad_Last_View_Date__c <= currentDate) {
										wrapper.sharingFlag = 'GREEN';
                                        wrapper.viewingFlag = 'GREEN';
										wrapper.sharingFlagMeaning=System.Label.get('', 'Sharing_08', userLanguage);
                                        wrapper.viewingFlagMeaning=System.Label.get('', 'Viewing08', userLanguage);
										
										break; 
									}
									else{
									   wrapper.sharingFlag = 'GREEN';
                                       wrapper.viewingFlag = 'RED';  
									   wrapper.sharingFlagMeaning=System.Label.get('', 'Sharing_09', userLanguage);
                                       wrapper.viewingFlagMeaning=System.Label.get('', 'Viewing09', userLanguage);
									   
									}
								}
							}
						}
						else{
								wrapper.sharingFlag = 'RED';
                                wrapper.viewingFlag = 'RED';
								wrapper.sharingFlagMeaning=System.Label.get('', 'Sharing_10', userLanguage);
                                wrapper.viewingFlagMeaning=System.Label.get('', 'Viewing10', userLanguage);
							}
							
                    }
					else{
						wrapper.sharingFlag = 'RED';
                        wrapper.viewingFlag = 'RED';
						wrapper.sharingFlagMeaning=System.Label.get('', 'Sharing_11', userLanguage);
                        wrapper.viewingFlagMeaning=System.Label.get('', 'Viewing11', userLanguage);
					}				
               
        }      
        // end showpad flag
        }
		
    }
	return wrapper;
	}
    public class IndicatorWrapper {
        @AuraEnabled public String presenatationFlag{get;set;}
        @AuraEnabled public String sharingFlag{get;set;}
        @AuraEnabled public String sharingFlagMeaning{get;set;}
        @AuraEnabled public String openingFlag{get;set;}
        @AuraEnabled public String viewingFlag{get;set;}
        @AuraEnabled public String viewingFlagMeaning{get;set;}
    }
}