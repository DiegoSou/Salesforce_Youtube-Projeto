({
    handleChangeSelectedList : function(component, event, helper) 
    {
        let list = component.get("v.selectedList");
        let toggleSaveButtonStyle = component.get("v.toggleSaveButtonStyle");
		let hasElement = false;
        
        list.map(x => { if(x) { hasElement = true; } })
        
        if(hasElement)
        {
            toggleSaveButtonStyle = "display:block";
        }
        else
        {
            toggleSaveButtonStyle = "display:none";
        }

        component.set("v.toggleSaveButtonStyle", toggleSaveButtonStyle);
    },

    publishReturnRecord : function(component, event, helper)
    {
        let objData = event.getParam("objData");

        let payload = { recordId : objData.ChannelYtbID__c };
        component.find("channelMessageChannel").publish(payload);
    },

    saveSelectedList : function(component, event, helper)
    {
        let list = component.get("v.selectedList");

        let listJson = list.map(x => x ? JSON.stringify(x) : '');

        let params = [
            {
                name : 'listObjJson',
                type : 'Object',
                value : JSON.stringify(listJson)
            }
        ];

        // chama a service
        let callAppService = component.find("callAppService");

        callAppService.call(
            'SelectedChannelAdapter',
            'callSaveChannels',
            JSON.stringify(params)
        );
    },

    handleResponse : function(component, event, helper)
    {
        let data = JSON.parse(event.getParam("response"));
        console.log(data);

        if(data == 'success')
        {
            // Any record returned, which means that was saved | Nenhum registro retornado, o que significa que foi salvo.
            component.find("channelMessageChannel").publish({ recordId : '' });

            component.set("v.hasSave", true);
            setTimeout(() => {
                component.set("v.hasSave", false);
                component.set("v.messageOnSave", "");
            }, 3000);
        }
    }
})