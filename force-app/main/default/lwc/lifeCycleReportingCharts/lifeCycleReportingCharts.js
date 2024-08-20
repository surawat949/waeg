import { LightningElement,api } from 'lwc';

export default class LifeCycleReportingCharts extends LightningElement {

    @api netsaleslast12mosum;
    @api netsaleslfysum;
    ownerName = 'austin';
    
    @api
    handleCallChildMethod() {
        // Accessing the child component
        const childComponent = this.template.querySelector('c-bar-charts-a-l-c');
        
        if (childComponent) {
            // Calling the method on the child component
            childComponent.checkIfUpdated();
        }
    }
}