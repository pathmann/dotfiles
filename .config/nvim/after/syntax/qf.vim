syn match qBuilt            "Built target *" nextgroup=qTarget
syn match qTarget           ".*$"   contained

syn match qEnteringLeaving  ": \(Entering\|Leaving\) directory *" nextgroup=qdSeparator
syn match qdSeparator       "'"     nextgroup=qdName contained
syn match qdName            "[^']*" contained

syn match qbProgress        "\[ *[0-9]*%\]"
syn match qBuild            "Building .* object"
syn match qWarn             "warning\( *#[0-9]*\|\):"
syn match qError            "error\( *#[0-9]*\|\):"
syn match qRemark           "remark\( *#[0-9]*\|\):"

hi def link qTarget          Constant
hi def link qError           Error
hi def link qWarn            Error
hi def link qRemark          WarningMsg
hi def link qEnteringLeaving Keyword
hi def link qBuild           Keyword
hi def link qBuilt           Keyword
hi def link qdName           Include
hi def link qbProgress       Special
