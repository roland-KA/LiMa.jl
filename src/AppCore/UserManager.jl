"""
Management of **library users**

Only registerd library users may use the libraries services.
Users breaking the libraries rules may be denied further services
(they will be added to a blacklist).

As each user is associated with an **address**, 
the module is also responsible for address management.
"""
module UserManager

export create_user, update_user_data!, activate_user!, deactivate_user!, delete_user!
export get_user, user_exists, search_users
export User, Address

using Dates, StructTypes
using ...StorageManager


mutable struct Address 
    id::Int64
    street::String
    housenumber::String
    city::String
    zip::String
    country::String
end

# meta information for use with `StructTypes`
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


#### Administration of the lifecycle of library users

"""
    create_user(name::String, firstname::String, birthdate::Date, address::Address)::User 

Create a new user with the information given. Return the new user.
"""
function create_user(name::String, firstname::String, birthdate::Date, address::Address)::User 
    storage_pool = get_storage_pool()       # Singleton from StorageManager
    begin_transaction(storage_pool)

    adr_id = insert(storage_pool, address)  # necessary?
    new_user = create(storage_pool, User, name, firstname, birthdate, adr_id)
    
    commit(storage_pool)
    return(new_user)
end

"""
    update_user_data!(userID::Integer; firstname = nothing, birthdate = nothing, address = nothing)::User

Update the user information for user `userID`. Return the updated user.
The information passed via the optional parameters will be updated.
"""
update_user_data!(userID::Integer; name = nothing, firstname = nothing, birthdate = nothing, address = nothing)::User = nothing

"""
    activate_user!(user::User)

Make `user` an active library user. 
The services of the library are only available to active users.
"""
activate_user!(user::User) = nothing

"""
    deactivate_user!(user::User)

Deactivate `user`, so he/she won't be able to use the libraries services any more.
This may occur, when a user doesn't pay the fees in time or if he hasn't used the 
libraries services for more than three years.
"""
deactivate_user!(user::User) = nothing

"""
    delete_user!(userID::Integer)

Delete the user identified by `userID` from the list of known users. 
"""
delete_user!(userID::Integer) = nothing


#### Retrieving library users

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

Search for users matching the attributes given. 
If several attributes are given, all must match.
If no matching users are found, an empty list is returned.
"""
search_users(name = nothing, firstname = nothing, birthdate = nothing, address = nothing)::AbstractVector{User} = []

end # module UserManager