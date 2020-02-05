# Troubleshoot MAKES command line tool issues

## Azure login failure due to multiple subscriptions being tied to a single Azure account

If you have multiple azure subscription associated with a single azure account, you'll need to specify the azure active directory domain name associated with the azure subscription that you would like to use to execute the command. (e.g. "--AzureActiveDirectoryDomainName constco.onmicrosoft.com").  

You can find this information by logging into azure portal and go to your Azure Active Directory resource detail page.  

## Azure subscription limit

If you encounter errors such as "operation could not be completed as it results in exceeding approved XXXXXX quota", you'll either need to contact azure support to increase your account quota or change the MAKES host machine settings.  

## Incomplete MAKERS release transfer

A release may not be completed immediately. Please allow 1 day after new release folder creation for all necessary files to be transferred.

## MAKES hosting resource/deployment region mismatch

MAKES can only be deployed to the same region as the MAKES hosting image. If you see an error message like "...The Image '/subscriptions/XXXXXXX-XXXX-XXX-XXXX-XXXXXXX/resourceGroups/xxxxmakeshostres/providers/Microsoft.Compute/images/xxxxmakeshostres' cannot be found in 'xxxx' region..." Make sure to create MAKES deployments and hosting image in the same region.

## Wrong MAKES path parameters

Special characters in parameters need to be escaped. You can also escape the whole parameter string by using quotes. E.g. --MakesPackage "https://consto.blob.core.windows.net/makes/2020-01-23/"

*quotes need to be straight like "ParamValue" instead of “ParamValue”.

## Command line tool(kesm.exe) version mismatch

Please use the command line tool that comes along with each release to customize and deploy MAKES. Older versions of the tool are not guaranteed to work with new releases. Make sure to specify the corresponding MAKES release for MakesPackage parameter.  

## MAKES deployment failure due to bad MAKES hosting image  

MAKES hosting image creation may fail due to various Azure hiccups. If you cannot reach your MAKES status endpoint (http://<deploymentName>.<deploymentRegion>.cloudapp.azure.net/status), please try creating the MAKES hosting image again using the command line tool(kesm.exe).   