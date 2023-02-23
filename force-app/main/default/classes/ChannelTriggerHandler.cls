public class ChannelTriggerHandler extends TriggerHandler
{
    // private final String stubResponseData = '{"kind": "youtube#channelListResponse","etag": "pnQ1dRPj_m5KYCLsR7gPeGt1228","pageInfo": {"totalResults": 1,"resultsPerPage": 5},"items": [{"kind": "youtube#channel","etag": "xDNqY-P4gI0dCPa1_FZT8gDKRhs","id": "UCrVh3JlhwUbc2AHMSMOdIqw","statistics": {"viewCount": "5274","subscriberCount": "414","hiddenSubscriberCount": false,"videoCount": "3"}}]}';
    public static Boolean bypass = false;
    
    private Map<Id, Channel__c> newMap;

    public ChannelTriggerHandler() {
        this.newMap = (Map<Id, Channel__c>) Trigger.newMap;
        
        if(!bypass && Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate))
        {
            this.callChannelsUpdateQueueable();
        }
    }

    private void callChannelsUpdateQueueable()
    {
        // call service that have a future method for callout
        ChannelUpdateQueueable channelsQueueable = new ChannelUpdateQueueable(newMap);
        Id jobId = System.enqueueJob(channelsQueueable);

        AsyncApexJob info = [SELECT Status, NumberOfErrors FROM AsyncApexJob WHERE Id=:jobId];
        System.debug(info);
    }

}