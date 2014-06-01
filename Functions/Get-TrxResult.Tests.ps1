$here = Split-Path -Parent $MyInvocation.MyCommand.Path
# $sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
$testDataFolder = "$here\TestData";
Import-Module "$here\..\Triksy.psm1"

Describe "Get-TrxResult" {

    Context "When we pass Get-Trx objects down the pipeline" {

        It "returns an empty array when no objects are passed in" {

            $result = (Get-Trx -Files @() | Get-TrxResult);

            Write-Verbose $result.GetType();
            $result.GetType().Name | Should Be "Object[]";
            $result.Length | Should Be "0";

        }

        It "returns an empty array when a TRX file has no results" {

            $result = (Get-Trx -Files @("$testDataFolder\Valid\MsTestNoTestResults.trx") | Get-TrxResult);

            Write-Verbose $result.GetType();
            $result.GetType().Name | Should Be "Object[]";
            $result.Length | Should Be "0";

        }

        It "returns a single test result where the results file contains a single result" {

            $result = (Get-Trx -Files @("$testDataFolder\Valid\MsTestSingleResult.trx") | Get-TrxResult);

            Write-Verbose $result.GetType();
            $result.GetType().Name | Should Be "Object[]";
            $result.Length | Should Be "1";

            $result[0].ExecutionId                    | Should Be "78f8285b-2e8e-4c51-b3f2-b42eae5a6064";
            $result[0].TestId                         | Should Be "bb99404f-dca9-bd18-ef8c-79f3920eb938";
            $result[0].TestName                       | Should Be "AlwaysPass";
            $result[0].ComputerName                   | Should Be "THEMACHINE";
            $result[0].Duration                       | Should Be "00:00:00.0180327";
            $result[0].StartTime                      | Should Be "2014-05-28T21:42:02.3764287-07:00";
            $result[0].EndTime                        | Should Be "2014-05-28T21:42:02.8784574-07:00";
            $result[0].TestType                       | Should Be "13cdc9d9-ddb5-4fa4-a97d-d965ccfc6d4b";
            $result[0].Outcome                        | Should Be "Passed";
            $result[0].TestListId                     | Should Be "8c84fa94-04c1-424b-9868-57a2d4851a1d";
            $result[0].RelativeResultsDirectory       | Should Be "78f8285b-2e8e-4c51-b3f2-b42eae5a6064";
            $result[0].Path                           | Should Be "$testDataFolder\Valid\MsTestSingleResult.trx";
        }


        It "returns two test results where the results file contains two results" {

            $result = (Get-Trx -Files @("$testDataFolder\Valid\MsTestTwoResults.trx") | Get-TrxResult);

            Write-Verbose $result.GetType();
            $result.GetType().Name | Should Be "Object[]";
            $result.Length | Should Be "2";

            $result[0].TestId                         | Should Be "fc878d54-a4e9-0991-83dc-502ccc3c8cf0";
            $result[1].TestId                         | Should Be "314a4350-bd73-7610-acb0-ed65a4722938";
        }

        It "returns all of the test results from two valid existing files" {

            $result = (Get-Trx -Files @("$testDataFolder\Valid\MsTestSingleResult.trx", "$testDataFolder\Valid\MsTestTwoResults.trx") | Get-TrxResult);

            Write-Verbose $result.GetType();
            $result.GetType().Name | Should Be "Object[]";
            $result.Length | Should Be "3";

            $result[0].TestId                         | Should Be "bb99404f-dca9-bd18-ef8c-79f3920eb938";
            $result[1].TestId                         | Should Be "fc878d54-a4e9-0991-83dc-502ccc3c8cf0";
            $result[2].TestId                         | Should Be "314a4350-bd73-7610-acb0-ed65a4722938";

        }

        It "returns all of the test results from two valid existing files with one invalid and one that does not exist" {

            $result = (Get-Trx -Files @("$testDataFolder\Valid\MsTestSingleResult.trx", "$testDataFolder\Valid\MsTestNotExist.trx", "$testDataFolder\Invalid\MsTestThatIsInvalid.trx", "$testDataFolder\Valid\MsTestTwoResults.trx") | Get-TrxResult);

            Write-Verbose $result.GetType();
            $result.GetType().Name | Should Be "Object[]";
            $result.Length | Should Be "3";

            $result[0].TestId                         | Should Be "bb99404f-dca9-bd18-ef8c-79f3920eb938";
            $result[1].TestId                         | Should Be "fc878d54-a4e9-0991-83dc-502ccc3c8cf0";
            $result[2].TestId                         | Should Be "314a4350-bd73-7610-acb0-ed65a4722938";

        }


        It "returns the raw [xml] output to get at the Output.ErrorInfo.[ErrorMessage|StackTrace]" {

            $result = (Get-Trx -Files @("$testDataFolder\Valid\MsTestTwoResults.trx") | Get-TrxResult);

            Write-Verbose $result.GetType();
            $result.GetType().Name | Should Be "Object[]";
            $result.Length | Should Be "2";

            $result[0].TestId                         | Should Be "fc878d54-a4e9-0991-83dc-502ccc3c8cf0";
            $result[0].Output                         | Should Not Be $null;
            $result[1].TestId                         | Should Be "314a4350-bd73-7610-acb0-ed65a4722938";
            $result[1].Output                         | Should Be $null;

            $result[0].Output.ErrorInfo.Message              | Should Be "Assert.Fail failed. Failed";
        }

    }

}
