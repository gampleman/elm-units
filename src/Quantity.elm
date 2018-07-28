module Quantity
    exposing
        ( Acceleration
        , Angle
        , Area
        , Duration
        , Kelvins
        , Length
        , Meters
        , Quantity(..)
        , Radians
        , Rate
        , Seconds
        , Speed
        , Squared
        , Temperature
        , abs
        , acos
        , asin
        , at
        , at_
        , atan
        , atan2
        , clamp
        , compare
        , cos
        , for
        , greaterThan
        , lessThan
        , max
        , maximum
        , min
        , minimum
        , minus
        , negate
        , per
        , plus
        , ratio
        , scaleBy
        , sin
        , sort
        , sqrt
        , squared
        , sum
        , tan
        , times
        )

-- Unit types


type Radians
    = Radians Never


type Meters
    = Meters Never


type Seconds
    = Seconds Never


type Kelvins
    = Kelvins Never


type Pixels
    = Pixels Never


type Squared units
    = Squared Never


type Rate dependent independent
    = Rate Never



-- Quantity types


type Quantity units
    = Quantity Float


type alias Duration =
    Quantity Seconds


type alias Angle =
    Quantity Radians


type alias Length =
    Quantity Meters


type alias Speed =
    Quantity (Rate Meters Seconds)


type alias Acceleration =
    Quantity (Rate Speed Seconds)


type alias Area =
    Quantity (Squared Meters)


type alias Temperature =
    Quantity Kelvins


value : Quantity units -> Float
value (Quantity x) =
    x



-- 'Infix' operators


negate : Quantity units -> Quantity units
negate (Quantity x) =
    Quantity -x


plus : Quantity units -> Quantity units -> Quantity units
plus (Quantity y) (Quantity x) =
    Quantity (x + y)


minus : Quantity units -> Quantity units -> Quantity units
minus (Quantity y) (Quantity x) =
    Quantity (x - y)


times : Quantity units -> Quantity units -> Quantity (Squared units)
times (Quantity y) (Quantity x) =
    Quantity (x * y)


scaleBy : Float -> Quantity units -> Quantity units
scaleBy scale (Quantity x) =
    Quantity (scale * x)


lessThan : Quantity units -> Quantity units -> Bool
lessThan (Quantity y) (Quantity x) =
    x < y


greaterThan : Quantity units -> Quantity units -> Bool
greaterThan (Quantity y) (Quantity x) =
    x > y



-- Comparison


compare : Quantity units -> Quantity units -> Order
compare (Quantity x) (Quantity y) =
    Basics.compare x y


max : Quantity units -> Quantity units -> Quantity units
max (Quantity x) (Quantity y) =
    Quantity (Basics.max x y)


min : Quantity units -> Quantity units -> Quantity units
min (Quantity x) (Quantity y) =
    Quantity (Basics.min x y)



-- Arithmetic


abs : Quantity units -> Quantity units
abs (Quantity x) =
    Quantity (Basics.abs x)


clamp : Quantity units -> Quantity units -> Quantity units -> Quantity units
clamp (Quantity lower) (Quantity upper) (Quantity x) =
    Quantity (Basics.clamp lower upper x)


squared : Quantity units -> Quantity (Squared units)
squared (Quantity x) =
    Quantity (x * x)


sqrt : Quantity (Squared units) -> Quantity units
sqrt (Quantity x) =
    Quantity (Basics.sqrt x)


ratio : Quantity units -> Quantity units -> Float
ratio (Quantity x) (Quantity y) =
    x / y



-- Trigonometry


sin : Angle -> Float
sin (Quantity angle) =
    Basics.sin angle


cos : Angle -> Float
cos (Quantity angle) =
    Basics.cos angle


tan : Angle -> Float
tan (Quantity angle) =
    Basics.tan angle


asin : Float -> Angle
asin x =
    Quantity (Basics.asin x)


acos : Float -> Angle
acos x =
    Quantity (Basics.acos x)


atan : Float -> Angle
atan x =
    Quantity (Basics.atan x)


atan2 : Quantity units -> Quantity units -> Angle
atan2 (Quantity y) (Quantity x) =
    Quantity (Basics.atan2 y x)



-- List functions


sum : List (Quantity units) -> Quantity units
sum quantities =
    List.foldl plus (Quantity 0) quantities


minimum : List (Quantity units) -> Maybe (Quantity units)
minimum quantities =
    case quantities of
        [] ->
            Nothing

        first :: rest ->
            Just (List.foldl min first rest)


maximum : List (Quantity units) -> Maybe (Quantity units)
maximum quantities =
    case quantities of
        [] ->
            Nothing

        first :: rest ->
            Just (List.foldl max first rest)


sort : List (Quantity units) -> List (Quantity units)
sort quantities =
    List.sortBy value quantities



-- Working with rates


per : Quantity independent -> Quantity dependent -> Quantity (Rate dependent independent)
per (Quantity independentValue) (Quantity dependentValue) =
    Quantity (dependentValue / independentValue)


for : Quantity independent -> Quantity (Rate dependent independent) -> Quantity dependent
for (Quantity independentValue) (Quantity rate) =
    Quantity (rate * independentValue)


at : Quantity (Rate dependent independent) -> Quantity independent -> Quantity dependent
at (Quantity rate) (Quantity independentValue) =
    Quantity (rate * independentValue)


at_ : Quantity (Rate dependent independent) -> Quantity dependent -> Quantity independent
at_ (Quantity rate) (Quantity dependentValue) =
    Quantity (dependentValue / rate)
