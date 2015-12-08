@IsTest
public class SObjectFieldProviders
{
    public class CountException extends Exception { }
    public class EmptyQueryException extends Exception { }
    
    public class UniqueNumberProvider implements IFieldProvider
    {
        Integer counter;
        public UniqueNumberProvider() { this(0); }
        public UniqueNumberProvider(Integer start)
        {
            this.counter = start;
        }
        public Object getValue()
        {
            return counter++;
        }
    }

    public class UniqueDateProvider implements IFieldProvider
    {
        final Date startDate;
        Integer counter;
        public UniqueDateProvider() { this(Date.today()); }
        public UniqueDateProvider(Date startDate)
        {
            this.counter = 0;
            this.startDate = startDate;
        }
        public Object getValue()
        {
            return startDate.addMonths(counter++);
        }
    }

	public class UniqueStringProvider implements IFieldProvider
    {
        final String base;
        Integer counter;
        public UniqueStringProvider() { this(''); }
        public UniqueStringProvider(String base)
        {
            this.base = base;
            this.counter = 0;
        }
        public Object getValue()
        {
            return base + counter++;
        }
    }

    public virtual class UniqueFixedLengthStringProvider implements IFieldProvider
    {
        final String base;
        final Integer remainingLength;
        Integer counter;
        
        public UniqueFixedLengthStringProvider(Integer length) { this('', length); }
        public UniqueFixedLengthStringProvider(String base, Integer length)
        {
            this.base = base;
            this.remainingLength = length - base.length();
            this.counter = 0;
        }
        public Object getValue()
        {
            String counterValue = String.valueOf(counter++);
            Integer counterLength = counterValue.length();
            if (counterLength < remainingLength)
                counterValue = counterValue.leftPad(remainingLength).replace(' ', '0');
            else if (counterLength > remainingLength)
                throw new CountException('Too many fixed length strings');
            return base + counterValue;
        }
    }
    public class DummyIdProvider
        extends UniqueFixedLengthStringProvider implements IFieldProvider
    {
        public DummyIdProvider(String prefix, Integer length) { super(prefix, length); }
        public DummyIdProvider(SObjectType sObjectType) { this(sObjectType, 18); }
        public DummyIdProvider(SObjectType sObjectType, Integer length)
        {
            this(sObjectType.getDescribe().getKeyPrefix(), length);
        }
    }
    
    public virtual class ListProvider implements IFieldProvider
    {
        final Integer size;
        final List<Object> values;
        Integer index;
        public ListProvider(List<Object> values)
        {
            this.values = values;
            this.size = values.size();
            this.index = 0;
        }
        public Object getValue()
        {
            Object value = values[index];
            index = Math.mod(index + 1, size);
            return value;
        }
    }
    public class MultiParentProvider extends ListProvider implements IFieldProvider
    {
        public MultiParentProvider(Set<Id> parentIds)
        {
            super(new List<Id>(parentIds));
        }
        public MultiParentProvider(List<SObject> parents)
        {
            this(Pluck.ids(parents));
        }
    }
    
    public class GenericParentProvider implements IFieldProvider
    {
        final SObjectBuilder builder;
        Id genericParentId;
        public GenericParentProvider(SObjectType sObjectType)
        {
            this.builder = new SObjectBuilder(sObjectType);
        }
        public GenericParentProvider(SObjectType sObjectType, SObjectField field, Object value)
        {
            this.builder = new SObjectBuilder(sObjectType).put(field, value);
        }
        public Object getValue()
        {
            if (genericParentId == null)
                genericParentId = builder.create().getRecord().Id;
            return genericParentId;
        }
    }
    
    public class QueryParentProvider implements IFieldProvider
    {
        final String query;
        Id queriedParentId;
        public QueryParentProvider(String query)
        {
            this.query = query;
        }
        public QueryParentProvider(SObjectType sObjectType)
        {
            this.query = 'SELECT Id FROM ' + String.valueOf(sObjectType) + ' LIMIT 1';
        }
        public Object getValue()
        {
            if (queriedParentId == null)
            {
                List<SObject> candidates = Database.query(query);
                if (candidates.isEmpty()) throw new EmptyQueryException();
                queriedParentId = candidates[0].Id;
            }
            return queriedParentId;
        }
    }
}