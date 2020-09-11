@ECHO OFF
SETLOCAL EnableExtensions
SETLOCAL EnableDelayedExpansion

REM If not set to PASSIVE, OpenMP (Eigen) boxes may load the cores fully even if there's little to do.
SET "OMP_WAIT_POLICY=PASSIVE"

REM Get the directory location of this script, assume it contains the OpenViBE dist tree. These variables will be used by OpenViBE executables.
SET "OV_PATH_ROOT=%~dp0"

REM Default behavior
SET OV_PAUSE=PAUSE
SET OV_RUN_IN_BG=

REM Parse out Windows specific args ...
SET "ARGS="
SET EMPTY=
:loop
SET "STRIPPEDARG=%~1"
if NOT !STRIPPEDARG! == !EMPTY! (
	IF /i "!STRIPPEDARG!" == "--no-pause" (
		SET OV_PAUSE=
		goto found:
	)
	IF /i "!STRIPPEDARG!" == "--run-bg" (
		REM Run in background, disable pause. The second parameter below is because CMD requires a 'title'
		SET OV_RUN_IN_BG=START "openvibe-convert-real.cmd"
		SET OV_PAUSE=
		goto found:
	)
	
	REM Pass the non-stripped arg to the launched application...
	SET ARGS=%ARGS% %1
	
:found	
	SHIFT
	goto loop:
)

REM Set dependency paths etc...
SET "OV_ENVIRONMENT_FILE=%OV_PATH_ROOT%\bin\OpenViBE-set-env.cmd"
IF NOT EXIST "%OV_ENVIRONMENT_FILE%" (
	ECHO Error: "%OV_ENVIRONMENT_FILE%" was not found
	GOTO EndOfScript
)
CALL "%OV_ENVIRONMENT_FILE%"

REM cmake variable OV_CMD_ARGS below may specify additional arguments outside this script

%OV_RUN_IN_BG% "%OV_PATH_ROOT%\bin\openvibe-convert-real.cmd"  %ARGS%
	
:EndOfScript

%OV_PAUSE%

