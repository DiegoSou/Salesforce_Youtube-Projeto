import { LightningElement, api, track } from 'lwc';

export default class VideoIFramePlayer extends LightningElement 
{
    @track externalId;
    @api setExternalId(externalId) { this.externalId = externalId; }

    get embedUrl()
    {
        if(this.externalId)
        {
            return 'https://www.youtube.com/embed/' + this.externalId; 
        }

        return;
    }

    get width()
    {
        return window.screen.width * 0.4;
    }

    get height()
    {
        return window.screen.height * 0.3;
    }
}