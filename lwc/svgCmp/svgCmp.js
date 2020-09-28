import {LightningElement, api} from 'lwc';

export default class SvgCmp extends LightningElement {
    @api type;
    @api svgClass;
}