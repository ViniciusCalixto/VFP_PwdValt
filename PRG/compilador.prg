SET SAFETY off

Local m.lcCaminho
WAIT WINDOW "COMPILANDO, AGUARDE..." nowait
m.lcCaminho = 'c:\vfpcalixto\vfp_geradordesenhas\'

If File(Addbs(m.lcCaminho) + 'cofredesenhas.exe')
	Delete File (Addbs(m.lcCaminho) + 'cofredesenhas.exe')
Endif

BUILD EXE (Addbs(m.lcCaminho) + 'cofredesenhas.exe') From Addbs(m.lcCaminho) + 'cofredesenhas.pjx'

MESSAGEBOX("COMPILADO!", 64,'Atenção!',2000)
WAIT clear