@echo off
setlocal enabledelayedexpansion

FOR %%A IN ("%~dp0..") DO ( call set SolutionPath=%%~dpA )

set EntryFile=Portal.Tests.dll

set RunSettingFile=TestData\prod.runsettings

set Results=TestResults

set TestProjectPath=%SolutionPath%%EntryFile%

set RunSettingPath=%SolutionPath%%RunSettingFile%

set TestResultPath=%SolutionPath%%Results%

vstest.console.exe %TestProjectPath: =% /Settings:%RunSettingPath: =% /Logger:trx /Enablecodecoverage /ResultsDirectory:%TestResultPath: =% /TestCaseFilter:"TestCategory=PRODUCTION"

pause