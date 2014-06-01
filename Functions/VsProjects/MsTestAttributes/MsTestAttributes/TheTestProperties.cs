using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace MsTestAttributes
{
    [TestClass]
    public class TheTestProperties
    {
        [TestMethod]
        public void WithNoProperties()
        {
        }

        [TestMethod]
        [TestProperty("TheTestProperty1", "TheProperty1Value")]
        public void WithOneTestProperty()
        {
            
        }

        [TestMethod]
        [TestProperty("TheTestProperty1", "TheProperty1Value")]
        [TestProperty("TheTestProperty2", "TheProperty2Value")]
        public void WithTwoTestProperties()
        {
            
        }
    }
}
