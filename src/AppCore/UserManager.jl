"""
Management of **library users**

Functions for 
- creating new users
- updating information for exisiting users
- activating/deactivating existing users
- deleting users 
- searching for existing users

As each user is associated with an **address**, the module is also responsible for their management.
"""
module UserManager

export create_user, update_user, delete_user
export User, Address

using Dates, StructTypes
using ...StorageManager


#### Data Types

mutable struct Address 
    id::Int64
    street::String
    housenumber::String
    city::String
    zip::String
    country::String
end

StructTypes.StructType(::Type{Address}) = StructTypes.Mutable()
StructTypes.idproperty(::Type{Address}) = :id
Address() = Address(-1, "", "", "", "", "")
==(x1::Address, x2::Address) = x1.id == x2.id

mutable struct User 
    id::Int64
    name::String
    firstname::String
    birthdate::Date
    address::Address
end

StructTypes.StructType(::Type{User}) = StructTypes.Mutable()
StructTypes.idproperty(::Type{User}) = :id
User() = User(-1, "", "", Date(0), Address())
==(x1::User, x2::User) = x1.id == x2.id

struct UserNotExists <: Exception end


#### Operations

"""
    get_user(userID::Integer)::User 

Return the user with ID `userID`. The user must exist (if not, a `UserNotExists` exepction occurs).
"""
function get_user(userID::Integer)::User 
    if !user_exists(userID) throw(UserNotExists()) end
end

"""
    user_exists(userID::Integer)::Bool

Check, if a user with `userID` exists.
"""
user_exists(userID::Integer)::Bool = false

"""
    search_users(firstname = nothing, birthdate = nothing, address = nothing)::AbstractVector{User}

Search for users matching the attributes given. If no matching users are found, an empty list is returned.
"""
search_users(name = nothing, firstname = nothing, birthdate = nothing, address = nothing)::AbstractVector{User} = []

"""
    create_user(name::String, firstname::String, birthdate::Date, address::Address)::User 

Create a new user with the information given. Return the new user.
"""
function create_user(name::String, firstname::String, birthdate::Date, address::Address)::User 
    storage_pool = get_storage_pool()       # Singleton aus dem StorageManager
    begin_transaction(storage_pool)

    adr_id = insert(storage_pool, address)
    new_user = create(storage_pool, User, name, firstname, birthdate, adr_id)
    
    commig_transaction(storage_pool)
    return(new_user)
end

"""
    update_user(userID::Integer; firstname = nothing, birthdate = nothing, address = nothing)::User

Update the user information for user `userID`. Return the updated user.
The information passed via the optional parameters will be updated.
"""
update_user(userID::Integer; firstname = nothing, birthdate = nothing, address = nothing)::User = nothing

"""
    delete_user(userID::Integer)::Bool

Delete the user `userID` from the system. Return `true` if such a user existed and could be deleted.
"""
delete_user(userID::Integer)::Bool = false

end # module UserManager