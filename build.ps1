# script to build the module and push to AWS CodeArtifact
# DOESN'T WORK YET

Import-Module AWSPowerShell.NetCore

$domain = "net8dot3"
$domainOwner = "243523715939"
$repository = "ps-modules"

# get an auhorization token for AWS CodeArtifact
$token = (Get-CAAuthorizationToken -Domain $domain -DomainOwner $domainOwner).AuthorizationToken
$token_secure = ConvertTo-SecureString "$token" -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential("aws", $token_secure)

# 2. Register Repository
$sourceUrl = "https://$domain-$domainOwner.d.codeartifact.us-west-2.amazonaws.com/$repository/"

Register-PSRepository -Name $domain -SourceLocation $sourceUrl -PublishLocation $sourceUrl -InstallationPolicy Trusted -Credential $credential

# $repository_parameters = @{
#   Name = "CodeArtifactSource"
#   SourceLocation = "http://artifactory.getty.cloud/artifactory/api/nuget/choco-infrastructure/"
#   InstallationPolicy = 'Trusted'
# }
# Register-PSRepository @repository_parameters

Get-PSRepository

Install-Module -Repository CodeArtifactSource homelab-functions
Import-Module homelab-functions
