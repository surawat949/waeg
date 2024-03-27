import { LightningElement,api ,wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//Apex
import getIndicators from '@salesforce/apex/tabShowPadController.getAIIndicators';
//Static Resources
import AI_Indicators from '@salesforce/resourceUrl/SFDC_V2_AI_Indicators';
//labels
import presentations from '@salesforce/label/c.Presentations_Indicator';
import sharing from '@salesforce/label/c.Sharing_Indicator';
import viewing from '@salesforce/label/c.Viewing_Indicator';
export default class TabShowPad extends LightningElement {
    @api recordId;
    presentationIndicator;
    sharingIndicator;
    openingIndicator;
    viewingIndicator;
    sharingIndicatorgMeaning;
    viewingIndicatorMeaning;
    custLabel={
        presentations,sharing,viewing
    }
    @wire(getIndicators, {recordId: '$recordId'}) 
     getIndicators ({error, data}) {
        if(data){
            // Set the variable value here based on apex response.
            this.presentationIndicator = AI_Indicators + '/'+this.getIndicatorImage(data.presenatationFlag);
            this.sharingIndicator = AI_Indicators + '/'+this.getIndicatorImage(data.sharingFlag);
            this.openingIndicator = AI_Indicators + '/'+this.getIndicatorImage(data.openingFlag);
            this.viewingIndicator = AI_Indicators + '/'+this.getIndicatorImage(data.viewingFlag);
            console.log('>>>>',data.sharingFlagMeaning);
            this.sharingIndicatorgMeaning = data.sharingFlagMeaning;
            this.viewingIndicatorMeaning = data.viewingFlagMeaning;
          
        }else if(error){
            this.showToast('Error', 'Error',JSON.stringify(error));
        }
    }
    getIndicatorImage(indicator){
        if(indicator == 'GREY')
            return 'GreyLight.png';
        else if(indicator == 'GREYALERT')
            return 'GreyLightAlert.png';
        else if(indicator == 'RED')
            return 'RedLight.png';
        else if(indicator == 'REDALERT')
            return 'RedLightAlert.png';
        else if(indicator == 'GREEN')
            return 'GreenLight.png';
        else if(indicator == 'GREENALERT')
            return 'GreenLightAlert.png';

    }
    showToast(title, variant, message) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant,
            }),
        );
    }
}