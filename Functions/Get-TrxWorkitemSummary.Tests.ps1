$here = Split-Path -Parent $MyInvocation.MyCommand.Path
# $sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
$testDataFolder = "$here\TestData";
Import-Module "$here\..\Triksy.psm1"

Describe "Get-TrxWorkitemSummary" {

    Context "When result objects are passed down the pipeline" {

		It "returns an empty array if there are no results in the pipeline" {

            $result = (Get-Trx "$testDataFolder\Valid\MsTestSingleResult.trx" | Get-TrxResult | Get-TrxWorkitemSummary);

            Write-Verbose $result.GetType();
            $result.GetType().Name | Should Be "Object[]";
            $result.Length | Should Be "0";
        
	    }

        It "returns a single pass result as passed" {

            $result = (Get-Trx "$testDataFolder\Valid\MsTestAttributes.trx" | Get-TrxResult | Get-TrxWorkitemSummary);

            $workitem = ($result | Where-Object { $_.Workitem -eq 2000 } | Select-Object -First 1);
            $workitem | Should Not Be $null;

            Write-Verbose "Outcome: $($workitem.Outcome)" -Verbose;

            $workitem.Workitem | Should Be 2000;
            $workitem.Outcome  | Should Be "Passed";
        }


        It "returns an inconclusive as a failure" {

            $result = (Get-Trx "$testDataFolder\Valid\MsTestAttributes.trx" | Get-TrxResult | Get-TrxWorkitemSummary);

            $workitem = ($result | Where-Object { $_.Workitem -eq 4000 } | Select-Object -First 1);
            $workitem | Should Not Be $null;

            Write-Verbose "Outcome: $($workitem.Outcome)" -Verbose;

            $workitem.Workitem | Should Be 4000;
            $workitem.Outcome  | Should Be "Failed";
        }

        It "returns a single failure as a failure" {

            $result = (Get-Trx "$testDataFolder\Valid\MsTestAttributes.trx" | Get-TrxResult | Get-TrxWorkitemSummary);

            $workitem = ($result | Where-Object { $_.Workitem -eq 2001 } | Select-Object -First 1);
            $workitem | Should Not Be $null;

            Write-Verbose "Outcome: $($workitem.Outcome)" -Verbose;

            $workitem.Workitem | Should Be 2001;
            $workitem.Outcome  | Should Be "Failed";
        }

        It "returns a pass and a fail as a fail" {

            $result = (Get-Trx "$testDataFolder\Valid\MsTestAttributes.trx" | Get-TrxResult | Get-TrxWorkitemSummary);

            $workitem = ($result | Where-Object { $_.Workitem -eq 3000 } | Select-Object -First 1);
            $workitem | Should Not Be $null;

            Write-Verbose "Outcome: $($workitem.Outcome)" -Verbose;

            $workitem.Workitem | Should Be 3000;
            $workitem.Outcome  | Should Be "Failed";
        }

        It "returns a pass for the default work item when it is provided" {

            $result = (Get-Trx "$testDataFolder\Valid\MsTestAttributes.trx" | Get-TrxResult | Get-TrxWorkitemSummary -DefaultWorkitems 1234);

            $workitem = ($result | Where-Object { $_.Workitem -eq 1234 } | Select-Object -First 1);
            $workitem | Should Not Be $null;

            Write-Verbose "Outcome: $($workitem.Outcome)" -Verbose;

            $workitem.Workitem | Should Be 1234;
            $workitem.Outcome  | Should Be "Passed";

        }
    }
}
