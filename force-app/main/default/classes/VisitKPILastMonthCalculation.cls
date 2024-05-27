public without sharing class VisitKPILastMonthCalculation {

    // Method to calculate and store aggregated values
    public static void calculateAndStoreKPI(Map<Id,VISIT_KPI__c> mapOfUserIdKpiRecords,Boolean isKpiInsert,Boolean isKpiUpdate,Map<Id,VISIT_KPI__c> mapOfUserIdOldKpiRecords) {
       // Get the start dates for the last 3 months, 6 months, and 12 months
        Date startDate3Months = Date.today().toStartOfMonth().addMonths(-3);
        Date startDate6Months = Date.today().toStartOfMonth().addMonths(-6);
        Date startDate12Months = Date.today().toStartOfMonth().addMonths(-12);
        
        // Query aggregated values for last 3 months grouped by Area_Sales_Manager__c
        AggregateResult[] results3Months = [SELECT 
                Area_Sales_Manager__c areaSM,
                SUM(Digital_Visits_completed__c) digitalVisitsCompleted,
                SUM(Individual_Digital_Days_in_Field__c) digitalDaysInField,
                SUM(Visits_completed__c) directVisitsCompleted,
                SUM(Individual_Days_in_Field__c) directDaysInField,
                SUM(Sum_of_Visits_Days_in_Field__c) totalDaysInField
            FROM 
                VISIT_KPI__c
            WHERE 
                Date__c >= :startDate3Months
            GROUP BY 
                Area_Sales_Manager__c];

        // Query aggregated values for last 6 months grouped by Area_Sales_Manager__c
        AggregateResult[] results6Months = [SELECT 
                Area_Sales_Manager__c areaSM,
                SUM(Digital_Visits_completed__c) digitalVisitsCompleted,
                SUM(Individual_Digital_Days_in_Field__c) digitalDaysInField,
                SUM(Visits_completed__c) directVisitsCompleted,
                SUM(Individual_Days_in_Field__c) directDaysInField,
                SUM(Sum_of_Visits_Days_in_Field__c) totalDaysInField
            FROM 
                VISIT_KPI__c
            WHERE 
                Date__c >= :startDate6Months
            GROUP BY 
                Area_Sales_Manager__c];

        // Query aggregated values for last 12 months grouped by Area_Sales_Manager__c
        List<AggregateResult> results12Months = [
            SELECT 
                Area_Sales_Manager__c areaSM,
                SUM(Digital_Visits_completed__c) digitalVisitsCompleted,
                SUM(Individual_Digital_Days_in_Field__c) digitalDaysInField,
                SUM(Visits_completed__c) directVisitsCompleted,
                SUM(Individual_Days_in_Field__c) directDaysInField,
                SUM(Sum_of_Visits_Days_in_Field__c) totalDaysInField
            FROM 
                VISIT_KPI__c
            WHERE 
                Date__c >= :startDate12Months
            GROUP BY 
                Area_Sales_Manager__c
        ];
         
        if(isKpiInsert){         
        // Create Visit KPI records for last 3 months
        createVisitKPIRecords(results3Months,3,mapOfUserIdKpiRecords);

        // Create Visit KPI records for last 6 months
        createVisitKPIRecords(results6Months,6,mapOfUserIdKpiRecords);
        
        // Create Visit KPI records for last 12 months
        createVisitKPIRecords(results12Months,12,mapOfUserIdKpiRecords);
        }
        
        if(isKpiUpdate) {
        // Create Visit KPI records for last 3 months
        updateVisitKPIRecords(results3Months,3,mapOfUserIdKpiRecords,mapOfUserIdOldKpiRecords);

        // Create Visit KPI records for last 6 months
        updateVisitKPIRecords(results6Months,6,mapOfUserIdKpiRecords,mapOfUserIdOldKpiRecords);
        
        // Create Visit KPI records for last 12 months
        updateVisitKPIRecords(results12Months,12,mapOfUserIdKpiRecords,mapOfUserIdOldKpiRecords);       
        }
    }
    
    public static void createVisitKPIRecords(List<AggregateResult> results, Integer months,Map<Id,VISIT_KPI__c> mapOfUserIdKpiRecords) {
          List<Visit_KPI__c> kpiRecords = new List<Visit_KPI__c>();       
           for (AggregateResult result : results) {        
            Visit_KPI__c kpiRecord=mapOfUserIdKpiRecords.get((String)result.get('areaSM'));
            if(kpiRecord!= null)
           {           
            if(months == 3){
            kpiRecord.Digital_Visits_Completed_L3Mo__c =  kpiRecord.Digital_Visits_completed__c+(Decimal)result.get('digitalVisitsCompleted');
            kpiRecord.Digital_Visits_Days_in_Field_L3Mo__c = kpiRecord.Individual_Digital_Days_in_Field__c+(Decimal)result.get('digitalDaysInField');
            kpiRecord.Direct_Visits_Completed_L3Mo__c =      kpiRecord.Visits_completed__c+(Decimal)result.get('directVisitsCompleted');
            kpiRecord.Direct_Visits_Days_in_Field_L3Mo__c = kpiRecord.Individual_Days_in_Field__c+(Decimal)result.get('directDaysInField');
            kpiRecord.Sum_of_Visits_Days_in_Field_L3Mo__c = kpiRecord.Sum_of_Visits_Days_in_Field__c+(Decimal)result.get('totalDaysInField');
            }
            
            if(months == 6){
            kpiRecord.Digital_Visits_Completed_L6Mo__c = kpiRecord.Digital_Visits_completed__c+(Decimal)result.get('digitalVisitsCompleted');
            kpiRecord.Digital_Visits_Days_in_Field_L6Mo__c = kpiRecord.Individual_Digital_Days_in_Field__c+(Decimal)result.get('digitalDaysInField');
            kpiRecord.Direct_Visits_Completed_L6Mo__c = kpiRecord.Visits_completed__c+(Decimal)result.get('directVisitsCompleted');
            kpiRecord.Direct_Visits_Days_in_Field_L6Mo__c = kpiRecord.Individual_Days_in_Field__c+(Decimal)result.get('directDaysInField'); 
            kpiRecord.Sum_of_Visits_Days_in_Field_L6Mo__c = kpiRecord.Sum_of_Visits_Days_in_Field__c+(Decimal)result.get('totalDaysInField');           
            }
            
            if(months == 12){
            kpiRecord.Digital_Visits_Completed_L12Mo__c = kpiRecord.Digital_Visits_completed__c+(Decimal)result.get('digitalVisitsCompleted');
            kpiRecord.Digital_Visits_Days_in_Field_L12Mo__c = kpiRecord.Individual_Digital_Days_in_Field__c+(Decimal)result.get('digitalDaysInField');
            kpiRecord.Direct_Visits_Completed_L12Mo__c = kpiRecord.Visits_completed__c+(Decimal)result.get('directVisitsCompleted');
            kpiRecord.Direct_Visits_Days_in_Field_L12Mo__c = kpiRecord.Individual_Days_in_Field__c+(Decimal)result.get('directDaysInField');  
            kpiRecord.Sum_of_Visits_Days_in_Field_L12Mo__c = kpiRecord.Sum_of_Visits_Days_in_Field__c+(Decimal)result.get('totalDaysInField');           
            }
            
           } 
        }    
    }
    
    
     public static void updateVisitKPIRecords(List<AggregateResult> results, Integer months,Map<Id,VISIT_KPI__c> mapOfUserIdKpiRecords,Map<Id,VISIT_KPI__c> mapOfUserIdOldKpiRecords) {
          List<Visit_KPI__c> kpiRecords = new List<Visit_KPI__c>();       
           for (AggregateResult result : results) {        
            Visit_KPI__c kpiRecord=mapOfUserIdKpiRecords.get((String)result.get('areaSM'));
            Visit_KPI__c oldkpiRecord=mapOfUserIdOldKpiRecords.get((String)result.get('areaSM'));

          if(kpiRecord!= null)
          {           
             if (months == 3) {
                kpiRecord.Digital_Visits_Completed_L3Mo__c = calculateUpdatedValue(oldkpiRecord.Digital_Visits_completed__c, kpiRecord.Digital_Visits_completed__c, (Decimal) result.get('digitalVisitsCompleted'));
                kpiRecord.Digital_Visits_Days_in_Field_L3Mo__c = calculateUpdatedValue(oldkpiRecord.Individual_Digital_Days_in_Field__c, kpiRecord.Individual_Digital_Days_in_Field__c, (Decimal) result.get('digitalDaysInField'));
                kpiRecord.Direct_Visits_Completed_L3Mo__c = calculateUpdatedValue(oldkpiRecord.Visits_completed__c, kpiRecord.Visits_completed__c, (Decimal) result.get('directVisitsCompleted'));
                kpiRecord.Direct_Visits_Days_in_Field_L3Mo__c = calculateUpdatedValue(oldkpiRecord.Individual_Days_in_Field__c, kpiRecord.Individual_Days_in_Field__c, (Decimal) result.get('directDaysInField'));
                kpiRecord.Sum_of_Visits_Days_in_Field_L3Mo__c = calculateUpdatedValue(oldkpiRecord.Sum_of_Visits_Days_in_Field__c, kpiRecord.Sum_of_Visits_Days_in_Field__c, (Decimal) result.get('totalDaysInField'));
            }
            
             if (months == 6) {
                kpiRecord.Digital_Visits_Completed_L6Mo__c = calculateUpdatedValue(oldkpiRecord.Digital_Visits_completed__c, kpiRecord.Digital_Visits_completed__c, (Decimal) result.get('digitalVisitsCompleted'));
                kpiRecord.Digital_Visits_Days_in_Field_L6Mo__c = calculateUpdatedValue(oldkpiRecord.Individual_Digital_Days_in_Field__c, kpiRecord.Individual_Digital_Days_in_Field__c, (Decimal) result.get('digitalDaysInField'));
                kpiRecord.Direct_Visits_Completed_L6Mo__c = calculateUpdatedValue(oldkpiRecord.Visits_completed__c, kpiRecord.Visits_completed__c, (Decimal) result.get('directVisitsCompleted'));
                kpiRecord.Direct_Visits_Days_in_Field_L6Mo__c = calculateUpdatedValue(oldkpiRecord.Individual_Days_in_Field__c, kpiRecord.Individual_Days_in_Field__c, (Decimal) result.get('directDaysInField'));
                kpiRecord.Sum_of_Visits_Days_in_Field_L6Mo__c = calculateUpdatedValue(oldkpiRecord.Sum_of_Visits_Days_in_Field__c, kpiRecord.Sum_of_Visits_Days_in_Field__c, (Decimal) result.get('totalDaysInField'));
            }
            
            
             if (months == 12) {
                kpiRecord.Digital_Visits_Completed_L12Mo__c = calculateUpdatedValue(oldkpiRecord.Digital_Visits_completed__c, kpiRecord.Digital_Visits_completed__c, (Decimal) result.get('digitalVisitsCompleted'));
                kpiRecord.Digital_Visits_Days_in_Field_L12Mo__c = calculateUpdatedValue(oldkpiRecord.Individual_Digital_Days_in_Field__c, kpiRecord.Individual_Digital_Days_in_Field__c, (Decimal) result.get('digitalDaysInField'));
                kpiRecord.Direct_Visits_Completed_L12Mo__c = calculateUpdatedValue(oldkpiRecord.Visits_completed__c, kpiRecord.Visits_completed__c, (Decimal) result.get('directVisitsCompleted'));
                kpiRecord.Direct_Visits_Days_in_Field_L12Mo__c = calculateUpdatedValue(oldkpiRecord.Individual_Days_in_Field__c, kpiRecord.Individual_Days_in_Field__c, (Decimal) result.get('directDaysInField'));
                kpiRecord.Sum_of_Visits_Days_in_Field_L12Mo__c = calculateUpdatedValue(oldkpiRecord.Sum_of_Visits_Days_in_Field__c, kpiRecord.Sum_of_Visits_Days_in_Field__c, (Decimal) result.get('totalDaysInField'));
            }
          } 
        }    
    }
    
    
    public static Decimal calculateUpdatedValue(Decimal oldValue, Decimal newValue, Decimal aggregatedValue) {
    // Handling null values by defaulting them to 0
    oldValue = oldValue != null ? oldValue : 0;
    newValue = newValue != null ? newValue : 0;
    aggregatedValue = aggregatedValue != null ? aggregatedValue : 0;
      if (oldValue != newValue) {
        if (oldValue < (newValue + aggregatedValue)) {
            return (newValue + aggregatedValue) - oldValue;
        } else {
            return oldValue - (newValue + aggregatedValue);
        }
    } else {
        return aggregatedValue;
    }
  }
}