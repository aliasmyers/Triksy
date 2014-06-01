# MODULE: 		  Triksy
#
# VERSION:        1.0 (31-May-2014)
#
# DESCRIPTION: 	  PowerShell Advanced Functions to process and aggregate TRX results files. 
#
# AUTHOR:         Graham Stephenson (feedback@brekit.com, http://www.havecomputerwillcode.com)
#
# DISCLAIMER:     Do not use (that should cover it!)
#
$here = Split-Path -Parent $MyInvocation.MyCommand.Path

. $here\Functions\Get-Trx.ps1
. $here\Functions\Get-TrxSummary.ps1
. $here\Functions\Get-TrxResult.ps1
. $here\Functions\Get-TrxUnitTest.ps1
. $here\Functions\Get-TrxWorkitemSummary.ps1

Export-ModuleMember -Function "Get-Trx"
Export-ModuleMember -Function "Get-TrxSummary"
Export-ModuleMember -Function "Get-TrxResult"
Export-ModuleMember -Function "Get-TrxUnitTest"
Export-ModuleMember -Function "Get-TrxWorkitemSummary"
