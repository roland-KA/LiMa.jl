"""
Business logic of the library manager
"""
module AppCore

export library_storage

using Reexport
using ..StorageManager

library_storage = StoragePool()

include("UserManager.jl")
@reexport using .UserManager

include("TitleCatalog.jl")
@reexport using .TitleCatalog

include("Inventory.jl")
@reexport using .Inventory

include("Circulation.jl")
@reexport using .Circulation

include("Fees.jl")
@reexport using .Fees

# initialize storage pool
add_type!(library_storage, Title)
add_type!(library_storage, Author)
add_type!(library_storage, Book)
add_type!(library_storage, User)
add_type!(library_storage, Lending)
add_type!(library_storage, Reservation)

end # module AppCore