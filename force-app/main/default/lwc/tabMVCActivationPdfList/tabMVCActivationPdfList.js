import { LightningElement ,api} from 'lwc';

import lblClose from '@salesforce/label/c.CloseButton';
import lblEditListPdf from '@salesforce/label/c.SFDC_V_2_tabMVCContact_ReferringOptician_PDFList';

import LightningModal from 'lightning/modal';

export default class TabMVCActivationPdfList extends LightningModal {
  //@api content;
  @api receivedId;

  siteUrl;
  LabelClosed = lblClose;
  LabelEditListPdf = lblEditListPdf;

  constructor() {
    super();
    // passed parameters are not yet received here
  }

  //label = {lblClose, lblEditListPdf};
  
  connectedCallback(){
    this.siteUrl = '/apex/TabMVCActivationPdfExport?receivedId=' + this.receivedId;
  }

  handleClose() {
        this.close('close popup');
  }
}