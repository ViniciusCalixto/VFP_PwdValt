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

_Screen.Visible = .F.
SetarFuncoes()
SetarVariaveisPublicas()

On Error Do errHandler With ;
	ERROR( ), Message( ), Message(1), Program( ), Lineno( )
*Use nodatabase
On Error  && Restores system error handler.

*On Key Label Alt+F4 Do Sair
On Shutdown Do Sair

Do Form vfpcalixto\vfp_geradordesenhas\frm\Frm_Splash.scx
Read Events
On Shutdown

Procedure SetarFuncoes
	SET SAFETY off
	SET EXACT on
	SET CENTURY on
	
	Set Procedure To vfpcalixto\vfp_geradordesenhas\PRG\Funcoes.prg
	Set Procedure To vfpcalixto\vfp_geradordesenhas\PRG\MoverBarraDeTitulo.prg additive
	
Endproc

Procedure SetarVariaveisPublicas
	setarVariaveisDarkMode()	
Endproc

Procedure setarVariaveisDarkMode
	Public xDarkMode, xBackColor, xBorderColor, ;
	xForeColor, xMouseEnterBackColor, xBackColorForm, ;
	xBorderColorLine, xBackColorScreen

	*
	xDarkMode = File(Addbs(Sys(2003)) + 'DarkMode.txt')
	
	xBackColorScreen		= Iif(xDarkMode, '128,128,128', '237,157,157')
	xBackColor 	 			= Iif(xDarkMode, '50,50,50', '223,95,95')
	xBorderColor 			= Iif(xDarkMode, '50,50,50', '223,95,95')
	xForeColor	 			= Iif(xDarkMode, '255,255,255', '0,0,0')
	xMouseEnterBackColor 	= Iif(xDarkMode, '192,192,192','235,152,152')
	
	xBackColorForm 			= Iif(xDarkMode, '80,80,80', '255,255,255')
	xBorderColorLine		= Iif(xDarkMode,  '192,192,192','235,152,152')
Endproc
