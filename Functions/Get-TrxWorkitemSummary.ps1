<#
.SYNOPSIS
Get an aggregated summary of the workitem outcomes. 

.DESCRIPTION
Some MsTest unit tests have an associated Workitem via the [Workitem(number)] attribute. The same workitem can exist on multiple unit tests. Some of those unit tests might pass; some might fail; some might be inconclusive. 

Get-TrxWorkitemSummary will produce an aggregate result for that workitem as follows: if every unit test associated with that Workitem passes, the result is Passed; otherwise it is Failed. 

.PARAMETER TrxResults
Zero or more TRXResults passed on from Get-TrxResult. 

.PARAMETER DefaultWorkitems
Not every unit test has a [Workitem] attribute but it is often convenient to assume a default to simplify aggregating the results. Optionally Provide the workitem id to use for methods that do not have a Workitem attribute. 

.EXAMPLE
Get all of the results from all TRX files:

Get-ChildItem "*.trx" -Recurse | Get-Trx | Get-TrxResult | Get-TrxWorkitemSummary

.EXAMPLE
Get all of the results from all Trx files. Where a method does not have a Workitem attribute, assume it has a Workitem attribute of 1234:

Get-ChildItem *.trx -Recurse | Get-Trx | Get-TrxResult | Get-TrxWorkitemSummary -DefaultWorkItems 1234
#>
function Get-TrxWorkitemSummary {

    [CmdletBinding(DefaultParameterSetName="ByTrxResults")]
    PARAM(
        [Parameter(ParameterSetName = "ByTrxResults", Mandatory = $true, ValueFromPipeline=$true)]
        [AllowEmptyCollection()]
        [PSObject[]] $TrxResults,
        [Parameter(ParameterSetName = "ByTrxResults", Mandatory = $false)]
        [AllowEmptycollection()]
        [string[]] $DefaultWorkitems
    )
    BEGIN
    {
        $Result = @();
    }
    PROCESS
    {
        $lookup = @{};

        foreach($t in $TrxResults)
        {
            
            # Look up the Unit Test for this result. 
            $testId = $t.TestId;

            $unitTest = $t.Trx.TestRun.TestDefinitions.UnitTest | Where-Object { $_.id -eq $testId };
            if($unitTest -eq $null)
            {
                Write-Verbose "ERROR: The unit test with an id of $($testId) reference in the test result $($t.ExecutionId) does not exist. ";
            }
            else
            {
                if($unitTest.Workitems -ne $null -and $unitTest.Workitems.ChildNodes -ne $null -and $unitTest.Workitems.ChildNodes.Count -gt 0)
                {
                    foreach($c in $unitTest.Workitems.ChildNodes)
                    {
                        if($lookup[$c.InnerText] -eq $null)
                        {
                            $lookup[$c.InnerText] = $t.Outcome;
                        }
                               
                        $currentValue = $lookup[$c.InnerText];

                        if($t.Outcome -ne "Passed")
                        {
                            $lookup[$c.Innertext] = "Failed";
                        }
                        else 
                        {   
                            if($currentValue -ne "Passed")
                            {
                                $lookup[$c.Innertext] = "Failed";
                            }
                        }
                      }
                }
                else
                {
                    # We can use the default work items. 
                    foreach($DefaultWorkitem in $DefaultWorkitems)
                    {
                        if($lookup[$DefaultWorkitem] -eq $null)
                        {
                            $lookup[$DefaultWorkitem] = $t.Outcome;
                        }
                               
                        $currentValue = $lookup[$DefaultWorkitem];

                        if($t.Outcome -ne "Passed")
                        {
                            $lookup[$DefaultWorkitem] = "Failed";
                        }
                        else 
                        {   
                            if($currentValue -ne "Passed")
                            {
                                $lookup[$DefaultWorkitem] = "Failed";
                            }
                        }

                    }
                }
            }
        }

        foreach($key in $lookup.Keys)
        {
            $o2 = New-Object "PSObject";

            Add-Member -InputObject $o2 -NotePropertyName "Workitem"        -NotePropertyValue $key;
            Add-Member -InputObject $o2 -NotePropertyName "Outcome"         -NotePropertyValue $lookup[$key];

            $Result += $o2;
        }

    }
    END
    {
        return ,$Result;
    }

}
