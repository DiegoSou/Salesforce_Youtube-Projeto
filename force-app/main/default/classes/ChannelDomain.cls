public class ChannelDomain 
{
    public Channel__c channelRecord{get; private set;}

    public void constructChannelFromWrapper(YoutubeIntegrationWrapper.Item item)
    {
        Channel__c channel = new Channel__c();

        if(item.snippet != null)
        {
            channel.Name = item.snippet.title;
            channel.Channel_URL__c = 'https://youtube.com/channel/' + item.snippet.channelId;
            channel.ChannelYtbID__c = item.snippet.channelId;
            channel.Description__c = item.snippet.description;
            channel.Thumbnail__c = item.snippet.thumbnails.get('default').get('url');
        }

        if(item.statistics != null)
        {
            channel.ChannelYtbID__c = item.customChannelId;
            channel.Subscriber_Counts__c = item.statistics.subscriberCount;
            channel.Video_Counts__c = item.statistics.videoCount;
            channel.View_Counts__c = item.statistics.viewCount;
        }

        this.channelRecord = channel;
    }
}