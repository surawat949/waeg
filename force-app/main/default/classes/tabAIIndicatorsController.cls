//This class is used for Address and Statistics indicators
public without sharing class tabAIIndicatorsController {
	public class IndicatorWrapper {
        @AuraEnabled public String salesFlag{get;set;}
        @AuraEnabled public String salesFlagMeaning{get;set;}
        
        @AuraEnabled public String commitmentsFlag{get;set;}
         @AuraEnabled public String commitmentsFlagMeaning{get;set;}
        
        @AuraEnabled public String deliveriesFlag{get;set;}
        @AuraEnabled public String deliveriesFlagMeaning{get;set;}
        
        
        @AuraEnabled public String returnsFlag{get;set;}
        @AuraEnabled public String returnsFlagMeaning{get;set;}
        
        @AuraEnabled public String paymentsFlag{get;set;}
        @AuraEnabled public String paymentsFlagMeaning{get;set;}
        
        @AuraEnabled public String satisfactionFlag{get;set;}
         @AuraEnabled public String satisfactionFlagMeaning{get;set;}

        @AuraEnabled public String contactFlag{get;set;}
        @AuraEnabled public String contactMeaning{get;set;}
        
        @AuraEnabled public String competitorFlag{get;set;}
        @AuraEnabled public String competitorFlagMeaning{get;set;}
        
        @AuraEnabled public String strategicValFlag{get;set;}
        @AuraEnabled public String strategicValFlagMeaning{get;set;}
        
        
    }
     @AuraEnabled(cacheable=true)
    public static IndicatorWrapper getAIIndicators(Id receivedId,String tabName) {
        Account currAcc = [Select Id,Hoya_Account_ID__c,Strategic_Value_Gross_Sales__c,Account_Status__c,First_Competitor_local_name__c,Second_Competitor_Local_Name__c,Lenses_Net_Sales_Last_12Mo__c,Net_Promoter_Score__c,Payment_issue__c,Segmentation_Net__c,Seiko_objective_ECP_agr__c,Seiko_Network__c,Visionary_Alliance__c,
                           Strategic_Value_Net_Sales__c,Owner.CompanyName From Account WHERE id =: receivedId limit 1];
        List<Last_Sales_Statistics__c> statsList = [Select Id, Lenses_Net_Sales_Last_12Mo_vs_LFY__c,Lenses_Gross_Sales_LFY__c,Lenses_Gross_Sales_Last_12Mo__c, Lenses_Net_Sales_Last_3Mo_CFY_vs_LFY__c, Lenses_Net_Sales_Last_12Mo__c, Lenses_Net_Sales_Forecast_CFY__c, 
                                                    Total_Returns_L12Mo__c,Total_Production_Returns_L12Mo__c,Lenses_Shipment_RX_Average_Delay_3Mo__c,Uncut_Lenses_L3Mo__c,Remote_Edging_L3Mo__c,Mounting_L3Mo__c,
                                                    Lenses_Shipment_STOCK_Average_Delay_3Mo__c,Lenses_Net_Sales_LFY__c,Lenses_Net_Sales_Last_Month__c
                                                    From Last_Sales_Statistics__c Where  Account__c = :receivedId];
        IndicatorWrapper wrapper = new IndicatorWrapper();
        String userLanguage = UserInfo.getLanguage();
        
        if(currAcc.Account_Status__c == 'Closed'){
            wrapper.satisfactionFlag = 'GREY';
            
            wrapper.satisfactionFlagMeaning=System.Label.get('', 'Satisfaction01', userLanguage);
            
            wrapper.returnsFlag = 'GREY';
            wrapper.returnsFlagMeaning =System.Label.get('', 'Returns09', userLanguage);
            
            wrapper.deliveriesFlag = 'GREY';
            wrapper.deliveriesFlagMeaning=System.Label.get('', 'Deliveries01', userLanguage);
            
            
            wrapper.commitmentsFlag = 'GREY';
             wrapper.commitmentsFlagMeaning = System.Label.get('', 'Commitment01', userLanguage);
            wrapper.salesFlag = 'GREY';
            if(currAcc.Payment_issue__c){
                wrapper.paymentsFlag = 'GREYALERT';
                
                wrapper.paymentsFlagMeaning = System.Label.get('', 'Payment01', userLanguage);}
            else{
                wrapper.paymentsFlag = 'GREY';
                wrapper.paymentsFlagMeaning = System.Label.get('', 'Payment02', userLanguage);
            }    
            wrapper.contactFlag = 'GREY';
            wrapper.competitorFlag = 'GREY';
            wrapper.competitorFlagMeaning=System.Label.get('', 'Competitors01', userLanguage);
            
            wrapper.strategicValFlag = 'GREY';
             wrapper.strategicValFlagMeaning=System.Label.get('', 'Strategic_Value01', userLanguage);
            //meaning
            wrapper.contactMeaning = System.Label.get('', 'Contact01', userLanguage);
            wrapper.salesFlagMeaning = System.Label.get('', 'Sales01', userLanguage);
        }
        else{//If Account status is not closed
            if(tabName == 'Address'){
                //Satisfaction Flag
                if(currAcc.Net_Promoter_Score__c > 0 && currAcc.Net_Promoter_Score__c != null){
                    if(currAcc.Net_Promoter_Score__c < 5){
                        wrapper.satisfactionFlag = 'REDALERT';
                        
                        wrapper.satisfactionFlagMeaning = System.Label.get('', 'Satisfaction02', userLanguage);                    }
                    else if(currAcc.Net_Promoter_Score__c >= 5 && currAcc.Net_Promoter_Score__c < 7){
                        wrapper.satisfactionFlag = 'RED';
                        
                        wrapper.satisfactionFlagMeaning = System.Label.get('', 'Satisfaction03', userLanguage); 
                    }
                    else if(currAcc.Net_Promoter_Score__c >= 7 && currAcc.Net_Promoter_Score__c < 9){
                        wrapper.satisfactionFlag = 'GREENALERT';
                        
                        wrapper.satisfactionFlagMeaning = System.Label.get('', 'Satisfaction04', userLanguage); 
                    }
                    else if(currAcc.Net_Promoter_Score__c >= 9 ){
                        wrapper.satisfactionFlag = 'GREEN';
                        
                        wrapper.satisfactionFlagMeaning = System.Label.get('', 'Satisfaction05', userLanguage); 
                    }
                }
                else{
                    wrapper.satisfactionFlag = 'GREEN';
                    
                    wrapper.satisfactionFlagMeaning = System.Label.get('', 'Satisfaction06', userLanguage); 
                }
                //Payment Flag
                if (!statsList.isEmpty() && statsList[0].Lenses_Net_Sales_Last_12Mo__c > 0 ){
                    if(currAcc.Payment_issue__c){
                        if(currAcc.Account_Status__c == 'Blocked'){
                            wrapper.paymentsFlag = 'REDALERT';
                            
                            wrapper.paymentsFlagMeaning = System.Label.get('', 'Payment03', userLanguage);}
                        else{
                            wrapper.paymentsFlag = 'RED';
                            wrapper.paymentsFlagMeaning = System.Label.get('', 'Payment_04', userLanguage);}
                    }else{
                        if(currAcc.Account_Status__c == 'Blocked'){
                            wrapper.paymentsFlag = 'GREENALERT';
                            
                            wrapper.paymentsFlagMeaning = System.Label.get('', 'Payment05', userLanguage);}
                        else{
                            wrapper.paymentsFlag = 'GREEN';
                            	
                            wrapper.paymentsFlagMeaning =  System.Label.get('', 'Payment_06', userLanguage);}
                    }
                }
                else{
                    if(currAcc.Payment_issue__c){
                        if(currAcc.Account_Status__c == 'Blocked'){
                            wrapper.paymentsFlag = 'REDALERT';
                            
                            wrapper.paymentsFlagMeaning = System.Label.get('', 'Payment07', userLanguage);}
                        else{
                            wrapper.paymentsFlag = 'RED';
                            wrapper.paymentsFlagMeaning = System.Label.get('', 'Payment08', userLanguage);}
                    }
                    else{
                        wrapper.paymentsFlag = 'GREEN';
                        
                        wrapper.paymentsFlagMeaning =System.Label.get('', 'Payment09', userLanguage);
                    }
                }                
                
                //Contact Flag
               // wrapper.contactFlag = 'GREY';
               ContactWrapper tempWrapper =  methodForContactFlag(receivedId,currAcc.Lenses_Net_Sales_Last_12Mo__c);
               wrapper.contactFlag= tempWrapper.contactFlag;
                wrapper.contactMeaning = System.Label.get('', tempWrapper.contactMeaning, userLanguage);
            }    
            
            if(tabName == 'Statistics'){
            	//commitments flag
                if(!statsList.isEmpty() && statsList[0].Lenses_Net_Sales_Last_12Mo__c > 0){
                     if(currAcc.Seiko_objective_ECP_agr__c == null || currAcc.Seiko_objective_ECP_agr__c == 0){
                         if(currAcc.Seiko_Network__c == 'Seiko Vision Specialist'){
                             wrapper.CommitmentsFlag = 'REDALERT';
                             wrapper.CommitmentsFlagMeaning = System.Label.get('', 'Commitment02', userLanguage);}
                             
                         else if(currAcc.Seiko_Network__c == 'Visionary Alliance'){
                              wrapper.CommitmentsFlag = 'REDALERT';
                              wrapper.CommitmentsFlagMeaning = System.Label.get('', 'Commitment03', userLanguage);
                         }                     
                         else if(currAcc.Visionary_Alliance__c == 'none' || currAcc.Visionary_Alliance__c == null){
                              wrapper.CommitmentsFlag = 'REDALERT';
                              wrapper.CommitmentsFlagMeaning = System.Label.get('', 'Commitment04', userLanguage);
                         }
                         else
                         {
                              wrapper.CommitmentsFlag = 'RED';
                               wrapper.CommitmentsFlagMeaning = System.Label.get('', 'Commitment05', userLanguage);
                         }
                     }else{
                         if(statsList[0].Lenses_Net_Sales_Last_12Mo__c >= currAcc.Seiko_objective_ECP_agr__c ){
                             if(statsList[0].Lenses_Net_Sales_Forecast_CFY__c >= currAcc.Seiko_objective_ECP_agr__c ){
                                  wrapper.CommitmentsFlag = 'GREEN';
                                 wrapper.CommitmentsFlagMeaning = System.Label.get('', 'Commitment06', userLanguage);
                             }else{
                                 wrapper.CommitmentsFlag = 'GREENALERT';
                                 wrapper.CommitmentsFlagMeaning = System.Label.get('', 'Commitment07', userLanguage);
                             }
                         }else{
                             if(statsList[0].Lenses_Net_Sales_Forecast_CFY__c >= currAcc.Seiko_objective_ECP_agr__c ){
                                  wrapper.CommitmentsFlag = 'GREENALERT';
                                 wrapper.CommitmentsFlagMeaning = System.Label.get('', 'Commitment08', userLanguage);
                             }else{
                                 wrapper.CommitmentsFlag = 'RED';
                                 wrapper.CommitmentsFlagMeaning = System.Label.get('', 'Commitment09', userLanguage);
                             }
                         }
                     }
                }
                else{
                    if(currAcc.Seiko_objective_ECP_agr__c == null || currAcc.Seiko_objective_ECP_agr__c == 0){
                        wrapper.commitmentsFlag = 'GREEN';
                        wrapper.CommitmentsFlagMeaning = System.Label.get('', 'Commitment10', userLanguage);
                    }else{
                         wrapper.commitmentsFlag = 'REDALERT';
                        wrapper.CommitmentsFlagMeaning = System.Label.get('', 'Commitment11', userLanguage);
                    }
                }
                // StrategicValueIndicator 
                if(statsList.size() > 0){
                    if(statsList[0].Lenses_Net_Sales_Last_12Mo__c > 0 || statsList[0].Lenses_Net_Sales_LFY__c > 0){
                        if(currAcc.Hoya_Account_ID__c.startsWith('SO4900') || currAcc.Hoya_Account_ID__c.startsWith('SO4990') || 
                           currAcc.Owner.CompanyName == 'HODG'){
                           if(currAcc.Strategic_Value_Gross_Sales__c == 0 || currAcc.Strategic_Value_Gross_Sales__c==null){
                               wrapper.strategicValFlag='RED'; 
                               wrapper.strategicValFlagMeaning = System.Label.get('', 'Strategic_Value02', userLanguage);
                            }
                            else if(currAcc.Strategic_Value_Gross_Sales__c < statsList[0].Lenses_Gross_Sales_LFY__c){
                                wrapper.strategicValFlag='REDALERT';  
                                wrapper.strategicValFlagMeaning = System.Label.get('', 'StrategicValue03', userLanguage);
                            }
                            else if(currAcc.Strategic_Value_Gross_Sales__c < statsList[0].Lenses_Gross_Sales_Last_12Mo__c){
                                wrapper.strategicValFlag='REDALERT';
                                wrapper.strategicValFlagMeaning = System.Label.get('', 'StrategicValue04', userLanguage);
                            }
                            else{ wrapper.strategicValFlag='GREEN';
                                wrapper.strategicValFlagMeaning = System.Label.get('', 'StrategicValue05', userLanguage);}
                           
                         }
                        else if(currAcc.Strategic_Value_Net_Sales__c==0 || currAcc.Strategic_Value_Net_Sales__c==null){
                            wrapper.strategicValFlag='RED'; 
                            wrapper.strategicValFlagMeaning = System.Label.get('', 'StrategicValue06', userLanguage);
                        }
                        else if(currAcc.Strategic_Value_Net_Sales__c < statsList[0].Lenses_Net_Sales_LFY__c){
                            wrapper.strategicValFlag='REDALERT'; 
                            wrapper.strategicValFlagMeaning = System.Label.get('', 'StrategicValue07', userLanguage);
                        }
                        else if(currAcc.Strategic_Value_Net_Sales__c < statsList[0].Lenses_Net_Sales_Last_12Mo__c){
                            wrapper.strategicValFlag='REDALERT';   
                            wrapper.strategicValFlagMeaning = System.Label.get('', 'StrategicValue08', userLanguage);
                        }
                        else{
                           wrapper.strategicValFlag='GREEN';  
                           wrapper.strategicValFlagMeaning = System.Label.get('', 'StrategicValue09', userLanguage);
                        }
                    }
                    else{
                         if(currAcc.Hoya_Account_ID__c.startsWith('SO4900') || currAcc.Hoya_Account_ID__c.startsWith('SO4990') || 
                            currAcc.Owner.CompanyName == 'HODG'){
                                if(currAcc.Strategic_Value_Gross_Sales__c == 0 || currAcc.Strategic_Value_Gross_Sales__c ==null){
                                	wrapper.strategicValFlag='REDALERT'; 
                                    wrapper.strategicValFlagMeaning = System.Label.get('', 'StrategicValue10', userLanguage);
                                }
                                else{
                                   wrapper.strategicValFlag='GREEN'; 
                                   wrapper.strategicValFlagMeaning = System.Label.get('', 'StrategicValue11', userLanguage);
                                }
                         }
                        else if(currAcc.Strategic_Value_Net_Sales__c == 0 || currAcc.Strategic_Value_Net_Sales__c ==null){
                         	   wrapper.strategicValFlag='REDALERT'; 
                               wrapper.strategicValFlagMeaning = System.Label.get('', 'StrategicValue12', userLanguage);
                        }
                        else{
                              wrapper.strategicValFlag='GREEN'; 
                               wrapper.strategicValFlagMeaning = System.Label.get('', 'StrategicValue13', userLanguage);
                        }
                      
                    }
                }   
                else{
                    wrapper.strategicValFlag='REDALERT';
                }
                //Competitor Flag
                list<String> listOfFirstCompetitorLocalName = new List<String>();
				list<String> listOfSecondCompetitorLocalName = new List<String>();
				listOfFirstCompetitorLocalName=Utility.getPicklistValue('Account','First_Competitor_local_name__c');
				listOfSecondCompetitorLocalName=Utility.getPicklistValue('Account','Second_Competitor_Local_Name__c');
                if(currAcc.First_Competitor_local_name__c !='' && currAcc.First_Competitor_local_name__c !=null){
                    if(listOfFirstCompetitorLocalName.contains(currAcc.First_Competitor_local_name__c)){
                        wrapper.competitorFlag = 'GREEN';
                        wrapper.competitorFlagMeaning = System.Label.get('', 'Competitors02', userLanguage);
                    }
                    else{
                    	wrapper.competitorFlag = 'GREENALERT'; 
                        wrapper.competitorFlagMeaning = System.Label.get('', 'Competitors03', userLanguage);
                    }
                }else if((currAcc.Second_Competitor_Local_Name__c !='' && currAcc.Second_Competitor_Local_Name__c !=null)){
                     if(listOfSecondCompetitorLocalName.contains(currAcc.Second_Competitor_Local_Name__c)){
                        wrapper.competitorFlag = 'GREEN';
                        wrapper.competitorFlagMeaning = System.Label.get('', 'Competitors04', userLanguage); 
                    }
                    else{
                     	wrapper.competitorFlag = 'GREENALERT'; 
                        wrapper.competitorFlagMeaning = System.Label.get('', 'Competitors05', userLanguage); 
                    }
                } 
                else{
                 	wrapper.competitorFlag = 'RED'; 
                    wrapper.competitorFlagMeaning = System.Label.get('', 'Competitors06', userLanguage);
                }
            }
            //Below three comman for two tabs
            if(tabName == 'Address' || tabName == 'Statistics'){
                //Sales Flag
                if(!statsList.isEmpty() && statsList[0].Lenses_Net_Sales_LFY__c <= 0){
                    if(statsList[0].Lenses_Net_Sales_Last_12Mo__c <= 0 || statsList[0].Lenses_Net_Sales_Last_12Mo__c == null){
                        wrapper.salesFlag = 'GREY';
                         wrapper.salesFlagMeaning = System.Label.get('', 'Sales02', userLanguage);
                    }
                    else{
                        if(!statsList.isEmpty() && (statsList[0].Lenses_Net_Sales_Last_Month__c <= 0 || statsList[0].Lenses_Net_Sales_Last_Month__c == null)){
                            wrapper.salesFlag = 'REDALERT';
                             wrapper.salesFlagMeaning = System.Label.get('', 'Sales03', userLanguage);
                            
                        }
                        else{
                            wrapper.salesFlag = 'GREENALERT';
                             wrapper.salesFlagMeaning = System.Label.get('', 'Sales04', userLanguage);
                           
                        }
                    }
                }
                else{
                    if(!statsList.isEmpty() && (statsList[0].Lenses_Net_Sales_Last_Month__c <= 0 || statsList[0].Lenses_Net_Sales_Last_Month__c == null)){
                        wrapper.salesFlag = 'REDALERT';
                        wrapper.salesFlagMeaning = System.Label.get('', 'Sales05', userLanguage);
                        
                    }
                    else{
                        if(!statsList.isEmpty() && statsList[0].Lenses_Net_Sales_Last_12Mo_vs_LFY__c < 0){
                            if(statsList[0].Lenses_Net_Sales_Last_3Mo_CFY_vs_LFY__c < statsList[0].Lenses_Net_Sales_Last_12Mo_vs_LFY__c){
                                 wrapper.salesFlag = 'REDALERT';
                                wrapper.salesFlagMeaning = System.Label.get('', 'Sales06', userLanguage);
                                
                            }
                            else if(statsList[0].Lenses_Net_Sales_Last_3Mo_CFY_vs_LFY__c > 0){
                                wrapper.salesFlag = 'GREENALERT';
                                wrapper.salesFlagMeaning = System.Label.get('', 'Sales07', userLanguage);
                            }
                            else{
                                wrapper.salesFlag = 'RED';
                                 wrapper.salesFlagMeaning = System.Label.get('', 'Sales08', userLanguage);
                                
                            }
                        }
                        else{
                            if(!statsList.isEmpty()){
                                if(statsList[0].Lenses_Net_Sales_Last_3Mo_CFY_vs_LFY__c < 0){
                                    wrapper.salesFlag = 'RED';
                                    wrapper.salesFlagMeaning = System.Label.get('', 'Sales09', userLanguage);
                                    
                                }
                                else{
                                    wrapper.salesFlag = 'GREEN';
                                    wrapper.salesFlagMeaning = System.Label.get('', 'Sales10', userLanguage);
                                    
                                }
                            }
                            else{
                                wrapper.salesFlag = 'GREY';
                         		wrapper.salesFlagMeaning = System.Label.get('', 'Sales02', userLanguage);
                            }                                
                        }
                    }
                }
                
                //Returns Flag
                if(!statsList.isEmpty() && statsList[0].Lenses_Net_Sales_Last_12Mo__c > 0){    
                    if(statsList[0].Total_Returns_L12Mo__c > 5){
                        if(statsList[0].Total_Returns_L12Mo__c > 10){
                            wrapper.returnsFlag = 'REDALERT';
                            
                             wrapper.returnsFlagMeaning = System.Label.get('', 'Returns01', userLanguage);
                        }else{
                            wrapper.returnsFlag = 'RED';
                             wrapper.returnsFlagMeaning = System.Label.get('', 'Returns02', userLanguage);
                        }
                    }
                    else{
                        if(statsList[0].Total_Production_Returns_L12Mo__c > 1){
                            if(statsList[0].Total_Production_Returns_L12Mo__c > 1.5){
                                if(statsList[0].Total_Production_Returns_L12Mo__c > 2){
                                    wrapper.returnsFlag = 'REDALERT';
                                    wrapper.returnsFlagMeaning = System.Label.get('', 'Returns03', userLanguage);
                                }else{
                                    wrapper.returnsFlag = 'RED';
                                    wrapper.returnsFlagMeaning =System.Label.get('', 'Returns04', userLanguage);
                                }
                            }else{
                                wrapper.returnsFlag = 'GREENALERT';
                                wrapper.returnsFlagMeaning = System.Label.get('', 'Returns05', userLanguage);
                            }
                        }else{
                            wrapper.returnsFlag = 'GREEN';
                            wrapper.returnsFlagMeaning = System.Label.get('', 'Returns06', userLanguage);
                        }
                    }
                }
                else{
                    if(!statsList.isEmpty() && statsList[0].Total_Returns_L12Mo__c > 0){
                        wrapper.returnsFlag = 'GREYALERT';  
                        wrapper.returnsFlagMeaning = System.Label.get('', 'Returns07', userLanguage);
                    }
                    else{
                        wrapper.returnsFlag = 'GREY'; 
                        wrapper.returnsFlagMeaning = System.Label.get('', 'Returns08', userLanguage);                      
                    }
                }
                
                //Deliveries Flag
                if(!statsList.isEmpty() && statsList[0].Lenses_Shipment_RX_Average_Delay_3Mo__c != null && statsList[0].Lenses_Shipment_RX_Average_Delay_3Mo__c > 0){
                    double formulaValue = ((statsList[0].Uncut_Lenses_L3Mo__c/100) * 4)+((statsList[0].Remote_Edging_L3Mo__c/100) * 5)+((statsList[0].Mounting_L3Mo__c/100) * 6);
                    if(statsList[0].Lenses_Shipment_RX_Average_Delay_3Mo__c >= formulaValue ){
                        double value = 0;
                        if(formulaValue != null && formulaValue != 0)
                           value = statsList[0].Lenses_Shipment_RX_Average_Delay_3Mo__c/formulaValue;
                        if(value >= 1.3){
                            wrapper.deliveriesFlag = 'REDALERT';
                            
                            wrapper.deliveriesFlagMeaning = System.Label.get('', 'Deliveries02', userLanguage); }
                        else{
                            wrapper.deliveriesFlag = 'RED';
                            wrapper.deliveriesFlagMeaning = System.Label.get('', 'Deliveries03', userLanguage);
                        }
                        
                    }
                    else{
                        if(statsList[0].Lenses_Shipment_STOCK_Average_Delay_3Mo__c !=null && statsList[0].Lenses_Shipment_STOCK_Average_Delay_3Mo__c > 0){
                            if(statsList[0].Lenses_Shipment_STOCK_Average_Delay_3Mo__c >= 2){
                                wrapper.deliveriesFlag = 'REDALERT';
                                wrapper.deliveriesFlagMeaning= System.Label.get('', 'Deliveries04', userLanguage);}
                            else if(statsList[0].Lenses_Shipment_STOCK_Average_Delay_3Mo__c >= 1.5){
                                wrapper.deliveriesFlag = 'RED';
                                wrapper.deliveriesFlagMeaning= System.Label.get('', 'Deliveries05', userLanguage);
                            }
                            else if(statsList[0].Lenses_Shipment_STOCK_Average_Delay_3Mo__c >= 1){
                                wrapper.deliveriesFlag = 'GREENALERT';
                                wrapper.deliveriesFlagMeaning= System.Label.get('', 'Deliveries06', userLanguage);
                            }
                            else{
                                wrapper.deliveriesFlag = 'GREEN';
                                wrapper.deliveriesFlagMeaning= System.Label.get('', 'Deliveries13', userLanguage);
                            }                       
                        }
                        else{
                            wrapper.deliveriesFlag = 'GREEN';
							wrapper.deliveriesFlagMeaning=System.Label.get('', 'Deliveries07', userLanguage);}
                    }
                }
                else{
                    if(!statsList.isEmpty() && statsList[0].Lenses_Shipment_STOCK_Average_Delay_3Mo__c != null && statsList[0].Lenses_Shipment_STOCK_Average_Delay_3Mo__c > 0){
                        if(statsList[0].Lenses_Shipment_STOCK_Average_Delay_3Mo__c >= 2){
                            wrapper.deliveriesFlag = 'REDALERT';
                            
                            wrapper.deliveriesFlagMeaning= System.Label.get('', 'Deliveries08', userLanguage);
                        }
                        else if(statsList[0].Lenses_Shipment_STOCK_Average_Delay_3Mo__c >= 1.5){
                            wrapper.deliveriesFlag = 'RED';
                             wrapper.deliveriesFlagMeaning= System.Label.get('', 'Deliveries09', userLanguage);
                        }
                        else if(statsList[0].Lenses_Shipment_STOCK_Average_Delay_3Mo__c >= 1){
                            wrapper.deliveriesFlag = 'GREENALERT';
                            wrapper.deliveriesFlagMeaning=System.Label.get('', 'Deliveries10', userLanguage);
                        }
                        else{
                            wrapper.deliveriesFlag = 'GREEN';
                            wrapper.deliveriesFlagMeaning=System.Label.get('', 'Deliveries11', userLanguage);
                        }
                    }
                    else{
                        wrapper.deliveriesFlag = 'GREEN';
                        wrapper.deliveriesFlagMeaning= System.Label.get('', 'Deliveries12', userLanguage);
                    }                
                }
            }
        }//If account status is not closed
        return wrapper;
    }
	public static ContactWrapper methodForContactFlag(Id accId, Decimal lensesNetSalesLast12Mo){
        list<Contact> listOfContact = [SELECT ID, AccountId,Contact_Record_Type__c,Salutation,FirstName,LastName 
                                       FROM Contact WHERE AccountId =: accId 
                                      ];
        List<String> listOfFirstAndLastName = new List<String>(new String[] {'X','XX','XXX','XXXX','Y',
            'YY','YYY','YYYY','Z','ZZ','ZZZ','ZZZZ','?','??','???','????'});
        list<String> listOfFirstName = new list<String>(); 
        list<String> listOfLastName = new list<String>(); 
        String contactFlag;
        ContactWrapper tempWrapper = new ContactWrapper();
        Boolean shopOwnerFound = false;
        if(listOfContact.size()>0){
            for (Contact conObj : listOfContact) {
                if(conObj.Contact_Record_Type__c == 'Shop Owner'){
                    shopOwnerFound = true;
                    break;
                }
            }
                
            if(shopOwnerFound){
                for (Contact conObj : listOfContact) {
                    If (listOfFirstAndLastName.contains(conObj.FirstName) || listOfFirstAndLastName.contains(conObj.LastName) ||
                        conObj.FirstName == conObj.LastName || (conObj.Salutation =='' || conObj.Salutation == null || conObj.LastName == null || conObj.FirstName == null)
                    ) {
                        tempWrapper.contactFlag = 'REDALERT'; 
                        tempWrapper.contactMeaning = 'Contact03';
                        contactFlag = 'REDALERT'; 
                        break;
                    }
                    else{
                        tempWrapper.contactFlag = 'GREEN'; 
                        tempWrapper.contactMeaning = 'Contact02'; 
                        contactFlag = 'GREEN'; 
                    }
                }
            }
            else{
                for (Contact conObj : listOfContact) {
                    If (listOfFirstAndLastName.contains(conObj.FirstName) || listOfFirstAndLastName.contains(conObj.LastName) ||
                        conObj.FirstName == conObj.LastName || (conObj.Salutation == '' || conObj.Salutation == null || conObj.LastName == null || conObj.FirstName == null) || conObj.Contact_Record_Type__c =='') {
                        tempWrapper.contactFlag = 'REDALERT'; 
                        tempWrapper.contactMeaning = 'Contact03';
                        contactFlag = 'REDALERT'; 
                            break;
                    }
                    else{
                        tempWrapper.contactFlag = 'GREENALERT';
                        tempWrapper.contactMeaning = 'Contact04';  
                        contactFlag = 'GREENALERT'; 
                    }
                }
            }
        }
        else{
            if(lensesNetSalesLast12Mo>0){
                tempWrapper.contactFlag = 'REDALERT'; 
                tempWrapper.contactMeaning = 'Contact06';      
            	contactFlag = 'REDALERT';       
            } 
            else{
                tempWrapper.contactFlag = 'RED';  
                tempWrapper.contactMeaning = 'Contact07';
                contactFlag = 'RED';  
            }
        }
        return tempWrapper;
    }

    public class ContactWrapper {
        public String contactFlag;
        public String contactMeaning;
    }
	

}