public class YoutubeIntegrationResultWrapper 
{
    public List<Item> items;

    public class Item extends YoutubeIntegrationAbstractItem
    {
        public String id;
        public String kind;
        public Statistics statistics;

        public override Boolean getStatictics() { return true; }
        public override Boolean getSnippet() { return false; }
    }

    public class Statistics
    {
        public Decimal viewCount;
        public Decimal subscriberCount;
        public Decimal videoCount;
        public Boolean hiddenSubscriberCount;
    }

    public static YoutubeIntegrationResultWrapper parse(String jsonResponse)
    {
        YoutubeIntegrationResultWrapper wrapper = 
        (YoutubeIntegrationResultWrapper) JSON.deserialize(
            jsonResponse, 
            YoutubeIntegrationResultWrapper.class
        );

        return wrapper;
    }
}

// channel response
// "items": [
//     {
//       "kind": "youtube#channel",     <=     field verification      
//       "etag": "Yc2PR6d1-euVQatDjf-XR_Melrk",
//       "id": "UCrVh3JlhwUbc2AHMSMOdIqw",      <=   the channel id
//       "statistics": {
//         "viewCount": "5622",
//         "subscriberCount": "425",
//         "hiddenSubscriberCount": false,
//         "videoCount": "3"
//     }
// ]

// video response
// "items" : []