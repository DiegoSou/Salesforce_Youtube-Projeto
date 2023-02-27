public class VideosFromChannelsBatchable implements Database.Batchable<sObject>, Database.AllowsCallouts
{
    public Set<String> channelIds {
        get
        {
            if(this.channelIds == null) { this.channelIds = new Set<String>(); }
                
            return this.channelIds;
        }
        private set;
    }

    public VideosFromChannelsBatchable(Set<String> channelIds)
    {
        this.channelIds = channelIds;
    }

    public Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator([SELECT Id, ChannelYtbID__c FROM Channel__c WHERE ChannelYtbID__c IN : this.channelIds]);
    }

    public void execute(Database.BatchableContext bc, List<Channel__c> scope)
    {
        List<Video__c> videoToInsertList = new List<Video__c>();

        for(Channel__c channel : scope)
        {
            HttpResponse response = YoutubeIntegrationRequest.getVideoListByChannelId(channel.ChannelYtbId__c);
            if(response.getStatusCode() != 200) { throw new YoutubeIntegrationRequest.YoutubeIntegrationRequestException('Callout request error. Method: VideoListByChannelId, Status Code: ' + response.getStatusCode()); }
        
            YoutubeIntegrationSearchWrapper wrappedResponse = YoutubeIntegrationSearchWrapper.parse(response.getBody());
            
            for(YoutubeIntegrationSearchWrapper.Item responseVideoItem : wrappedResponse.items)
            {
                VideoDomain videoFromResponse = new VideoDomain().constructVideoFromWrapper(responseVideoItem, channel.Id);
                videoToInsertList.add(videoFromResponse.videoRecord);
            }
        }

        insert videoToInsertList;
    }

    public void finish(Database.BatchableContext bc)
    {
        AsyncApexJob info = [SELECT Status, NumberOfErrors FROM AsyncApexJob WHERE Id=:bc.getJobID()];
        System.debug('VideosFromChannelsBatchable - AsyncApexJob: ' + info);
        System.debug('Videos inserted.');
    }
}