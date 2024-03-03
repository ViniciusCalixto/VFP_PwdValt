_Screen.Visible 	= .F.
_Screen.WindowState = 2
_Screen.MinWidth 	= 955
_Screen.MinHeight	= 722
_Screen.Caption		= 'PWD Vault'
_Screen.Icon = 'IMG\ICO\KEYS.ICO'
SetarFuncoes()
SetarVariaveisPublicas()

#Define _VERSAO_ '1.00.0004'

*On Key Label Alt+F4 Do Sair
On Shutdown Do Sair
Do Form Frm_Splash.scx

Read Events
On Shutdown

Procedure SetarFuncoes
	Set Exact On
	Set Resource To
	Set Bell On
	Set Console Off
	Set Talk Off
	Set Date BRITISH
	Set Century On
	Set Status Bar On
	Set Safety Off
	Set Help On
	Set Hours To 24
	Set Deleted On
	Set Multilocks On
	Set Refresh To 4,2 && Refresh wait 4 sec on network, 2 sec local
	Set Exclusive Off
	Set Escape Off && Allow exit via Escape key
	Set Memowidth To 80 && Set width of memo fields printing to 80
	Set Carry Off && New records are blank
	Set Reprocess To 25 && Number of times to attempt locking
	Set Sysmenu Off
	Set Clock Status

	Public c_netpath, c_root
	c_netpath	= Sys(5)+Curdir()
	c_root		= Sys(5)+Curdir()

	Set Default To &c_netpath
	Set Path To &c_root


	On Error Do errHandler With Error( ), Message( ), Message(1), Program( ), Lineno( )

	Set Procedure To Funcoes.prg
	Set Procedure To MoverBarraDeTitulo.prg Additive
	Set Procedure To ComfiguracoesDarkMode.prg Additive

	Set Library To vfpencryption.fll Additive
	Set Library To vfpencryption71.fll Additive
Endproc

Procedure SetarVariaveisPublicas
	setarVariaveisDarkMode()
	*chaveencrydecry()
	Public xNomeUsuario, xSobreUsuario, xlogin, xEmailLogin, xLoginAtivo, xPk_padraoUsuario
	Public xChavePublicaEncDec, xVersao, xFotoUsuario
	xChavePublicaEncDec = 'NotDecryptSorry_'

	xPk_padraoUsuario 	= ''
	xLoginAtivo			= .F.
	xFotoUsuario		= ''
	xNomeUsuario  		= 'Padrão'
	xSobreUsuario 		= ''
	xlogin				= 'padrao'
	xEmailLogin 		= 'padrao@padrao.com'
	xVersao				= _VERSAO_


Endproc


Procedure errHandler
	Parameter merror, Mess, mess1, mprog, mlineno
	Messagebox('Error number: ' + Ltrim(Str(merror)) + Chr(13) + Chr(10) + ;
		'Error message: ' + Mess + Chr(13) + Chr(10) + ;
		'Line of code with error: ' + mess1 + Chr(13) + Chr(10) + ;
		'Line number of error: ' + Ltrim(Str(mlineno)) + Chr(13) + Chr(10) + ;
		'Program with error: ' + mprog + Chr(13) + Chr(10) ;
		, 48, "Atenção-Error!")

	Sair()

Endproc

Procedure chaveEncrydecry
	Public xChavePublicaEncDec
	xChavePublicaEncDec = 'NotDecryptSorry_'

	Try
		xChavePublicaEncDec = Alltrim(Filetostr(Addbs(Sys(2003)) + 'songrim.dll'))
	Catch
	Endtry
Endproc

Function Criptografar
	Lparameters lcstring

	Return Encrypt(Alltrim(lcstring), xChavePublicaEncDec, 0, 3, 3)
Endfunc

Function DesCriptografar
	Lparameters lcstring

	Return decrypt(Alltrim(lcstring), xChavePublicaEncDec, 0, 3, 3)
Endfunc
