import { LightningElement, api } from 'lwc';

export default class VideoTile extends LightningElement 
{
    @api video;
    videoRecord = null;

    connectedCallback()
    {
        this.videoRecord = {
            url : this.video.Video_URL__c,
            thumbnail : this.video.Thumbnail__c,
            title : this.video.Title__c,
            channelName : this.video.Channel__r.Name,
            publishDate : this.video.Publish_Date__c,
            description : this.video.Description__c
        };
    }

    textAddOrAdded = 'Add';
    clickAdd(event)
    {
        event.currentTarget.classList.toggle('slds-button_brand');
        event.currentTarget.classList.toggle('slds-button_success');

        let addEvent;
        if(this.textAddOrAdded == 'Add')
        {
            this.textAddOrAdded = 'Added';
            addEvent = new CustomEvent('added', { detail : { recordAdded : JSON.stringify(this.video) } });
        }
        else
        {
            this.textAddOrAdded = 'Add';
            addEvent = new CustomEvent('removed', { detail : { recordRemoved : this.video.VideoYtbId__c } });   
        }
        
        this.dispatchEvent(addEvent);
    }
}