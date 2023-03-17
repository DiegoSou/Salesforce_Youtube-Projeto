public class ChannelUpdateQueueable implements Queueable, Database.AllowsCallouts
{
    private Map<Id, Channel__c> channelMap = new Map<Id,Channel__c>();

    public ChannelUpdateQueueable(Map<Id, Channel__c> channelMap) 
    {
        this.channelMap = channelMap;
    }

    public void execute(QueueableContext context)
    {
        String commaSeparatedChannelIDs = '';
        
        Map<String, Channel__c> channelByYoutubeId = new Map<String, Channel__c>();
        
        // Constrói a lista de ids para o callout
        List<Channel__c> channels = YoutubeIntegrationSelector.getChannelsByID(channelMap.keySet());
        for(Channel__c item : channels)
        {
            commaSeparatedChannelIDs += item.ChannelYtbID__c + ','; 

            // Armazena o registro com id
            channelByYoutubeId.put(item.ChannelYtbID__c, item);
        }

        // Faz o callout 
        HttpResponse response = YoutubeIntegrationRequest.getResultsListByIds(commaSeparatedChannelIDs, 'channels');
        if(response.getStatusCode() != 200) { throw new YoutubeIntegrationRequest.YoutubeIntegrationRequestException('Callout request error. Method: ChannelListByIds, Status Code: ' + response.getStatusCode()); }

        YoutubeIntegrationResultWrapper wrappedResponse = YoutubeIntegrationResultWrapper.parse(response.getBody());

        // Atualiza os registros do newMap com as estatísticas de cada canal, vindas do callout
        for(YoutubeIntegrationResultWrapper.Item responseChannelItem : wrappedResponse.items)
        {
            ChannelDomain channelFromResponse = new ChannelDomain().constructChannelFromWrapper(responseChannelItem);
            System.debug('ChannelUpdateQueueable - constructChannelFromWrapper: ' + channelFromResponse.channelRecord);

            Channel__c channelFromNewMap = channelByYoutubeId.get(channelFromResponse.channelRecord.ChannelYtbID__c);
            channelFromNewMap.Subscriber_Counts__c = channelFromResponse.channelRecord.Subscriber_Counts__c;
            channelFromNewMap.Video_Counts__c = channelFromResponse.channelRecord.Video_Counts__c;
            channelFromNewMap.View_Counts__c = channelFromResponse.channelRecord.View_Counts__c;
        }
	
        ChannelTriggerHandler.bypass = true;
        update channelByYoutubeId.values();
        ChannelTriggerHandler.bypass = false;

        // chain video queueable (50 first)
        VideosFromChannelsBatchable videosBatchable = new VideosFromChannelsBatchable(channelByYoutubeId.keySet());
        Id jobId = Database.executeBatch(videosBatchable, 100);
    }
}