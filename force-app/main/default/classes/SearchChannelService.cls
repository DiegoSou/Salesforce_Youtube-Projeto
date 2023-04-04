public without sharing class SearchChannelService 
{
    public List<Channel__c> searchChannels(String searchParam, Integer maxResults)
    {
        // Lista para os canais encontrados conforme o parâmetro de pesquisa
        List<Channel__c> foundChannelList = new List<Channel__c>();

        try 
        {
            HttpResponse response = YoutubeIntegrationRequest.searchChannelListByParam(searchParam, String.valueOf(maxResults));
            if(response.getStatusCode() != 200) { throw new YoutubeIntegrationRequest.YoutubeIntegrationRequestException('Callout request error. Method: SearchChannels, Status Code: ' + response.getStatusCode()); }

            YoutubeIntegrationSearchWrapper searchData =  YoutubeIntegrationSearchWrapper.parse(response.getBody());

            // Associa cada item com o objeto Channel__c
            for(YoutubeIntegrationSearchWrapper.Item item : searchData.items)
            {
                ChannelDomain channelFromResponse = new ChannelDomain();
                channelFromResponse.constructChannelFromWrapper(item);

                foundChannelList.add(channelFromResponse.channelRecord);
            }

            // Retorna a lista de Channels
            return foundChannelList;
        } 
        catch (Exception e) 
        {
            System.debug(e.getMessage());
            return null;
        }
    }
}