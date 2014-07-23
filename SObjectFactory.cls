/*
How it works:
    build([recordCount], objectType, [fieldToValue])
        - create an sObject but do not return it
        - optionally specify how many of this sObject type to create
        - optionally specify a map of field to value
    create([recordCount], objectType, [fieldToValue])
        - same overloading structure, but sObjects are inserted
*/
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
        List<sObject> records = new List<sObject>();
        for (Integer i = 0; i < recordCount; i++)
        {
            sObject record = objectType.newSObject();
            if (fieldToValue != null)
            {
                for (Schema.SObjectField field : fieldToValue.keySet())
                {
                    record.put(field, fieldToValue.get(field));
                }
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
    
}