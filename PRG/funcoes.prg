Function FecharSistema
	Local llRetorno
	llRetorno = .F.
	llRetorno = Messagebox("Deseja realmente sair?", 32 + 4 ,"Atenção!") == 6
	Return llRetorno
Endfunc

Procedure Sair
	*On Shutdown
	*CLOSE DATABASES ALL

	Clear Events
	Close All
	Quit
Endproc

Procedure _Sleep
	Lparameters lntempo
	lntempo = Iif(Upper(Alltrim(Vartype(lntempo))) == 'N', lntempo, 0)

	Declare Sleep In WIN32API Integer
	Do While .T.
		Sleep(lntempo)  && 0 puts it into an efficient wait state
		Exit
	Enddo
Endproc



*!*	Procedure ExecutarSemRestricoes
*!*		Lparameter lcComando, lcAcao, lcParams

*!*		lcAcao = Iif(Empty(lcAcao), "Open", lcAcao)
*!*		lcParams = Iif(Empty(lcParams), "", lcParams)

*!*		Declare Integer ShellExecute ;
*!*			IN SHELL32.Dll ;
*!*			INTEGER nWinHandle, ;
*!*			STRING cOperation, ;
*!*			STRING cFileName, ;
*!*			STRING cParameters, ;
*!*			STRING cDirectory, ;
*!*			INTEGER nShowWindow

*!*		Declare Integer FindWindow ;
*!*			IN WIN32API ;
*!*			STRING cNull,String cWinName

*!*		Return ShellExecute(FindWindow(0, _Screen.Caption), ;
*!*			lcAcao, lcComando, ;
*!*			lcParams, Sys(2023), 1)
*!*	Endproc

Function GerarCaracteresAleatorios
	Lparameters lnQTDChar

	lnQTDChar = Iif(Upper(Alltrim(Vartype(lnQTDChar))) == 'N' And lnQTDChar > 0, lnQTDChar, 1)

	Local m.lcString, m.lnPassLength
	m.lcString 		= ""
	m.lnPassLength 	= lnQTDChar
	For j = 1 To Int((Rand(-1)*2000/50)*100)
		Wait Window 'Calculando caracteres, para gerar a novo senha, aguarde!' Nowait
		For i = 1 To lnPassLength
			m.lnRandom = Rand() * 94 + 33
			If Inlist(Chr(m.lnRandom), [`], '~', '+', '*', "}","{","[","]",["],['],[^])
				i = i - 1
			Else
				m.lcString = m.lcString + Chr(m.lnRandom)
			Endif
		Endfor
	Endfor
	Wait Clear
	Return lcString
Endfunc


******************************************************************************

Function ExecutarSemRestricoes
	Lparameters lcExe, lcParametros, llEsperar, lnTipoAberturaExe

	* lnTipoAberturaExe:
	* [0]  Hides the window and activates another window.
	* [1]  Activates and displays a window. If the window is minimized or maximized,
	*      the system restores it to its original size and position.
	*      An application should specify this flag when displaying the window for the first time.
	* [2]  Activates the window and displays it as a minimized window.
	* [3]  Activates the window and displays it as a maximized window.
	* [4]  Displays a window in its most recent size and position. The active window remains active.
	* [5]  Activates the window and displays it in its current size and position.
	* [6]  Minimizes the specified window and activates the next top-level window in the Z order.
	* [7]  Displays the window as a minimized window. The active window remains active.
	* [8]  Displays the window in its current state. The active window remains active.
	* [9]  Activates and displays the window. If the window is minimized or maximized,
	*      the system restores it to its original size and position.
	*      An application should specify this flag when restoring a minimized window.
	* [10] Sets the show-state based on the state of the program that started the application.

	If Vartype(m.lnTipoAberturaExe) <> 'N' Or ;
			!Between(m.lnTipoAberturaExe, 0, 10)
		m.lnTipoAberturaExe = 2
	Endif

	Local llRetorno, ;
		loEnv, loWScript As "WScript.Shell", ;
		loExcecao As Exception, loExcecaoWin32Api As Exception, ;
		lnExitCode
	m.llRetorno = .T.

	Try
		m.loWScript = Createobject("WScript.Shell")
		m.loEnv = m.loWScript.Environment("PROCESS")
		m.loEnv.Item("SEE_MASK_NOZONECHECKS") = 1
		m.lnExitCode = m.loWScript.Run(m.lcExe + Iif(Not Empty(m.lcParametros), " "+m.lcParametros, ""), ;
			m.lnTipoAberturaExe, m.llEsperar)
		m.loEnv.Remove("SEE_MASK_NOZONECHECKS")

	Catch To m.loExcecao
		m.loExcecao.Comment = GetCallStack()

		Local loShellExecuteInfo
		m.loShellExecuteInfo = Createobject("SHELLEXECUTEINFOA")
		With m.loShellExecuteInfo
			.fMask = Iif(m.llEsperar,SEE_MASK_NOCLOSEPROCESS + SEE_MASK_NOASYNC,0) + SEE_MASK_NOZONECHECKS
			.lpVerb = "open"
			.lpFile = m.lcExe
			If Not Empty(m.lcParametros)
				.lpParameters = m.lcParametros
			Endif
			.nShow = m.lnTipoAberturaExe
		Endwith

		If apiShellExecuteEx(m.loShellExecuteInfo.Address)==0
			m.loExcecaoWin32Api = Win32ApiErrorToException(apiGetLastError(), "Error in ShellExecuteEx function.")
		Else
			If m.llEsperar
				Local lnWait
				m.lnWait = 1 && Milliseconds
				m.lnExitCode = STILL_ACTIVE
				*
				Do While m.lnExitCode == STILL_ACTIVE
					If Inlist(apiWaitForSingleObject(m.loShellExecuteInfo.hProcess, m.lnWait),WAIT_OBJECT_0,WAIT_TIMEOUT)
						If apiGetExitCodeProcess(m.loShellExecuteInfo.hProcess, @m.lnExitCode) <> 0
							DoEvents
							m.llReturn = (m.lnExitCode==0)
						Else
							m.loExcecaoWin32Api = Win32ApiErrorToException(apiGetLastError(), "Error in GetExitCodeProcess function.")
						Endif
					Else
						m.loExcecaoWin32Api = Win32ApiErrorToException(apiGetLastError(), "Error in WaitingForSingleObject function.")
						Exit
					Endif
				Enddo
				*
				apiCloseHandle(m.loShellExecuteInfo.hProcess)
			Endif
		Endif

		m.loShellExecuteInfo = Null

		If Vartype(m.loExcecaoWin32Api)=="O"
			m.loExcecaoWin32Api.Comment = GetCallStack()
			m.loExcecaoWin32Api.UserValue = ExceptionToString(m.loExcecao)
			m.llRetorno = .F.
			EnviarErro(m.loExcecao)
		Endif

	Finally
		Store Null To m.loEnv, m.loWScript, m.loExcecao, m.loExcecaoWin32Api

	Endtry

	Return m.lnExitCode
Endfunc
Function apiWaitForSingleObject
	Lparameters hHandle, dwMilliseconds
	Declare Integer WaitForSingleObject In kernel32 As apiWaitForSingleObject ;
		Integer hHandle, ;
		Integer dwMilliseconds
	Return apiWaitForSingleObject(m.hHandle, m.dwMilliseconds)
Endfunc

Function apiGetExitCodeProcess
	Lparameters hProcess, lpExitCode
	Declare Integer GetExitCodeProcess In WIN32API As apiGetExitCodeProcess ;
		Integer hProcess, ;
		Integer @ lpExitCode
	Return apiGetExitCodeProcess(m.hProcess, @m.lpExitCode)
Endfunc

Function Win32ApiErrorToException
	Lparameters lnErrorNo, lcErrorMSG
	Local loException As Exception
	m.loException = Createobject("Exception")
	With m.loException As Exception
		.ErrorNo = m.lnErrorNo
		.Message = m.lcErrorMSG
		.Details = FormatMessageEx(m.lnErrorNo) && vfp2c32.fll
	Endwith
	Return m.loException
Endfunc

Function apiCloseHandle
	Lparameters hObject
	Declare Integer CloseHandle In win32api As apiCloseHandle ;
		Integer hObject
	Return apiCloseHandle(m.hObject)
Endfunc

Procedure EnviarErro
	Lparameters loExcecao As Exception
	* TO DO: Enviar os detalhes do erro através de log de erros online.
	* Pode passar o objeto da exceção ou converter para
	* string utilizando a função ExceptionToString

	*
	Throw
Endproc

Procedure apiGetLastError
	Lparameters loExcecao As Exception
	* TO DO:

	*
	Throw
Endproc

Function ExceptionToString
	Lparameters loException
	Local lcException
	With m.loException As Exception
		m.lcException = "ErrorNo: " + Alltrim(Transform(.ErrorNo)) + Chr(13) + ;
			"Comment: " + Alltrim(Transform(.Comment)) + Chr(13) + ;
			"Details: " + Alltrim(Transform(.Details)) + Chr(13) + ;
			"LineContents: " + Alltrim(Transform(.LineContents)) + Chr(13) + ;
			"LineNo: " + Alltrim(Transform(.Lineno)) + Chr(13) + ;
			"Message: " + Alltrim(Transform(.Message)) + Chr(13) + ;
			"Procedure: " + Alltrim(Transform(.Procedure)) + Chr(13) + ;
			"StackLevel: " + Alltrim(Transform(.StackLevel)) + Chr(13) + ;
			"Tag: " + Alltrim(Transform(.Tag)) + Chr(13) + ;
			"UserValue: " + Alltrim(Transform(.UserValue))
	Endwith
	m.loException = Null
	Return m.lcException
Endfunc

Function GetCallStack
	Local lcCallStack, laCallStack[1], lnInfo
	m.lcCallStack = ""
	If Astackinfo(m.laCallStack) > 0
		For m.lnInfo=1 To Alen(m.laCallStack,1)
			m.lcCallStack = m.lcCallStack + ;
				"Call Stack Level: " + Alltrim(Transform(m.laCallStack[m.lnInfo,1])) + Chr(13) + ;
				"Current program filename: " + Alltrim(Transform(m.laCallStack[m.lnInfo,2])) + Chr(13) + ;
				"Module or Object name: " + Alltrim(Transform(m.laCallStack[m.lnInfo,3])) + Chr(13) + ;
				"Module or Object Source filename: " + Alltrim(Transform(m.laCallStack[m.lnInfo,4])) + Chr(13) + ;
				"Line number in the object source file: " + Alltrim(Transform(m.laCallStack[m.lnInfo,5])) + Chr(13) + ;
				"Source line contents: " + Alltrim(Transform(m.laCallStack[m.lnInfo,6]))+ Chr(13)
		Endfor
	Endif
	Return m.lcCallStack
Endfunc

Function apiShellExecuteEx
	Lparameters lpExecInfo
	Declare Integer ShellExecuteEx In Shell32 As apiShellExecuteEx ;
		Integer lpExecInfo
	Return apiShellExecuteEx(m.lpExecInfo)
Endfunc

******************************************************************************
* Program: IsExeRunning
* Purpose: to determine if an EXE is already running, and terminate it if directed so.
PROCEDURE IsExeRunning
	PARAMETERS tcName
	local loLocator, loWMI, loProcesses, loProcess
	loLocator = createobject('WBEMScripting.SWBEMLocator')
	loWMI = loLocator.ConnectServer()
	loWMI.Security_.ImpersonationLevel = 3 && Impersonate

	loProcesses = loWMI.ExecQuery([SELECT * FROM Win32_Process WHERE Name = '] + tcName + ['])

	return loProcesses.count
endproc
