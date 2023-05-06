SET SAFETY off

Local m.lcCaminho
WAIT WINDOW "COMPILANDO, AGUARDE..." nowait
m.lcCaminho = 'c:\vfpcalixto\VFP_PwdValt\'
m.lcCaminhoDestino = 'd:\vfpcalixto\VFP_PwdValt\'

If File(Addbs(m.lcCaminho) + 'cofredesenhas.exe')
	Delete File (Addbs(m.lcCaminho) + 'cofredesenhas.exe')
Endif

BUILD EXE (Addbs(m.lcCaminho) + 'cofredesenhas.exe') From Addbs(m.lcCaminho) + 'cofredesenhas.pjx'

IF INLIST(MESSAGEBOX('Deseja copiar para unidade "D"?',36,'Atenção', 2000), 6,1)
	COPY FILE Addbs(m.lcCaminho) + 'cofredesenhas.exe' TO Addbs(m.lcCaminhoDestino) + 'cofredesenhas.exe'
endif
MESSAGEBOX("COMPILADO!", 64,'Atenção!',2000)
WAIT clear