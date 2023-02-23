public class YoutubeIntegrationWrapper
{
    public List<Item> items;
    
    public class Item
    {
        public String customChannelId;
        public String kind;
        public Snippet snippet;
        public Statistics statistics;
    }

    public class Snippet
    {
        public String title;
        public String channelId;
        public String description;
        public Map<String, Map<String, String>> thumbnails;
    }

    public class Statistics
    {
        public Decimal viewCount;
        public Decimal subscriberCount;
        public Decimal videoCount;
    }

    public class CustomChannelIdClass
    {
        public List<CustomItemClass> items;
    }

    public class CustomItemClass
    {
        public String id;
    }

    public static YoutubeIntegrationWrapper parse(String jsonResponse)
    {
        YoutubeIntegrationWrapper wrapper = (YoutubeIntegrationWrapper) JSON.deserialize(jsonResponse, YoutubeIntegrationWrapper.class);

        // Somente para conseguir o channel id, quando a response é do tipo channel, pois o formato da response é diferente
        try
        {
            for(Integer i=0; i<wrapper.items.size(); i++)
            {
                if(wrapper.items[i].kind != 'youtube#channel') { break; }
                
                CustomChannelIdClass cId = (CustomChannelIdClass) JSON.deserialize(jsonResponse, CustomChannelIdClass.class);
                wrapper.items[i].customChannelId = cId.items[i].id;
            }
    
            return wrapper;
        } 
        catch(Exception e)
        {
            System.debug(e.getMessage());
            return null;
        }
    }
}

// search response
// "items": [
//     {
//       "kind": "youtube#searchResult",    <=   field verification
//       "etag": "Z45cVrqBqV12RSLdwTnDDcKY6zI",
//       "id": {
//         "kind": "youtube#channel",
//         "channelId": "UCrVh3JlhwUbc2AHMSMOdIqw"
//       },
//       "snippet": {
//         "publishedAt": "2021-12-10T02:51:23Z",
//         "channelId": "UCrVh3JlhwUbc2AHMSMOdIqw",    <=   the channel id
//         "title": "C3C Software",
//         "description": "Canal da empresa C3C Software.",
//         "thumbnails": {
//           "default": {
//             "url": "https://yt3.ggpht.com/jb50Br6GhGAO9G3XLCNBF7hc6fcgxSJeY9iWJYnmISBocqbbhD5WHjYPWJPtC6e8rUwNhI9urw=s88-c-k-c0xffffffff-no-rj-mo"
//           },
//           "medium": {
//             "url": "https://yt3.ggpht.com/jb50Br6GhGAO9G3XLCNBF7hc6fcgxSJeY9iWJYnmISBocqbbhD5WHjYPWJPtC6e8rUwNhI9urw=s240-c-k-c0xffffffff-no-rj-mo"
//           },
//           "high": {
//             "url": "https://yt3.ggpht.com/jb50Br6GhGAO9G3XLCNBF7hc6fcgxSJeY9iWJYnmISBocqbbhD5WHjYPWJPtC6e8rUwNhI9urw=s800-c-k-c0xffffffff-no-rj-mo"
//           }
//         },
//         "channelTitle": "C3C Software",
//         "liveBroadcastContent": "none",
//         "publishTime": "2021-12-10T02:51:23Z"
//       }
//     },
// ]

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
