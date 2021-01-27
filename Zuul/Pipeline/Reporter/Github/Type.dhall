{ check : Optional ./Check.dhall
, comment : Optional Bool
, label : Optional (List Text)
, `merge` : Optional Bool
, review : Optional ./Review.dhall
, review-body : Optional Text
, status : Optional ./Status.dhall
, status-url : Optional Text
, unlabel : Optional (List Text)
}
