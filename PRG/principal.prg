*!*	Clear

*!*	TEXT TO lcCharImprimiveis
*!*	-------------------------------------------------------------------
*!*	|  Caracteres imprimiveis [ASCII De: 33 a 126] :
*!*	|	! " # $ % & ' ( ) * + , - . /
*!*	|	: ; < = > ? @
*!*	|	0 1 2 3 4 5 6 7 8 9
*!*	|	[ \ ] ^ _ ` { | } ~
*!*	|	A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
*!*	|	a b c d e f g h i j k l m n o p q r s t u v w x y z
*!*	-------------------------------------------------------------------

*!*	ENDTEXT


*!*	Local m.lcString, m.lnPassLength
*!*	m.lcString 		= ""
*!*	m.lnPassLength 	= 15
*!*	If lnPassLength >= 10 And lnPassLength <= 95
*!*		For i = 1 To lnPassLength
*!*			m.lnRandom = Rand() * 94 + 33
*!*			m.lcString = m.lcString + Chr(m.lnRandom)
*!*		Endfor
*!*	Else
*!*		Messagebox("Quantidade minimo e maximo: De 10 à 95 caracteres!", 48,'Atenção!')
*!*	Endif
*!*	?lcString

_Screen.Visible 	= .F.
_Screen.windowstate = 2
_Screen.minWidth 	= 720
_Screen.minheight	= 96
_Screen.Caption		= 'PWD Vault'
_Screen.Icon = 'IMG\ICO\KEYS.ICO'
SetarFuncoes()
SetarVariaveisPublicas()



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
	SET CLOCK status

	Public c_netpath, c_root
	c_netpath	= Sys(5)+Curdir()
	c_root		= Sys(5)+Curdir()

	Set Default To &c_netpath
	Set Path To &c_root


	On Error Do errHandler With Error( ), Message( ), Message(1), Program( ), Lineno( )

	Set Procedure To Funcoes.prg
	Set Procedure To MoverBarraDeTitulo.prg Additive

	Set Library To vfpencryption.fll Additive
	Set Library To vfpencryption71.fll Additive
Endproc

Procedure SetarVariaveisPublicas
	setarVariaveisDarkMode()
	chaveencrydecry()
	Public xNomeUsuario, xSobreUsuario, xlogin, xEmailLogin, xLoginAtivo, xPk_padraoUsuario
	
	xPk_padraoUsuario 	= ''
	xLoginAtivo			= .F.
	xNomeUsuario  		= 'Padrão'
	xSobreUsuario 		= ''
	xlogin				= 'padrao'
	xEmailLogin 		= 'padrao@padrao.com'

Endproc

Procedure setarVariaveisDarkMode
	Public xDarkMode, xBackColor, xBorderColor, ;
		xForeColor, xMouseEnterBackColor, xBackColorForm, ;
		xBorderColorLine, xBackColorScreen, ;
		xDisabledForeColor, xDisabledBackColor, xBorderColorLineText

	*
	xDarkMode = File(Addbs(Sys(2003)) + 'DarkMode.txt')

	xBackColorScreen		= Iif(xDarkMode, '128,128,128', '237,157,157')
	xBackColor 	 			= Iif(xDarkMode, '50,50,50', '223,95,95')
	xBorderColor 			= Iif(xDarkMode, '50,50,50', '223,95,95')
	xForeColor	 			= Iif(xDarkMode, '255,255,255', '0,0,0')
	
	xDisabledBackColor 		= Iif(xDarkMode, '100,100,100', '235,152,152') &&'192,192,192'
	xDisabledForeColor	 	= Iif(xDarkMode, '192,192,192', '128,128,128')
	
	xMouseEnterBackColor 	= Iif(xDarkMode, '192,192,192','235,152,152')

	xBackColorForm 			= Iif(xDarkMode, '80,80,80', '255,255,255')
	xBorderColorLine		= Iif(xDarkMode,  '192,192,192','235,152,152')
	xBorderColorLineText	= Iif(xDarkMode,  '192,192,192','235,152,152')
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

ENDPROC

Procedure chaveEncrydecry
	Public xChavePublicaEncDec

	xChavePublicaEncDec = 'DeuErro'

	Try
		xChavePublicaEncDec = ALLTRIM(Filetostr(Addbs(Sys(2003)) + 'songrim.dll'))
	Catch
	Endtry
ENDPROC

Function Criptografar
	Lparameters lcstring

	Return Encrypt(lcstring, xChavePublicaEncDec, 0, 3, 3)
Endfunc

Function DesCriptografar
	Lparameters lcstring

	Return decrypt(ALLTRIM(lcstring),iif(alltrim(UPPER(xChavePublicaEncDec)) == 'DEUERRO', 'NotDecryptSorry', xChavePublicaEncDec), 0, 3, 3)
Endfunc
