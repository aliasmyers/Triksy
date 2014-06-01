using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace MsTestAttributes
{
    [TestClass]
    public class TheWorkitems
    {
        [TestMethod]
        public void WithNoWorkitems()
        {
        }

        [TestMethod]
        [WorkItem(1000)]
        public void WithOneWorkitem()
        {
        }

        [TestMethod]
        [WorkItem(1000)]
        [WorkItem(1001)]
        public void WithTwoWorkitems()
        {
        }

        [TestMethod]
        [WorkItem(1000)]
        [WorkItem(1000)]
        public void WithTwoWorkitemsTheSame()
        {
        }



        [TestMethod]
        [WorkItem(2000)]
        public void WorkItemPasses()
        {
        }

        [TestMethod]
        [WorkItem(2001)]
        public void WorkItemFails()
        {
            Assert.Fail("Fail");
        }

        [TestMethod]
        [WorkItem(2002)]
        public void WorkItemAssertion()
        {
            Assert.AreEqual(true, false);
        }



        [TestMethod]
        [WorkItem(3000)]
        public void WorkItemPassesAndFailsPass()
        {
        }

        [TestMethod]
        [WorkItem(3000)]
        public void WorkItemPassesAndFailsFail()
        {
            Assert.Fail("Fail");
        }


        [TestMethod]
        [WorkItem(4000)]
        public void WorkItemIsInconclusive()
        {
            Assert.Inconclusive();
        }
    }
}
