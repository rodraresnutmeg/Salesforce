import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
import SPREADJS from '@salesforce/resourceUrl/SpreadJS';
import DATA from '@salesforce/apex/FactFindExportCtrl.getData';

export default class ExportFactfind extends LightningElement {
    @track accountId = 'a090C000000Ki8BQAS';
    answersFormData = {};
    // @wire(DATA, { accountId: 'a090C000000Ki8BQAS' }) answersList;
    initialized = false;

    @wire(DATA, { accountId: 'a090C000000Ki8BQAS' })
    wiredData({ data }) {
        let p = JSON.stringify(data);
        if (p) {
            this.answersFormData = JSON.parse(p);
            console.log(JSON.parse(p).questions);
            console.log(this.answersFormData);
        }
    }

    renderedCallback() {
        if (this.initialized) {
            return;
        }
        this.initialized = true;

        Promise.all([
                loadScript(this, SPREADJS + '/codebase/spreadsheet.js'),
                loadStyle(this, SPREADJS + '/codebase/spreadsheet.css')
            ])
            .then(() => {
                this.wiredData();
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error loading spreadsheet',
                        message: error.message,
                        variant: 'error'
                    }),
                );
            });
    }
}