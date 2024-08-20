import { LightningElement, track } from 'lwc';
//import isDashboardNotReferencedToday from '@salesforce/apex/Utility.isFirstLoginOfDay';
import CloseButton from '@salesforce/label/c.CloseButton';
import Reminder from '@salesforce/label/c.Reminder';
import Dashboard_Refresh_Message from '@salesforce/label/c.Dashboard_Refresh_Message';
import Ok from '@salesforce/label/c.Ok';


export default class DailyLoginMessage extends LightningElement {
    @track showMessage = false;
    executedToday = false;
    custLabel ={
        CloseButton,Reminder,Dashboard_Refresh_Message,Ok
    }
    /*@track error;

    @wire(isDashboardNotReferencedToday)
    wiredShowMessage({ error, data }) {
        if (data !== undefined) {
            this.showMessage = data;
        } else if (error) {
            this.error = error;
            console.error('Error fetching login message:', error);
        }
    }*/

    closeModal() {
        this.showMessage = false;
    }

    connectedCallback() {
        this.checkExecution();
        if (!this.executedToday) {
            this.executeComponentLogic();
            this.storeExecution();
        }
    }

    checkExecution() {
        const storedDate = localStorage.getItem('homePageMessageLastDate');
        if (storedDate) {
            const lastExecutionDate = new Date(storedDate);
            const today = new Date();
            if (lastExecutionDate.getDate() === today.getDate() && lastExecutionDate.getMonth() === today.getMonth() && lastExecutionDate.getFullYear() === today.getFullYear()) {
                this.executedToday = true;
            }
        }
    }

    storeExecution() {
        const today = new Date();
        localStorage.setItem('homePageMessageLastDate', today.toString());
    }

    executeComponentLogic() {
        this.showMessage = true;
    }

}