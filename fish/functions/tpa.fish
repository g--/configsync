function tpa -d "terraform plan to .tf-plan file, then prompt before apply unless no changes (via t)"
    t plan -detailed-exitcode -out .tf-plan $argv
    switch $status
        case 0
            echo "No changes. Nothing to apply."
            return
        case 2
            # changes present, fall through to prompt
        case '*'
            return 1
    end
    read -l -P "Apply .tf-plan? [y/N] " answer
    if test "$answer" = y -o "$answer" = Y
        t apply .tf-plan
    else
        echo "Skipped apply. Run it manually with: t apply .tf-plan"
    end
end
