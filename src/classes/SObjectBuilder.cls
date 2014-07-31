@IsTest
public class SObjectBuilder
{
    final Schema.SObjectType sObjectType;
    final Map<Schema.SObjectField, Object> fieldToValue;
    
    Integer recordCount;
    
    Schema.SObjectField additionalField;
    List<Object> additionalFieldValues;
    
    List<sObject> records;
    
    public SObjectBuilder(Schema.SObjectType sObjectType)
    {
        this.sObjectType = sObjectType;
        this.fieldToValue = new Map<Schema.SObjectField, Object>();
    }
    public SObjectBuilder count(Integer recordCount)
    {
        this.recordCount = recordCount;
        return this;
    }
    public SObjectBuilder put(Schema.SObjectField field, Object value)
    {
        this.fieldToValue.put(field, value);
        return this;
    }
    public SObjectBuilder putAll(Map<Schema.SObjectField, Object> fieldMap)
    {
        this.fieldToValue.putAll(fieldMap);
        return this;
    }
    public SObjectBuilder addValues(Schema.SObjectField field, List<Object> values)
    {
        this.additionalField = field;
        this.additionalFieldValues = values;
        return this;
    }
    
    Boolean isPlural { get { return recordCount != null && recordCount > 1; } }
    Boolean hasValues { get { return !fieldToValue.isEmpty(); } }
    Boolean hasAdditionalValues
    {
        get
        {
            return additionalField != null &&
                additionalFieldValues != null &&
                !additionalFieldValues.isEmpty();
        }
    }
    public SObjectBuilder build()
    {
        records = new List<sObject>();
        if (hasValues)
        {
            if (hasAdditionalValues)
                records.addAll(SObjectFactory.build(sObjectType, additionalField, additionalFieldValues, fieldToValue));
            else if (isPlural)
                records.addAll(SObjectFactory.build(recordCount, sObjectType, fieldToValue));
            else
                records.add(SObjectFactory.build(sObjectType, fieldToValue));
        }
        else
        {
            if (hasAdditionalValues)
                records.addAll(SObjectFactory.build(sObjectType, additionalField, additionalFieldValues));
            else if (isPlural)
                records.addAll(SObjectFactory.build(recordCount, sObjectType));
            else
                records.add(SObjectFactory.build(sObjectType));
        }
        
        return this;
    }
    public SObjectBuilder create()
    {
        build();
        insert records;
        return this;
    }
    
    public sObject getRecord()
    {
        if (records == null || records.isEmpty()) return null;
        return records[0];
    }
    public List<sObject> getRecords()
    {
        return (records == null) ? new List<sObject>() : records;
    }
}