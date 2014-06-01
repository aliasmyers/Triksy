$here = Split-Path -Parent $MyInvocation.MyCommand.Path
# $sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
$testDataFolder = "$here\TestData";
Import-Module "$here\..\Triksy.psm1"

Describe "Get-TrxUnitTest" {

    Context "When Trx objects are passed down the pipeline" {

		It "returns an empty array when no objects are passed down" {

            $result = (Get-Trx -Files @() | Get-TrxUnitTest);

            Write-Verbose $result.GetType();
            $result.GetType().Name | Should Be "Object[]";
            $result.Length | Should Be "0";

        }

        It "returns an empty array when a TRX file has no unit tests" {

            $result = (Get-Trx -Files @("$testDataFolder\Valid\MsTestNoTestResults.trx") | Get-TrxUnitTest);

            Write-Verbose $result.GetType();
            $result.GetType().Name | Should Be "Object[]";
            $result.Length | Should Be "0";

        }


        It "returns a single test where the results file contains a single unit test" {

            $result = (Get-Trx -Files @("$testDataFolder\Valid\MsTestSingleResult.trx") | Get-TrxUnitTest);

            Write-Verbose $result.GetType();
            $result.GetType().Name | Should Be "Object[]";
            $result.Length | Should Be "1";

            $result[0].Name              | Should Be "AlwaysPass";
            $result[0].Storage           | Should Be "mstestsingleproject.dll";
            $result[0].Id                | Should Be "bb99404f-dca9-bd18-ef8c-79f3920eb938";
            $result[0].Execution         | Should Not Be $null;
            $result[0].Execution.Id      | Should Be "78f8285b-2e8e-4c51-b3f2-b42eae5a6064";

            $result[0].TestMethod        | Should Not Be $null;
            $result[0].TestMethod.Name   | Should Be "AlwaysPass";
        }

        It "returns two tests where the results file contains two unit tests" {

            $result = (Get-Trx -Files @("$testDataFolder\Valid\MsTestTwoResults.trx") | Get-TrxUnitTest);

            Write-Verbose $result.GetType();
            $result.GetType().Name | Should Be "Object[]";
            $result.Length | Should Be "2";

            $result[0].Id    | Should Be "314a4350-bd73-7610-acb0-ed65a4722938";
            $result[1].Id    | Should Be "fc878d54-a4e9-0991-83dc-502ccc3c8cf0";
        }

	}



    Context "When we pass Trx objects down the pipeline to process properties" {

        It "returns an empty property dictionary if there are no properties" {

            $result = (Get-Trx -Files @("$testDataFolder\Valid\MsTestAttributes.trx") | Get-TrxUnitTest);

            $result = $result | Where-Object { $_.Name -eq "WithNoProperties" } | Select-Object -First 1;
            $result | Should Not Be $null;

            $result.Properties | Should Not Be $null;
            $result.Properties.Count | Should Be 0;
        }

        It "returns an a dictionary containing the default property" {

            $result = (Get-Trx -Files @("$testDataFolder\Valid\MsTestAttributes.trx") | Get-TrxUnitTest -DefaultProperties "MyProperty");

            $result = $result | Where-Object { $_.Name -eq "WithNoProperties" } | Select-Object -First 1;
            $result | Should Not Be $null;

            $result.Properties | Should Not Be $null;
            $result.Properties.Count | Should Be 1;
            $result.Properties["MyProperty"] | should Be $true;
        }

        It "returns a property dictionary if there is one property" {

            $result = (Get-Trx -Files @("$testDataFolder\Valid\MsTestAttributes.trx") | Get-TrxUnitTest);

            $result = $result | Where-Object { $_.Name -eq "WithOneTestProperty" } | Select-Object -First 1;
            $result | Should Not Be $null;

            $result.Properties | Should Not Be $null;
            $result.Properties.Count | Should Be 1;

            $result.Properties["TheTestProperty1"] | Should Be "TheProperty1Value";
        }

        It "returns a property dictionary if there is one property without the default properties" {

            $result = (Get-Trx -Files @("$testDataFolder\Valid\MsTestAttributes.trx") | Get-TrxUnitTest -DefaultProperties "MyProperty");

            $result = $result | Where-Object { $_.Name -eq "WithOneTestProperty" } | Select-Object -First 1;
            $result | Should Not Be $null;

            $result.Properties | Should Not Be $null;
            $result.Properties.Count | Should Be 1;

            $result.Properties["TheTestProperty1"] | Should Be "TheProperty1Value";
        }

        It "returns a property dictionary if there are two categories" {

            $result = (Get-Trx -Files @("$testDataFolder\Valid\MsTestAttributes.trx") | Get-TrxUnitTest);

            $result = $result | Where-Object { $_.Name -eq "WithTwoTestProperties" } | Select-Object -First 1;
            $result | Should Not Be $null;

            $result.Properties | Should Not Be $null;
            $result.Properties.Count | Should Be 2;

            $result.Properties["TheTestProperty1"] | Should Be "TheProperty1Value";
            $result.Properties["TheTestProperty2"] | Should Be "TheProperty2Value";
        }
    }




    Context "When we pass Trx objects down the pipeline to process categories" {

        It "returns an empty category dictionary if there are no categories and no default category is specified" {

            $result = (Get-Trx -Files @("$testDataFolder\Valid\MsTestAttributes.trx") | Get-TrxUnitTest);

            $result = $result | Where-Object { $_.Name -eq "WithNoCategories" } | Select-Object -First 1;
            $result | Should Not Be $null;

            $result.Categories | Should Not Be $null;
            $result.Categories.Count | Should Be 0;
        }

        It "returns a category dictionary containing the default category" {

            $result = (Get-Trx -Files @("$testDataFolder\Valid\MsTestAttributes.trx") | Get-TrxUnitTest -DefaultCategories "MyCategory");

            $result = $result | Where-Object { $_.Name -eq "WithNoCategories" } | Select-Object -First 1;
            $result | Should Not Be $null;

            $result.Categories | Should Not Be $null;
            $result.Categories.Count | Should Be 1;
            $result.Categories["MyCategory"] | Should Be $true;
        }

        It "returns a category dictionary containing the default categories" {

            $result = (Get-Trx -Files @("$testDataFolder\Valid\MsTestAttributes.trx") | Get-TrxUnitTest -DefaultCategories @("MyCategory1","MyCategory2"));

            $result = $result | Where-Object { $_.Name -eq "WithNoCategories" } | Select-Object -First 1;
            $result | Should Not Be $null;

            $result.Categories | Should Not Be $null;
            $result.Categories.Count | Should Be 2;
            $result.Categories["MyCategory1"] | Should Be $true;
            $result.Categories["MyCategory2"] | Should Be $true;
        }

        It "returns a category dictionary if there is one category" {

            $result = (Get-Trx -Files @("$testDataFolder\Valid\MsTestAttributes.trx") | Get-TrxUnitTest);

            $result = $result | Where-Object { $_.Name -eq "WithOneCategory" } | Select-Object -First 1;
            $result | Should Not Be $null;

            $result.Categories | Should Not Be $null;
            $result.Categories.Count | Should Be 1;

            $result.Categories["TheCategory1"] | Should Be $true;
        }

        It "returns a category dictionary if there is one category and ignores the default category" {

            $result = (Get-Trx -Files @("$testDataFolder\Valid\MsTestAttributes.trx") | Get-TrxUnitTest -DefaultCategories "TheDefault");

            $result = $result | Where-Object { $_.Name -eq "WithOneCategory" } | Select-Object -First 1;
            $result | Should Not Be $null;

            $result.Categories | Should Not Be $null;
            $result.Categories.Count | Should Be 1;

            $result.Categories["TheCategory1"] | Should Be $true;
        }

        It "returns a category dictionary if there are two categories" {

            $result = (Get-Trx -Files @("$testDataFolder\Valid\MsTestAttributes.trx") | Get-TrxUnitTest);

            $result = $result | Where-Object { $_.Name -eq "WithTwoCategories" } | Select-Object -First 1;
            $result | Should Not Be $null;

            $result.Categories | Should Not Be $null;
            $result.Categories.Count | Should Be 2;

            $result.Categories["TheCategory1"] | Should Be $true;
            $result.Categories["TheCategory2"] | Should Be $true;
        }
    }



    Context "When we pass Trx objects down the pipeline to process workitems" {

        It "returns an empty workitem dictionary if there are no workitems and no default workitem is specified" {

            $result = (Get-Trx -Files @("$testDataFolder\Valid\MsTestAttributes.trx") | Get-TrxUnitTest);

            $result = $result | Where-Object { $_.Name -eq "WithNoWorkitems" } | Select-Object -First 1;
            $result | Should Not Be $null;

            $result.WorkItems | Should Not Be $null;
            $result.WorkItems.Count | Should Be 0;
        }

        It "returns a workitem dictionary containing the default workitem" {

            $result = (Get-Trx -Files @("$testDataFolder\Valid\MsTestAttributes.trx") | Get-TrxUnitTest -DefaultWorkitems 1234);

            $result = $result | Where-Object { $_.Name -eq "WithNoWorkitems" } | Select-Object -First 1;
            $result | Should Not Be $null;

            $result.WorkItems | Should Not Be $null;
            $result.WorkItems.Count | Should Be 1;
            $result.WorkItems["1234"] | Should Be $true;
        }

        It "returns a workitem dictionary containing the default workitems" {

            $result = (Get-Trx -Files @("$testDataFolder\Valid\MsTestAttributes.trx") | Get-TrxUnitTest -DefaultWorkitems @(1234, 5678) );

            $result = $result | Where-Object { $_.Name -eq "WithNoWorkitems" } | Select-Object -First 1;
            $result | Should Not Be $null;

            $result.WorkItems | Should Not Be $null;
            $result.WorkItems.Count | Should Be 2;
            $result.WorkItems["1234"] | Should Be $true;
            $result.WorkItems["5678"] | Should Be $true;
        }

        It "returns a workitem dictionary if there is one workitem" {

            $result = (Get-Trx -Files @("$testDataFolder\Valid\MsTestAttributes.trx") | Get-TrxUnitTest);

            $result = $result | Where-Object { $_.Name -eq "WithOneWorkitem" } | Select-Object -First 1;
            $result | Should Not Be $null;

            $result.WorkItems | Should Not Be $null;
            $result.WorkItems.Count | Should Be 1;

            $result.WorkItems["1000"] | Should Be $true;
        }

        It "returns a workitem dictionary if there is one workitem even if a default is provided" {

            $result = (Get-Trx -Files @("$testDataFolder\Valid\MsTestAttributes.trx") | Get-TrxUnitTest -DefaultWorkItems 1234);

            $result = $result | Where-Object { $_.Name -eq "WithOneWorkitem" } | Select-Object -First 1;
            $result | Should Not Be $null;

            $result.WorkItems | Should Not Be $null;
            $result.WorkItems.Count | Should Be 1;

            $result.WorkItems["1000"] | Should Be $true;
        }

        It "returns a workitem dictionary if there are two workitems" {

            $result = (Get-Trx -Files @("$testDataFolder\Valid\MsTestAttributes.trx") | Get-TrxUnitTest);

            $result = $result | Where-Object { $_.Name -eq "WithTwoWorkitems" } | Select-Object -First 1;
            $result | Should Not Be $null;

            $result.WorkItems | Should Not Be $null;
            $result.WorkItems.Count | Should Be 2;

            $result.WorkItems["1000"] | Should Be $true;
            $result.WorkItems["1001"] | Should Be $true;
        }
    }



}
