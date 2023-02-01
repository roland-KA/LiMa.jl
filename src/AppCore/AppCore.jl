"""
Business logic of the library manager
"""
module AppCore

using Reexport

include("UserManager.jl")
@reexport using .UserManager


include("TitleCatalog.jl")
@reexport using .TitleCatalog


module InventoryManager
end # module InventoryManager


module CirculationManager
end # module CirculationManager


module Fees
end # module Fees


end # module AppCore