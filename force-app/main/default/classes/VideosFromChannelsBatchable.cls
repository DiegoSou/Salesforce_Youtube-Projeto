public class VideosFromChannelsBatchable implements Database.Batchable<sObject>, Database.AllowsCallouts
{
    // Channel Ids passed from someone which calls batchable
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

    // Get the channel list to load videos
    public Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator([SELECT Id, ChannelYtbID__c FROM Channel__c WHERE ChannelYtbID__c IN : this.channelIds]);
    }

    // Load videos
    public void execute(Database.BatchableContext bc, List<Channel__c> scope)
    {
        // YtbID -> Video
        Map<String, Video__c> videoByYtbId = new Map<String, Video__c>();

        // Make a callout to get video snippet for each channel and put their videos into list
        for(Channel__c channel : scope)
        {
            HttpResponse response = YoutubeIntegrationRequest.getVideoListByChannelId(channel.ChannelYtbId__c);
            if(response.getStatusCode() != 200) { throw new YoutubeIntegrationRequest.YoutubeIntegrationRequestException('Callout request error. Method: VideoListByChannelId, Status Code: ' + response.getStatusCode()); }
        
            // Wrap the search result
            YoutubeIntegrationSearchWrapper wrappedResponse = YoutubeIntegrationSearchWrapper.parse(response.getBody());
            
            for(YoutubeIntegrationSearchWrapper.Item responseVideoItem : wrappedResponse.items)
            {
                // Video Domain identify that is a Search, so it construct the records according with
                VideoDomain videoFromResponse = new VideoDomain().constructVideoFromWrapper(responseVideoItem, channel.Id);
                
                videoByYtbId.put(
                    videoFromResponse.videoRecord.VideoYtbID__c, 
                    videoFromResponse.videoRecord
                );
            }
        }

        // For already existing records, fill Id field 
        List<Video__c> existingVideos = YoutubeIntegrationSelector.getVideosByYtbID(videoByYtbId.keySet());
        for(Video__c video : existingVideos)
        {
            System.debug('Existing...');
            videoByYtbId.get(video.VideoYtbID__c).Id = video.Id;
        }

        // Upsert
        upsert videoByYtbId.values();
    }

    public void finish(Database.BatchableContext bc)
    {
        AsyncApexJob info = [SELECT Status, NumberOfErrors FROM AsyncApexJob WHERE Id=:bc.getJobID()];
        System.debug('VideosFromChannelsBatchable - AsyncApexJob: ' + info);
        System.debug('Videos inserted.');
    }
}