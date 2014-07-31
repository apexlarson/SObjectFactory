@IsTest
public class UniqueFieldsCache
{
    public static final String NO_STOCK_VALUE = '';
    public static final String ARBITRARY_EMAIL = 'ZtestZ@ZtestZ.ZtestZ';
    
    public static Map<Schema.SObjectField, Object> get(Schema.SObjectType sObjectType)
    {
        Map<Schema.SObjectField, Object> uniqueValues = new Map<Schema.SObjectField, Object>();
        if (!stockValueMap.containsKey(sObjectType)) return uniqueValues;
        
        Map<Schema.SObjectField, String> fieldToStockValue = stockValueMap.get(sObjectType);
        for (Schema.SObjectField field : fieldToStockValue.keySet())
        {
            uniqueValues.put(field, fieldToStockValue.get(field) + getCounter(field));
        }
        return uniqueValues;
    }
    
    static Map<Schema.SObjectField, Integer> counterMap = new Map<Schema.SObjectField, Integer>();
    static Integer getCounter(Schema.SObjectField field)
    {
        if (!counterMap.containsKey(field))
            counterMap.put(field, 1);
        else
            counterMap.put(field, counterMap.get(field) + 1);
        return counterMap.get(field);
    }
    
    static Map<Schema.SObjectType, Map<Schema.SObjectField, String>> stockValueMap =
        new Map<Schema.SObjectType, Map<Schema.SObjectField, String>>
    {
        User.sObjectType => new Map<Schema.SObjectField, String>
        {
            User.Alias => NO_STOCK_VALUE,
            User.Username => ARBITRARY_EMAIL,
            User.CommunityNickname => NO_STOCK_VALUE
        }
    };
}