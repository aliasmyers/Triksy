<#
.SYNOPSIS
Load zero or more TRX files and convert them into an [xml] object along with information such as "does the file exist?" and "is it valid?". 

.DESCRIPTION
Get-Trx will return a PSObject containing four properties: Path; Exists; Valid; XmlObject. Pass the output of this method to Get-TrxResult, Get-TrxUnitTest and Get-TrxWorkitemSummary

This method is intended to be called to process a TRX file that might or might not exist (running MsTest against a DLL containing no tests does not produce a TRX file). As part of an automation pipeline, it is better to explicitly check for the the existence of particular TRX file rather than discover; catastrophic failures might be missed otherwise. 

It is legal to pass in files that do not exist or are not valid Xml. 

The returned objects contains four properties:

Path - The fully qualified path of the TRX file. 
Exists - True or False. True if the file existed; False otherwise. 
Valid - True if the file was loaded as valid Xml; False otherwise.
XmlObject - An [xml] cast of the TRX file. ie: $x = [xml] (Get-Content theFile.trx)
#>
function Get-Trx {
    PARAM(
        [Parameter(Mandatory = $true, ValueFromPipeline=$true)]
        [AllowEmptyCollection()]
        [string[]] $Files
    )
    BEGIN
    {
        $Result = @();
    }
    PROCESS
    {
        foreach($file in $Files)
        {
            $o = New-Object "PSObject";

            $exists = Test-Path $file;
            if($exists -eq $false) 
            { 
                Write-Verbose "The file does not exist" -Verbose;
            }

            Add-Member -InputObject $o -NotePropertyName "Exists" -NotePropertyValue $exists;

            $valid = $false;
            $xml = $null;
            try
            {
                if($exists)
                {
                    $xml = [Xml] (Get-Content $File);

                    $valid = $true;
                }
                else
                {
                    $valid = $null;
                }
                
            }
            catch
            {
            }

            Add-Member -InputObject $o -NotePropertyName "Path" -NotePropertyValue $File;
            Add-Member -InputObject $o -NotePropertyName "Valid" -NotePropertyValue $valid;
            Add-Member -InputObject $o -NotePropertyName "XmlObject" -NotePropertyValue $xml;

            $Result += $o;
        }



    }
    END
    {
        return ,$Result;
    }
}
