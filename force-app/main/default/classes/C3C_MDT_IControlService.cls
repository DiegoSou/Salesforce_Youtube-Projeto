public interface C3C_MDT_IControlService {
    String metadatas(String key);
    String columns(String key);
    void save(String key, String listjson);
}