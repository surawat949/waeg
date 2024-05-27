public class tabActivationPortalRegistrationIndicator {
    @AuraEnabled(cacheable=true)
	public static IndicatorWrapper getAIIndicators(Id recordId) {
		IndicatorWrapper wrapper = new IndicatorWrapper();
		String userLanguage = UserInfo.getLanguage();
		DateTime currentDate = DateTime.now();
		Date sixMonthsAgo = Date.valueOf(currentDate.addMonths(-6));
		Date threeMontsAgo = Date.valueOf(currentDate.addMonths(-3));
        Date oneMontsAgo = Date.valueOf(currentDate.addMonths(-1));
        
        ID accountEndConsumerRecId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('End_Consumer_Account').getRecordTypeId();
        ID subscriptionRecId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Subscription').getRecordTypeId();
		ID shopOwnerRecId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Shop_Owner').getRecordTypeId();
	    ID consumerContactRecId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('End_Consumer').getRecordTypeId();

		Boolean PurchaseReg_Email_Flag = false; //for Purchase Registration Email Flag
        Boolean loyalty_Email_Flag = false;//for Loyalty Program Emails Activation Flag


		Account currAcc  = [Select Id,Account_Status__c,Portal__c,Language__c,Brand_Visibility__c,Catalog_name__c,Brand__c,Account_Number_ILog__c,
                          Lenses_Net_Sales_Last_12Mo__c,CHCUSTCLASSIFICATIONID__c, Seiko_Network__c 
                          From Account WHERE id =: recordId limit 1];
        List<Account> childAcc  = [Select Id,parentId
                             From Account WHERE parentId =: currAcc.id AND recordTypeId =: accountEndConsumerRecId limit 1];
        list<Contact> childContact = new list<Contact>();
        if(childAcc.size()>0){
          childContact  =[SELECT ID,CreatedDate
                                      FROM Contact WHERE AccountId=: childAcc[0].Id AND recordTypeId=:consumerContactRecId];
        }
        System.debug('>>>'+childContact);
		list<New_Media_Usage__c> listOfNewMedia= [SELECT Id,Tool__c,Transaction_date_field__c 
                                                 FROM New_Media_Usage__c WHERE 
                                                  Hoya_Account_ID__c =:recordId And Transaction_date_field__c>=:sixMonthsAgo
                                                  And (Tool__c ='SXN Orders' OR Tool__c='HoyaiLog orders')];
												  
		List<New_Media_Usage__c> listNewMedia_PurchaseReg = [SELECT Id, Tool__c, Transaction_date_field__c, 
                                                                Hoya_Account_ID__c FROM New_Media_Usage__c 
                                                                WHERE (Hoya_Account_ID__c=:recordId) AND (Tool__c = 'Purchase Registrations')];
																
		List<Contact> listContact = [SELECT ID,AccountId,Subscription_Type__c,
                                    Email,Active_Subscription__c,Sync_to_Pardot__c,RecordTypeId 
                                    FROM Contact WHERE AccountId=: recordId 
                                    AND RecordTypeId=: subscriptionRecId AND Email !='' and Subscription_Type__c = 'Track and Trace' And
                                    Active_Subscription__c =true And Sync_to_Pardot__c = 'Yes'];
									
		List<Contact> listOfContact1 = [SELECT ID,AccountId,RecordTypeId,Portal_User_Name__c,Send_Registration_Email_Flag__c FROM Contact 
                                     WHERE AccountId=: recordId];
		
		Seiko_Data__c[] Seiko_Sales = [SELECT Id, Account__c, Purchase_Registration_Email_Activation__c,Loyalty_Program_Emails_Activation__c
                                        FROM Seiko_Data__c WHERE Account__c =: recordId LIMIT 1];
        system.debug('>>>'+Seiko_Sales);
        if(Seiko_Sales.size() > 0){
            PurchaseReg_Email_Flag = Seiko_Sales[0].Purchase_Registration_Email_Activation__c;
        }
        if(Seiko_Sales.size() > 0){
            loyalty_Email_Flag = Seiko_Sales[0].Loyalty_Program_Emails_Activation__c;
        }
         system.debug('>>>PurchaseReg_Email_Flag'+PurchaseReg_Email_Flag);
									 
		if (currAcc.Account_Status__c == 'Closed') {
				wrapper.trackTraceFlag = 'GREY'; 
				wrapper.trackTraceFlagMeaning=System.Label.get('', 'Track_Trace_01', userLanguage);
				wrapper.iLogFlag = 'GREY'; 
				wrapper.iLogFlagMeaning=System.Label.get('', 'iLog01', userLanguage);
				wrapper.registrationFlag = 'GREY';   
				wrapper.registrationFlagMeaning=System.Label.get('', 'Registration01', userLanguage);
				wrapper.PurchaseRegFlag = 'GREY';
				wrapper.PurchaseRegFlagMeaning = System.Label.get('', 'Purchase_Reg01', userLanguage);
               
        }else{
			
			//Purchase Registration Flag
            Boolean NewMediaPurchaseReg = false;
            system.debug('>>>>listNewMedia_PurchaseReg'+listNewMedia_PurchaseReg);
            if(listNewMedia_PurchaseReg.size() > 0){
                NewMediaPurchaseReg = true;
            }

            if(currAcc.Brand__c == 'SEIKO'){
                if(currAcc.Seiko_Network__c == 'Seiko Vision Specialist'){
                    if(PurchaseReg_Email_Flag == true){
                        system.debug('>>>NewMediaPurchaseReg'+NewMediaPurchaseReg);
                        if(NewMediaPurchaseReg == true){
                            //flag for Three months record if found
                            Boolean IsThreeMonths = false;
                            for(New_Media_Usage__c newMedia : listNewMedia_PurchaseReg){
                                if(newMedia.Transaction_date_field__c >= threeMontsAgo && newMedia.Transaction_date_field__c!=null && newMedia.Transaction_date_field__c <= currentDate){
                                    IsThreeMonths = true;
                                    wrapper.PurchaseRegFlag = 'GREEN';
                                    wrapper.PurchaseRegFlagMeaning = System.Label.get('', 'Purchase_Reg02', userLanguage);
                                    break;
                                }
                            }
                            
                            if(!IsThreeMonths){
                                for(New_Media_Usage__c newMedia : listNewMedia_PurchaseReg){
                                    if(newMedia.Transaction_date_field__c >= sixMonthsAgo && newMedia.Transaction_date_field__c!=null && newMedia.Transaction_date_field__c<=currentDate){
                                        wrapper.PurchaseRegFlag = 'GREENALERT';
                                        wrapper.PurchaseRegFlagMeaning = System.Label.get('', 'Purchase_Reg03', userLanguage);
                                        break;
                                    }else{
                                        wrapper.PurchaseRegFlag = 'REDALERT';
                                        wrapper.PurchaseRegFlagMeaning = System.Label.get('', 'Purchase_Reg04', userLanguage);
                                    }
                                }
                            }
                            
                        }else{
                            wrapper.PurchaseRegFlag = 'RED';
                            wrapper.PurchaseRegFlagMeaning = System.Label.get('', 'Purchase_Reg05', userLanguage);
                        }
                    }else{
                        wrapper.PurchaseRegFlag = 'REDALERT';
                        wrapper.PurchaseRegFlagMeaning = System.Label.get('', 'Purchase_Reg06', userLanguage);
                    }
                }else{
                    if(NewMediaPurchaseReg == true){
                        wrapper.PurchaseRegFlag = 'GREENALERT';
                        wrapper.PurchaseRegFlagMeaning = System.Label.get('', 'Purchase_Reg07', userLanguage);
                    }else{
                        wrapper.PurchaseRegFlag = 'GREEN';
                        wrapper.PurchaseRegFlagMeaning = System.Label.get('', 'Purchase_Reg08', userLanguage);
                    }
                }
            }else{
                wrapper.PurchaseRegFlag = 'GREY';
                wrapper.PurchaseRegFlagMeaning = System.Label.get('', 'Purchase_Reg09', userLanguage);
            }
			
			//track flag
			if (listContact.size() > 0) {
               wrapper.trackTraceFlag = 'GREEN';   
               wrapper.trackTraceFlagMeaning=System.Label.get('', 'Track_Trace_02', userLanguage);
               
			} 
			else{
               if(currAcc.Lenses_Net_Sales_Last_12Mo__c>0){
                   if(currAcc.CHCUSTCLASSIFICATIONID__c =='Ind'){
                       wrapper.trackTraceFlag = 'REDALERT';   
                       wrapper.trackTraceFlagMeaning=System.Label.get('', 'Track_Trace_03', userLanguage);
                       
                   } 
                   else{
                       wrapper.trackTraceFlag = 'RED';   
                      
                       wrapper.trackTraceFlagMeaning=System.Label.get('', 'Track_Trace_04', userLanguage);
                       

                   }
               }
               else{
                   wrapper.trackTraceFlag = 'GREEN';   
                   wrapper.trackTraceFlagMeaning=System.Label.get('', 'Track_Trace_05', userLanguage);
                   
               }
           }
           //ilogFlag
           Date twoMonthsAgo = Date.valueOf(currentDate.addMonths(-2));
           boolean newMedaiFound=false;    
            if(currAcc.Catalog_name__c !='' && currAcc.Catalog_name__c != null){
                if(currAcc.Brand__c !='' && currAcc.Brand__c != null){
                    if(currAcc.Account_Number_ILog__c !='' && currAcc.Account_Number_ILog__c !=null){
                        if(listOfNewMedia.size()>0){
                            newMedaiFound=true;
                        }
                        else{
                            wrapper.iLogFlag = 'REDALERT'; 
                            wrapper.iLogFlagMeaning=System.Label.get('', 'iLog04', userLanguage);       
                        }
                        if(newMedaiFound){
                                for(New_Media_Usage__c newMediaObj : listOfNewMedia){
									if(newMediaObj.Transaction_date_field__c >=twoMonthsAgo && newMediaObj.Transaction_date_field__c !=null &&  newMediaObj.Transaction_date_field__c<= Date.valueOf(currentDate)){
										wrapper.iLogFlag = 'GREEN';   
										wrapper.iLogFlagMeaning=System.Label.get('', 'iLog02', userLanguage);
										break;
									}
									else{
										wrapper.iLogFlag = 'GREENALERT';   
										wrapper.iLogFlagMeaning=System.Label.get('', 'iLog03', userLanguage);      
									}
                                }      
                        }
                        else{
                            wrapper.iLogFlag = 'REDALERT'; 
                            wrapper.iLogFlagMeaning=System.Label.get('', 'iLog04', userLanguage);       
                        }
                    }
                     else{
                       wrapper.iLogFlag = 'RED';   
                       wrapper.iLogFlagMeaning=System.Label.get('', 'iLog05', userLanguage);    
                    }
                   
                }
                else{
                   wrapper.iLogFlag = 'RED';   
                   wrapper.iLogFlagMeaning=System.Label.get('', 'iLog06', userLanguage); 
                }
            }    
            else{
				wrapper.iLogFlag = 'RED';   
				wrapper.iLogFlagMeaning=System.Label.get('', 'iLog07', userLanguage);  
            }
            //Registration flag is start 
            Boolean showIfPart=false;
            for(Contact con : listOfContact1){
                if(con.RecordtypeId==shopOwnerRecId && con.Portal_User_Name__c!=null && con.Portal_User_Name__c!=''){
                        showIfPart=true;
                        break;
				}	
            }				
            if(showIfPart){    
					if(currAcc.Portal__c!='' && currAcc.Portal__c !=null){
                      	if(currAcc.Language__c!='' && currAcc.Language__c !=null){  
                            if(currAcc.Brand_Visibility__c!='' && currAcc.Brand_Visibility__c !=null){
                                wrapper.registrationFlag = 'GREEN';   
                                wrapper.registrationFlagMeaning=System.Label.get('', 'Registration02', userLanguage); 
                            }								
                            else{
                                wrapper.registrationFlag = 'REDALERT';   
                                wrapper.registrationFlagMeaning=System.Label.get('', 'Registration03', userLanguage);    
                            } 
                        }
                        else{
                            wrapper.registrationFlag = 'REDALERT';   
                            wrapper.registrationFlagMeaning=System.Label.get('', 'Registration04', userLanguage);     
                        } 
                    }    
                    else{
                        wrapper.registrationFlag = 'REDALERT';   
                        wrapper.registrationFlagMeaning=System.Label.get('', 'Registration05', userLanguage);     
                    }
            }
            else{
                if(currAcc.Portal__c!='' && currAcc.Portal__c !=null){
                    if(currAcc.Language__c!='' && currAcc.Language__c !=null){
                        if(currAcc.Brand_Visibility__c!='' && currAcc.Brand_Visibility__c !=null){
                            if(listOfContact1.size()>0){
                               for(Contact con : listOfContact1){
                                   if(con.RecordtypeId==shopOwnerRecId && con.Send_Registration_Email_Flag__c==true){
                                       wrapper.registrationFlag = 'REDALERT';   
                                       wrapper.registrationFlagMeaning=System.Label.get('', 'Registration06', userLanguage);
                                       break;
                                   }
                                    else{
                                       wrapper.registrationFlag = 'RED';   
                                       wrapper.registrationFlagMeaning=System.Label.get('', 'Registration07', userLanguage);
                                    }    
                                }   
                            }
                            else{
                               wrapper.registrationFlag = 'RED';   
                               wrapper.registrationFlagMeaning=System.Label.get('', 'Registration07', userLanguage);        
                            }
                        }
                        else{
                           wrapper.registrationFlag = 'RED';   
                           wrapper.registrationFlagMeaning=System.Label.get('', 'Registration08', userLanguage);     
                        }
                    }
                    else{
                        wrapper.registrationFlag = 'RED';   
                        wrapper.registrationFlagMeaning=System.Label.get('', 'Registration09', userLanguage); 
                    }
                }
                else{
                   wrapper.registrationFlag = 'RED';   
                   wrapper.registrationFlagMeaning=System.Label.get('', 'Registration10', userLanguage);  
                }
            }
            //Loyalty Program
            boolean threemonthsAgo=false;
            if(currAcc.Brand__c == 'SEIKO'){
                if(currAcc.Seiko_Network__c =='Seiko Vision Specialist'){
                    if(loyalty_Email_Flag){
                        system.debug('>>>'+childContact);
                        if(childContact.size()>0){
                            for(Contact con : childContact){
                                if(con.CreatedDate >= oneMontsAgo){
                                    wrapper.loyaltyFlag = 'GREEN'; 
                                    threemonthsAgo=true;
                                    wrapper.loyaltyFlagMeaning=System.Label.get('', 'Loyalty02', userLanguage);
                                    break;    
                                }
                            }  
                            if(!threemonthsAgo){
							    for(Contact con : childContact){
                                   if(con.CreatedDate >= threeMontsAgo){
										wrapper.loyaltyFlag = 'GREENALERT';   
										wrapper.loyaltyFlagMeaning=System.Label.get('', 'Loyalty03', userLanguage);
										break;    
                                    }
                                    else{
                                        wrapper.loyaltyFlag = 'REDALERT';   
                                        wrapper.loyaltyFlagMeaning=System.Label.get('', 'Loyalty04', userLanguage);
                                        break;     
                                    }
						        }			
                            }
                                        
                        }
						else{
							wrapper.loyaltyFlag = 'REDALERT';
							wrapper.loyaltyFlagMeaning = System.Label.get('', 'Loyalty05', userLanguage);  
                        }
                    }
                    else{
						wrapper.loyaltyFlag = 'RED';
						wrapper.loyaltyFlagMeaning = System.Label.get('', 'Loyalty06', userLanguage); 
                    }
                }
                else{
                    if(loyalty_Email_Flag){
                        wrapper.loyaltyFlag = 'REDALERT';
                        wrapper.loyaltyFlagMeaning = System.Label.get('', 'Loyalty07', userLanguage); 
                    }
                    else{
                        wrapper.loyaltyFlag = 'GREEN';
                        wrapper.loyaltyFlagMeaning = System.Label.get('', 'Loyalty08', userLanguage);
                    }
                }
            }   
            else{
                wrapper.loyaltyFlag = 'GREY';
                wrapper.loyaltyFlagMeaning = System.Label.get('', 'Purchase_Reg09', userLanguage);
            }
        }			
        system.debug(wrapper);
         return wrapper;
    }
	public class IndicatorWrapper {
       @AuraEnabled public String trackTraceFlag{get;set;}
       @AuraEnabled public String trackTraceFlagMeaning{get;set;}
       @AuraEnabled public String iLogFlag{get;set;}
       @AuraEnabled public String iLogFlagMeaning{get;set;}
       @AuraEnabled public String registrationFlag{get;set;}
       @AuraEnabled public String registrationFlagMeaning{get;set;}
       @AuraEnabled public String PurchaseRegFlag{get;set;}
       @AuraEnabled public String PurchaseRegFlagMeaning{get;set;}
       @AuraEnabled public String loyaltyFlag{get;set;}
       @AuraEnabled public String loyaltyFlagMeaning{get;set;} 
      
	}
}