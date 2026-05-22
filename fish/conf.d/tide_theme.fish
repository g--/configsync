# Tide prompt configuration, synced across machines.
#
# Tide stores its config in fish universal variables (fish_variables), which
# we don't sync because that file mixes intentional config with runtime state
# (prompt cache, fisher plugin lists, etc). Setting these as --global here
# overrides the universal-var values on every shell startup.
#
# To tweak interactively: run `tide configure`, then mirror the changes you
# want to keep into this file.
#
# Color palette: based on Ghostty CLRS theme.

# --- Layout / framing -------------------------------------------------------
set --global tide_left_prompt_items vi_mode os pwd git newline
set --global tide_right_prompt_items status cmd_duration context jobs direnv node python rustc java php pulumi ruby go gcloud kubectl distrobox toolbox terraform aws nix_shell crystal elixir zig
set --global tide_left_prompt_frame_enabled true
set --global tide_right_prompt_frame_enabled true
set --global tide_left_prompt_prefix ''
set --global tide_left_prompt_suffix 
set --global tide_left_prompt_separator_diff_color 
set --global tide_left_prompt_separator_same_color 
set --global tide_right_prompt_prefix 
set --global tide_right_prompt_suffix ''
set --global tide_right_prompt_separator_diff_color 
set --global tide_right_prompt_separator_same_color 
set --global tide_prompt_add_newline_before false
set --global tide_prompt_color_frame_and_connection 6C6C6C
set --global tide_prompt_color_separator_same_color 949494
set --global tide_prompt_icon_connection ─
set --global tide_prompt_min_cols 34
set --global tide_prompt_pad_items true
set --global tide_prompt_transient_enabled true

# --- Generic UI segments (CLRS-tinted) -------------------------------------
set --global tide_character_color 328A5D
set --global tide_character_color_failure F8282A
set --global tide_character_icon ❯
set --global tide_character_vi_icon_default ❮
set --global tide_character_vi_icon_replace ▶
set --global tide_character_vi_icon_visual V

set --global tide_cmd_duration_bg_color E3BD0E
set --global tide_cmd_duration_color 000000
set --global tide_cmd_duration_decimals 0
set --global tide_cmd_duration_icon 
set --global tide_cmd_duration_threshold 3000

set --global tide_context_always_display false
set --global tide_context_bg_color 555753
set --global tide_context_color_default EEEEEC
set --global tide_context_color_root E3BD0E
set --global tide_context_color_ssh 3AD5CE
set --global tide_context_hostname_parts 1

set --global tide_git_bg_color 328A5D
set --global tide_git_bg_color_unstable E3BD0E
set --global tide_git_bg_color_urgent F8282A
set --global tide_git_color_branch 000000
set --global tide_git_color_conflicted 000000
set --global tide_git_color_dirty 000000
set --global tide_git_color_operation 000000
set --global tide_git_color_staged 000000
set --global tide_git_color_stash 000000
set --global tide_git_color_untracked 000000
set --global tide_git_color_upstream 000000
set --global tide_git_icon 
set --global tide_git_truncation_length 24
set --global tide_git_truncation_strategy ''

set --global tide_jobs_bg_color 555753
set --global tide_jobs_color 2CC631
set --global tide_jobs_icon 
set --global tide_jobs_number_threshold 1000

set --global tide_os_bg_color 333333
set --global tide_os_color D6D6D6
set --global tide_os_icon 

set --global tide_pwd_bg_color 3465A4
set --global tide_pwd_color_anchors E4E4E4
set --global tide_pwd_color_dirs E4E4E4
set --global tide_pwd_color_truncated_dirs BCBCBC
set --global tide_pwd_icon 
set --global tide_pwd_icon_home 
set --global tide_pwd_icon_unwritable 
set --global tide_pwd_markers .bzr .citc .git .hg .node-version .python-version .ruby-version .shorten_folder_marker .svn .terraform Cargo.toml composer.json CVS go.mod package.json build.zig

set --global tide_shlvl_bg_color FA701D
set --global tide_shlvl_color 000000
set --global tide_shlvl_icon 
set --global tide_shlvl_threshold 1

set --global tide_status_bg_color 555753
set --global tide_status_bg_color_failure F8282A
set --global tide_status_color 2CC631
set --global tide_status_color_failure FFFFFF
set --global tide_status_icon ✔
set --global tide_status_icon_failure ✘

set --global tide_time_bg_color B3B3B3
set --global tide_time_color 000000
set --global tide_time_format ''

set --global tide_vi_mode_bg_color_default B3B3B3
set --global tide_vi_mode_bg_color_insert 135CD0
set --global tide_vi_mode_bg_color_replace F8282A
set --global tide_vi_mode_bg_color_visual 9F00BD
set --global tide_vi_mode_color_default 000000
set --global tide_vi_mode_color_insert FFFFFF
set --global tide_vi_mode_color_replace FFFFFF
set --global tide_vi_mode_color_visual FFFFFF
set --global tide_vi_mode_icon_default D
set --global tide_vi_mode_icon_insert I
set --global tide_vi_mode_icon_replace R
set --global tide_vi_mode_icon_visual V

set --global tide_private_mode_bg_color F1F3F4
set --global tide_private_mode_color 000000
set --global tide_private_mode_icon \U000f05f9

# --- Tool / language brand colors ------------------------------------------
# Mostly upstream tide defaults — kept here so tide configure changes are
# explicit and synced.

set --global tide_aws_bg_color FF9900
set --global tide_aws_color 232F3E
set --global tide_aws_icon 

set --global tide_crystal_bg_color FFFFFF
set --global tide_crystal_color 000000
set --global tide_crystal_icon 

set --global tide_direnv_bg_color D7AF00
set --global tide_direnv_bg_color_denied FF0000
set --global tide_direnv_color 000000
set --global tide_direnv_color_denied 000000
set --global tide_direnv_icon ▼

set --global tide_distrobox_bg_color FF00FF
set --global tide_distrobox_color 000000
set --global tide_distrobox_icon \U000f01a7

set --global tide_docker_bg_color 2496ED
set --global tide_docker_color 000000
set --global tide_docker_default_contexts default colima
set --global tide_docker_icon 

set --global tide_elixir_bg_color 4E2A8E
set --global tide_elixir_color 000000
set --global tide_elixir_icon 

set --global tide_gcloud_bg_color 4285F4
set --global tide_gcloud_color 000000
set --global tide_gcloud_icon \U000f02ad

set --global tide_github_bg_color 777777
set --global tide_github_color FFFFFF
set --global tide_github_icon 

set --global tide_go_bg_color 00ACD7
set --global tide_go_color 000000
set --global tide_go_icon 

set --global tide_java_bg_color ED8B00
set --global tide_java_color 000000
set --global tide_java_icon 

set --global tide_kubectl_bg_color 326CE5
set --global tide_kubectl_color 000000
set --global tide_kubectl_icon \U000f10fe

set --global tide_nix_shell_bg_color 7EBAE4
set --global tide_nix_shell_color 000000
set --global tide_nix_shell_icon 

set --global tide_node_bg_color 44883E
set --global tide_node_color 000000
set --global tide_node_icon 

set --global tide_php_bg_color 617CBE
set --global tide_php_color 000000
set --global tide_php_icon 

set --global tide_pulumi_bg_color F7BF2A
set --global tide_pulumi_color 000000
set --global tide_pulumi_icon 

set --global tide_python_bg_color 444444
set --global tide_python_color 00AFAF
set --global tide_python_icon \U000f0320

set --global tide_ruby_bg_color B31209
set --global tide_ruby_color 000000
set --global tide_ruby_icon 

set --global tide_rustc_bg_color F74C00
set --global tide_rustc_color 000000
set --global tide_rustc_icon 

set --global tide_terraform_bg_color 800080
set --global tide_terraform_color 000000
set --global tide_terraform_icon \U000f1062

set --global tide_toolbox_bg_color 613583
set --global tide_toolbox_color 000000
set --global tide_toolbox_icon 

set --global tide_zig_bg_color F7A41D
set --global tide_zig_color 000000
set --global tide_zig_icon 
