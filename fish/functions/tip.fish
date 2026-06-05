function tip -d "terraform init then plan to tf-plan file (via t)"
    t init; and t plan -out tf-plan $argv
end
