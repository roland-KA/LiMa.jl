"""
A persistent data pool
"""
module StorageManager

export add_type!, delete_type!, declare_attr_unique, declare_obj_unique
export insert!, create!, update!, exists, get, delete!, lookup
export begin_transaction, commit, rollback, set_autocommit
export StoragePool


#### Internal Pool Management

struct StoragePool
    objects::Dict{DataType, Dict{Int64, Any}}   # storage for objects
    next_ids::Dict{DataType, Int64}             # next free id for each type
end

StoragePool() = StoragePool(
                    Dict{DataType, Dict{Int64, Any}}(),
                    Dict{DataType, Int64}()
                )

function add_object!(sp::StoragePool, type::DataType, obj::Any)
  sp.objects[type][obj.id] = obj
  sp.next_ids[type] += 1
end

has_object(sp::StoragePool, type::DataType, id::Int64) = haskey(sp.objects, type) && haskey(sp.objects[type], id)
get_object(sp::StoragePool, type::DataType, id::Int64) = sp.objects[type][id]
del_object!(sp::StoragePool, type::DataType, id::Int64) = delete!(sp.objects[type], id)
get_next_id(sp::StoragePool, type::DataType) = sp.next_ids[type] 


#### Schema Administration (public interface)

"""
Management of data types (data schema)

This is an interface for the administration of the data schema. 
    - Types can be added or deleted from the schema
    - Single attributes of a type can be declared as being unique
    - A Type can be declared as being unique, i.e. each record/object within that type is unique 

If a DBMS is used for persistent storage, its database scheme can be inferred from this information.
"""

"""
    add_type!(pool::StoragePool, type::DataType)

Add `type` to the data scheme.
"""
function add_type!(sp::StoragePool, type::DataType) 
    sp.objects[type] = Dict{Int64, Any}()
    sp.next_ids[type] = 1
end 

"""
    delete_type!(pool::StoragePool, type::DataType) 

Delete `type` from the data scheme. 
This is only possible, if no objects of that type exist.
"""
delete_type!(pool::StoragePool, type::DataType) = nothing

"""
    declare_attr_unique(pool::StoragePool, type::DataType, attr_name::Symbol)

The attribute `attr_name` of `type` is unique.
"""
declare_attr_unique(pool::StoragePool, type::DataType, attr_name::Symbol) = nothing

"""
    declare_obj_unique(pool::StoragePool, type::DataType)

Each object of type `type` is unique.
"""
declare_obj_unique(pool::StoragePool, type::DataType) = nothing 


#### Pool Usage (public interface)

"""
    insert!(pool::StoragePool, obj::Any)

Insert an object (created outside) into the storage pool. 
"""
function insert!(pool::StoragePool, obj::Any) 
    type = typeof(obj)
    obj.id = get_next_id(pool, type)
    add_object(pool, type, new_obj)
    return(obj.id)
end

"""
    create!(pool::StoragePool, type::DataType, attrs::Tuple) --> obj

Create an object of type `type` from `attrs` within the pool and return that new object.
"""
function create!(pool::StoragePool, type::DataType, attrs::Tuple)
    next_id = get_next_id(pool, type)
    new_obj = Expr(:call, type, next_id, attrs...)
    add_object(pool, type, new_obj)
    return(new_obj)
end

"""
    update!(pool::StoragePool, type::DataType, id::Int64, attrs::Tuple) --> obj

Update the existing object of type `type` identified by `id` with the new attributes `attrs`
and return the updated object.
"""
update!(pool::StoragePool, type::DataType, id::Int64, attrs::Tuple) = nothing

"""
    exists(pool::StoragePool, type::DataType, id::Int64) --> Bool

Is there an object of type `type` identified by `id` within the `pool`?
"""
exists(pool::StoragePool, type::DataType, id::Int64)::Bool = has_object(pool, type, id)

"""
    get(pool::StoragePool, type::DataType, id::Int64) --> obj

Retrieve an object of type `type` identified by `id`.
"""
get(pool::StoragePool, type::DataType, id::Int64) = get_object(pool, type, id)

"""
    delete!(pool::StoragePool, type::DataType, id::Int64)

Delete the object of type `type` identified by `id` from the `pool`.
"""
delete!(pool::StoragePool, type::DataType, id::Int64) = del_object!(pool, type, id)

"""
    lookup(pool::StoragePool, query::String, args::Tuple) --> Iterable{obj}

Search for objects using a query with search terms; 
the result is an iterable collection of objects (which may contain 0, 1 oder more elements)
"""
lookup(pool::StoragePool, query::String, args::Tuple) = nothing


#### Transaction Management (public interface)

"""
    begin_transaction(pool::StoragePool)

Mark the begin of a transaction.
"""
begin_transaction(pool::StoragePool) = nothing

"""
    commit(pool::StoragePool)

End a transaction and make all changes permanent.
"""
commit(pool::StoragePool) = nothing

"""
    rollback(pool::StoragePool)

End a transaction and rollback all changes.
"""
rollback(pool::StoragePool) = nothing 

"""
    set_autocommit(pool::StoragePool, mode::Bool)

Sets the autocommit-mode which is by default `true`. In this case each operation is considered 
being a single transaction which is commited immediately after execution. The above mentioned 
transaction commands are only meaningful, if this mode is set to `false`.
"""
set_autocommit(pool::StoragePool, mode::Bool) = nothing


end # module StorageManager
