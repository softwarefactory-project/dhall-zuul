{ dequeue = None ./Reporter/map.dhall
, dequeue-message = None Text
, dequeue-on-new-patchset = None Bool
, description = None Text
, disable-after-consecutive-failures = None Bool
, disabled = None ./Reporter/map.dhall
, enqueue = None ./Reporter/map.dhall
, enqueue-message = None Text
, failure = None ./Reporter/map.dhall
, failure-message = None Text
, footer-message = None Text
, ignore-dependencies = None Bool
, merge-failure = None ./Reporter/map.dhall
, merge-failure-message = None Text
, no-jobs = None ./Reporter/map.dhall
, no-jobs-message = None Text
, post-review = None Bool
, precedence = None ./Precedence.dhall
, reject = None ./Requirement.dhall
, require = None ./Requirement.dhall
, start = None ./Reporter/map.dhall
, start-message = None Text
, success = None ./Reporter/map.dhall
, success-message = None Text
, supercedes = None Text
, trigger = None ./Trigger/map.dhall
, variant-description = None Text
, window = None Natural
, window-decrease-factor = None Natural
, window-decrease-type = None ./WindowDecreaseType.dhall
, window-floor = None Natural
, window-increase-factor = None Natural
, window-increase-type = None Natural
}