import {LightningElement, api, track} from 'lwc';
import getTasks from '@salesforce/apex/serviceFlow_TaskIBOBHandler.getTasks';
export default class ServiceFlowIBOBChange extends LightningElement {
    @api listViewIds;
    @api calltype;
    @track error;
    @track taskList ;
    defaultSortDirection = 'asc';
    sortDirection = 'asc';
    sortedBy;
    @track columns = [{
            label: 'Subject',
            fieldName: 'SFlow_Subject__c',
            type: 'text',
            sortable: true
        },
        {
            label: 'Sub Subject',
            fieldName: 'SFlow_Sub_Subject__c',
            type: 'text',
            sortable: true
        },
        {
            label: 'Type',
            fieldName: 'CallType',
            type: 'text',
            sortable: true
        },
        {
            label: 'Status',
            fieldName: 'Status',
            type: 'text',
            sortable: true
        },
        {
            label: 'ECP Order Number',
            fieldName: 'serviceFlow_ECP_patient_order_number__c',
            type: 'text',
            sortable: true
        },
		{
            label: 'Hoya Reference Number',
            fieldName: 'serviceFlow_Hoya_reference_number__c',
            type: 'text',
            sortable: true
        },
		{
            label: 'Hoya Account Id',
            fieldName: 'serviceFlow_Hoya_Account_ID__c',
            type: 'text',
            sortable: true
        }
    ];
    connectedCallback() {
        //code
        this.invokeApexMethods();
    }
    async invokeApexMethods() {
        if(this.listViewIds){
            try {            
                const result = await getTasks({
                    listOfTaskIds : this.listViewIds,
                    callType : this.calltype
                });
                console.log('getTasks result: ' + JSON.stringify(result));
                if(result){
                    this.taskList = result;
                    this.error = undefined;
                }else{
                    this.taskList = undefined;
                    this.error = "Please records been selected";
                }
            } catch(error) {
                console.log(error);
                this.taskList = undefined;
                this.error = error;
            } finally {
                console.log('Finally Block');
            }
        }else{
            console.log("nothing got selected");
        }
        
    }
    onHandleSort(event) {
        const { fieldName: sortedBy, sortDirection } = event.detail;
        const cloneData = [...this.taskList];

        cloneData.sort(this.sortBy(sortedBy, sortDirection === 'asc' ? 1 : -1));
        this.taskList = cloneData;
        this.sortDirection = sortDirection;
        this.sortedBy = sortedBy;
    }
    sortBy(field, reverse, primer) {
        const key = primer
            ? function (x) {
                  return primer(x[field]);
              }
            : function (x) {
                  return x[field];
              };

        return function (a, b) {
            a = key(a);
            b = key(b);
            return reverse * ((a > b) - (b > a));
        };
    }
    close(){
		setTimeout(
			function() {
				window.history.back();
			},
			1000
		);
	}
}