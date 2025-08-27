typeset -g POWERLEVEL9K_MODE=nerdfont-complete
typeset -g POWERLEVEL9K_ICON_PADDING=none
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
  os_icon
  context
  dir
  vcs
  direnv
  nix_shell

  newline
  prompt_char
)

typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
  command_execution_time
  background_jobs
  kubecontext
  aws
  azure
  gcloud
  time

  newline
  status
)

typeset -g POWERLEVEL9K_BACKGROUND=                            # transparent background
typeset -g POWERLEVEL9K_{LEFT,RIGHT}_{LEFT,RIGHT}_WHITESPACE=  # no surrounding whitespace
typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SUBSEGMENT_SEPARATOR=' '  # separate segments with a space
typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SEGMENT_SEPARATOR=        # no end-of-line symbol

typeset -g POWERLEVEL9K_ICON_BEFORE_CONTENT=true
typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=false

# os_icon
typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND=5

# prompt_char
typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=2
typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=1

# dir
typeset -g POWERLEVEL9K_DIR_FOREGROUND=6
typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
typeset -g POWERLEVEL9K_SHORTEN_DELIMITER=

# vcs
typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=2
typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=1
typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=3
typeset -g POWERLEVEL9K_VCS_DISABLED_WORKDIR_PATTERN='~'

# status
typeset -g POWERLEVEL9K_STATUS_FOREGROUND=1
typeset -g POWERLEVEL9K_STATUS_OK_FOREGROUND=2

# command_execution_time
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=3

# nix_shell
typeset -g POWERLEVEL9K_NIX_SHELL_FOREGROUND=4

# context
typeset -g POWERLEVEL9K_CONTEXT_FOREGROUND=5
typeset -g POWERLEVEL9K_CONTEXT_{DEFAULT,SUDO}_{CONTENT,VISUAL_IDENTIFIER}_EXPANSION=

# kubecontext
typeset -g POWERLEVEL9K_KUBECONTEXT_FOREGROUND=5
typeset -g POWERLEVEL9K_KUBECONTEXT_SHOW_ON_COMMAND='kubectl|helm'

# aws
typeset -g POWERLEVEL9K_AWS_FOREGROUND=3
typeset -g POWERLEVEL9K_AWS_SHOW_ON_COMMAND='aws|awless|cdk|terraform|terragrunt'

# azure
typeset -g POWERLEVEL9K_AZURE_FOREGROUND=4
typeset -g POWERLEVEL9K_AZURE_SHOW_ON_COMMAND='az|terraform|terragrunt'

# gcloud
typeset -g POWERLEVEL9K_GCLOUD_FOREGROUND=4
typeset -g POWERLEVEL9K_GCLOUD_SHOW_ON_COMMAND='gcloud|gcs|gsutil|terraform|terragrunt'

# time
typeset -g POWERLEVEL9K_TIME_FOREGROUND=7
