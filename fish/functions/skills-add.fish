function skills-add -d "Install a skill globally to claude-code, opencode, pi, and antigravity-cli, symlinked"
    npx skills add $argv --agent claude-code opencode pi antigravity-cli --global --yes
end
