import { LightningElement } from 'lwc';
//import getFirstData from '@salesforce/apex/MyApexClass.getFirstData';
//import getSecondData from '@salesforce/apex/MyApexClass.getSecondData';

export default class TestABC extends LightningElement {
    

    accountId = '001XXXXXXXXXXXX';  
    contactId = '003XXXXXXXXXXXX'; 

    connectedCallback() {
    
        this.loadData();
    }

   
    loadData() {
        
        Promise.all([
            getFirstData({ accountId: this.accountId }), 
            getSecondData({ contactId: this.contactId })  
        ])
        .then((results) => {
            
            this.firstData = results[0];  
            this.secondData = results[1];

            console.log('First Data:', this.firstData);
            console.log('Second Data:', this.secondData);
        })
        .catch((error) => {
            
            this.error = error;
            console.error('Error occurred:', error);
        });
    }
}