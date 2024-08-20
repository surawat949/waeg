import { LightningElement, wire } from 'lwc';
import getBudget from '@salesforce/apex/UserSalesPerformanceCtrl.getBudget';

export default class LwcUserSalesPerformance extends LightningElement {
    budget;

    @wire(getBudget)
    wiredBudget({ error, data }) {
        if (data) {
            this.budget = data;
        } else if (error) {
            this.budget = undefined;
            console.error(error);
        }
    }
}