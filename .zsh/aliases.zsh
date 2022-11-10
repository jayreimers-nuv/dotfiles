# Alias
# ---
#
alias k="kubectl"
alias h="helm"
alias tf="terraform"
alias r="cd ~/Repositories"
alias rny="cd ~/Repositories/ny"
alias j11='export JAVA_HOME=$(/usr/libexec/java_home -v 11); java -version'
alias kns='kubens'
alias kl='kubectl logs'
alias k3dstart='k8sk3d && k3d cluster start local'
alias k3dstop='k8sk3d && k3d cluster stop local'
alias mvnunit='mvn verify -DskipIntegrationTests -Pgcp'
alias mvnit='mvn verify -DskipUnitTests -Dcheckstyle.skip -Pgcp -Pkubernetes'
alias kgp='kubectl get pods'

# ALIAS COMMANDS
alias ls="exa --icons --group-directories-first"
alias ll="exa --icons --group-directories-first -l"
alias g="goto"
alias grep='grep --color'
