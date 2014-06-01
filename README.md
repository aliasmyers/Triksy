Triksy:
-------
PowerShell scripts for processing and aggregating MsTest Trx files. 


Author:
-------
Graham Stephenson (feedback@brekit.com, http://www.havecomputerwillcode.com)


Why?
----
These are the problems I wanted to solve:

1. Process multiple TRX files in one go and aggregate the total number of tests executed, passed, failed and so forth across those files. 
2. Get all of the unit tests within one or more TRX files
3. Get all of the test results within one or more TRX files
4. Product a summary of which Unit Tests passed or failed based on the [Workitem] attribute ready for importing into ALM or Test Management tools. 


To install:
-----------
Download / clone the repository and drop the files to:

   %USERPROFILE%\Documents\WindowsPOwershell\modules\Triksy

Then open a PowerShell instance and type:
 
   Import-Module "Triksy"

You now have access to all of the modules. Help is included along with CmdLets - just type help Get-Trx as an example.


Samples:
--------
Example 1: Find every Trx file recursively and try to load them (the objects output from this method are piped into the other Trx processing functions later):

   Get-Childitem *.trx -Recurse | Get-Trx | Format-Table -Property Exists,Valid,XmlObject,Path -Autosize

Will produce:

   Exists Valid XmlObject Path
   ------ ----- --------- ----
     True False           F:\Github\Triksy\Functions\TestData\Invalid\MsTestThatIsInvalid.trx
     True  True #document F:\Github\Triksy\Functions\TestData\Valid\MsTestAttributes.trx
     True  True #document F:\Github\Triksy\Functions\TestData\Valid\MsTestNoTestResults.trx
     True  True #document F:\Github\Triksy\Functions\TestData\Valid\MsTestSingleResult.trx
     True  True #document F:\Github\Triksy\Functions\TestData\Valid\MsTestSummary1.trx
     True  True #document F:\Github\Triksy\Functions\TestData\Valid\MsTestSummary2.trx
     True  True #document F:\Github\Triksy\Functions\TestData\Valid\MsTestTwoResults.trx

Notice the presence of 'Valid' - if the Trx file could not be loaded (because the Xml is corrupted) then Valid will be False.
Similarly, if the Trx file does not exist, then Exists will be False (only useful when calling Get-Trx with an explicit list of filenames). 
XmlObject is the raw [xml] object representing the Trx file. 


Example 2: Find every Trx file recursively and produce a summary showing the outcome, tests passed, failed etc:

   get-childitem *.trx -Recurse | Get-TrxSummary | Format-Table -Property Valid,Outcome,Total,Executed,Passed,Error,Failed,Timeout,Aborted,Inconclusive,Path -Autosize

Will produce:

Valid Outcome   Total Executed Passed Error Failed Timeout Aborted Inconclusive Path
----- -------   ----- -------- ------ ----- ------ ------- ------- ------------ ----
False                                                                           F:\Github\Triksy\Functions\TestData\...
 True Failed    16    16       12     0     3      0       0       1            F:\Github\Triksy\Functions\TestData\...
 True Completed 0     0        0      0     0      0       0       0            F:\Github\Triksy\Functions\TestData\...
 True Completed 20    19       18     17    16     15      14      13           F:\Github\Triksy\Functions\TestData\...
 True Completed 20    19       18     17    16     15      14      13           F:\Github\Triksy\Functions\TestData\...
 True Completed 120   119      118    117   116    115     114     113          F:\Github\Triksy\Functions\TestData\...
 True Failed    2     2        1      0     1      0       0       0            F:\Github\Triksy\Functions\TestData\...


Example 3: Find every Trx file recursively and then aggregate / sum the total number of tests, passed, failed across all files and produce the result in a single object (note the use of the -Aggregate switch):

    get-childitem *.trx -Recurse | Get-TrxSummary -Aggregate | Format-Table -Property Total,Executed,Passed,Error,Failed,Timeout,Aborted,Inconclusive -Autosize

Will produce:

   Total Executed Passed Error Failed Timeout Aborted Inconclusive
   ----- -------- ------ ----- ------ ------- ------- ------------
     178      175    167   151    152     145     142          140



Example 4: Get all of the unit tests in an individual trx file:

    Get-Trx -Files "Valid\MsTestAttributes.trx" | Get-TrxUnitTest

Will produce:

   Name                       Storage              Id                                   Execution TestMethod Path
   ----                       -------              --                                   --------- ---------- ----
   WorkItemPasses             mstestattributes.dll aa8e8736-ce1b-a9e9-b205-65f9fcfea1d8 Execution TestMethod Valid\MsTe...
   WithNoProperties           mstestattributes.dll 5816b9ab-f414-c69b-68a9-2877bf8085c7 Execution TestMethod Valid\MsTe...
   WorkItemAssertion          mstestattributes.dll 6a53be14-ca56-15ec-36b9-8978a8a2e4e6 Execution TestMethod Valid\MsTe...
   WithOneTestProperty        mstestattributes.dll a3f52ab3-b36c-8b14-8df0-a64e0d519eea Execution TestMethod Valid\MsTe...
   ... etc

NOTE: The Execution and TestMethod properties are the raw [Xml] objects from the loaded Trx file. Use, for example, TestMethod.CodeBase to get at the CodeBase property (you can see all available properties by just looking at the raw TRX Xml). 



Example 5: Get all of the unit tests in all Trx files recursively:

   Get-ChildItem *.trx -Recurse | Get-Trx | Get-TrxUnitTest | format-table



Example 6: Get all of the test results in all Trx files recursively:

   Get-ChildItem *.trx -Recurse | Get-Trx | Get-TrxResult | format-table -Property TestName,TestId,Outcome -Autosize



Example 7: The use of the MsTest [Workitem] attribute is useful for associating a particular test with a given requirement or test case in an ALM or test management tool. This example will process the results and return the Workitem and aggregated outcome for all methods that have the same Workitem id (ie: if any test method with a given Workitem Id is not 'Passed', then the result is Failed):

   Get-ChildItem *.trx -Recurse | Get-Trx | Get-TrxResult | Get-TrxWorkitemSummary

Will produce:

   Workitem                                                    Outcome
   --------                                                    -------
   4000                                                        Failed
   3000                                                        Failed
   1000                                                        Passed
   1001                                                        Passed
   2000                                                        Passed
   2001                                                        Failed
   2002                                                        Failed

From an automation and results processing perspective, it is often useful to provide a default Workitem id to those methods that do not have one. Use the -DefaultWorkitems parameter for this:

   Get-ChildItem *.trx -Recurse | Get-Trx | Get-TrxResult | Get-TrxWorkitemSummary -DefaultWorkItems 1234

Will produce:

   Workitem                                                    Outcome
   --------                                                    -------
   4000                                                        Failed
   3000                                                        Failed
   1000                                                        Passed
   1001                                                        Passed
   2000                                                        Passed
   2001                                                        Failed
   2002                                                        Failed
   1234                                                        Failed


Testing and Development:
------------------------
The application is thoroughly tested with Pester - install Pester, then CD the folder containing Triksy and type:

   Invoke-Pester

That will execute all tests.

The original Visual Studio projects used to create the TRX files are also part of the solution; however, some of the Trx files were modified by hand to bring about particular test scenarios. 
