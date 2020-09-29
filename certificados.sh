#!/usr/bin/env bash

#
# certificados.sh: 	Emite certificados dos treinamentos existentes no
# ----------------	portfólio do programa AWS Academy.
#
#			Para tanto, utiliza o template de certificado de
#			conclusão disponível em formato PDF no LMS Canvas 
#			do programa, bem como o arquivo "alunos.csv", que 
#			contém os dados dos alunos.
#
#			A estrutura de diretórios do projeto contempla as
#			pastas csv-template, pdf-template e pdf-output,
#			a saber:
#
#			--> csv-template: contém o arquivo "alunos.csv",
#			devidamente populado, com entradas que exemplificam
#			o formato de dados exigido pelo script;
#
#			--> pdf-template: nesse diretório deve ser copiado
#			o certificado de conclusão disponíbilizado aos 
#			intrutores devidamente credenciados no programa AWS
#			Academy via LMS Canvas. O template está localizado
#			na seção "Arquivos", na pasta "Educator Files" e 
#			originalmente recebe o nome: 
#			"AWS+Academy+Completion+Certificate_MASTER(ACF)_PT.pdf"
#
#			* Atenção: O certificado não é distribuído com a 
#			aplicação por motivos óbvios. Cabe ao instrutor
#			credenciado ao programa baixar o arquivo e gravá-lo
#			na pasta indicada. 
#
#			Uma vez copiado o arquivo original, faça uma cópia
#			denominada "template.pdf". É com esse arquivo que
#			o script irá trabalhar.
#
#			--> pdf-output: nesse diretório serão gerados os
#			certificados resultantes, em formato PDF, de acordo 
#			com os dados informados no arquivo "alunos.csv",
#			armazenado no diretório "csv-template", descrito 
#			anteriormente.
#

# declaração de variáveis e chaves de sistema
ano=`date | cut -f 4 -d " " `
configure=false
debianlike=false
dia=`date | cut -f 2 -d " " `
doas=false
freebsd=false
kernel=`uname` 
linux=false
mes=`date | cut -f 3 -d " " `
openbsd=false
pdftk=false
redhatlike=false
slackwarelike=false
sudo=false

checa_arquivos() {

	echo -e "\n --> Checando arquivos: "

	if [[ -d csv-template ]] ; then
		echo -e "\t - Diretório csv-template detectado!  =)"
		if [[ -f csv-template/alunos.csv ]] ; then
			echo -e "\t\t - Arquivo alunos.csv detectado!  =)"
		else
			echo -e "\t\t - Arquivo alunos.csv não detectado!  =("
			echo -e "\t\t - Abortando execução..."
			exit 1
		fi
	else
		echo -e "\t\t - Diretório csv-template não detectado!  =("
		echo -e "\t\t - O script deve ser executado a partir da pasta de instalação."
		echo -e "\t\t - Abortando execução..."
		exit 1
	fi

	if [[ -d pdf-template ]] ; then
		echo -e "\t - Diretório pdf-template detectado!  =)"
			if [[ -f pdf-template/template.pdf ]] ; then
				echo -e "\t\t - Arquivo template.pdf detectado!  =)"
			else
				echo -e "\t\t - Arquivo template.pdf não detectado!  =("
				echo -e "\t\t - Abortando execução..."
				exit 1
			fi
	else
		echo -e "\t\t - Diretório pdf-template não detectado!  =("
		echo -e "\t\t - O script deve ser executado a partir da pasta de instalação."
		echo -e "\t\t - Abortando execução..."
		exit 1
	fi


	if [[ -d pdf-output ]] ; then
		echo -e "\t - Diretório pdf-output detectado!  =)"
	else
		echo -e "\t - Diretório pdf-template não detectado!  =("
		echo -e "\t\t - Criando diretório ..."
		mkdir pdf-output && echo -e "\t\t - Diretório pdf-output criado!  =)"
	fi

	configure=true

}

checa_dependencias() {

	echo -e "\n --> Checando dependências: "

	if [[ `which doas 2> /dev/null ` ]] ; then
		echo -e "\t - Binário doas detectado!  =)"
		doas=true
	elif [[ `which sudo 2> /dev/null ` ]] ; then
		echo -e "\t - Binário sudo detectado!  =)"
		sudo=true
	else
		echo -e "\t - Binário doas não detectado!  =("
		echo -e "\t - Binário sudo não detectado!  =("
		echo -e "\t - Para instalação das dependências é necessário que o utilitário doas ou sudo esteja instalado e devidamente configurado."
		exit 10
	fi
	
	if [[ `which pdftk 2> /dev/null` ]] ; then
		echo -e "\t - Binário pdftk detectado!  =)"
		pdftk=true
	else
		echo -e "\t - Binário pdftk não detectado!  =("
	fi
	
}


checa_so() {

	echo -e "\n --> Checando sistema operacional: "

	if [[ "$kernel" == "FreeBSD"  ]] ; then
		echo -e "\t - FreeBSD detectado! "
		freebsd=true
	elif [[ "$kernel" == "OpenBSD"  ]] ; then
		echo -e "\t - OpenBSD detectado! "
		openbsd=true
	elif [[ "$kernel" == "Linux"  ]] ; then
		echo -e "\t - Linux detectado! "
		linux=true
		if [[ `apt-get 2> /dev/null` ]] ; then	
			echo -e "\t- Distribuição Debian like."
			debianlike=true
		elif [[ `yum 2> /dev/null` ]] ; then
			echo -e "\t - Distribuição Red Hat like."
			redhatlike=true
		else
			echo -e "\t - Distribuição Slackware like"
			slackwarelike=true
		fi
	else
		echo -e "\t - Sistema Operacional não suportado! \n"
		exit 20
	fi

}

gera_certificados () {
	echo -e "\n --> Iniciando processo de geração de certificados: "
	
	if [[ -f pdf-template/template-uncompressed.pdf ]] ; then
		echo -e "\t - Arquivo template-uncompressed.pdf detectado!  =) \n"
	else
		echo -e "\t - Arquivo template-uncompressed.pdf não detectado!  =( "
		echo -e "\t\t - Gerando arquivo template-uncompressed..."
		pdftk pdf-template/template.pdf output pdf-template/template-uncompressed.pdf uncompress 2> /dev/null && echo -e "\t\t - Arquivo template-uncompressed.pdf gerado com sucesso!  =) \n"
	fi	

	while read line ; do
	
		nome=`echo "$line" | cut -f 1 -d :`
		sobrenome=`echo "$line" | cut -f 2 -d :`

		echo -e "\t - Lendo dados do estudante: "
		echo -e "\t\t - Nome do estudante: $nome"
		echo -e "\t\t - Sobrenome do estudante: $sobrenome"

		echo -e "\t - Gerando arquivos necessários... "
		cp pdf-template/template-uncompressed.pdf pdf-template/"$nome-uncompressed.pdf"
	

		if $linux ; then
			ano=`date | cut -f 6 -d " " `
			dia=`date | cut -f 3 -d " " `
			mes=`date | cut -f 2 -d " " `
		
			echo -e "\t - Modificando dados do template... "
			sed -i "s/Mary/$nome/g" pdf-template/"$nome-uncompressed.pdf" && \
			sed -i "s/Johnson/$sobrenome/g" pdf-template/"$nome-uncompressed.pdf" && \
			sed -i "s/DD/$dia/g" pdf-template/"$nome-uncompressed.pdf" && \
			sed -i "s/MM/$mes/g" pdf-template/"$nome-uncompressed.pdf" && \
			sed -i "s/YYYY/$ano/g" pdf-template/"$nome-uncompressed.pdf" && \
			pdftk pdf-template/"$nome-uncompressed.pdf" output pdf-output/"Certificado-$nome-$sobrenome.pdf" compress && \
			echo -e "\t\t - Certificado do estudante $nome $sobrenome gerado com sucesso!"

			echo -e "\t - Removendo arquivos temporários... "
			rm pdf-template/"$nome-uncompressed.pdf"

			echo -e "\t - Procedimento concluído! \n"
		else
			echo -e "\t - Modificando dados do template... "
			sed -i '' -e "s/Mary/$nome/g" pdf-template/"$nome-uncompressed.pdf" && \
			sed -i '' -e "s/Johnson/$sobrenome/g" pdf-template/"$nome-uncompressed.pdf" && \
			sed -i '' -e "s/DD/$dia/g" pdf-template/"$nome-uncompressed.pdf" && \
			sed -i '' -e "s/MM/$mes/g" pdf-template/"$nome-uncompressed.pdf" && \
			sed -i '' -e "s/YYYY/$ano/g" pdf-template/"$nome-uncompressed.pdf" && \
			pdftk pdf-template/"$nome-uncompressed.pdf" output pdf-output/"Certificado-$nome-$sobrenome.pdf" compress && \
			echo -e "\t\t - Certificado do estudante $nome $sobrenome gerado com sucesso!"

			echo -e "\t - Removendo arquivos temporários... "
			rm pdf-template/"$nome-uncompressed.pdf"

			echo -e "\t - Procedimento concluído! \n"
		fi

	done < csv-template/alunos.csv	

}

instala_dependencias () {

	echo -e "\n --> Instalando dependências: "

	if $freebsd ; then 
		echo -e "\t - Instalando pdftk em ambiente FreeBSD... \n"
		if $doas ; then
			doas pkg install pdftk
			echo -e "\n"
		else
			sudo pkg install pdftk
			echo -e "\n"
		fi
	elif $linux ; then
		echo -e "\t - Instalando pdftk em ambiente Linux... \n"
		if $debianlike ; then
			if $doas ; then
				doas apt-get install pdftk || doas snap install pdftk
				echo -e "\n"
			else
				sudo apt-get install pdftk || sudo snap install pdftk
				echo -e "\n"
			fi
		elif $redhatlike ; then
			if $doas ; then
				doas yum install pdftk 
				echo -e "\n"
			else
				sudo yum install pdftk || sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && \
					                  sudo dnf upgrade && \
							  sudo yum update && \
							  sudo yum install snapd && \
							  sudo systemctl enable --now snapd.socket && \
							  test -d /snap || sudo ln -s /var/lib/snapd/snap /snap && \
							  sudo snap install pdftk

				echo -e "\n"
			fi
		else
			if $doas ; then
				doas slackpkg install pdftk
				echo -e "\n"
			else
				sudo slackpkg install pdftk
				echo -e "\n"
			fi
		fi
	elif $openbsd ; then
		echo -e "\t - Instalando pdftk em ambiente OpenBSD... \n"
		if $doas ; then
			doas pkg_add pdftk
			echo -e "\n"
		else
			sudo pkg_add pdftk
			echo -e "\n"
		fi
	fi

}

# limpa a tela para execução do script
clear

# verifica o sistema operacional host e checa as dependências
checa_so
checa_dependencias

# caso existam dependências, realiza a instalação
if ! $pdftk ; then
	instala_dependencias
fi

# verifica se os arquivos necessários, descritos na documentação, estão disponíveis
checa_arquivos

# se tudo estiver ok, gera os certificados
if $configure ; then
	gera_certificados
fi
