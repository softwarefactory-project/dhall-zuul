{ approval : Optional (List ./Approval/Type.dhall)
, branch : Optional (List Text)
, comment : Optional (List Text)
, comment_filter : Optional (List Text)
, email : Optional (List Text)
, email_filter : Optional (List Text)
, event : List ./Event.dhall
, ignore-deletes : Optional Bool
, ref : Optional (List Text)
, reject-approval : Optional (List ./RejectApproval/Type.dhall)
, require-approval : Optional (List ./RequireApproval/Type.dhall)
, scheme : Optional Text
, username : Optional (List Text)
, username_filter : Optional (List Text)
, uuid : Optional Text
}
