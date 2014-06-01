$here = Split-Path -Parent $MyInvocation.MyCommand.Path
# $sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
$testDataFolder = "$here\TestData";
Import-Module "$here\..\Triksy.psm1"

Describe "Get-TrxSummary" {

    Context "When Get-TrxSummary is called by passing in file names without aggregation" {

        It "It returns an empty array if no files are passed in" {

		    $result = (Get-TrxSummary -Files @());

            Write-Verbose $result.GetType();
            $result.GetType().Name | Should Be "Object[]";
            $result.Length | Should Be "0";
	    }

        It "returns an array containing one element for a valid object" {

            $result = (Get-TrxSummary -Files @("$testDataFolder\Valid\MsTestSummary1.trx"));
            Write-Verbose $result.GetType();
            $result.GetType().Name | Should Be "Object[]";
            $result.Length | Should Be "1";

            $result[0].Exists | Should Be $true;
            $result[0].Valid | Should Be $true;
            $result[0].XmlObject | Should Not Be Null;
            $result[0].Path | Should Be "$testDataFolder\Valid\MsTestSummary1.trx";

            # Outcome
            Write-Verbose "The actual outcome $($result[0].Outcome)" -Verbose;
            $result[0].Outcome | Should Be "Completed";

            $result[0].Total               | Should Be 20;
            $result[0].Executed            | Should Be 19;
            $result[0].Passed              | Should Be 18;
            $result[0].Error               | Should Be 17;
            $result[0].Failed              | Should Be 16;
            $result[0].Timeout             | Should Be 15;
            $result[0].Aborted             | Should Be 14;
            $result[0].Inconclusive        | Should Be 13;
            $result[0].PassedButRunAborted | Should Be 12;
            $result[0].NotRunnable         | Should Be 11;
            $result[0].NotExecuted         | Should Be 10;
            $result[0].Disconnected        | Should Be 9;
            $result[0].Warning             | Should Be 8;
            $result[0].Completed           | Should Be 7;
            $result[0].InProgress          | Should Be 6;

        }

        It "returns an array containing two elements for valid objects" {

            $result = (Get-TrxSummary -Files @("$testDataFolder\Valid\MsTestSummary1.trx", "$testDataFolder\Valid\MsTestSummary2.trx"));
            Write-Verbose $result.GetType();
            $result.GetType().Name | Should Be "Object[]";
            $result.Length | Should Be "2";

            Write-Verbose "The actual outcome $($result[0].Outcome)" -Verbose;
            $result[0].Outcome | Should Be "Completed";

            $result[0].Exists | Should Be $true;
            $result[0].Valid | Should Be $true;
            $result[0].XmlObject | Should Not Be Null;
            $result[0].Path | Should Be "$testDataFolder\Valid\MsTestSummary1.trx";

            $result[0].Total               | Should Be 20;
            $result[0].Executed            | Should Be 19;
            $result[0].Passed              | Should Be 18;
            $result[0].Error               | Should Be 17;
            $result[0].Failed              | Should Be 16;
            $result[0].Timeout             | Should Be 15;
            $result[0].Aborted             | Should Be 14;
            $result[0].Inconclusive        | Should Be 13;
            $result[0].PassedButRunAborted | Should Be 12;
            $result[0].NotRunnable         | Should Be 11;
            $result[0].NotExecuted         | Should Be 10;
            $result[0].Disconnected        | Should Be 9;
            $result[0].Warning             | Should Be 8;
            $result[0].Completed           | Should Be 7;
            $result[0].InProgress          | Should Be 6;

            Write-Verbose "The actual outcome $($result[1].Outcome)" -Verbose;
            $result[1].Outcome | Should Be "Completed";

            $result[1].Exists | Should Be $true;
            $result[1].Valid | Should Be $true;
            $result[1].XmlObject | Should Not Be Null;
            $result[1].Path | Should Be "$testDataFolder\Valid\MsTestSummary2.trx";

            $result[1].Total               | Should Be 120;
            $result[1].Executed            | Should Be 119;
            $result[1].Passed              | Should Be 118;
            $result[1].Error               | Should Be 117;
            $result[1].Failed              | Should Be 116;
            $result[1].Timeout             | Should Be 115;
            $result[1].Aborted             | Should Be 114;
            $result[1].Inconclusive        | Should Be 113;
            $result[1].PassedButRunAborted | Should Be 112;
            $result[1].NotRunnable         | Should Be 111;
            $result[1].NotExecuted         | Should Be 110;
            $result[1].Disconnected        | Should Be 109;
            $result[1].Warning             | Should Be 108;
            $result[1].Completed           | Should Be 107;
            $result[1].InProgress          | Should Be 106;

        }

        It "returns an array containing three elements where the middle file does not exist" {

            $result = (Get-TrxSummary -Files @("$testDataFolder\Valid\MsTestSummary1.trx", "$testDataFolder\Valid\MsTestNotExist.trx","$testDataFolder\Valid\MsTestSummary2.trx"));
            Write-Verbose $result.GetType();
            $result.GetType().Name | Should Be "Object[]";
            $result.Length | Should Be "3";

            Write-Verbose "The actual outcome $($result[0].Outcome)" -Verbose;
            $result[0].Outcome | Should Be "Completed";

            $result[0].Exists | Should Be $true;
            $result[0].Valid | Should Be $true;
            $result[0].XmlObject | Should Not Be Null;
            $result[0].Path | Should Be "$testDataFolder\Valid\MsTestSummary1.trx";

            $result[0].Total               | Should Be 20;
            $result[0].Executed            | Should Be 19;
            $result[0].Passed              | Should Be 18;
            $result[0].Error               | Should Be 17;
            $result[0].Failed              | Should Be 16;
            $result[0].Timeout             | Should Be 15;
            $result[0].Aborted             | Should Be 14;
            $result[0].Inconclusive        | Should Be 13;
            $result[0].PassedButRunAborted | Should Be 12;
            $result[0].NotRunnable         | Should Be 11;
            $result[0].NotExecuted         | Should Be 10;
            $result[0].Disconnected        | Should Be 9;
            $result[0].Warning             | Should Be 8;
            $result[0].Completed           | Should Be 7;
            $result[0].InProgress          | Should Be 6;

            Write-Verbose "The actual outcome $($result[1].Outcome)" -Verbose;
            $result[1].Outcome | Should Be $null;

            $result[1].Exists | Should Be $false;
            $result[1].Valid | Should Be $null;
            $result[1].XmlObject | Should Be $null;
            $result[1].Path | Should Be "$testDataFolder\Valid\MsTestNotExist.trx";

            $result[1].Total               | Should Be $null;
            $result[1].Executed            | Should Be $null;
            $result[1].Passed              | Should Be $null;
            $result[1].Error               | Should Be $null;
            $result[1].Failed              | Should Be $null;
            $result[1].Timeout             | Should Be $null;
            $result[1].Aborted             | Should Be $null;
            $result[1].Inconclusive        | Should Be $null;
            $result[1].PassedButRunAborted | Should Be $null;
            $result[1].NotRunnable         | Should Be $null;
            $result[1].NotExecuted         | Should Be $null;
            $result[1].Disconnected        | Should Be $null;
            $result[1].Warning             | Should Be $null;
            $result[1].Completed           | Should Be $null;
            $result[1].InProgress          | Should Be $null;

            Write-Verbose "The actual outcome $($result[2].Outcome)" -Verbose;
            $result[2].Outcome | Should Be "Completed";

            $result[2].Exists | Should Be $true;
            $result[2].Valid | Should Be $true;
            $result[2].XmlObject | Should Not Be Null;
            $result[2].Path | Should Be "$testDataFolder\Valid\MsTestSummary2.trx";

            $result[2].Total               | Should Be 120;
            $result[2].Executed            | Should Be 119;
            $result[2].Passed              | Should Be 118;
            $result[2].Error               | Should Be 117;
            $result[2].Failed              | Should Be 116;
            $result[2].Timeout             | Should Be 115;
            $result[2].Aborted             | Should Be 114;
            $result[2].Inconclusive        | Should Be 113;
            $result[2].PassedButRunAborted | Should Be 112;
            $result[2].NotRunnable         | Should Be 111;
            $result[2].NotExecuted         | Should Be 110;
            $result[2].Disconnected        | Should Be 109;
            $result[2].Warning             | Should Be 108;
            $result[2].Completed           | Should Be 107;
            $result[2].InProgress          | Should Be 106;
        }

    }

    Context "When filenames are passed in from the pipe with no aggregate" {

        It "Returns an empty array when no files are passed in" {

            $result = (Get-ChildItem "$testDataFolder\Valid\*.noneexistent" | Get-TrxSummary);
            Write-Verbose $result.GetType();

            $result.Length | Should Be 0;            

        }


        It "returns an array containing one object when a single filename is passed down the pipeline" {

            $result = (Get-ChildItem "$testDataFolder\Valid\MsTestSummary1.trx" | Get-TrxSummary);
            Write-Verbose $result.GetType();
            $result.GetType().Name | Should Be "Object[]";
            $result.Length | Should Be "1";

            $result[0].Exists | Should Be $true;
            $result[0].Valid | Should Be $true;
            $result[0].XmlObject | Should Not Be Null;
            $result[0].Path | Should Be "$testDataFolder\Valid\MsTestSummary1.trx";

            $result[0].Total               | Should Be 20;
            $result[0].Executed            | Should Be 19;
            $result[0].Passed              | Should Be 18;
            $result[0].Error               | Should Be 17;
            $result[0].Failed              | Should Be 16;
            $result[0].Timeout             | Should Be 15;
            $result[0].Aborted             | Should Be 14;
            $result[0].Inconclusive        | Should Be 13;
            $result[0].PassedButRunAborted | Should Be 12;
            $result[0].NotRunnable         | Should Be 11;
            $result[0].NotExecuted         | Should Be 10;
            $result[0].Disconnected        | Should Be 9;
            $result[0].Warning             | Should Be 8;
            $result[0].Completed           | Should Be 7;
            $result[0].InProgress          | Should Be 6;
        }

        It "returns an array containing two objects when two trx files are passed down the pipeline" {

            $result = (Get-ChildItem "$testDataFolder\Valid\MsTestSummary*.trx" | Get-TrxSummary);
            Write-Verbose $result.GetType();
            $result.GetType().Name | Should Be "Object[]";
            $result.Length | Should Be "2";

            $file = $result | Where-Object { $_.Path -eq "$testDataFolder\Valid\MsTestSummary1.trx" } | Select-Object -First 1
            $file.Exists | Should Be $true;
            $file.Valid | Should Be $true;
            $file.XmlObject | Should Not Be Null;
            $file.Path | Should Be "$testDataFolder\Valid\MsTestSummary1.trx";

            $file.Total               | Should Be 20;
            $file.Executed            | Should Be 19;
            $file.Passed              | Should Be 18;
            $file.Error               | Should Be 17;
            $file.Failed              | Should Be 16;
            $file.Timeout             | Should Be 15;
            $file.Aborted             | Should Be 14;
            $file.Inconclusive        | Should Be 13;
            $file.PassedButRunAborted | Should Be 12;
            $file.NotRunnable         | Should Be 11;
            $file.NotExecuted         | Should Be 10;
            $file.Disconnected        | Should Be 9;
            $file.Warning             | Should Be 8;
            $file.Completed           | Should Be 7;
            $file.InProgress          | Should Be 6;

            $file = $result | Where-Object { $_.Path -eq "$testDataFolder\Valid\MsTestSummary2.trx" } | Select-Object -First 1
            $file.Exists | Should Be $true;
            $file.Valid | Should Be $true;
            $file.XmlObject | Should Not Be Null;
            $file.Path | Should Be "$testDataFolder\Valid\MsTestSummary2.trx";

            $file.Total               | Should Be 120;
            $file.Executed            | Should Be 119;
            $file.Passed              | Should Be 118;
            $file.Error               | Should Be 117;
            $file.Failed              | Should Be 116;
            $file.Timeout             | Should Be 115;
            $file.Aborted             | Should Be 114;
            $file.Inconclusive        | Should Be 113;
            $file.PassedButRunAborted | Should Be 112;
            $file.NotRunnable         | Should Be 111;
            $file.NotExecuted         | Should Be 110;
            $file.Disconnected        | Should Be 109;
            $file.Warning             | Should Be 108;
            $file.Completed           | Should Be 107;
            $file.InProgress          | Should Be 106;

        }
    }

    Context "When Trx PSObjects are passed down the pipeline from Get-Trx" {

        It "Returns an empty collection when no objects are passed in" {

            $result = (Get-ChildItem "$testDataFolder\Valid\*.noneexistent" | Get-Trx | Get-TrxSummary);
            Write-Verbose $result.GetType();

            $result.Length | Should Be 0;            

        }

        It "Returns returns a single summary for a single test file" {

            $result = (Get-Trx "$testDataFolder\Valid\MsTestSummary1.trx" | Get-TrxSummary);
            Write-Verbose $result.GetType();
            $result.GetType().Name | Should Be "Object[]";
            $result.Length | Should Be "1";

            $result[0].Exists | Should Be $true;
            $result[0].Valid | Should Be $true;
            $result[0].XmlObject | Should Not Be Null;
            $result[0].Path | Should Be "$testDataFolder\Valid\MsTestSummary1.trx";

            $result[0].Total               | Should Be 20;
            $result[0].Executed            | Should Be 19;
            $result[0].Passed              | Should Be 18;
            $result[0].Error               | Should Be 17;
            $result[0].Failed              | Should Be 16;
            $result[0].Timeout             | Should Be 15;
            $result[0].Aborted             | Should Be 14;
            $result[0].Inconclusive        | Should Be 13;
            $result[0].PassedButRunAborted | Should Be 12;
            $result[0].NotRunnable         | Should Be 11;
            $result[0].NotExecuted         | Should Be 10;
            $result[0].Disconnected        | Should Be 9;
            $result[0].Warning             | Should Be 8;
            $result[0].Completed           | Should Be 7;
            $result[0].InProgress          | Should Be 6;

        }

    }



    Context "When files are passed into the Files with Aggregate" {

        It "returns a summary with all zeros when an empty array is passed in" {

            $result = (Get-TrxSummary -Files @() -Aggregate);
            $result | Should Not Be $null;

            $result.Exists | Should Be 0;
            $result.Valid  | Should Be 0;
            $result.Files  | Should Be 0;

            $result.Total               | Should Be 0;
            $result.Executed            | Should Be 0;
            $result.Passed              | Should Be 0;
            $result.Error               | Should Be 0;
            $result.Failed              | Should Be 0;
            $result.Timeout             | Should Be 0;
            $result.Aborted             | Should Be 0;
            $result.Inconclusive        | Should Be 0;
            $result.PassedButRunAborted | Should Be 0;
            $result.NotRunnable         | Should Be 0;
            $result.NotExecuted         | Should Be 0;
            $result.Disconnected        | Should Be 0;
            $result.Warning             | Should Be 0;
            $result.Completed           | Should Be 0;
            $result.InProgress          | Should Be 0;

        }

        It "returns a summary containing the totals from one file when a single file is passed in" {

            $result = (Get-TrxSummary -Files @("$testDataFolder\Valid\MsTestSummary1.trx") -Aggregate);
            $result | Should Not Be $null;

            $result.Exists | Should Be 1;
            $result.Valid  | Should Be 1;
            $result.Files  | Should Be 1;

            $result.Total               | Should Be 20;
            $result.Executed            | Should Be 19;
            $result.Passed              | Should Be 18;
            $result.Error               | Should Be 17;
            $result.Failed              | Should Be 16;
            $result.Timeout             | Should Be 15;
            $result.Aborted             | Should Be 14;
            $result.Inconclusive        | Should Be 13;
            $result.PassedButRunAborted | Should Be 12;
            $result.NotRunnable         | Should Be 11;
            $result.NotExecuted         | Should Be 10;
            $result.Disconnected        | Should Be 9;
            $result.Warning             | Should Be 8;
            $result.Completed           | Should Be 7;
            $result.InProgress          | Should Be 6;

        }

        It "returns a summary containing the totals from two files are passed in" {

            $result = (Get-TrxSummary -Files @("$testDataFolder\Valid\MsTestSummary1.trx", "$testDataFolder\Valid\MsTestSummary2.trx") -Aggregate);
            $result | Should Not Be $null;

            $result.Exists | Should Be 2;
            $result.Valid  | Should Be 2;
            $result.Files  | Should Be 2;

            $result.Total               | Should Be 140;
            $result.Executed            | Should Be 138;
            $result.Passed              | Should Be 136;
            $result.Error               | Should Be 134;
            $result.Failed              | Should Be 132;
            $result.Timeout             | Should Be 130;
            $result.Aborted             | Should Be 128;
            $result.Inconclusive        | Should Be 126;
            $result.PassedButRunAborted | Should Be 124;
            $result.NotRunnable         | Should Be 122;
            $result.NotExecuted         | Should Be 120;
            $result.Disconnected        | Should Be 118;
            $result.Warning             | Should Be 116;
            $result.Completed           | Should Be 114;
            $result.InProgress          | Should Be 112;

        }

        It "returns a summary containing the totals from two existing files and a missing file are passed in" {

            $result = (Get-TrxSummary -Files @("$testDataFolder\Valid\MsTestSummary1.trx", "$testDataFolder\Valid\MsTestNotExist.trx", "$testDataFolder\Valid\MsTestSummary2.trx") -Aggregate);
            $result | Should Not Be $null;

            $result.Exists | Should Be 2;
            $result.Valid  | Should Be 2;
            $result.Files  | Should Be 3;

            $result.Total               | Should Be 140;
            $result.Executed            | Should Be 138;
            $result.Passed              | Should Be 136;
            $result.Error               | Should Be 134;
            $result.Failed              | Should Be 132;
            $result.Timeout             | Should Be 130;
            $result.Aborted             | Should Be 128;
            $result.Inconclusive        | Should Be 126;
            $result.PassedButRunAborted | Should Be 124;
            $result.NotRunnable         | Should Be 122;
            $result.NotExecuted         | Should Be 120;
            $result.Disconnected        | Should Be 118;
            $result.Warning             | Should Be 116;
            $result.Completed           | Should Be 114;
            $result.InProgress          | Should Be 112;

        }


        It "returns a summary containing the totals from two existing files and a missing file and an invalid file are passed in" {

            $result = (Get-TrxSummary -Files @("$testDataFolder\Valid\MsTestSummary1.trx", "$testDataFolder\Valid\MsTestNotExist.trx", "$testDataFolder\Invalid\MsTestThatIsInvalid.trx", "$testDataFolder\Valid\MsTestSummary2.trx") -Aggregate);
            $result | Should Not Be $null;

            $result.Exists | Should Be 3;
            $result.Valid  | Should Be 2;
            $result.Files  | Should Be 4;

            $result.Total               | Should Be 140;
            $result.Executed            | Should Be 138;
            $result.Passed              | Should Be 136;
            $result.Error               | Should Be 134;
            $result.Failed              | Should Be 132;
            $result.Timeout             | Should Be 130;
            $result.Aborted             | Should Be 128;
            $result.Inconclusive        | Should Be 126;
            $result.PassedButRunAborted | Should Be 124;
            $result.NotRunnable         | Should Be 122;
            $result.NotExecuted         | Should Be 120;
            $result.Disconnected        | Should Be 118;
            $result.Warning             | Should Be 116;
            $result.Completed           | Should Be 114;
            $result.InProgress          | Should Be 112;
        }
    }

    Context "When files are passed down the pipeline with Aggregate" {

        It "returns a summary containing the totals from two existing files and a missing file and an invalid file are passed in" {

            $result = (Get-Trx -Files @("$testDataFolder\Valid\MsTestSummary1.trx", "$testDataFolder\Valid\MsTestNotExist.trx", "$testDataFolder\Invalid\MsTestThatIsInvalid.trx", "$testDataFolder\Valid\MsTestSummary2.trx") | Get-TrxSummary -Aggregate);
            $result | Should Not Be $null;

            $result.Exists | Should Be 3;
            $result.Valid  | Should Be 2;
            $result.Files  | Should Be 4;

            $result.Total               | Should Be 140;
            $result.Executed            | Should Be 138;
            $result.Passed              | Should Be 136;
            $result.Error               | Should Be 134;
            $result.Failed              | Should Be 132;
            $result.Timeout             | Should Be 130;
            $result.Aborted             | Should Be 128;
            $result.Inconclusive        | Should Be 126;
            $result.PassedButRunAborted | Should Be 124;
            $result.NotRunnable         | Should Be 122;
            $result.NotExecuted         | Should Be 120;
            $result.Disconnected        | Should Be 118;
            $result.Warning             | Should Be 116;
            $result.Completed           | Should Be 114;
            $result.InProgress          | Should Be 112;

        }
    }
}
