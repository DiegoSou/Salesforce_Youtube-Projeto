public class YoutubeIntegrationSelector 
{
    public class YoutubeIntegrationSelectorException extends Exception{}

    public static YoutubeIntegration__mdt getEndpoint(String developerName)
    {
        YoutubeIntegration__mdt mdt = [SELECT Id, DeveloperName, Method__c, Endpoint__c FROM YoutubeIntegration__mdt WHERE DeveloperName =: developerName LIMIT 1];
        
        if(mdt == null) { throw new YoutubeIntegrationSelectorException('Registro de metadado não encontrado para esta integração'); }
        return mdt;
    }

    public static IntegrationKeys__c getIntegrationKey()
    {
        IntegrationKeys__c key = [SELECT key__c, name__c FROM IntegrationKeys__c WHERE name__c = 'YoutubeIntegration'];

        if(key == null) { throw new YoutubeIntegrationSelectorException('Registro de custom setting não encontrado para esta integração'); }
        return key;
    }
    
    public static List<Channel__c> getChannelsByID(Set<Id> ids)
    {
        return [SELECT Id, ChannelYtbID__c FROM Channel__c WHERE Id IN : ids];
    }

    public static List<Channel__c> getChannelsByYtbID(Set<String> ids)
    {
        return [SELECT Id, ChannelYtbID__c FROM Channel__c WHERE ChannelYtbID__c IN : ids];
    }
}