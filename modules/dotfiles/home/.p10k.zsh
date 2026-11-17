typeset -g POWERLEVEL9K_MODE=nerdfont-complete
typeset -g POWERLEVEL9K_ICON_PADDING=none
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
  os_icon
  dir
  time

  context
  vcs
  status
  command_execution_time
  background_jobs
  direnv
  nix_shell
  kubecontext
  aws
  azure
  gcloud

  newline
  prompt_char
)

typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()

typeset -g POWERLEVEL9K_BACKGROUND=                            # transparent background
typeset -g POWERLEVEL9K_{LEFT,RIGHT}_{LEFT,RIGHT}_WHITESPACE=  # no surrounding whitespace
typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SUBSEGMENT_SEPARATOR=' '  # separate segments with a space
typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SEGMENT_SEPARATOR=        # no end-of-line symbol

typeset -g POWERLEVEL9K_{STATUS,VCS_UNTRACKED}_FOREGROUND=1
typeset -g POWERLEVEL9K_{STATUS_OK,VCS_CLEAN}_FOREGROUND=2
typeset -g POWERLEVEL9K_{COMMAND_EXECUTION_TIME,VCS_MODIFIED,AWS}_FOREGROUND=3
typeset -g POWERLEVEL9K_{NIX_SHELL,AZURE,GCLOUD}_FOREGROUND=4
typeset -g POWERLEVEL9K_{OS_ICON,CONTEXT,KUBECONTEXT}_FOREGROUND=5
typeset -g POWERLEVEL9K_DIR_FOREGROUND=6
typeset -g POWERLEVEL9K_TIME_FOREGROUND=7

typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=2
typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=1

typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
typeset -g POWERLEVEL9K_SHORTEN_DELIMITER=

typeset -g POWERLEVEL9K_VCS_DISABLED_WORKDIR_PATTERN='~'
typeset -g POWERLEVEL9K_CONTEXT_{DEFAULT,SUDO}_{CONTENT,VISUAL_IDENTIFIER}_EXPANSION=

typeset -g POWERLEVEL9K_KUBECONTEXT_SHOW_ON_COMMAND='kubectl|helm'
typeset -g POWERLEVEL9K_AWS_SHOW_ON_COMMAND='aws|awless|cdk|terraform|terragrunt'
typeset -g POWERLEVEL9K_AZURE_SHOW_ON_COMMAND='az|terraform|terragrunt'
typeset -g POWERLEVEL9K_GCLOUD_SHOW_ON_COMMAND='gcloud|gcs|gsutil|terraform|terragrunt'
