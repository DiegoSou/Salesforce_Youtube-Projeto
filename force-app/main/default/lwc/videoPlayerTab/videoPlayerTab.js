import { LightningElement, api, wire, track } from 'lwc';

import { subscribe, MessageContext } from 'lightning/messageService';
import CallServiceChannel from '@salesforce/messageChannel/CallServiceChannel__c';

export default class VideoPlayerTab extends LightningElement 
{
    loaded;
    @api recordId;
    @wire(MessageContext) messageContext;

    renderedCallback()
    {
        // Previne que entre em loop
        if(!this.loaded)
        {
            subscribe(
                this.messageContext,
                CallServiceChannel,
                (call) => this.handleCallService(call.response),
                {}
            );
    
            this.getExternalId(this.recordId);
        }
    }

    getExternalId(videoId)
    {
        let callAppService = this.template.querySelector('c-call-app-service');

        let params = [
            {
                name : 'recordId',
                type : 'String',
                value : videoId
            }
        ];

        callAppService.call('SelectedVideoAdapter', 'getExternalVideoId', JSON.stringify(params));
    }

    handleCallService(response)
    {
        if(response.data)
        {
            let externalId = JSON.parse(response.data);
            let videoiframe = this.template.querySelector('c-video-i-frame-player');

            videoiframe.setExternalId(externalId);
            this.loaded = true;
        }
    }
}