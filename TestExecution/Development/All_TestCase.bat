cd /D "C:\TestPlatform\tools\net451\Common7\IDE\Extensions\TestPlatform"

vstest.console.exe C:\AutomationBuild\Portal.Tests.dll /Settings:C:\AutomationBuild\TestData\dev.runsettings /Logger:trx /Enablecodecoverage /ResultsDirectory:C:\logs\portal.test\TestResults

pause
