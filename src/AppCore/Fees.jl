"""
Rules and amounts for overdue fees

Depending on the extent of the overdue period, fees are getting higher.
"""
module Fees

export overdue_fee, days_remaining

using Dates

"""
    overdue_fee(overdue_date::Date)::Float64

Fee (if any) a library user has to pay from `overdue_date` 
(a day in the past) until today.
"""
overdue_fee(overdue_date::Date)::Float64 = nothing

"""
    days_remaining(start_date::Date)::Int

Number of days until the next fee level is reached.
If a library user starts to lend a book, it is the number
of days up to the due date.
"""
days_remaining(start_date::Date)::Int = nothing

end # module