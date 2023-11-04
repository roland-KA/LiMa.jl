"""
LiMa - LibraryManager

An example application to show the principles of software architecture design.
"""
module LiMa

using Reexport

print("This is the LibraryManager LiMA")

include("StorageManager.jl")
include("AppCore/AppCore.jl")

@reexport using .AppCore

end # module LiMa
