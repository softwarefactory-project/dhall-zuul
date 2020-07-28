{-|
The Zuul Union to group different schemas in a single list
-}
< Job :
    ./Zuul/Job/wrapped.dhall sha256:4eef0f01a9c68a8e988851cb58681c550efa5d96bef9fe5c8c343fd76d84ca62
| Nodeset :
    ./Zuul/Nodeset/wrapped.dhall sha256:c5e46c7e76ef5bb08dbc182a464a97279374f8114436550fe71d987b3e78cdde
| Project :
    ./Zuul/Project/wrapped.dhall sha256:e285293083bd9fbf09e88bd8fd1ea7e2c06ce137822b8d6b212f788d6679d071
>
