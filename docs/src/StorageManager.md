# StorageManager

## Overview

The `StorageManager` is an **_object pool_** which stores its objects permanently. 

A **_pool_** is basically a container for objects. It manages these objects over their lifetime 
and offers some additional services for them, e.g. access control, sharing across systems or, 
as in our case, **_persistence_**.

A pool offers the following interface:

- `insert!(pool,obj) -> id`: 
  Insert an object (that has been created outside) into the pool and return its `id`
- `create!(pool,type,attrs) -> obj`: 
  Create (within the pool) a new object of `type` using the attributes `attrs` and return it
- `update!(pool,type,id,attrs) –> obj`:
  Update the object `obj`of `type` with `id` with the new attribute `attrs`and return the updated object
- `exists(pool,type,id) -> Bool`: 
  Does an object `obj` of `type` with `id` exist within the pool?
- `get(pool,type,id) -> obj`: 
  Retrieve an object `obj` of `type` with `id` from the pool (*exactly one*)
- `delete!(pool,type,id)`: 
  Delete an exisiting object `obj` of `type` with `id` from the pool 
- `lookup(pool,query,args) -> Iterable<obj>`: 
  Search for objects using a query with search terms; 
  the result is an iterable collection of objects (which may contain 0, 1 oder more elements)

This interface definition differs from some more generic pool interfaces as it assumes that each
object is of a specific `type` and has some unique `id`. We come to that point in more detail lateron.

The `StorageManager` offers persistence with **_transaction control_**. Therefore it has also the 
following transaction interface:

- `begin_transaction(pool)`: Mark the begin of a transaction
- `commit(pool)`: End a transaction and make all changes permanent
- `rollback(pool)`: End a transaction and rollback all changes
- `set_autocommit(pool, Bool)`: Sets the `autocommit`-mode which is by default `true`. In this case each operation is considered being a single transaction which is commited immediately after execution. The above mentioned transaction commands are only meaningful, if this mode is set to `false`.

## Data managed by StorageManager

### Requirements

The data managed by the `StorageManager` has to fullfill certain requirements:
- it must be a used-defined mutable composite type (UDMCT)
- it must have an attribute `id::Int64` which is managed by the `StorageManager`; this `id` is a unique identifier for all objects of a specific type
- its attributes may have one of the following data types
  1. a Julia primitive type, a `STRING` or a  `DATE` (i.e. types which can be easily mapped to a corresponding SQL data type)
  2. another UDMCT
  3. an iterable collection, containing objects of the same type (i.e. all objects returned by the `Iterator` for this collection have an identical `eltype` )


### Examples

The following definitions of UDMCTs from the LiMa-Application are typical examples of data which can be managed by `StorageManager`:

```julia
mutable struct User 
    id::Int64            # managed by `StorageManager`
    name::String
    firstname::String
    birthdate::Date
    address::Address      # another UDMCT-type
end

mutable struct Address 
    id::Int64
    street::String
    housenumber::String
    city::String
    zip::String
    country::String
end
```

Most of their attributes are „simple“ data types (category 1); only `User` declares one attribute (`address`) whose type is an UDMCT.

The next definitions contain an example, where a collection-type is used:

```julia
mutable struct Author
    id::Int64
    name1::String       # firstname
    name2::String       # more names (if they exist)
    name3::String       # familyname, organisation (if not a person)
    affiliation::String
end

mutable struct Title 
    id::Int64
    titleID::String     # unique identifier used by the library
    isbn::String        # not all titles may hav a ISBN
    name::String        # title
    authors::AbstractArray{Author}
    publisher::String
    pub_date::Date
end
```

A `Title` may have one or more authors. Therefore the attribute `author` is defined as an `AbstractArray{Author}`, which is an iterable collection.

### Use of `StructTypes`

TODO

## StorageManager – Public Interface

### Usage of the storage pool

```@docs
LiMa.StorageManager.insert!
LiMa.StorageManager.create!
LiMa.StorageManager.update!
LiMa.StorageManager.exists
LiMa.StorageManager.get
LiMa.StorageManager.delete!
LiMa.StorageManager.lookup
```

### Schema Administration

```@docs
LiMa.StorageManager.add_type!
LiMa.StorageManager.delete_type!
LiMa.StorageManager.declare_attr_unique
LiMa.StorageManager.declare_obj_unique
```

### Transaction Management

```@docs
LiMa.StorageManager.begin_transaction
LiMa.StorageManager.commit
LiMa.StorageManager.rollback
LiMa.StorageManager.set_autocommit
```

## Persistence Layer

### Object Creation

In Julia a generic creation mechanism is possible using meta programming. E.g. the following statement

 `e = Expr(:call, Address, 1, "a1", "a2", "a3", "a4", "a5")`

creates a valid Julia expression (in this case a constructor for a new `Address`), which can be evaluated using `eval`, thus creating an `Address`- object.

This can be used to implement the `create`-function.

