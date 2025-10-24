$ErrorActionPreference = 'Stop'

# The hack for lazy loading the DockerCompletion module
# However, this requires pressing <Tab> twice the first time.
Register-ArgumentCompleter -Native -CommandName docker -ScriptBlock {
    Import-Module DockerCompletion -ErrorAction SilentlyContinue
}
