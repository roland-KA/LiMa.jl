"""
Management of **titles** within the libraries catalog

The catalog contains all titles the library offers for lending
(via its own inventory or by partnership with other libraries).
"""
module TitleCatalog

export catalog_title!, deactivate_title!, import_catalog!
export create_title, delete_title!, create_author, delete_author!
export Author, Title

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
    isbn::String        # not all titles may hav an ISBN
    name::String        # title
    authors::AbstractArray{Author}
    publisher::String
    pub_date::Date
    in_catalog::Bool    # available in the libraries catalaog?
end

#### Administration of the libraries catalog

"""
    catalog_title!(title::Title) 

Makte `title` available in the libraries catalog.
"""
function catalog_title!(title::Title) 
    title.in_catalog = true
end

"""
    catalog_title!(titleID::String) 

Makte the `Title` identified by `titleID` available in the libraries catalog.
"""
catalog_title!(titleID::String) = nothing

"""
    deactivate_title!(title::Title) 

Remove `title` from the libraries catalog.
"""
function deactivate_title!(title::Title)
    title.in_catalog = false
end

"""
    deactivate_title!(title::Title) 

Remove the `Title` identified by `titleID` from the libraries catalog.
"""
deactivate_title!(titleID::String) = nothing

"""
    import_catalog!(catalog::AbstractArray{Title})

Add the `Titles` given in `catalog` to the libraries catalog.
This occurs typically when catalog data is imported from third parties.
"""
import_catalog!(catalog::AbstractArray{Title}) = nothing


#### Administration of titles and authors

"""
    create_title(titleID::String, isbn::String, name::String, authors::AbstractArray{Author}, publisher::String, pub_date::Date)

Create a new `Title` with the given attributes. 
The new `Title` isn't yet part of the libraries catalog.
"""
create_title(titleID::String, isbn::String, name::String, authors::AbstractArray{Author}, publisher::String, pub_date::Date) = nothing

"""
    delete_title!(title::Title)

Delete `title` from the list of known titles.
"""
delete_title!(title::Title) = nothing

"""
    create_author(name1::String, name2::String, name3::String, affiliation::String)

Create a new `Author` with the given attributes. 
"""
create_author(name1::String, name2::String, name3::String, affiliation::String) = nothing

"""
    delete_author!(author::Author)

Delete `author` from the list of known authors.
"""
delete_author!(author::Author) = nothing

end # module TitleCatalog