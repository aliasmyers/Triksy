<#
.SYNOPSIS
Get the summary from zero or more Trx files. A single object is always returned with -Aggregate. An array containing zero, one or more elements is returned where -Aggregate is not specified. 

.DESCRIPTION
A summary consists of the properties from Get-Trx (Exists, Valid, XmlObject etc), the overall Outcome and Counters from the Trx file. It is legal to pass in the location of files that do not exist or are not valid TRX. Check the Exists and Valid properties of the returned objects. 

.PARAMETER ByFiles
Zero or more paths to a TRX files to be summarised. It is legal to pass in files that do not exist or are not valid Xml.

.PARAMETER ByTrxs
Zero or more TRX files returned from the call to Get-Trx. 

.PARAMETER Aggregate
Will optionally sum the totals / counters for all Trx files and return a single object containing a summary. The returned information includes all of the Counters, the number of files that existed, were valid, and the total.

.EXAMPLE
Get a summary of an individual Trx file:

Get-TrxSummary -Files "thefile.trx";

.EXAMPLE
Summarize every TRX file discovered in this directory and its children:

Get-ChildItem "*.trx" -Recurse | Get-TrxSummary

.EXAMPLE
Summarize every TRX file that has been processed by Get-Trx:

Get-ChildItem "*.trx" -Recurse | Get-Trx | Get-TrxSummary

.EXAMPLE
Sum the Counters (Passed, Failed, NotRun etc) from the Counters section of every TRX file. This will return a single object containing the aggregated totals:

Get-ChildItem "*.trx -Recurse | Get-TrxSummary -Aggregate
#>
function Get-TrxSummary {
    [CmdletBinding(DefaultParameterSetName="ByFiles")]
    PARAM(
        [Parameter(ParameterSetName = "ByFiles", Mandatory = $true, ValueFromPipeline=$true)]
        [AllowEmptyCollection()]
        [string[]] $Files,
        [Parameter(ParameterSetName = "ByTrxs", Mandatory = $true, ValueFromPipeline=$true)]
        [AllowEmptyCollection()]
        [PSObject[]] $Trxs,
        [Parameter(Mandatory = $false)]
        [Switch] $Aggregate
    )
    BEGIN
    {
        $Result = @();
    }
    PROCESS
    {
        # Regardless of the parameter set used, coerce everything into an object collection to simplify processing. 
        $FilesToUse = @($Files);
        $ObjectsToUse = @($Trxs);

        switch($PSCmdlet.ParameterSetName)
        {
            "ByFiles"
            {
                $ObjectsToUse = @();

                foreach($file in $Files)
                {
                    $t = (Get-Trx $file);

                    $ObjectsToUse += $t;
                }
            }

            "ByTrxs"
            {
                # We have no work to do - we have to assume the object is the Trx object. 
            }
        }

        # ASSERTION: $ObjectsToUse contains the Get-Trx output we need to work with. 

        foreach($o in $ObjectsToUse)
        {
            $o2 = New-Object "PSObject";

            # Map across original properties
            Add-Member -InputObject $o2 -NotePropertyName "Path" -NotePropertyValue $o.Path;
            Add-Member -InputObject $o2 -NotePropertyName "Valid" -NotePropertyValue $o.Valid;
            Add-Member -InputObject $o2 -NotePropertyName "XmlObject" -NotePropertyValue $o.XmlObject;
            Add-Member -InputObject $o2 -NotePropertyName "Exists" -NotePropertyValue $o.Exists;
           
            if($o.Exists -and $o.Valid -and ($o.XmlObject -ne $null))
            {
                $x = $o.XmlObject;

                $outcome = $x.TestRun.ResultSummary.Outcome;

                # Outcome 
                Add-Member -InputObject $o2 -NotePropertyName "Outcome" -NotePropertyValue "$outcome";

                # Counters
                Add-Member -InputObject $o2 -NotePropertyName "Total"               -NotePropertyValue $x.TestRun.ResultSummary.Counters.Total
                Add-Member -InputObject $o2 -NotePropertyName "Executed"            -NotePropertyValue $x.TestRun.ResultSummary.Counters.Executed
                Add-Member -InputObject $o2 -NotePropertyName "Passed"              -NotePropertyValue $x.TestRun.ResultSummary.Counters.Passed
                Add-Member -InputObject $o2 -NotePropertyName "Error"               -NotePropertyValue $x.TestRun.ResultSummary.Counters.Error
                Add-Member -InputObject $o2 -NotePropertyName "Failed"              -NotePropertyValue $x.TestRun.ResultSummary.Counters.Failed
                Add-Member -InputObject $o2 -NotePropertyName "Timeout"             -NotePropertyValue $x.TestRun.ResultSummary.Counters.Timeout
                Add-Member -InputObject $o2 -NotePropertyName "Aborted"             -NotePropertyValue $x.TestRun.ResultSummary.Counters.Aborted
                Add-Member -InputObject $o2 -NotePropertyName "Inconclusive"        -NotePropertyValue $x.TestRun.ResultSummary.Counters.Inconclusive
                Add-Member -InputObject $o2 -NotePropertyName "PassedButRunAborted" -NotePropertyValue $x.TestRun.ResultSummary.Counters.PassedButRunAborted
                Add-Member -InputObject $o2 -NotePropertyName "NotRunnable"         -NotePropertyValue $x.TestRun.ResultSummary.Counters.NotRunnable
                Add-Member -InputObject $o2 -NotePropertyName "NotExecuted"         -NotePropertyValue $x.TestRun.ResultSummary.Counters.NotExecuted
                Add-Member -InputObject $o2 -NotePropertyName "Disconnected"        -NotePropertyValue $x.TestRun.ResultSummary.Counters.Disconnected
                Add-Member -InputObject $o2 -NotePropertyName "Warning"             -NotePropertyValue $x.TestRun.ResultSummary.Counters.Warning
                Add-Member -InputObject $o2 -NotePropertyName "Completed"           -NotePropertyValue $x.TestRun.ResultSummary.Counters.Completed
                Add-Member -InputObject $o2 -NotePropertyName "InProgress"          -NotePropertyValue $x.TestRun.ResultSummary.Counters.InProgress
            }
            else
            {
                # Outcome 
                Add-Member -InputObject $o2 -NotePropertyName "Outcome" -NotePropertyValue $null;

                # Counters
                Add-Member -InputObject $o2 -NotePropertyName "Total"               -NotePropertyValue $null;
                Add-Member -InputObject $o2 -NotePropertyName "Executed"            -NotePropertyValue $null;
                Add-Member -InputObject $o2 -NotePropertyName "Passed"              -NotePropertyValue $null;
                Add-Member -InputObject $o2 -NotePropertyName "Error"               -NotePropertyValue $null;
                Add-Member -InputObject $o2 -NotePropertyName "Failed"              -NotePropertyValue $null;
                Add-Member -InputObject $o2 -NotePropertyName "Timeout"             -NotePropertyValue $null;
                Add-Member -InputObject $o2 -NotePropertyName "Aborted"             -NotePropertyValue $null;
                Add-Member -InputObject $o2 -NotePropertyName "Inconclusive"        -NotePropertyValue $null;
                Add-Member -InputObject $o2 -NotePropertyName "PassedButRunAborted" -NotePropertyValue $null;
                Add-Member -InputObject $o2 -NotePropertyName "NotRunnable"         -NotePropertyValue $null;
                Add-Member -InputObject $o2 -NotePropertyName "NotExecuted"         -NotePropertyValue $null;
                Add-Member -InputObject $o2 -NotePropertyName "Disconnected"        -NotePropertyValue $null;
                Add-Member -InputObject $o2 -NotePropertyName "Warning"             -NotePropertyValue $null;
                Add-Member -InputObject $o2 -NotePropertyName "Completed"           -NotePropertyValue $null;
                Add-Member -InputObject $o2 -NotePropertyName "InProgress"          -NotePropertyValue $null;
            }

            $Result += $o2;
        }
    }
    END
    {
        if($aggregate)
        {
            $exists    = [int] 0;
            $valid     = [int] 0;

            $Total               = [int] 0;
            $Executed            = [int] 0;
            $Passed              = [int] 0;
            $Error               = [int] 0;
            $Failed              = [int] 0;
            $Timeout             = [int] 0;
            $Aborted             = [int] 0;
            $Inconclusive        = [int] 0;
            $PassedButRunAborted = [int] 0;
            $NotRunnable         = [int] 0;
            $NotExecuted         = [int] 0;
            $Disconnected        = [int] 0;
            $Warning             = [int] 0;
            $Completed           = [int] 0;
            $InProgress          = [int] 0;
            $FileCount           = [int] 0;

            foreach($r in $Result)
            {
                $FileCount++;

                if($r.Exists) { $exists++ };
                if($r.Valid)  { $valid++  };

                if($r.Valid)
                {
                    $Total               += [int] $r.Total;
                    $Executed            += [int] $r.Executed;
                    $Passed              += [int] $r.Passed;
                    $Error               += [int] $r.Error;
                    $Failed              += [int] $r.Failed;
                    $Timeout             += [int] $r.Timeout;
                    $Aborted             += [int] $r.Aborted;
                    $Inconclusive        += [int] $r.Inconclusive;
                    $PassedButRunAborted += [int] $r.PassedButRunAborted;
                    $NotRunnable         += [int] $r.NotRunnable;
                    $NotExecuted         += [int] $r.NotExecuted;
                    $Disconnected        += [int] $r.Disconnected;
                    $Warning             += [int] $r.Warning;
                    $Completed           += [int] $r.completed;
                    $InProgress          += [int] $r.InProgress;
                }
            }

            # Publish the aggregated object. 
            $o2 = New-Object "PSObject";

            Add-Member -InputObject $o2 -NotePropertyName "Total"               -NotePropertyValue $Total;
            Add-Member -InputObject $o2 -NotePropertyName "Executed"            -NotePropertyValue $Executed;
            Add-Member -InputObject $o2 -NotePropertyName "Passed"              -NotePropertyValue $Passed;
            Add-Member -InputObject $o2 -NotePropertyName "Error"               -NotePropertyValue $Error;
            Add-Member -InputObject $o2 -NotePropertyName "Failed"              -NotePropertyValue $Failed;
            Add-Member -InputObject $o2 -NotePropertyName "Timeout"             -NotePropertyValue $Timeout;
            Add-Member -InputObject $o2 -NotePropertyName "Aborted"             -NotePropertyValue $Aborted;
            Add-Member -InputObject $o2 -NotePropertyName "Inconclusive"        -NotePropertyValue $Inconclusive;
            Add-Member -InputObject $o2 -NotePropertyName "PassedButRunAborted" -NotePropertyValue $PassedButRunAborted;
            Add-Member -InputObject $o2 -NotePropertyName "NotRunnable"         -NotePropertyValue $NotRunnable;
            Add-Member -InputObject $o2 -NotePropertyName "NotExecuted"         -NotePropertyValue $NotExecuted;
            Add-Member -InputObject $o2 -NotePropertyName "Disconnected"        -NotePropertyValue $Disconnected;
            Add-Member -InputObject $o2 -NotePropertyName "Warning"             -NotePropertyValue $Warning;
            Add-Member -InputObject $o2 -NotePropertyName "Completed"           -NotePropertyValue $Completed;
            Add-Member -InputObject $o2 -NotePropertyName "InProgress"          -NotePropertyValue $InProgress;

            Add-Member -InputObject $o2 -NotePropertyName "Files"               -NotePropertyValue $FileCount;
            Add-Member -InputObject $o2 -NotePropertyName "Valid"               -NotePropertyValue $valid;
            Add-Member -InputObject $o2 -NotePropertyName "Exists"              -NotePropertyValue $exists;
            
            return $o2;
        }
        else
        {
            return ,$Result;
        }
    }
}
