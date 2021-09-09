########################################################
#      Lambda Instance Start - Authored by Ryan Payne  #
# Please see README.md for important usage information #
########################################################
#
# PowerShell script file to be executed as a AWS Lambda function. 
# 
# When executing in Lambda the following variables will be predefined.
#   $LambdaInput - A PSObject that contains the Lambda function input data.
#   $LambdaContext - An Amazon.Lambda.Core.ILambdaContext object that contains information about the currently running Lambda environment.
#
# The last item in the PowerShell pipeline will be returned as the result of the Lambda function.
#
# To include PowerShell modules with your Lambda function, like the AWSPowerShell.NetCore module, add a "#Requires" statement 
# indicating the module and version.

#Requires -Modules @{ModuleName='AWSPowerShell.NetCore';ModuleVersion='3.3.422.0'}

# Uncomment to send the input event to CloudWatch Logs
# Write-Host (ConvertTo-Json -InputObject $LambdaInput -Compress -Depth 5)

Write-Host 'Function name:' $LambdaContext.FunctionName
Write-Host 'Remaining milliseconds:' $LambdaContext.RemainingTime.TotalMilliseconds
Write-Host 'Log group name:' $LambdaContext.LogGroupName
Write-Host 'Log stream name:' $LambdaContext.LogStreamName

function Start-Instance {

Param(

)

    # w/ Tag Filter
    $stateTag =@(
        @{
            name = 'tag:<key>'
            values = "<value>"
        }
    )
    $instanceIds = (Get-EC2Instance -Filter $stateTag).Instances

    <# w/ Stored Parameters
    $ssmParamName = ""
	$ssmParam = (Get-SSMParameterValue -Name $ssmParamName).Parameters
	$instanceIds = $ssmParam.Value
	Write-Host "Found $ssmParamName contains $instanceIds"
    #>

    foreach ($i in $instanceIds){
        if ($_.Instances.state.Name.Value -ne 'running') {
            Start-EC2Instance -InstanceId $i
        } else {
            Write-Host "$i is already running"
        }
    }


}

Start-Instance
