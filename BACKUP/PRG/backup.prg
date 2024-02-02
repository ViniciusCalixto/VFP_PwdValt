#Define  _cListaExtensoesARQBKP '|.DBF|.CDX|.SQL|.FPT|.DBC|.DCT|.DCX|'

*!*	SepararArquivos('C:\VFPCALIXTO\TEMP\TESTE\BDADOS\PAD')
*!*	CompactarArquivos('C:\VFPCALIXTO\TEMP\BKPCALIXTOTESTE.zip')
Procedure AtualizarLabel
	Lparameters loForm, lcTexto

	loForm.lblStatus.Caption = lcTexto
	loForm.lblStatus.Refresh()
Endproc

Function CompactarArquivos
	Lparameters loForm, lcCaminhoArquivoZip, lcPassword

	lcPassword = Iif(Upper(Alltrim(Vartype(	lcPassword))) == 'C', '-p'+Alltrim(lcPassword), '')

	Local lnRetorno, lcBKPFILETemp
	lnRetorno  		= 0
	lcBKPFILETemp 	= Addbs(Sys(2023)) + Justfname(lcCaminhoArquivoZip)

	If Used("crCaminhoArquivos")
		Select crCaminhoArquivos
		Go Top
		Scan
			Local lcFileCorrente, lcComando
			lcFileCorrente = ''
			lcComando      = ''
			lcFileCorrente = Alltrim(Addbs(Alltrim(crCaminhoArquivos.FullDirFile)) + crCaminhoArquivos.NomeArquivo)
			Wait Window [C O M P A C T A N D O] + Chr(13) + ;
				[Caminho: ] + Alltrim(Addbs(Alltrim(crCaminhoArquivos.FullDirFile))) + Chr(13) + ;
				[Arquivo: ] + Alltrim(crCaminhoArquivos.NomeArquivo) Nowait

			AtualizarLabel(loForm, "Compactando: " + Alltrim(crCaminhoArquivos.NomeArquivo))

			If File(lcFileCorrente)
				***Help Command 7z
				***https://axelstudios.github.io/7z/#!/
				Local lcDirEXE7z
				lcDirEXE7z  = RetornarCaminho7zip()
				If !Empty(lcDirEXE7z)
					lcComando = '"' + lcDirEXE7z + '" a -tzip -mx9 '+lcPassword+' -spf2 "' + lcBKPFILETemp + '" "' + lcFileCorrente + '"'
					lnRetorno = ExecutarSemRestricoes(lcComando, '', .T., 0)

					If lnRetorno <> 0
						Messagebox("Ocorreu um erro ao realizar o [B A C K U P]"+Chr(13)+;
							"Error_CODE: " + Alltrim(Transform(lnRetorno)),48,_Screen.Caption)
						Rename lcCaminhoArquivoZip To "ERROR_"+lcCaminhoArquivoZip
						Exit
					Endif
				ELSE
					lnRetorno = -1
					Messagebox("Ocorreu um erro ao realizar o [B A C K U P]"+Chr(13)+;
						"Recurso não foi localizado '7zip 32bits'",48,_Screen.Caption)
					Exit
				Endif
			Endif
			PreencherProgresso(loForm)
			_sleep(90)
		Endscan

		If lnRetorno == 0 And File(lcBKPFILETemp)
			lnRetorno = CopiarBkpParaDestino(loForm, lcBKPFILETemp, Upper(lcCaminhoArquivoZip))
		Endif

		Wait Clear
	Endif
	Return lnRetorno
Endfunc

Function CopiarBkpParaDestino
	Lparameters loForm, lcCaminhoArquivoZip_Origem, lcCaminhoArquivoZip_Destino
	Local lnRetorno, lcJustDir, lcJustFile
	lnRetorno  = 0
	lcJustDir  = Justpath(Alltrim(lcCaminhoArquivoZip_Destino))
	lcJustFile = Justfname(Alltrim(lcCaminhoArquivoZip_Destino))

	Wait Window [F I N A L I Z A N D O] + Chr(13) + ;
		[Caminho: ] + lcJustDir   + Chr(13) + ;
		[Arquivo: ] + lcJustFile  + Chr(13) + ;
		[Aguarde...] Nowait
	Try
		If File(lcCaminhoArquivoZip_Origem)
			Copy File (lcCaminhoArquivoZip_Origem) To (lcCaminhoArquivoZip_Destino)
		Endif
	Catch To loError
		lnRetorno = loError
	Endtry
	PreencherProgresso(loForm)

	Try
		If File(lcCaminhoArquivoZip_Origem)
			Wait Window [L I M P A N D O  T E M P] + Chr(13) + ;
				[Aguarde...] Nowait
			_sleep(1000)

			Dimension larrFileDelete[1,1]
			larrFileDelete[1,1] = ''

			**BACKUP-20231223-152131-BDADOS
			Local lcJustpathOrigem
			lcJustpathOrigem = Addbs(Justpath(Alltrim(lcCaminhoArquivoZip_Origem)))

			Adir(larrFileDelete, lcJustpathOrigem + Juststem(lcJustFile) + '*.*', "D", 1)

			Local lnTotalArr
			lnTotalArr = Alen(larrFileDelete, 1)

			If lnTotalArr > 0
				Local lcNomeArqDel
				lcNomeArqDel 	= ''
				For I = 1 To lnTotalArr
					lcNomeArqDel = larrFileDelete[i, 1]
					If File(lcJustpathOrigem + lcNomeArqDel)
						Delete File (lcJustpathOrigem + lcNomeArqDel)
					Endif
				Endfor
			Endif
			Wait Clear
		Endif
	Catch
		*TO lRetorno

		*!*			Messagebox("11-Erro ao finalizar bkp!" 								+ Chr(13) + Chr(13) + ;
		*!*						[Error: ] 			+ Alltrim(Transform(lRetorno.ErrorNo))  	+ Chr(13) + ;
		*!*						[LineNo: ] 		+ Alltrim(Transform(lRetorno.Lineno)) 		+ Chr(13) + ;
		*!*						[Message: ] 		+ Alltrim(lRetorno.Message)					+ Chr(13) + ;
		*!*						[Procedure: ] 		+ Alltrim(lRetorno.Procedure)  				+ Chr(13) + ;
		*!*						[Details: ] 		+ Alltrim(lRetorno.Details)  				+ Chr(13) + ;
		*!*						[StackLevel: ] 	+ Alltrim(Transform(lRetorno.StackLevel))  	+ Chr(13) + ;
		*!*						[LineContents: ] 	+ Alltrim(lRetorno.LineContents) 			+ Chr(13) + ;
		*!*						[UserValue: ] 		+ Alltrim(lRetorno.UserValue), ;
		*!*						48, "Atenção - "+_Screen.Caption)
	Endtry
	PreencherProgresso(loForm)

	Wait Clear
	Return lnRetorno
Endfunc

Procedure ConfigurarProgresso
	Lparameters loForm
	Local lnMaxProg
	lnMaxProg = 2 && Copiar + Limpar + QTDArquivos

	If Used("crCaminhoArquivos")
		lnMaxProg = lnMaxProg + Reccount("crCaminhoArquivos")
	Endif
	loForm.progressbar.ctlMaximum 	= lnMaxProg
	loForm.progressbar.ctlMinimum 	= 0
	loForm.progressbar.ctlvalue 	= 0
Endproc

Procedure PreencherProgresso
	Lparameters loForm
	loForm.progressbar.ctlIncrement(1)
	loForm.progressbar.Refresh()
Endproc

Function SepararArquivos
	Lparameters loForm, lcPastaBKP
	Local lnRetorno
	lnRetorno = 0
	If !Used("crCaminhoArquivos")
		Create Cursor crCaminhoArquivos(FullDirFile M, NomeArquivo C(200))
	Endif
	If Directory(lcPastaBKP)
		Local lcNomeArquivo, loFolder, loFiles_ID, loFile
		loFolder = Createobject("scripting.filesystemobject")
		loFiles_ID = loFolder.getfolder(lcPastaBKP)
		For Each loFile In loFiles_ID.Files
			lcNomeArquivo = loFile.Name

			Wait Window [S E P A R A N D O] + Chr(13) +;
				[Arquivo: ] + Alltrim(lcNomeArquivo) Nowait

			If Upper(Right(Alltrim(lcNomeArquivo), 4)) $ _cListaExtensoesARQBKP

				Insert Into crCaminhoArquivos(FullDirFile, NomeArquivo);
					values(lcPastaBKP, lcNomeArquivo)

				*?"NOME_ARQUIVO: ", fil.Name
				*?CHR(13)
				*?"Size: ", fil.size
				*?"Date created:", fil.DateCreated
				*?"Last modified:", fil.DateLastModified
			Endif
			Wait Clear
		Next
		ConfigurarProgresso(loForm)
	Else
		lnRetorno = 1
	Endif
	Return lnRetorno
Endfunc

Function RetornarCaminho7zip
	Local lcDirEXE7z, lcTentativa1, lcTentativa2
	lcDirEXE7z = ''

	lcTentativa1 = Addbs(Getenv("ProgramFiles(x86)"))+ '7-Zip\' + '7z.exe'

	*
	lcTentativa2Aux = Justpath(Addbs(Sys(05) + Addbs(Sys(2003))))
	lnVoltarDir = 1
	lcQtdQuebras = Getwordcount(lcTentativa2Aux,'\')
	lcTentativa2 = ''
	For I = 1 To lcQtdQuebras - lnVoltarDir
		lcTentativa2 = Addbs(lcTentativa2) + Getwordnum(lcTentativa2Aux, I, '\')
	Endfor
	lcTentativa2 = Addbs(lcTentativa2) + "Uteis\7z.exe"

	*************
	For I= 1 To 2
		lcDirEXE7z  = ''
		If File(Evaluate("lcTentativa"+Alltrim(Str(I))))
			lcDirEXE7z = Evaluate("lcTentativa"+Alltrim(Str(I)))
			Exit
		Endif
	Endfor

	Return lcDirEXE7z
Endfunc
