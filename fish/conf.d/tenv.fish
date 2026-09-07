# tenv manages versioned Terraform binaries and supplies its own completions.
if type -q tenv
    set -gx PATH (tenv update-path | string split :)
    tenv completion fish | source
end
