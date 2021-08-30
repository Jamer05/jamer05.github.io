@setlocal DisableDelayedExpansion
@echo off
goto MAS_Start

:9:
====================================================================================================
   Credits:
====================================================================================================

   Microsoft Activation Scripts (MAS):

   A collection of scripts for activating Microsoft products using HWID / KMS38 / Online KMS 
   activation methods with a focus on open-source code, less antivirus detection and user-friendliness.

   These scripts are mostly a fork of other honourable developer's tools and scripts.

   Homepages-
   NsaneForums: (Login Required) https://www.nsaneforums.com/topic/316668-microsoft-activation-scripts/
   GitHub: https://github.com/massgravel/Microsoft-Activation-Scripts
   GitLab: https://gitlab.com/massgrave/microsoft-activation-scripts

   Maintained by @WindowsAddict

   To achieve this I have used the following projects as the base of this activator.  
   I would like to say thanks to the following authors for making such awesome projects.

====================================
   HWID and KMS38 Activation:
====================================

   @mspaintmsi   Original co-authors of HWID/KMS38 Activation without KMS or predecessor install/upgrade.
      and        Created various methods for HWID/KMS38 Activation
   *Anonymous    https://www.nsaneforums.com/topic/316668--/?do=findComment&comment=1497887
                 https://github.com/massgravel/MASSGRAVE
                 https://gitlab.com/massgrave/massgrave
  
   @vyvojar      Original slshim (slc.dll)
                 https://github.com/vyvojar/slshim/releases

====================================

   HWID/KMS38 methods Suggestions and improvements:-
  
   @sponpa       New ideas for the HWID/KM38 Generation
                 https://www.nsaneforums.com/topic/316668--/page/21/?tab=comments#comment-1431257

   @leitek8      Improvements for the slc.dll
                 https://www.nsaneforums.com/topic/316668--/page/22/?tab=comments#comment-1438005

====================================
   Online KMS Activation: 
====================================

   @abbodi1406   Activate.cmd (KMS_VL_ALL)
                 https://forums.mydigitallife.net/posts/838808
                 (* With the great help from @RPO, Forked it to work with Multi KMS Servers,
                 Renewal task, Desktop context menu, $OEM$, etc for Online KMS)

                 Clear-KMS-Cache.cmd
                 https://forums.mydigitallife.net/posts/1511883
                 (*Applied it as it is)

                 Check-Activation-Status-wmic.cmd
                 https://forums.mydigitallife.net/posts/838808
                 (*Applied it as it is)

====================================

   Online Public KMS Servers:

   kms.srv.crsoo.com
   kms.loli.beer
   kms8.MSGuides.com

   kms9.MSGuides.com
   kms.zhuxiaole.org
   kms.lolico.moe
   kms.moeclub.org

====================================
   Useful scripts and ideas I used :
====================================

   @AveYo (@BAU) Compressed2TXT
                 https://github.com/AveYo/Compressed2TXT
                 (For storing the files in text format)

                 Reg_takeownership snippet
                 pastebin.com/XTPt0JSC
                 (*Applied in KMS38 Protection)

   @hearywarlot  Elevate program as admin with vbs method
                 https://forums.mydigitallife.net/threads/.74332/

   @dbenham      Set buffer height independently of window height
                 https://stackoverflow.com/a/13351373
                 
   @Ratiborus    Ratiborus Tools
                 http://forum.ru-board.com/topic.cgi?forum=2&topic=5734#1

   @abbodi1406   Continuously providing best solutions for tons of issues.

                 abbodi1406's Batch Scripts Repo
                 https://forums.mydigitallife.net/threads/74197/

   @s1ave77      slave77s S-M-R-T JATDevice MkIII
                 https://forums.mydigitallife.net/threads/44717/

====================================
   Kind Help:
====================================
   
   Thanks to the following people for answering all of my queries. (In no particular order)
   
   @AveYo aka @BAU, @sponpa, @mspaintmsi @RPO, @leitek8, @mxman2k, @Yen, @abbodi1406

   @BorrowedWifi for providing support in fixing English grammar errors in the Read Me.
   @Chibi ANUBIS for testing scripts for ARM64 system.

----------------------------------------------------------------------------------------------------

   Special thanks to @RPO and @abbodi1406,
   For providing great support and solving countless issues in this tool.

====================================================================================================
:9:


::========================================================================================================================================

:MAS_Start

cls
title  Microsoft Activation Scripts AIO 1.4
set _elev=
if /i "%~1"=="-el" set _elev=1
for /f "tokens=6 delims=[]. " %%G in ('ver') do set winbuild=%%G
set "_null=1>nul 2>nul"
set "_psc=powershell"
set "EchoRed=%_psc% write-host -back Black -fore Red"
set "EchoGreen=%_psc% write-host -back Black -fore Green"
set "ErrLine=echo: & %EchoRed% ==== ERROR ==== &echo:"

::========================================================================================================================================

for %%i in (powershell.exe) do if "%%~$path:i"=="" (
echo: &echo ==== ERROR ==== &echo:
echo Powershell is not installed in the system.
echo Aborting...
goto MASend
)

::========================================================================================================================================

if %winbuild% LSS 7600 (
%ErrLine%
echo Unsupported OS version Detected.
echo Project is supported only for Windows 7/8/8.1/10 and their Server equivalent.
goto MASend
)

::========================================================================================================================================

::  Elevate script as admin and pass arguments and preventing loop
::  Thanks to @hearywarlot [ https://forums.mydigitallife.net/threads/.74332/ ] for the VBS method.
::  Thanks to @abbodi1406 for the powershell method and solving special characters issue in file path name.

set "batf_=%~f0"
set "batp_=%batf_:'=''%"

%_null% reg query HKU\S-1-5-19 && (
goto :_Passed
) || (
if defined _elev goto :_E_Admin
)

set "_vbsf=%temp%\admin.vbs"
set _PSarg="""%~f0""" -el

setlocal EnableDelayedExpansion
(
echo Set strArg=WScript.Arguments.Named
echo Set strRdlproc = CreateObject^("WScript.Shell"^).Exec^("rundll32 kernel32,Sleep"^)
echo With GetObject^("winmgmts:\\.\root\CIMV2:Win32_Process.Handle='" ^& strRdlproc.ProcessId ^& "'"^)
echo With GetObject^("winmgmts:\\.\root\CIMV2:Win32_Process.Handle='" ^& .ParentProcessId ^& "'"^)
echo If InStr ^(.CommandLine, WScript.ScriptName^) ^<^> 0 Then
echo strLine = Mid^(.CommandLine, InStr^(.CommandLine , "/File:"^) + Len^(strArg^("File"^)^) + 8^)
echo End If
echo End With
echo .Terminate
echo End With
echo CreateObject^("Shell.Application"^).ShellExecute "cmd.exe", "/c " ^& chr^(34^) ^& chr^(34^) ^& strArg^("File"^) ^& chr^(34^) ^& strLine ^& chr^(34^), "", "runas", 1
)>"!_vbsf!"

(%_null% cscript //NoLogo "!_vbsf!" /File:"!batf_!" -el) && (
del /f /q "!_vbsf!"
exit /b
) || (
del /f /q "!_vbsf!"
%_null% %_psc% "start cmd.exe -arg '/c \"!_PSarg:'=''!\"' -verb runas" && (
exit /b
) || (
goto :_E_Admin
)
)
exit /b

:_E_Admin
%ErrLine%
echo This script require administrator privileges.
echo To do so, right click on this script and select 'Run as administrator'.
goto MASend

:_Passed

::========================================================================================================================================

setlocal EnableDelayedExpansion

:MainMenu

cls
title  Microsoft Activation Scripts AIO 1.4
mode con cols=98 lines=30
set "MAS_Temp=%SystemRoot%\Temp\_MAS"
if exist "%MAS_Temp%\" @RD /S /Q "%MAS_Temp%\" %_null%

echo:
echo:
echo                   _____________________________________________________________
echo                  ^|                                                               ^| 
echo                  ^|                                                               ^|
echo                  ^|      [1] Read Me                                              ^|
echo                  ^|      _________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|      [2] HWID Activation       - Windows 10                   ^|
echo                  ^|                                                               ^|
echo                  ^|      [3] KMS38 Activation      - Windows 10 /Server           ^|
echo                  ^|                                                               ^|
echo                  ^|      [4] Online KMS Activation - Windows /Server /Office      ^|
echo                  ^|      _________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|      [5] Check Activation Status                              ^|
echo                  ^|      _________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|      [6] Extras                                               ^|
echo                  ^|      _________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|      [7] Credits         [8] Homepages          [9] Exit      ^|
echo                  ^|                                                               ^|
echo                  ^|_______________________________________________________________^|
echo:          
choice /C:123456789 /N /M ">                   Enter Your Choice in the Keyboard [1,2,3,4,5,6,7,8,9] : "

if errorlevel  9 goto:Exit
if errorlevel  8 goto:HomePages
if errorlevel  7 goto:_credits
if errorlevel  6 goto:Extras
if errorlevel  5 setlocal & call :CheckStatus & cls & endlocal & goto :MainMenu
if errorlevel  4 goto:OnlineKMSActivation
if errorlevel  3 setlocal & call :KMS38Activation & cls & endlocal & goto :MainMenu
if errorlevel  2 setlocal & call :HWIDActivation & cls & endlocal & goto :MainMenu
if errorlevel  1 goto:Readme

::========================================================================================================================================

:ReadMe

cls
title Read Me
mode con cols=98 lines=32

echo:
echo:
echo                   _____________________________________________________________
echo                  ^|                                                               ^|
echo                  ^|                                                               ^|
echo                  ^|      [1] Activations Summary                                  ^|
echo                  ^|      _________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|      [2] Digital Activation                                   ^|
echo                  ^|                                                               ^|
echo                  ^|      [3] KMS38 Activation                                     ^|
echo                  ^|                                                               ^|
echo                  ^|      [4] Online KMS Activation                                ^|
echo                  ^|      _________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|      [5] $OEM$ Folders [Preactivation]                        ^|
echo                  ^|                                                               ^|
echo                  ^|      [6] KMS38 Protection                                     ^|
echo                  ^|                                                               ^|
echo                  ^|      [7] What's that big blocks of text in this script?       ^|
echo                  ^|                                                               ^|
echo                  ^|      [8] Download Genuine Installation Media                  ^|
echo                  ^|      _________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|      [9] Credits                             [0] Go Back      ^|
echo                  ^|                                                               ^|
echo                  ^|_______________________________________________________________^|
echo:
choice /C:1234567890 /N /M ".                   Enter Your Choice [1,2,3,4,5,6,7,8,9,0] : "

if errorlevel 10 goto:MainMenu
if errorlevel  9 call :ReadMeCodes 9 &goto ReadMe
if errorlevel  8 start https://pastebin.com/raw/jduBSazJ  &goto ReadMe
if errorlevel  7 call :ReadMeCodes 7 &goto ReadMe
if errorlevel  6 call :ReadMeCodes 6 &goto ReadMe
if errorlevel  5 call :ReadMeCodes 5 &goto ReadMe
if errorlevel  4 call :ReadMeCodes 4 &goto ReadMe
if errorlevel  3 call :ReadMeCodes 3 &goto ReadMe
if errorlevel  2 call :ReadMeCodes 2 &goto ReadMe
if errorlevel  1 call :ReadMeCodes 1 &goto ReadMe

::========================================================================================================================================

:OnlineKMSActivation

cls
title Online KMS Activation
mode con cols=98 lines=30

echo:
echo              _______________________________________________________________________
echo:
echo               This script will skip any permanent and KMS38 Activation.
echo               KMS activates for 180 Days.^(For core/ProWMC edition it is 30/45 Days^)
echo               Use Read Me for the more details.
echo              _______________________________________________________________________
echo:
echo                      _______________________________________________________   
echo                     ^|                                                         ^|
echo                     ^|                                                         ^|
echo                     ^|     [1] Activate - Windows /Server /Office              ^|
echo                     ^|                                                         ^|
echo                     ^|     [2] Create Activation Renewal Setup                 ^|
echo                     ^|                                                         ^|
echo                     ^|     [3] Complete Uninstall                              ^|
echo                     ^|                                                         ^|
echo                     ^|     [4] Go to Main Menu                                 ^|
echo                     ^|                                                         ^|
echo                     ^|_________________________________________________________^|
echo:                                                                               
choice /C:1234 /N /M ">                     Enter Your Choice [1,2,3,4] : "

if errorlevel 4 goto:MainMenu
if errorlevel 3 setlocal & call :KMS_Uninstall & cls & endlocal & goto :OnlineKMSActivation
if errorlevel 2 goto:Renewal_Setup
if errorlevel 1 goto:KMSActivation

::========================================================================================================================================

:Extras

cls
title Extras
mode con cols=98 lines=30
echo:
echo:
echo:
echo                     ________________________________________________________
echo                    ^|                                                          ^|
echo                    ^|                                                          ^|
echo                    ^|      [1] Extract $OEM$ Folder [Preactivation]            ^|
echo                    ^|      ____________________________________________      ^|
echo                    ^|                                                          ^|
echo                    ^|      [2] Insert Windows 10 Key [OEMRET]                  ^|
echo                    ^|                                                          ^|
echo                    ^|      [3] Change Windows 10 Edition [OEMRET]              ^|
echo                    ^|      ____________________________________________      ^|
echo                    ^|                                                          ^|
echo                    ^|      [4] Protect / Unprotect KMS38 Activation            ^|
echo                    ^|      ____________________________________________      ^|
echo                    ^|                                                          ^|
echo                    ^|      [5] abbodi1406's Batch Scripts Repo [Link]          ^|
echo                    ^|                                                          ^|
echo                    ^|      [6] Go to Main Menu                                 ^|
echo                    ^|                                                          ^|
echo                    ^|__________________________________________________________^|
echo:                
choice /C:123456 /N /M ">                     Enter Your Choice [1,2,3,4,5,6] : "

if errorlevel 6 goto:MainMenu
if errorlevel 5 goto:abbodi1406_repo_link
if errorlevel 4 setlocal & call :PU_KMS38 & cls & endlocal & goto :Extras
if errorlevel 3 setlocal & call :ChangeEdition_OEMRET & cls & endlocal & goto :Extras
if errorlevel 2 setlocal & call :Insert_Key_OEMRET & cls & endlocal & goto :Extras
if errorlevel 1 goto:Extract$OEM$

::========================================================================================================================================

:Extract$OEM$

cls
title Extract $OEM$ Folder
mode con cols=98 lines=30

echo:
echo:
echo                             Extract the $OEM$ Folder on your desktop.
echo                                  For more details use Read me.
echo                       _____________________________________________________
echo                      ^|                                                       ^|
echo                      ^|                                                       ^|
echo                      ^|   [1] HWID                                            ^|
echo                      ^|                                                       ^|
echo                      ^|   [2] KMS38                                           ^|
echo                      ^|                                                       ^|
echo                      ^|   [3] HWID, Fallback to KMS38                         ^|
echo                      ^|                                                       ^|
echo                      ^|   [4] Online KMS                                      ^|
echo                      ^|                                                       ^|
echo                      ^|   [5] HWID ^+ Online KMS                               ^|
echo                      ^|                                                       ^|
echo                      ^|   [6] KMS38 ^+ Online KMS                              ^|
echo                      ^|                                                       ^|
echo                      ^|   [7] HWID, Fallback to KMS38 ^+ Online KMS            ^|
echo                      ^|                                                       ^|
echo                      ^|   [8] Go to Main Menu                                 ^|
echo                      ^|                                                       ^|
echo