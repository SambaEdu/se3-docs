# Documentation wpkg

* [Informations sur les applications](#informations-sur-les-applications)
	* [Géogébra](#géogébra)
	* [Java](#java)
	* [Libre Office](#libre-office)
* [Liens utiles](#liens-utiles)


## Informations sur les applications

### Géogébra

Depuis le début de l'année 2018, une nouvelle version de Géogébra est sortie (version 6). Cette nouvelle version ne permet plus l'association de fichiers et présente une interface très différente.

Il est donc disponible en version stable la version 5 et en version testing la version 6.

### Java

Il arrive que java n'arrive plus à s'installer automatiquement sur les postes. Durant l'installation de java, une boite dialogue s'ouvre et le programme reste bloqué à cet endroit.

Pour régler le soucis, il faut :
1. Nettoyer le poste à l'aide des commandes suivantes :
```
rd /S /Q "C:\ProgramData\Oracle"
rd /S /Q "C:\Program Files\Java"
rd /S /Q "C:\Program Files (x86)\Java"
rd /S /Q "C:\Users\adminse3\.oracle_jre_usage"
rd /S /Q "C:\Users\adminse3\AppData\Roaming\sun"
rd /S /Q "C:\Users\adminse3\AppData\LocalLow\sun"
rd /S /Q "C:\Users\adminse3\AppData\Local\sun"
```
2. Relancer wpkg en administrateur en mode non caché. Lorsque java ouvre une fenêtre, cliquer sur ok. Il existe une fenêtre pour la version 64 bits et une fenêtre pour la version 32 bits.

### Libre Office

Depuis le 5 avril 2018, un nouveau xml est disponible pour Libre Office en version testing. Il ne sera plus fonctionnel pour windows XP, puisque la version 6.0 requiert windows 7 ou supérieur.

Depuis la version 3.4.5, il n'est plus nécessaire de déinstaller les versions antérieures. Si vous possédiez une version antérieure à la version 3.4.5, vous devriez faire le ménage avant.

Par défaut, les fichiers docx, xlsx... ne sont pas associés à libre office. Pour l'activer, il faut modifier le xml, en remplacant :
```
		<!-- installation sans association de fichiers -->
		<install cmd="msiexec /I &quot;%Z%\packages\libreoffice\LibreOffice_Win_x86.msi&quot; /qn /LOG &quot;%SystemDrive%\Netinst\Logs\LibreOffice-Prog.log&quot; CREATEDESKTOPLINK=1 ADDLOCAL=ALL ALLUSERS=1 ISCHECKFORPRODUCTUPDATES=0 AgreeToLicense=1 RebootYesNo=No IS1036=1 SELECT_WORD=0 REGISTER_DOCX=0 REGISTER_DOC=0 REGISTER_DOCM=0 REGISTER_DOT=0 REGISTER_DOTX=0 REGISTER_DOTM=0 REGISTER_RTF=0 SELECT_EXCEL=0 REGISTER_XLS=0 REGISTER_XLSX=0 REGISTER_XLSM=0 REGISTER_XLSB=0 REGISTER_XLAM=0 REGISTER_XLT=0 REGISTER_XLTX=0 REGISTER_XLTM=0 SELECT_POWERPOINT=0 REGISTER_PPS=0 REGISTER_PPSX=0 REGISTER_PPSM=0 REGISTER_PPAM=0 REGISTER_PPT=0 REGISTER_PPTX=0 REGISTER_PPTM=0 REGISTER_POT=0 REGISTER_POTX=0 REGISTER_POTM=0" architecture="x86"/>
		<install cmd="msiexec /I &quot;%Z%\packages\libreoffice\LibreOffice_Win_x64.msi&quot; /qn /LOG &quot;%SystemDrive%\Netinst\Logs\LibreOffice-Prog.log&quot; CREATEDESKTOPLINK=1 ADDLOCAL=ALL ALLUSERS=1 ISCHECKFORPRODUCTUPDATES=0 AgreeToLicense=1 RebootYesNo=No IS1036=1 SELECT_WORD=0 REGISTER_DOCX=0 REGISTER_DOC=0 REGISTER_DOCM=0 REGISTER_DOT=0 REGISTER_DOTX=0 REGISTER_DOTM=0 REGISTER_RTF=0 SELECT_EXCEL=0 REGISTER_XLS=0 REGISTER_XLSX=0 REGISTER_XLSM=0 REGISTER_XLSB=0 REGISTER_XLAM=0 REGISTER_XLT=0 REGISTER_XLTX=0 REGISTER_XLTM=0 SELECT_POWERPOINT=0 REGISTER_PPS=0 REGISTER_PPSX=0 REGISTER_PPSM=0 REGISTER_PPAM=0 REGISTER_PPT=0 REGISTER_PPTX=0 REGISTER_PPTM=0 REGISTER_POT=0 REGISTER_POTX=0 REGISTER_POTM=0" architecture="x64"/>

		<!-- installation avec association de fichiers 
		<install cmd="msiexec /I &quot;%Z%\packages\libreoffice\LibreOffice_Win_x86.msi&quot; /qn /LOG &quot;%SystemDrive%\Netinst\Logs\LibreOffice-Prog.log&quot; CREATEDESKTOPLINK=1 ADDLOCAL=ALL ALLUSERS=1 ISCHECKFORPRODUCTUPDATES=0 AgreeToLicense=1 RebootYesNo=No IS1036=1 SELECT_WORD=1 REGISTER_DOCX=1 REGISTER_DOC=1 REGISTER_DOCM=1 REGISTER_DOT=1 REGISTER_DOTX=1 REGISTER_DOTM=1 REGISTER_RTF=1 SELECT_EXCEL=1 REGISTER_XLS=1 REGISTER_XLSX=1 REGISTER_XLSM=1 REGISTER_XLSB=1 REGISTER_XLAM=1 REGISTER_XLT=1 REGISTER_XLTX=1 REGISTER_XLTM=1 SELECT_POWERPOINT=1 REGISTER_PPS=1 REGISTER_PPSX=1 REGISTER_PPSM=1 REGISTER_PPAM=1 REGISTER_PPT=1 REGISTER_PPTX=1 REGISTER_PPTM=1 REGISTER_POT=1 REGISTER_POTX=1 REGISTER_POTM=1" architecture="x86"/>
		<install cmd="msiexec /I &quot;%Z%\packages\libreoffice\LibreOffice_Win_x64.msi&quot; /qn /LOG &quot;%SystemDrive%\Netinst\Logs\LibreOffice-Prog.log&quot; CREATEDESKTOPLINK=1 ADDLOCAL=ALL ALLUSERS=1 ISCHECKFORPRODUCTUPDATES=0 AgreeToLicense=1 RebootYesNo=No IS1036=1 SELECT_WORD=1 REGISTER_DOCX=1 REGISTER_DOC=1 REGISTER_DOCM=1 REGISTER_DOT=1 REGISTER_DOTX=1 REGISTER_DOTM=1 REGISTER_RTF=1 SELECT_EXCEL=1 REGISTER_XLS=1 REGISTER_XLSX=1 REGISTER_XLSM=1 REGISTER_XLSB=1 REGISTER_XLAM=1 REGISTER_XLT=1 REGISTER_XLTX=1 REGISTER_XLTM=1 SELECT_POWERPOINT=1 REGISTER_PPS=1 REGISTER_PPSX=1 REGISTER_PPSM=1 REGISTER_PPAM=1 REGISTER_PPT=1 REGISTER_PPTX=1 REGISTER_PPTM=1 REGISTER_POT=1 REGISTER_POTX=1 REGISTER_POTM=1" architecture="x64"/>
		desactive -->
```
par :
```
		<!-- installation sans association de fichiers
		<install cmd="msiexec /I &quot;%Z%\packages\libreoffice\LibreOffice_Win_x86.msi&quot; /qn /LOG &quot;%SystemDrive%\Netinst\Logs\LibreOffice-Prog.log&quot; CREATEDESKTOPLINK=1 ADDLOCAL=ALL ALLUSERS=1 ISCHECKFORPRODUCTUPDATES=0 AgreeToLicense=1 RebootYesNo=No IS1036=1 SELECT_WORD=0 REGISTER_DOCX=0 REGISTER_DOC=0 REGISTER_DOCM=0 REGISTER_DOT=0 REGISTER_DOTX=0 REGISTER_DOTM=0 REGISTER_RTF=0 SELECT_EXCEL=0 REGISTER_XLS=0 REGISTER_XLSX=0 REGISTER_XLSM=0 REGISTER_XLSB=0 REGISTER_XLAM=0 REGISTER_XLT=0 REGISTER_XLTX=0 REGISTER_XLTM=0 SELECT_POWERPOINT=0 REGISTER_PPS=0 REGISTER_PPSX=0 REGISTER_PPSM=0 REGISTER_PPAM=0 REGISTER_PPT=0 REGISTER_PPTX=0 REGISTER_PPTM=0 REGISTER_POT=0 REGISTER_POTX=0 REGISTER_POTM=0" architecture="x86"/>
		<install cmd="msiexec /I &quot;%Z%\packages\libreoffice\LibreOffice_Win_x64.msi&quot; /qn /LOG &quot;%SystemDrive%\Netinst\Logs\LibreOffice-Prog.log&quot; CREATEDESKTOPLINK=1 ADDLOCAL=ALL ALLUSERS=1 ISCHECKFORPRODUCTUPDATES=0 AgreeToLicense=1 RebootYesNo=No IS1036=1 SELECT_WORD=0 REGISTER_DOCX=0 REGISTER_DOC=0 REGISTER_DOCM=0 REGISTER_DOT=0 REGISTER_DOTX=0 REGISTER_DOTM=0 REGISTER_RTF=0 SELECT_EXCEL=0 REGISTER_XLS=0 REGISTER_XLSX=0 REGISTER_XLSM=0 REGISTER_XLSB=0 REGISTER_XLAM=0 REGISTER_XLT=0 REGISTER_XLTX=0 REGISTER_XLTM=0 SELECT_POWERPOINT=0 REGISTER_PPS=0 REGISTER_PPSX=0 REGISTER_PPSM=0 REGISTER_PPAM=0 REGISTER_PPT=0 REGISTER_PPTX=0 REGISTER_PPTM=0 REGISTER_POT=0 REGISTER_POTX=0 REGISTER_POTM=0" architecture="x64"/>
		desactive -->
		
		<!-- installation avec association de fichiers -->
		<install cmd="msiexec /I &quot;%Z%\packages\libreoffice\LibreOffice_Win_x86.msi&quot; /qn /LOG &quot;%SystemDrive%\Netinst\Logs\LibreOffice-Prog.log&quot; CREATEDESKTOPLINK=1 ADDLOCAL=ALL ALLUSERS=1 ISCHECKFORPRODUCTUPDATES=0 AgreeToLicense=1 RebootYesNo=No IS1036=1 SELECT_WORD=1 REGISTER_DOCX=1 REGISTER_DOC=1 REGISTER_DOCM=1 REGISTER_DOT=1 REGISTER_DOTX=1 REGISTER_DOTM=1 REGISTER_RTF=1 SELECT_EXCEL=1 REGISTER_XLS=1 REGISTER_XLSX=1 REGISTER_XLSM=1 REGISTER_XLSB=1 REGISTER_XLAM=1 REGISTER_XLT=1 REGISTER_XLTX=1 REGISTER_XLTM=1 SELECT_POWERPOINT=1 REGISTER_PPS=1 REGISTER_PPSX=1 REGISTER_PPSM=1 REGISTER_PPAM=1 REGISTER_PPT=1 REGISTER_PPTX=1 REGISTER_PPTM=1 REGISTER_POT=1 REGISTER_POTX=1 REGISTER_POTM=1" architecture="x86"/>
		<install cmd="msiexec /I &quot;%Z%\packages\libreoffice\LibreOffice_Win_x64.msi&quot; /qn /LOG &quot;%SystemDrive%\Netinst\Logs\LibreOffice-Prog.log&quot; CREATEDESKTOPLINK=1 ADDLOCAL=ALL ALLUSERS=1 ISCHECKFORPRODUCTUPDATES=0 AgreeToLicense=1 RebootYesNo=No IS1036=1 SELECT_WORD=1 REGISTER_DOCX=1 REGISTER_DOC=1 REGISTER_DOCM=1 REGISTER_DOT=1 REGISTER_DOTX=1 REGISTER_DOTM=1 REGISTER_RTF=1 SELECT_EXCEL=1 REGISTER_XLS=1 REGISTER_XLSX=1 REGISTER_XLSM=1 REGISTER_XLSB=1 REGISTER_XLAM=1 REGISTER_XLT=1 REGISTER_XLTX=1 REGISTER_XLTM=1 SELECT_POWERPOINT=1 REGISTER_PPS=1 REGISTER_PPSX=1 REGISTER_PPSM=1 REGISTER_PPAM=1 REGISTER_PPT=1 REGISTER_PPTX=1 REGISTER_PPTM=1 REGISTER_POT=1 REGISTER_POTX=1 REGISTER_POTM=1" architecture="x64"/>
```

## Liens utiles

[Liste des applications disponibles](http://wawadeb.crdp.ac-caen.fr/versions-xml-se3.php)

