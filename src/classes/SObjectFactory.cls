@IsTest
public class SObjectFactory
{
    public static sObject build(Schema.SObjectType objectType) { return build(1, objectType)[0]; }
    public static List<sObject> build(Integer recordCount, Schema.SObjectType objectType)
    {
        return build(recordCount, objectType, null);
    }
    public static sObject build(Schema.SObjectType objectType, Map<Schema.SObjectField, Object> fieldToValue)
    {
        return build(1, objectType, fieldToValue)[0];
    }
    public static List<sObject> build(Integer recordCount, Schema.SObjectType objectType, Map<Schema.SObjectField, Object> fieldToValue)
    {
        Map<Schema.SObjectField, Object> fieldMap = RequiredFieldsCache.get(objectType);
        if (fieldToValue != null) fieldMap.putAll(fieldToValue);
        
        List<sObject> records = new List<sObject>();
        for (Integer i = 0; i < recordCount; i++)
        {
            fieldMap.putAll(UniqueFieldsCache.get(objectType));
            
            sObject record = objectType.newSObject();
            for (Schema.SObjectField field : fieldMap.keySet())
            {
                record.put(field, fieldMap.get(field));
            }
            records.add(record);
        }
        return records;
    }
    
    public static sObject create(Schema.SObjectType objectType) { return create(1, objectType)[0]; }
    public static List<sObject> create(Integer recordCount, Schema.SObjectType objectType)
    {
        return create(recordCount, objectType, null);
    }
    public static sObject create(Schema.SObjectType objectType, Map<Schema.SObjectField, Object> fieldToValue)
    {
        return create(1, objectType, fieldToValue)[0];
    }
    public static List<sObject> create(Integer recordCount, Schema.SObjectType objectType, Map<Schema.SObjectField, Object> fieldToValue)
    {
        List<sObject> records = build(recordCount, objectType, fieldToValue);
        insert records;
        return records;
    }
    
    public static List<sObject> build(Schema.SObjectType objectType, Schema.SObjectField field, List<Object> values)
    {
        List<sObject> records = new List<sObject>();
        for (Object value : values)
        {
            records.add(build(objectType, new Map<Schema.SObjectField, Object> { field => value }));
        }
        return records;
    }
    public static List<sObject> build(Schema.SObjectType objectType, Schema.SObjectField field, List<Object> values, Map<Schema.SObjectField, Object> fieldToValue)
    {
        Integer recordCount = values.size();
        List<sObject> records = build(recordCount, objectType, fieldToValue);
        for (Integer i = 0; i < recordCount; i++)
        {
            records[i].put(field, values[i]);
        }
        return records;
    }
    
    public static List<sObject> create(Schema.SObjectType objectType, Schema.SObjectField field, List<Object> values)
    {
        List<sObject> records = build(objectType, field, values);
        insert records;
        return records;
    }
    public static List<sObject> create(Schema.SObjectType objectType, Schema.SObjectField field, List<Object> values, Map<Schema.SObjectField, Object> fieldToValue)
    {
        List<sObject> records = build(objectType, field, values, fieldToValue);
        insert records;
        return records;
    }
}