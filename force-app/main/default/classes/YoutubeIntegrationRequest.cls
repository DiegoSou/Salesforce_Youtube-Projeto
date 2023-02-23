public class YoutubeIntegrationRequest 
{
    public class YoutubeIntegrationRequestException extends Exception{}

    private static final String KEY = (YoutubeIntegrationSelector.getIntegrationKey()).key__c;

    public static HttpResponse searchChannelListByParam(String param, String maxResults)
    {
        Http http = new Http();
        HttpRequest request = new HttpRequest();

        String formattedParam = param.replaceAll(' ', '%20');  // my channel => my%20channel

        YoutubeIntegration__mdt searchListMdt = YoutubeIntegrationSelector.getEndpoint('SearchList');

        String endpoint = (searchListMdt.Endpoint__c)
        .replace('{part}', 'snippet')
        .replace('{type}', 'channel')
        .replace('{q}', formattedParam)
        .replace('{maxResults}', maxResults)
        .replace('{key}', KEY);

        request.setEndpoint(endpoint);
        request.setMethod(searchListMdt.Method__c);

        return http.send(request);
    }

    public static HttpResponse getChannelListByIds(String commaSeparatedIds)
    {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        commaSeparatedIds = commaSeparatedIds.replaceAll(',', '%2C'); // 1234556,543221 => 1234556%2C543221

        YoutubeIntegration__mdt channelListMdt = YoutubeIntegrationSelector.getEndpoint('ChannelList');

        String endpoint = (channelListMdt.Endpoint__c)
        .replace('{part}', 'statistics')
        .replace('{id}', commaSeparatedIds)
        .replace('{key}', KEY);

        request.setEndpoint(endpoint);
        request.setMethod(channelListMdt.Method__c);
        
        return http.send(request);
    }
}