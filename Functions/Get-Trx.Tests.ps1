$here = Split-Path -Parent $MyInvocation.MyCommand.Path
# $sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
$testDataFolder = "$here\TestData";
Import-Module "$here\..\Triksy.psm1"

Describe "Get-Trx" {

    Context "When Get-Trx is invoked" {

        It "returns an empty array when the files parameter is empty" {

            $result = (Get-Trx -Files @());
            Write-Verbose $result.GetType();
            $result.GetType().Name | Should Be "Object[]";
            $result.Length | Should Be "0";

        }

        It "returns an array with one entry containing a valid Trx that exists" {

            $result = (Get-Trx -Files @("$testDataFolder\Valid\MsTestSummary1.trx"));
            Write-Verbose $result.GetType();
            $result.GetType().Name | Should Be "Object[]";
            $result.Length | Should Be "1";

            $result[0].Exists | Should Be $true;
            $result[0].Valid | Should Be $true;
            $result[0].XmlObject | Should Not Be Null;
            $result[0].Path | Should Be "$testDataFolder\Valid\MsTestSummary1.trx";
        }

        It "returns an array with one entry containing a Trx that does not exist" {

            $result = (Get-Trx -Files @("$testDataFolder\Valid\MsTestThatDoesNotExt.trx"));
            Write-Verbose $result.GetType();

            $result.Length | Should Be 1;

            $result[0].Exists | Should Be $false;
            $result[0].Valid | Should Be $null;
            $result[0].XmlObject | Should Be $null;
            $result[0].Path | Should Be "$testDataFolder\Valid\MsTestThatDoesNotExt.trx";

        }

        It "returns an array with one entry containing an invalid Trx" {

            $result = (Get-Trx -Files @("$testDataFolder\Invalid\MsTestThatIsInvalid.trx"));
            Write-Verbose $result.GetType();

            $result.Length | Should Be 1;

            $result[0].Exists | Should Be $true;
            $result[0].Valid | Should Be $false;
            $result[0].XmlObject | Should Be $null;
            $result[0].Path | Should Be "$testDataFolder\Invalid\MsTestThatIsInvalid.trx";

        }

        It "returns an array with two entries containing one valid and one invalid Trx" {

            $result = (Get-Trx -Files @("$testDataFolder\Invalid\MsTestThatIsInvalid.trx", "$testDataFolder\Valid\MsTestSummary1.trx"));
            Write-Verbose $result.GetType();

            $result.Length | Should Be 2;

            $result[0].Exists | Should Be $true;
            $result[0].Valid | Should Be $false;
            $result[0].XmlObject | Should Be $null;
            $result[0].Path | Should Be "$testDataFolder\Invalid\MsTestThatIsInvalid.trx";
                
            $result[1].Exists | Should Be $true;
            $result[1].Valid | Should Be $true;
            $result[1].XmlObject | Should Not Be Null;
            $result[1].Path | Should Be "$testDataFolder\Valid\MsTestSummary1.trx";
        }

    }

    Context "When filenames are passed in from the pipe" {

        It "returns an empty array when no files are passed in" {

            $result = (Get-ChildItem "$testDataFolder\Valid\*.noneexistent" | Get-Trx);
            Write-Verbose $result.GetType();

            $result.Length | Should Be 0;
        }

        It "returns an array containing one object when a single filename is passed down the pipeline" {

            $result = (Get-ChildItem "$testDataFolder\Valid\MsTestSummary1.trx" | Get-Trx);
            Write-Verbose $result.GetType();
            $result.GetType().Name | Should Be "Object[]";
            $result.Length | Should Be "1";

            $result[0].Exists | Should Be $true;
            $result[0].Valid | Should Be $true;
            $result[0].XmlObject | Should Not Be Null;
            $result[0].Path | Should Be "$testDataFolder\Valid\MsTestSummary1.trx";
        }

        It "returns an array containing two objects when two trx files are passed down the pipeline" {

            $result = (Get-ChildItem "$testDataFolder\Valid\MsTestSummary*.trx" | Get-Trx);
            Write-Verbose $result.GetType();
            $result.GetType().Name | Should Be "Object[]";
            $result.Length | Should Be "2";

            $file = $result | Where-Object { $_.Path -eq "$testDataFolder\Valid\MsTestSummary1.trx" } | Select-Object -First 1
            $file.Exists | Should Be $true;
            $file.Valid | Should Be $true;
            $file.XmlObject | Should Not Be Null;
            $file.Path | Should Be "$testDataFolder\Valid\MsTestSummary1.trx";

            $file = $result | Where-Object { $_.Path -eq "$testDataFolder\Valid\MsTestSummary2.trx" } | Select-Object -First 1
            $file.Exists | Should Be $true;
            $file.Valid | Should Be $true;
            $file.XmlObject | Should Not Be Null;
            $file.Path | Should Be "$testDataFolder\Valid\MsTestSummary2.trx";

        }

    }
}
