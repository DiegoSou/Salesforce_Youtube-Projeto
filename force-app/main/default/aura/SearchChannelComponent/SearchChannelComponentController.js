({
    doInit : function(component, event, helper)
    {
        let windowHeight = window.innerHeight;
        component.set('v.windowHeight', windowHeight);
    },

    handleResponse : function(component, event, helper)
    { 
        let response = event.getParam('response');
    
        if(response.from == 'hp-search-channel')
        {   
            if(response.data)
            {
                let foundList = component.get("v.foundChannelList");
                
                let data = JSON.parse(response.data);
    
                data.forEach((channel) => {
                    foundList.push({ [channel.ChannelYtbID__c] : channel })
                });
    
                component.set('v.foundChannelList', foundList);
                component.set('v.displaysListChannel', data);
            }
            if(response.error)
            {
                console.log(JSON.parse(response.error));
            }
        }
    },
    
    clickSearch : function(component, event, helper) 
    {
        // let foundData = [{"Name":"C3C Software","Channel_URL__c":"https://youtube.com/channel/UCrVh3JlhwUbc2AHMSMOdIqw","ChannelYtbID__c":"UCrVh3JlhwUbc2AHMSMOdIqw","Description__c":"Canal da empresa C3C Software.","Thumbnail__c":"https://yt3.ggpht.com/jb50Br6GhGAO9G3XLCNBF7hc6fcgxSJeY9iWJYnmISBocqbbhD5WHjYPWJPtC6e8rUwNhI9urw=s88-c-k-c0xffffffff-no-rj-mo"}];
        // component.set("v.foundChannelList", foundData);

        let searchParam = component.get("v.searchParam"); 
        let maxResults = component.get("v.maxResults");

        // evita chamadas de search desnecessárias
        if(searchParam.replaceAll(' ', '') != '')
        {
            let callAppService = component.find("callAppService");
            callAppService.call('SearchChannelAdapter', 'searchChannels', { searchParam : searchParam, maxResults : maxResults });
        }
        else
        {
            component.set("v.anyParam", true);
            setTimeout(() => {
                component.set("v.anyParam", false);
            }, 3000);
        }
    },

    toggleMaxResults : function(component, event, helper)
    {
        let styleMaxResults = component.get("v.toggleMaxResultsStyle");
        switch (styleMaxResults)
        {
            case "display:none":
                styleMaxResults = "display:block";
                break;

            case "display:block":
                styleMaxResults = "display:none";
                component.set("v.maxResults", 25);
                break;
        }

        component.set("v.toggleMaxResultsStyle", styleMaxResults);
    },

    firePassRecord : function(component, event, helper)
    {
        let list = component.get('v.displaysListChannel');
        
        let channelTile = event.getParam("channelTile");
        let index = event.getParam("index");
        let passRecord = helper.constructClickTileEvent(component, channelTile, index, 'passRecord');
        passRecord.fire();

        delete list[index];
        component.set('v.displaysListChannel', list);
    },
    
    // Atualiza a lista de displays e de selecionados
    handleReturnRecord : function(component, event, helper)
    {
        let foundList = component.get('v.foundChannelList');
        let displaysList = component.get('v.displaysListChannel');

        let recordId =  event.getParam('recordId');

        if(recordId)
        {
            let record;
            foundList.forEach(channel => {
                if(channel[recordId])
                    record = channel[recordId];
            });
    
            let removeRecord = helper.constructClickTileEvent(component, record, '', 'removeRecord');
        	removeRecord.fire();
            
            displaysList.unshift(record);
            component.set('v.displaysListChannel', displaysList);
        }
        else
        {
			helper.handleHasSaved(component, helper);
        }
    },
})