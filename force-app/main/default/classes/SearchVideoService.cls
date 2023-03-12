public without sharing class SearchVideoService 
{
    public List<Video__c> searchVideos(String searchParam, String channelId)
    {
        // Lista de videos encontrados conforme o parâmetro de pesquisa
        List<Video__c> foundVideoList = new List<Video__c>();
        
        // Seleciona o canal que está envolvido na pesquisa
        Channel__c channelRecord = YoutubeIntegrationSelector.getChannelsByID(new Set<Id> { Id.valueOf(channelId) })[0];

        try
        {
            HttpResponse response = YoutubeIntegrationRequest.searchVideoListByParam(searchParam, channelRecord.ChannelYtbID__c);
            if(response.getStatusCode() != 200) { throw new YoutubeIntegrationRequest.YoutubeIntegrationRequestException('Callout request error. Method: SearchVideos, Status Code: ' + response.getStatusCode()); }

            YoutubeIntegrationSearchWrapper searchData = YoutubeIntegrationSearchWrapper.parse(response.getBody());

            // Associa cada item da pesquisa com o objeto Video__c
            for(YoutubeIntegrationSearchWrapper.Item item : searchData.items)
            {
                VideoDomain videoFromResponse = new VideoDomain();
                videoFromResponse.constructVideoFromWrapper(item);

                videoFromResponse.videoRecord.Channel__r = channelRecord;

                foundVideoList.add(videoFromResponse.videoRecord);
            }       

            // Retorna a lista de videos
            return foundVideoList;
        }
        catch (Exception e)
        {
            System.debug(e.getMessage());
            return null;
        }
    }
}