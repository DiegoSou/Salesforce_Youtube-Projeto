import { LightningElement, api, wire } from 'lwc';

import { subscribe, MessageContext } from 'lightning/messageService';
import CallServiceChannel from '@salesforce/messageChannel/CallServiceChannel__c';

import { CurrentPageReference } from 'lightning/navigation';

export default class VideoPlayerTab extends LightningElement 
{
    loaded;
    @api recordId;
    @wire(MessageContext) messageContext;
    @wire(CurrentPageReference) getStateParameters(pageReference) 
    { if(pageReference) this.recordId = pageReference.state.recordId; }

    renderedCallback()
    {
        // Previne que entre em loop
        if(!this.loaded)
        {
            subscribe(
                this.messageContext,
                CallServiceChannel,
                (call) => { if(call.response.from == 'video-player-tab') { this.handleCallService(call.response) } },
                {}
            );
    
            this.getExternalId(this.recordId);
        }
    }

    // Chamada imperativa para buscar o external id
    getExternalId(videoId)
    {
        let callAppService = this.template.querySelector('c-call-app-service');

        callAppService.cmp = 'video-player-tab';
        callAppService.call('SelectedVideoAdapter', 'getExternalVideoId', { recordId : videoId });
    }

    // Função resposta à chamada do apex
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