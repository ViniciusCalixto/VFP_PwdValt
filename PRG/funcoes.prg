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
