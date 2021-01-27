{ name : Text
, post-review : Optional Bool
, description : Optional Text
, manager : ./Manager.dhall
, variant-description : Optional Text
, success-message : Optional Text
, failure-message : Optional Text
, start-message : Optional Text
, enqueue-message : Optional Text
, merge-failure-message : Optional Text
, no-jobs-message : Optional Text
, dequeue-message : Optional Text
, footer-message : Optional Text
, trigger : Optional ./Trigger/map.dhall
, require : Optional ./Require/map.dhall
, reject : Optional ./Reject/map.dhall
, supercedes : Optional Text
, dequeue-on-new-patchset : Optional Bool
, ignore-dependencies : Optional Bool
, precedence : Optional ./Precedence.dhall
, success : Optional ./Reporter/map.dhall
, failure : Optional ./Reporter/map.dhall
, merge-failure : Optional ./Reporter/map.dhall
, enqueue : Optional ./Reporter/map.dhall
, start : Optional ./Reporter/map.dhall
, no-jobs : Optional ./Reporter/map.dhall
, disabled : Optional ./Reporter/map.dhall
, dequeue : Optional ./Reporter/map.dhall
, disable-after-consecutive-failures : Optional Bool
, window : Optional Natural
, window-floor : Optional Natural
, window-increase-type : Optional Natural
, window-increase-factor : Optional Natural
, window-decrease-type : Optional ./WindowDecreaseType.dhall
, window-decrease-factor : Optional Natural
}
