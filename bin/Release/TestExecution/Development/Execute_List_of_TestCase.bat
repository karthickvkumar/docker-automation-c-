@echo off
setlocal enabledelayedexpansion

for /f "tokens=*" %%t in (TestCaseList.txt) do (
  call set "Test=%%Test%%,%%t"
)

FOR %%A IN ("%~dp0..") DO ( call set SolutionPath=%%~dpA )

set EntryFile=AutomationDocker.dll

set RunSettingFile=TestData\dev.runsettings

set Results=TestResults

set TestProjectPath=%SolutionPath%%EntryFile%

set RunSettingPath=%SolutionPath%%RunSettingFile%

set TestResultPath=%SolutionPath%%Results%

vstest.console.exe %TestProjectPath: =% /Settings:%RunSettingPath: =% /Logger:trx /Enablecodecoverage /ResultsDirectory:%TestResultPath: =% /Tests:%Test:~1%

pause