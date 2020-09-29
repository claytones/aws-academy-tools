# aws-academy-tools

Conjunto de ferramentas voltadas a instrutores credenciados no programa AWS Academy.

Com a migração da plataforma de cursos para o LMS Canvas, a emissão de certificados por parte dos instrutores passou a ser manual. 

Em turmas no formato EaD, o número de estudantes pode ser substancial, o que pode causar um atraso significativo na emissão dos certificados.

Nesse sentido, uma das funcionalidades providas pelos scripts desenvolvidos é gerar um conjunto de certificados em formato PDF utilizando como fonte de dados um arquivo em formato .csv com as informações dos estudantes.

Script|Descrição:
:-----|:---------
certificados.sh|    Emite certificados dos treinamentos existentes no portfólio do programa AWS Academy.<br /> <br /> Para tanto, utiliza o template de certificado de conclusão disponível em formato PDF no LMS Canvas do programa, bem como o arquivo "alunos.csv", que contém os dados dos alunos. <br /> <br />			              A estrutura de diretórios do projeto contempla as pastas csv-template, pdf-template e pdf-output, a saber: <br /> <br /> --> csv-template: contém o arquivo "alunos.csv", devidamente populado, com entradas que exemplificam o formato de dados exigido pelo script; <br /> <br /> --> pdf-template: nesse diretório deve ser copiado o certificado de conclusão disponíbilizado aos intrutores devidamente credenciados no programa AWS Academy via LMS Canvas. O template está localizado na seção "Arquivos", na pasta "Educator Files" e originalmente recebe o nome: "AWS+Academy+Completion+Certificate_MASTER(ACF)_PT.pdf" <br /> <br />* Atenção: O certificado não é distribuído com a aplicação por motivos óbvios. Cabe ao instrutor credenciado ao programa baixar o arquivo e gravá-lo na pasta indicada. <br /> <br /> Uma vez copiado o arquivo original, faça uma cópia denominada "template.pdf". É com esse arquivo que o script irá trabalhar. <br /> <br /> --> pdf-output: nesse diretório serão gerados os certificados resultantes, em formato PDF, de acordo com os dados informados no arquivo "alunos.csv", armazenado no diretório "csv-template", descrito anteriormente. <br /> <br /> * Observações: <br /> <br /> - Atualmente o script funciona perfeitamente nos sistemas operacionais FreeBSD e OpenBSD; <br /> - O suporte a Linux foi implementado com vistas às três distribuições matriz: Debian, Red Hat e Slackware. O script foi testado e mostrou-se funcional em CentOS 8.1 e Ubuntu 18.04; <br /> - O script não está otimizado, comentado, nem tampouco concluído; <br />  - Revisões futuras, com vistas a otimização e tratamento de erros, serão realizadas a medida que for possível; <br /> - Em um próximo release, seria interessante implementar o envio automático dos certificados via e-mail; <br /> - Esse código foi implementado para automatizar uma tarefa e resolver um problema, missão cumprida!  =)  
