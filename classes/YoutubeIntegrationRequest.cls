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

    public static HttpResponse getResultsListByIds(String commaSeparatedIds, String typeRecords)
    {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        commaSeparatedIds = commaSeparatedIds.replaceAll(',', '%2C'); // 1234556,543221 => 1234556%2C543221

        YoutubeIntegration__mdt channelListMdt = YoutubeIntegrationSelector.getEndpoint('ResultsList');

        String endpoint = (channelListMdt.Endpoint__c)
        .replace('{typeForRecords}', typeRecords)
        .replace('{part}', 'statistics')
        .replace('{id}', commaSeparatedIds)
        .replace('{key}', KEY);

        request.setEndpoint(endpoint);
        request.setMethod(channelListMdt.Method__c);
        
        return http.send(request);
    }

    public static HttpResponse searchVideoListByParam(String param, String channelYtbId)
    {
        Http http = new Http();
        HttpRequest request = new HttpRequest();

        String formattedParam = param.replaceAll(' ', '%20'); 

        YoutubeIntegration__mdt videoListMdt = YoutubeIntegrationSelector.getEndpoint('VideoList');

        String endpoint = (videoListMdt.Endpoint__c)
        .replace('{part}', 'snippet')
        .replace('{type}', 'video')
        .replace('{channelId}', channelYtbId)
        .replace('{maxResults}', '25')
        .replace('{key}', KEY)
        + ('&q=' + formattedParam);
        
        request.setEndpoint(endpoint);
        request.setMethod(videoListMdt.Method__c);

        return http.send(request);
    }

    public static HttpResponse getVideoListByChannelId(String channelYtbId)
    {
        Http http = new Http();
        HttpRequest request = new HttpRequest();

        YoutubeIntegration__mdt videoListMdt = YoutubeIntegrationSelector.getEndpoint('VideoList');

        String endpoint = (videoListMdt.Endpoint__c)
        .replace('{part}', 'snippet')
        .replace('{type}', 'video')
        .replace('{channelId}', channelYtbId)
        .replace('{maxResults}', '50')
        .replace('{key}', KEY);

        request.setEndpoint(endpoint);
        request.setMethod(videoListMdt.Method__c);

        return http.send(request);  
    }
}