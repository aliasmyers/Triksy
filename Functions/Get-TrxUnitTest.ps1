<#
.SYNOPSIS
Get the unit tests in the TRX file. 

.DESCRIPTION
The unit tests contain information such as its Test Id, the storage (location on disk), the adapter used to execute the tests and so forth. 

.PARAMETER Trxs
Zero or more TRX files returned from the call to Get-Trx. 

.PARAMETER DefaultWorkItems
If specified, all unit tests that do not have at least one work item will have these workitems added to the output object. 

.PARAMETER DefaultCategories
If specified, all unit tests that do not have at least one test category associated with it have these categories added to the output object. 

.PARAMETER DefaultProperties
If specified, all unit tests that do not have at least one test property associated with it will have these properties added to the output object. 

.EXAMPLE
Get all of the unit tests from a single TRX file:

Get-Trx -Files "thefile.trx" | Get-TrxUnitTest;

.EXAMPLE
Get all of the results from all TRX files:

Get-ChildItem "*.trx" -Recurse | Get-Trx | Get-TrxUnitTest

.EXAMPLE
Get all of the results in a TRX file and associate Workitem 1234 with any unit test that does not have a workitem. 

Get-Trx -Files "thefile.trx" | Get-TrxUnitTest -DefaultWorkItems 1234
#>
function Get-TrxUnitTest {

    [CmdletBinding(DefaultParameterSetName="ByTrxs")]
    PARAM(
        [Parameter(ParameterSetName = "ByTrxs", Mandatory = $true, ValueFromPipeline=$true)]
        [AllowEmptyCollection()]
        [PSObject[]] $Trxs,
        [Parameter(ParameterSetName = "ByTrxs", Mandatory = $false)]
        [string[]] $DefaultWorkitems,
        [Parameter(ParameterSetName = "ByTrxs", Mandatory = $false)]
        [string[]] $DefaultCategories,
        [Parameter(ParameterSetName = "ByTrxs", Mandatory = $false)]
        [string[]] $DefaultProperties
    )
    BEGIN
    {
        $Result = @();
    }
    PROCESS
    {
        foreach($t in $Trxs)
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

                    foreach($cn in $x.TestRun.TestDefinitions.ChildNodes)
                    {
                        $o2 = New-Object "PSObject";

                        # Map across original properties
                        Add-Member -InputObject $o2 -NotePropertyName "Name"            -NotePropertyValue $cn.Name;
                        Add-Member -InputObject $o2 -NotePropertyName "Storage"         -NotePropertyValue $cn.Storage;
                        Add-Member -InputObject $o2 -NotePropertyName "Id"              -NotePropertyValue $cn.Id;
                        Add-Member -InputObject $o2 -NotePropertyName "Execution"       -NotePropertyValue $cn.Execution;
                        Add-Member -InputObject $o2 -NotePropertyName "TestMethod"      -NotePropertyValue $cn.TestMethod;

                        Add-Member -InputObject $o2 -NotePropertyName "Path"            -NotePropertyValue $t.Path;

                        # Properties
                        $properties = @{ };

                        if($cn.Properties -ne $null -and $cn.Properties.ChildNodes -ne $null)
                        {
                            foreach($c in $cn.Properties.ChildNodes)
                            {
                                $properties[$c.Key] = $c.Value;
                            }
                        }

                        if($DefaultProperties -ne $null -and $DefaultProperties.Length -ne 0 -and $properties.Count -eq 0)
                        {
                            foreach($DefaultProperty in $DefaultProperties)
                            {
                                $properties[$DefaultProperty] = $true;
                            }
                        }

                        Add-Member -InputObject $o2 -NotePropertyName "Properties"      -NotePropertyValue $properties;

                        # Categories
                        $categories = @{ };

                        if($cn.TestCategory -ne $null -and $cn.TestCategory.ChildNodes -ne $null)
                        {
                            foreach($c in $cn.TestCategory.ChildNodes)
                            {
                                $categories[$c.TestCategory] = $c.TestCategory;
                            }
                        }

                        if($DefaultCategories -ne $null -and $DefaultCategories.Length -ne 0 -and $categories.Count -eq 0)
                        {
                            foreach($DefaultCategory in $DefaultCategories)
                            {
                                $categories[$DefaultCategory] = $true;
                            }
                        }

                        Add-Member -InputObject $o2 -NotePropertyName "Categories"    -NotePropertyValue $categories;

                        # Workitems
                        $Workitems = @{ };

                        if($cn.Workitems -ne $null -and $cn.Workitems.ChildNodes -ne $null)
                        {
                            foreach($c in $cn.Workitems.ChildNodes)
                            {
                                $workitems[$c.InnerText] = $c.InnerText;
                            }
                        }

                        if($DefaultWorkitems -ne $null -and $DefaultWorkitems.Length -ne 0 -and $workitems.Count -eq 0)
                        {
                            foreach($DefaultWorkitem in $DefaultWorkitems)
                            {
                                $workitems[$DefaultWorkitem] = $true;
                            }
                        }

                        Add-Member -InputObject $o2 -NotePropertyName "Workitems"    -NotePropertyValue $workitems;

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
