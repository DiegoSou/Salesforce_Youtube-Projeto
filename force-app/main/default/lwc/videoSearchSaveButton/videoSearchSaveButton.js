import { LightningElement } from 'lwc';

export default class VideoSearchSaveButton extends LightningElement 
{
    handleClickSave() {
        this.dispatchEvent(new CustomEvent('save'));
    }
}