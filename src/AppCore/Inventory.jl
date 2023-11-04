"""
Management of the libraries inventory (consisting of **books**)

Books are (physical or electronic) copies of a title which are owned by the library.
Their lifecycle is managed within this module. 
"""
module Inventory

export add_book, make_book_available!, withdraw_book!, remove_book!
export Book

using Dates
using ..AppCore         # access to `library_storage`
using ..TitleCatalog
using ...StorageManager

mutable struct Book
    id::Int64
    title::Title
    inventory_no::String
    ebook::Bool
    lendable::Bool
end

#### Administration of the libraries inventory

"""
    add_book(title::Title, inventory_no::String, ebook::Bool)

Add a copy of `title` identified by `inventory_no` to the inventory of the library. 
This may be a physical (`ebook = false`) or an electronic copy.
"""
add_book(title::Title, inventory_no::String, ebook::Bool) = nothing

"""
    make_book_available!(book::Book)

Make `book` available for lending.
"""
function make_book_available!(book::Book)
    book.lendable = true
end

"""
    withdraw_book(book::Book)

Withdraw `book` from public lending.
"""
function withdraw_book!(book::Book)
    book.lendable = false
end

"""
    remove_book!(book:Book)

Remove `book` form the inventory of the library.
"""
remove_book!(book::Book) = nothing

end # module