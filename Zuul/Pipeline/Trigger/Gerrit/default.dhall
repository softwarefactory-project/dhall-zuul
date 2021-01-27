{ approval = None (List ./Approval/Type.dhall)
, branch = None (List Text)
, comment = None (List Text)
, comment_filter = None (List Text)
, email = None (List Text)
, email_filter = None (List Text)
, ignore-deletes = None Bool
, ref = None (List Text)
, reject-approval = None (List ./RejectApproval/Type.dhall)
, require-approval = None (List ./RequireApproval/Type.dhall)
, scheme = None Text
, username = None (List Text)
, username_filter = None (List Text)
, uuid = None Text
}
