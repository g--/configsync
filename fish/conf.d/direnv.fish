# Load .envrc files when entering their directories, when direnv is installed.
if status is-interactive; and type -q direnv
    direnv hook fish | source
end
