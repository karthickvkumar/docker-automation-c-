using Microsoft.VisualStudio.TestTools.UnitTesting;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Support.UI;
using System;
using WebDriverManager;
using WebDriverManager.DriverConfigs.Impl;

using System.IO;
using OpenQA.Selenium.Firefox;
using OpenQA.Selenium.Remote;
using System.Threading;

namespace AutomationDocker
{
    [TestClass]
    public class TestSetup
    {
        protected static IWebDriver webDriver;
        /*protected static Recorder _rec;*/
        public static void Setup(TestContext context)
        {
            Console.WriteLine("Initializing the Setup Method");

            /*string remoteUrl = "http://127.0.0.1:49158";*/

            new DriverManager().SetUpDriver(new ChromeConfig());
            ChromeOptions options = new ChromeOptions();
            options.AddArgument("--no-sandbox");
            options.AddArgument("--headless");
            options.AddArgument("--disable-gpu");
            options.AddArgument("--window-size=1920,1080");
            options.AddArgument("--disable-dev-shm-usage");

            /*options.PlatformName = "Windows";
            options.BrowserVersion = "latest";*/

            //chromeOptions.AddAdditionalCapability("enableVNC", true);

            //webDriver = new RemoteWebDriver(new Uri(remoteUrl), options);

            webDriver = new ChromeDriver(options);

            Console.WriteLine("Initialized the Chrome Driver");

            /*var firefoxOptions = new FirefoxOptions();
            firefoxOptions.AddArgument("--headless");


            new DriverManager().SetUpDriver(new FirefoxConfig());
            webDriver = new FirefoxDriver(firefoxOptions);*/

            Console.WriteLine("Initialized the Chrome Driver");

            if (!object.ReferenceEquals(null, context.Properties["siteURL"]))
            {
                webDriver.Url = context.Properties["siteURL"].ToString();
            }
            else
            {
                webDriver.Url = "https://github.com/";
            }
            Console.WriteLine($"Chrome Drive is loading the {webDriver.Url}");

            webDriver.Manage().Window.Maximize();

            Console.WriteLine("Browser window is getting maxmize");
            /**/
            /*string videoPath = Path.Combine(Directory.GetCurrentDirectory(), "sample.mp4");*/
            /*_rec = Recorder.CreateRecorder();
            _rec.Record(videoPath);*/

        }

        [ClassInitialize]
        public static void ClassInitialize(TestContext context)
        {
            Setup(context);
            webDriver.Manage().Timeouts().ImplicitWait = TimeSpan.FromSeconds(10);
        }

        [TestInitialize]
        public void TestInitialize()
        {
            WaitForNetworkIdle();
        }

        [ClassCleanup]
        public static void ClassCleanup()
        {
            webDriver.Quit();
            /*_rec.Stop();*/
        }

        [TestMethod]
        public void GitHubLogin_WithValidDetails_ShouldPass()
        {
            Console.WriteLine("Browser is opening the Github page");

            IWebElement signInLink = webDriver.FindElement(By.ClassName("HeaderMenu-link--sign-in"));
            signInLink.Click();
            Console.WriteLine("Clicked the SignIn Link");

            WaitForNetworkIdle();
            IWebElement loginInput = webDriver.FindElement(By.Id("login_field"));
            loginInput.SendKeys("concord-india");
            Console.WriteLine("Typed the Username in Login Input");

            IWebElement passwordInput = webDriver.FindElement(By.Id("password"));
            passwordInput.SendKeys("8056202457VKK@k");
            Console.WriteLine("Typed the Passowrd in Password Field");

            IWebElement signInButton = webDriver.FindElement(By.ClassName("js-sign-in-button"));
            signInButton.Click();
            WaitForNetworkIdle();
            Console.WriteLine("Borwser is processing the Sign IN action");

            IWebElement dashboardText = webDriver.FindElement(By.ClassName("AppHeader-context-item-label"));
            Assert.AreEqual(dashboardText.Text.Trim(), "Dashboard");
            Console.WriteLine("Navigated to the Dashboard Page");
        }

        private void WaitForNetworkIdle()
        {
            /*Thread.Sleep(3000);*/
            WebDriverWait wait = new WebDriverWait(webDriver, TimeSpan.FromSeconds(30));
            Func<IWebDriver, bool> waitForNetworkActivity = (d) =>
            {
                bool isComplete = (bool)((IJavaScriptExecutor)d).ExecuteScript("return (window.performance.getEntriesByType('resource').filter(r => r.initiatorType === 'xmlhttprequest').length === 0);");
                return isComplete;
            };
            wait.Until(waitForNetworkActivity);
        }
    }
}
