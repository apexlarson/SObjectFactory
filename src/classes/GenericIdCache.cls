@IsTest
public class GenericIdCache
{
    static Map<Schema.SObjectType, Id> sObjectTypeToId = new Map<Schema.SObjectType, Id>
    {
        Profile.sObjectType => [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id
    };
    
    public static Id get(Schema.SObjectType sObjectType)
    {
        if (!sObjectTypeToId.containsKey(sObjectType))
            sObjectTypeToId.put(sObjectType, SObjectFactory.create(sObjectType).Id);
        return sObjectTypeToId.get(sObjectType);
    }
}