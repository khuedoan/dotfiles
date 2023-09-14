typeset -g POWERLEVEL9K_MODE=nerdfont-complete
typeset -g POWERLEVEL9K_ICON_PADDING=none
typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=always

typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
  os_icon                # os identifier
  dir                    # current directory
  vcs                    # git status
)

typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
  status                 # exit code of the last command
  command_execution_time # duration of the last command
  background_jobs        # presence of background jobs
  asdf                   # asdf version manager (https://github.com/asdf-vm/asdf)
  virtualenv             # python virtual environment (https://docs.python.org/3/library/venv.html)
  anaconda               # conda environment (https://conda.io/)
  pyenv                  # python environment (https://github.com/pyenv/pyenv)
  goenv                  # go environment (https://github.com/syndbg/goenv)
  nodenv                 # node.js version from nodenv (https://github.com/nodenv/nodenv)
  nvm                    # node.js version from nvm (https://github.com/nvm-sh/nvm)
  nodeenv                # node.js environment (https://github.com/ekalinin/nodeenv)
  kubecontext            # current kubernetes context (https://kubernetes.io/)
  terraform              # terraform workspace (https://www.terraform.io)
  aws                    # aws profile (https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html)
  aws_eb_env             # aws elastic beanstalk environment (https://aws.amazon.com/elasticbeanstalk/)
  azure                  # azure account name (https://docs.microsoft.com/en-us/cli/azure)
  gcloud                 # google cloud cli account and project (https://cloud.google.com/)
  google_app_cred        # google application credentials (https://cloud.google.com/docs/authentication/production)
  context                # user@hostname
  nix_shell              # nix shell
)

# os_icon
typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND=0
typeset -g POWERLEVEL9K_OS_ICON_BACKGROUND=5

# dir
typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
typeset -g POWERLEVEL9K_SHORTEN_DELIMITER=
local anchor_files=(
  .git
)

# git
typeset -g POWERLEVEL9K_VCS_DISABLED_WORKDIR_PATTERN='~'

# command_execution_time
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0

# kubecontext TODO
typeset -g POWERLEVEL9K_KUBECONTEXT_FOREGROUND=0
typeset -g POWERLEVEL9K_KUBECONTEXT_SHOW_ON_COMMAND='kubectl|helm|istioctl'

# aws
typeset -g POWERLEVEL9K_AWS_SHOW_ON_COMMAND='aws|terraform'

# azure
typeset -g POWERLEVEL9K_AZURE_FOREGROUND=0
typeset -g POWERLEVEL9K_AZURE_SHOW_ON_COMMAND='az|terraform'

# gcloud
typeset -g POWERLEVEL9K_GCLOUD_SHOW_ON_COMMAND='gcloud|gcs|terraform'

# context
typeset -g POWERLEVEL9K_CONTEXT_{DEFAULT,SUDO}_{CONTENT,VISUAL_IDENTIFIER}_EXPANSION=
