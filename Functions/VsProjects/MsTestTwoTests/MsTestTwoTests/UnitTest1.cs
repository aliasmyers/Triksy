using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace MsTestTwoTests
{
    [TestClass]
    public class UnitTest1
    {
        [TestMethod]
        public void AlwaysPass()
        {
        }

        [TestMethod]
        public void AlwaysFail()
        {
            Assert.Fail("Failed");
        }
    }
}
