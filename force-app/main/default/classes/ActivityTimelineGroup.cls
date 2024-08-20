global  class ActivityTimelineGroup {
    @AuraEnabled
    global String name {get;set;}

    @AuraEnabled
    global List<ActivityTimelineModel> items {get;set;}

    global ActivityTimelineGroup(String name, List<ActivityTimelineModel> items){
        this.name = name;
        this.items = items;
    }

    global ActivityTimelineGroup(Long dateAsLong, List<ActivityTimelineModel> items){
        this.name = serviceFlow_Utils.getMonthName(DateTime.valueOf(dateAsLong).month()) + ' • ' + DateTime.valueOf(dateAsLong).year();
        this.items = items;
    }
}