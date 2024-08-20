import { LightningElement } from 'lwc';

export default class Searchcombobox extends LightningElement {
    picklistOrdered;
  searchResults;
  selectedSearchResult;

  get selectedValue() {
    return this.selectedSearchResult ? this.selectedSearchResult.label : null;
  }

  connectedCallback() {
    getValuesFromTable().then((result) => {
        this.picklistOrdered = result.map(({value: label, key: value}) => ({ label,value}))
        this.picklistOrdered = this.picklistOrdered.sort((a,b)=>{
            if(a.label < b.label){
                return -1
            }
        })
    })
  }

  search(event) {
    const input = event.detail.value.toLowerCase();
    const result = this.picklistOrdered.filter((picklistOption) =>
      picklistOption.label.toLowerCase().includes(input)
    );
    this.searchResults = result;
  }

  selectSearchResult(event) {
    const selectedValue = event.currentTarget.dataset.value;
    this.selectedSearchResult = this.picklistOrdered.find(
      (picklistOption) => picklistOption.value === selectedValue
    );
    this.clearSearchResults();
  }

  clearSearchResults() {
    this.searchResults = null;
  }

  showPicklistOptions() {
    if (!this.searchResults) {
      this.searchResults = this.picklistOrdered;
    }
  }

}