Function FecharSistema
	Local llRetorno
	llRetorno = .F.
	llRetorno = Messagebox("Deseja realmente sair?", 32 + 4 ,"Atenção!") == 6
	Return llRetorno
Endfunc

Procedure Sair
	*On Shutdown
	Clear Events
	Close All
	Quit
Endproc



Procedure errHandler
	Parameter merror, Mess, mess1, mprog, mlineno
	Clear
	Messagebox('Error number: ' + Ltrim(Str(merror)) + Chr(13) + Chr(10) + ;
		'Error message: ' + Mess + Chr(13) + Chr(10) + ;
		'Line of code with error: ' + mess1 + Chr(13) + Chr(10) + ;
		'Line number of error: ' + Ltrim(Str(mlineno)) + Chr(13) + Chr(10) + ;
		'Program with error: ' + mprog + Chr(13) + Chr(10) ;
		, 48, "Atenção-Error!")

	Sair()

Endproc

Procedure ExecutarSemRestricoes
	Lparameter lcComando, lcAcao, lcParams

	lcAcao = Iif(Empty(lcAcao), "Open", lcAcao)
	lcParams = Iif(Empty(lcParams), "", lcParams)

	Declare Integer ShellExecute ;
		IN SHELL32.Dll ;
		INTEGER nWinHandle, ;
		STRING cOperation, ;
		STRING cFileName, ;
		STRING cParameters, ;
		STRING cDirectory, ;
		INTEGER nShowWindow

	Declare Integer FindWindow ;
		IN WIN32API ;
		STRING cNull,String cWinName

	Return ShellExecute(FindWindow(0, _Screen.Caption), ;
		lcAcao, lcComando, ;
		lcParams, Sys(2023), 1)
Endproc
