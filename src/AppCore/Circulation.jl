"""
Lending services of the library

The core lending services are lending and returning of books. 
Additional functions deal with billing (of fees for books which are overdue or damaged).
"""
module Circulation

export checkout_book, return_book, extend_period, is_overdue
export invoice_overdue_fee, invoice_damage
export Lending, Reservation

using Dates
using ..TitleCatalog
using ..Inventory
using ..UserManager

"""
The process of lending of _one_ book by one library user
"""
mutable struct Lending
    id::Int64
    book::Book
    user::User
    start_date::Date
    due_date::Date
    fee::Float64
    returned::Bool      # Has the book been returned?
    closed::Bool        # Is the case closed? Book my be returned, but fees unpaid.
end

"""
Reservation of a title (in case that all of its copies are in circulation)
"""
mutable struct Reservation
    id::Int64
    title::Title 
    user::User
    start_date::Date
end

"""
    checkout_book(book::Book, user::User)

`user` lends `book` from the library
"""
checkout_book(book::Book, user::User) = nothing

"""
    return_book(book::Book)

`book` (which must be in circulation) gets returned to the library
"""
return_book(book::Book) = nothing

"""
    extend_period(lending::Lending)

Extend the lending period of `lending` 
by the standard extension period of the library.
May only be called, if an extension is possible.
"""
extend_period(lending::Lending) = nothing

"""
    is_overdue(lending::Lending)::Bool

Is the `lending` overdue?
"""
is_overdue(lending::Lending)::Bool = nothing

"""
    invoice_overdue_fee(user::User, overdue::Lending)

Send an invoice to `user` for the `overdue` lending.
"""
invoice_overdue_fee(user::User, overdue::Lending) = nothing

"""
    invoice_damage_fee(user::User, book::Book)

Bill `user` for the `book` he/she damaged.
"""
invoice_damage(user::User, book::Book) = nothing

end # module