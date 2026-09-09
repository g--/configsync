# tenv manages versioned Terraform binaries and supplies its own completions.
if type -q tenv
    # update-path prints a complete PATH based on tenv's own environment.
    # Keep the existing PATH so entries such as ~/.local/bin are not lost.
    set -l tenv_path (string split : -- (tenv update-path))
    set -l tenv_bin $tenv_path[1]
    if test -n "$tenv_bin"; and not contains -- "$tenv_bin" $PATH
        set -gx PATH $tenv_bin $PATH
    end

    tenv completion fish | source
end
