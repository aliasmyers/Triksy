using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace MsTestAttributes
{
    [TestClass]
    public class TheCategories
    {
        [TestMethod]
        public void WithNoCategories()
        {
        }

        [TestMethod]
        [TestCategory("TheCategory1")]
        public void WithOneCategory()
        {
            
        }

        [TestMethod]
        [TestCategory("TheCategory1")]
        [TestCategory("TheCategory2")]
        public void WithTwoCategories()
        {
            
        }
    }
}
