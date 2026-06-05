function t -d "Run ./tf if it exists, otherwise terraform"
    if test -x ./tf
        ./tf $argv
    else
        terraform $argv
    end
end
