public class CaseTriggerHelper {
    /**
    * This method calculates time spent on old status value after case status is changed
    */
    public static void processTimeSpent(List<case> newList, Map<Id, case> newMap, List<case> oldList, Map<Id, case> oldMap) {
        List<String> all_new = new List<String>{'neu','new', 'arrived'};
        List<String> all_InProgress = new List<String>{'in progress', 'servizio tecnico', 'customer service', 'processing', 'investigation'};
        List<String> all_Escalated = new List<String>{'eskaliert', 'escalated'};
        List<String> all_OnHold = new List<String>{'in warteschleife', 'solution follow up', 'on hold'};
        for (Case eachCase : newList) {
            if (newMap.get(eachCase.Id).Status != oldMap.get(eachCase.Id).Status) {
                Datetime lastChanged  = oldMap.get(eachCase.Id).Last_Status_Change_Time__c;
                if (lastChanged != null) {
                 	Long lastChangeMilis = lastChanged.getTime();
                    Long changeInMillis = Datetime.now().getTime() - lastChangeMilis;
                    Long seconds = changeInMillis / 1000;
                    Decimal minutes = seconds / 60;
                    System.debug('++' + minutes);
                    Decimal hours = minutes / 60;
                    System.debug('++2' + hours);
                    String oldStatus = oldMap.get(eachCase.Id).Status;
                    if (all_new.contains(oldStatus.toLowerCase())) {
                        if (oldMap.get(eachCase.Id).Hours_Spent_New__c == null) {
                            eachCase.Hours_Spent_New__c = hours;
                        } else {
                            eachCase.Hours_Spent_New__c = oldMap.get(eachCase.Id).Hours_Spent_New__c + hours;
                        }
                    } else if (all_InProgress.contains(oldStatus.toLowerCase())) {
                        if (oldMap.get(eachCase.Id).Hours_Spent_In_Progress__c == null) {
                            eachCase.Hours_Spent_In_Progress__c = hours;
                        } else {
                            eachCase.Hours_Spent_In_Progress__c = oldMap.get(eachCase.Id).Hours_Spent_In_Progress__c + hours;
                        }
                    } else if (all_Escalated.contains(oldStatus.toLowerCase())) {
                        if (oldMap.get(eachCase.Id).Hours_Spent_Escalated__c == null) {
                            eachCase.Hours_Spent_Escalated__c = hours;
                        } else {
                            eachCase.Hours_Spent_Escalated__c = oldMap.get(eachCase.Id).Hours_Spent_Escalated__c + hours;
                        }
                    } else if (all_OnHold.contains(oldStatus.toLowerCase())) {
                        if (oldMap.get(eachCase.Id).Hours_Spent_On_Hold__c == null) {
                          eachCase.Hours_Spent_On_Hold__c = hours;
                        } else {
                            eachCase.Hours_Spent_On_Hold__c = oldMap.get(eachCase.Id).Hours_Spent_On_Hold__c + hours;
                        }
                    }   
                }
                eachCase.Last_Status_Change_Time__c = Datetime.now();
            }
        }
    }
}