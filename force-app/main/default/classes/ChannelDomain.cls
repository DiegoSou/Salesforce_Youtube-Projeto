public class ChannelDomain 
{
    public Channel__c channelRecord{get; private set;}

    public ChannelDomain constructChannelFromWrapper(YoutubeIntegrationAbstractItem item)
    {
        Channel__c channel = new Channel__c();

        if(item.getSnippet())
        {
            YoutubeIntegrationSearchWrapper.Item searchItem = (YoutubeIntegrationSearchWrapper.Item) item;

            channel.Name = searchItem.snippet.title;
            channel.Channel_URL__c = 'https://youtube.com/channel/' + searchItem.snippet.channelId;
            channel.ChannelYtbID__c = searchItem.snippet.channelId;
            channel.Description__c = searchItem.snippet.description;
            channel.Thumbnail__c = searchItem.snippet.thumbnails.get('default').get('url');
        }

        if(item.getStatictics())
        {
            YoutubeIntegrationResultWrapper.Item resultItem = (YoutubeIntegrationResultWrapper.Item) item;

            channel.ChannelYtbID__c = resultItem.id;
            channel.Subscriber_Counts__c = resultItem.statistics.subscriberCount;
            channel.Video_Counts__c = resultItem.statistics.videoCount;
            channel.View_Counts__c = resultItem.statistics.viewCount;
        }

        this.channelRecord = channel;

        return this;
    }
}