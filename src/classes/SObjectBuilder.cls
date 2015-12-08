@IsTest
public class SObjectBuilder
{
	final List<SObject> records;
	final SObjectType sObjectType;
	final Map<SObjectField, Object> fieldToValue;

	Integer count;

	public SObjectBuilder(SObjectType sObjectType)
	{
		this.count = 1;
		this.sObjectType = sObjectType;
		this.records = new List<SObject>();
		this.fieldToValue = new Map<SObjectField, Object>();
	}

	public SObjectBuilder count(Integer count)
	{
		this.count = count;
		return this;
	}

	public SObjectBuilder put(SObjectField field, Object value)
	{
		this.fieldToValue.put(field, value);
		return this;
	}
	public SObjectBuilder putAll(Map<SObjectField, Object> fieldToValue)
	{
		this.fieldToValue.putAll(fieldToValue);
		return this;
	}
	public SObjectBuilder provideDummyIds()
	{
		SObjectField idField = this.sObjectType.getDescribe().fields.getMap().get('id');
		this.put(idField, SObjectFactory.provideDummyId(this.sObjectType));
		return this;
	}

	public SObjectBuilder build()
	{
		this.records.clear();
		this.records.addAll(SObjectFactory.build(sObjectType, count, fieldToValue));
		return this;
	}
	public SObjectBuilder create()
	{
		this.records.clear();
		this.records.addAll(SObjectFactory.create(sObjectType, count, fieldToValue));
		return this;
	}
	public SObjectBuilder createAsAdmin()
	{
		system.runAs(SObjectFactory.ADMIN_USER) { this.create(); }
		return this;
	}

	public SObject getRecord() { return this.records[0]; }
	public List<SObject> getRecords() { return this.records; }
}