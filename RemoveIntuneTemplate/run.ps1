using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

$APIName = $TriggerMetadata.FunctionName
Write-LogMessage -user $request.headers.'x-ms-client-principal' -API $APINAME  -message "Accessed this API" -Sev "Debug"

$ID = $request.query.id
try {
    Remove-Item "Config\$($ID).IntuneTemplate.json" -Force
    Write-LogMessage -user $request.headers.'x-ms-client-principal'  -API $APINAME  -message "Removed Intune Template with ID $ID." -Sev "Info"
    $body = [pscustomobject]@{"Results" = "Successfully removed Intune Template" }
}
catch {
    Write-LogMessage -user $request.headers.'x-ms-client-principal'  -API $APINAME  -message "Failed to remove intune template $ID. $($_.Exception.Message)" -Sev "Error"
    $body = [pscustomobject]@{"Results" = "Failed to remove template" }
}


# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::OK
        Body       = $body
    })

