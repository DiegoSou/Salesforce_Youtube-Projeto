import { LightningElement, api, track, wire } from 'lwc';

import { subscribe, MessageContext } from 'lightning/messageService';
import CallServiceChannel from '@salesforce/messageChannel/CallServiceChannel__c';

const windowScrollHeight = 'max-height: ' + (window.innerHeight - (window.innerHeight*0.4)) + 'px';

export default class VideoSearchResults extends LightningElement 
{
    loading = false;
    scrollHeight = windowScrollHeight;
    @track videoList;
    @track videosAddedList;
    
    @wire(MessageContext) messageContext;

    // Subscribe message channel to receive videos from search call
    connectedCallback()
    {
        subscribe(
            this.messageContext,
            CallServiceChannel,
            (call) => {
                if(call.response.from == 'video-search-results') { this.handleCallVideoSearch(call.response); }
                if(call.response.from == 'video-save-results') { this.handleCallVideoSave(call.response); }
            },
            {} 
        );
    }

    @api search(channelId, searchParam)
    {   
        this.loading = true;

        this.videoList = [];
        this.videosAddedList = [];

        let callService = this.template.querySelector('c-call-app-service');

        callService.cmp = 'video-search-results';
        callService.call('SearchVideoAdapter', 'searchVideos', { searchParam : searchParam, channelId : channelId });
    }

    @api save()
    {
        this.loading = true;

        let callService = this.template.querySelector('c-call-app-service');
        
        callService.cmp = 'video-save-results';
        callService.call('SelectedVideoAdapter', 'callSaveVideos', { listObjJson : this.videosAddedList });
    }

    // Handles the call service search videos
    handleCallVideoSearch(response)
    {
        this.loading = false;

        if(response.data)
        {
            this.videoList = JSON.parse(response.data);
                
            // Check if is Empty List
            if(Array.isArray(this.videoList) && this.videoList.length > 0)
            {
                this.dispatchEvent(new CustomEvent('setempty', { detail : { isEmpty : false } }));
            }
        }
    }

    // Handles the call service save videos
    handleCallVideoSave(response)
    {
        this.loading = false;

        let callService = this.template.querySelector('c-call-app-service');

        if(response.data)
        {
            this.videoList = [];

            this.dispatchEvent(new CustomEvent('setempty', { detail : { isEmpty : true} }));
            callService.notificationToast('Successfull save videos!', 'Check them on related lists', 'success');
        }

        if(response.error)
        {
            this.dispatchEvent(new CustomEvent('setempty', { detail : { isEmpty : false} }));
        }
    }

    // Handles the click add on tile
    handleAdded(event)
    {
        let addedRecordJson = event.detail.recordAdded;

        console.log('Added!', addedRecordJson);

        this.videosAddedList.push(addedRecordJson);
    }

    // Handles the click remove on tile
    handleRemoved(event)
    {
        let removedExternalId = event.detail.recordRemoved;

        console.log('Removed!', removedExternalId);
        
        this.videosAddedList = this.videosAddedList.filter(
            video => JSON.parse(video).VideoYtbId__c !== removedExternalId
        );
    }
}


// this.handleSearch(
//     {
//         from : 'video-search-results',
//         data : '[{"attributes":{"type":"Video__c"},"VideoYtbId__c":"ixg9D-k02qs","Title__c":"Componente Aura na Prática","Video_URL__c":"https://youtube.com/video/ixg9D-k02qs","Channel__c":"a00Dn000007vPVNIA2","Publish_Date__c":"2022-02-15T16:23:49.000+0000","Description__c":"Iniciando na carreira Salesforce? Então nos siga nas redes sociais: https://www.instagram.com/c3csoftware/ ...","Thumbnail__c":"https://i.ytimg.com/vi/ixg9D-k02qs/default.jpg"},{"attributes":{"type":"Video__c"},"VideoYtbId__c":"mWi9i3Syjvs","Title__c":"Desenvolvedor Salesforce, e agora?","Video_URL__c":"https://youtube.com/video/mWi9i3Syjvs","Channel__c":"a00Dn000007vPVNIA2","Publish_Date__c":"2021-12-10T03:43:46.000+0000","Description__c":"Iniciando na carreira Salesforce? Então nos siga nas redes sociais: https://www.instagram.com/c3csoftware/ ...","Thumbnail__c":"https://i.ytimg.com/vi/mWi9i3Syjvs/default.jpg"},{"attributes":{"type":"Video__c"},"VideoYtbId__c":"A-s6YFIWgxM","Title__c":"Como fazer testes unitários?","Video_URL__c":"https://youtube.com/video/A-s6YFIWgxM","Channel__c":"a00Dn000007vPVNIA2","Publish_Date__c":"2021-12-17T03:57:36.000+0000","Description__c":"Iniciando na carreira Salesforce? Então nos siga nas redes sociais: https://www.instagram.com/c3csoftware/ ...","Thumbnail__c":"https://i.ytimg.com/vi/A-s6YFIWgxM/default.jpg"}]'
//     }
// )