({
    passRecordToList : function(component, event, helper) {
        let objData = event.getParam("objData");
        let indexTile = event.getParam("indexTile");

        let listObj = component.get("v.listSelected");
        let repeatedValue = false;
        
        if(objData && objData !== '')
        {
            listObj.map(x => {
            if(x && x.ChannelYtbID__c === objData.ChannelYtbID__c)
                    repeatedValue = true;
            });
    
            if(!repeatedValue)
            {
                listObj.push(objData);
            }
    
            component.set("v.listSelected", listObj);  
        }
        else
        {
            helper.handleHasSaved(component);
        }
    },
    
    removeRecordFromList : function(component, event, helper)
    {
    	let objData = event.getParam("objData");
        let indelTile = event.getParam("indexTile");
        
        let listObj = component.get("v.listSelected");
        let returnRecordIndex = '';
        
        listObj.map((x, index) => {
            if(x && x.ChannelYtbID__c === objData.ChannelYtbID__c)
            {
             	returnRecordIndex = index;
        	}     
        });

        if(returnRecordIndex !== '')
        {
            delete listObj[returnRecordIndex];
        }
        
        component.set("v.listSelected", listObj);
    },
})