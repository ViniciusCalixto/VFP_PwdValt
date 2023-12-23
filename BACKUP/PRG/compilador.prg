SET SAFETY off

Local m.lcCaminho
WAIT WINDOW "COMPILANDO, AGUARDE..." nowait
m.lcCaminho = 'c:\vfpcalixto\VFP_PwdValt\BACKUP\'
m.lcCaminhoDestino = 'd:\vfpcalixto\VFP_PwdValt\BACKUP\'

If File(Addbs(m.lcCaminho) + 'BACKUP.exe')
	Delete File (Addbs(m.lcCaminho) + 'BACKUP.exe')
Endif

BUILD EXE (Addbs(m.lcCaminho) + 'BACKUP.exe') From Addbs(m.lcCaminho) + 'BACKUP.pjx'

IF INLIST(MESSAGEBOX('Deseja copiar para unidade "D"?',36,'Atenção'), 6,1)
	COPY FILE Addbs(m.lcCaminho) + 'BACKUP.exe' TO Addbs(m.lcCaminhoDestino) + 'BACKUP.exe'
endif
MESSAGEBOX("COMPILADO!", 64,'Atenção!',2000)
WAIT clear