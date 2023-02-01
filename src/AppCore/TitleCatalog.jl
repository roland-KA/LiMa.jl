"""
Management of **titles** and **books**

The catalog contains all titles the library offers as well as the corresponding copies.
The titles and the associated (physical or electronic) copies have a lifecycle that has
to be managed. As a title may have several authors, it is also the responsibility of 
this module to manage the **authors**.
"""
module TitleCatalog

export create_title, catalog_title, deactivate_title, delete_title
export create_book, add_book, withdraw_book, delete_book
export Author, Title, Book

using Dates
using ...StorageManager

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
    author::AbstractArray{Author}
    publisher::String
    pub_date::Date
end

mutable struct Book
    id::Int64
    title::Title
    inventory_no::String
    ebook::Bool
    lendable::Bool
end

end # module TitleCatalog