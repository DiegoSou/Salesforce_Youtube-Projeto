public class C3C_Lib_Database implements C3C_Lib_IDatabase
{   
    public List<SObject> queryExecute(String query)
    {   
        return  Database.query(query);
    }

    public List<SObject> queryExecute(fflib_QueryFactory query)
    {
        // if(listResult.size() > 0 && !C3C_APP_ApplicationContext.contract.mapPagination.containsKey(query.pageNumber+1))
        // {
        // 	C3C_APP_ApplicationContext.addNewReferencePagination(listResult[listResult.size()-1].getByField(query.pageReferenceField));
        // }
        
        return this.queryExecute(query.toSOQL());
    }
}