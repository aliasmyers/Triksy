<#
.SYNOPSIS
Get the Test Results from Trx files. 

.DESCRIPTION
The test result is from the UnitTestResult array under the TestRun.Results section of the TRX file. 

This CmdLet accepts zero or more TRX files (from Get-Trx) and extracts the Test Results from each file in turn.

.PARAMETER ByTrxs
Zero or more TRX files returned from the call to Get-Trx. 

.EXAMPLE
Get all of the results from a single TRX file:

Get-Trx -Files "thefile.trx" | Get-TrxResult;

.EXAMPLE
Get all of the results from all TRX files:

Get-ChildItem "*.trx" -Recurse | Get-Trx | Get-TrxResult
#>
function Get-TrxResult {

    [CmdletBinding(DefaultParameterSetName="ByTrxs")]
    PARAM(
        [Parameter(ParameterSetName = "ByTrxs", Mandatory = $true, ValueFromPipeline=$true)]
        [AllowEmptyCollection()]
        [PSObject[]] $Trxs
    )
    BEGIN
    {
        $Result = @();
    }
    PROCESS
    {
        foreach($t in $trxs)
        {
            if($t.Valid)
            {
                $x = $t.XmlObject;

                if($x.TestRun.Results -eq $null -or $x.TestRun.Results.ChildNodes.Count -eq 0)
                {
                    Write-Verbose "There are no results in the file $($t.Path)";
                }
                else
                {

                    foreach($cn in $x.TestRun.Results.ChildNodes)
                    {
                        $o2 = New-Object "PSObject";

                        # Map across original properties
                        Add-Member -InputObject $o2 -NotePropertyName "ExecutionId"                   -NotePropertyValue $cn.ExecutionId;
                        Add-Member -InputObject $o2 -NotePropertyName "TestId"                        -NotePropertyValue $cn.TestId;
                        Add-Member -InputObject $o2 -NotePropertyName "TestName"                      -NotePropertyValue $cn.TestName;
                        Add-Member -InputObject $o2 -NotePropertyName "ComputerName"                  -NotePropertyValue $cn.ComputerName;
                        Add-Member -InputObject $o2 -NotePropertyName "Duration"                      -NotePropertyValue $cn.Duration;
                        Add-Member -InputObject $o2 -NotePropertyName "StartTime"                     -NotePropertyValue $cn.StartTime;
                        Add-Member -InputObject $o2 -NotePropertyName "EndTime"                       -NotePropertyValue $cn.EndTime;
                        Add-Member -InputObject $o2 -NotePropertyName "TestType"                      -NotePropertyValue $cn.TestType;
                        Add-Member -InputObject $o2 -NotePropertyName "Outcome"                       -NotePropertyValue $cn.Outcome;
                        Add-Member -InputObject $o2 -NotePropertyName "TestListId"                    -NotePropertyValue $cn.TestListId;
                        Add-Member -InputObject $o2 -NotePropertyName "RelativeResultsDirectory"      -NotePropertyValue $cn.RelativeResultsDirectory;

                        Add-Member -InputObject $o2 -NotePropertyName "Output"                        -NotePropertyValue $cn.Output;

                        Add-Member -InputObject $o2 -NotePropertyName "Path"                          -NotePropertyValue $t.Path;
                        Add-Member -InputObject $o2 -NotePropertyName "Trx"                           -NotePropertyValue $x;

                        $Result += $o2;
                    }

                }
            }
        }
    }
    END
    {
        return ,$Result;
    }
}
