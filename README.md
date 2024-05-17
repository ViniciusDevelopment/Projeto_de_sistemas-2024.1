
  
  

# Relatório Especificação de Requisitos ServiçoCerto

  

## Projeto de Sistemas 2024.1 | Universidade Federal do Tocantins - Palmas, 2024

  

## Introdução

  

O projeto desenvolvido na disciplina Projeto de sistemas do semestre 2024.1 é dividido em etapas. Primeiramente, os integrantes descrevem os casos expandidos de uso e user stories dos requisitos funcionais do sistema. Foi combinado a utilização da plataforma GitHub para gerenciar e controlar as versões do projeto, além do método Kanban para gestão ágil, por meio da ferramenta Trello. Todo o trabalho será desenvolvido no formato markdown.

  

## Escopo do projeto

  

### Descrição do projeto

Desenvolver uma plataforma de prestação de serviços que conecta prestadores de serviços a usuários, permitindo que os prestadores ofereçam seus serviços e os usuários solicitem os mesmos. A plataforma deve permitir que os prestadores de serviços criem perfis com informações pessoais, habilidades e preços, além de possibilitar a criação de perfis de usuários com informações de contato e preferências. Os usuários devem ser capazes de buscar e filtrar prestadores com base em critérios como localização e classificações, enviar solicitações de serviços e visualizar históricos de transações. Além disso, o sistema deve suportar a avaliação e revisão de prestadores e oferecer funcionalidades de pagamento seguro.

  

### Objetivos

  

* Conectar prestadores de serviços a usuários, facilitando a oferta e solicitação de serviços.

* Permitir que prestadores de serviços criem perfis detalhados com informações pessoais, habilidades e preços.

* Possibilitar aos usuários a criação de perfis com informações de contato e preferências.

* Oferecer recursos de busca e filtragem de prestadores com base em critérios como localização e classificações.

* Permitir que os usuários enviem solicitações de serviços de forma eficiente.

* Manter registros de transações para que os usuários possam acessar seu histórico.

* Facilitar a avaliação e revisão de prestadores de serviços.

* Garantir um sistema de pagamento seguro para todas as transações.

* Organizar o desenvolvimento do projeto em iterações definidas.

  

### Requisitos Funcionais

Os **Requisitos Funcionais** são uma lista dos recursos e funcionalidades específicas que o sistema, produto ou serviço deve oferecer. Isso pode incluir funcionalidades como login de usuário, solicitação de serviços, geração de relatórios, etc.

  
  

### Atores

**Usuário:** Este ator possui um nível de acesso básico dentro da aplicação. Suas principais ações incluem visualizar os serviços disponíveis e solicitar a prestação desses serviços.

  

**Prestador de Serviço:** Este ator tem todas as funcionalidades de um usuário, com a adição de privilégios adicionais. Além de poder visualizar e solicitar serviços, o prestador de serviço tem a capacidade de adicionar e gerenciar os serviços que oferece. Isso inclui a criação, edição e exclusão de serviços, bem como a definição de preços e informações detalhadas sobre os serviços prestados.

  

Esses dois atores desempenham papéis distintos no sistema ServiçoCerto, refletindo as diferentes necessidades e responsabilidades de cada grupo de usuários.

### Cronograma

|Período|Ações|
| --------------- | ----------------------------------------------------------------------------------- |
|Iteração 1| Inicio do desenvolvimento da documentação, prototipação e desenvolvimento do código (CRUD).|
|Iteração 2| Desenvolvimento de mais requisitos e funcionalidades do aplicativo.|
|Iteração 3| Desenvolvimento de mais requisitos e funcionalidades do aplicativo.|
|Iteração 4| Desenvolvimento de mais requisitos e funcionalidades do aplicativo.|
|Iteração 5| Finalização do desenvolvimento do aplicativo e realização do deploy|


  

### Metodologia de Desenvolvimento

O Kanban será usado para organizar e gerenciar o fluxo de trabalho da equipe. Criamos um quadro Kanban que representa o progresso do projeto, com colunas como "A fazer", "Em progresso" e "Concluído". As tarefas do Backlog serão adicionadas ao quadro e movidas conforme o progresso.

No final de cada iteração, a equipe realizará uma retrospectiva para avaliar o processo e identificar áreas de melhoria. Os aprendizados serão aplicados nas próximas iterações.

Após a conclusão de cada iteração, haverá uma revisão interna e externa para garantir a qualidade do código e da funcionalidade implementada. Os feedbacks serão incorporados para refinamento contínuo.

  

### Tecnologias e Ferramentas

  

Neste projeto, serão utilizadas várias tecnologias e ferramentas para o desenvolvimento, divididas entre o back-end, front-end e o sistema de gerenciamento de banco de dados (SGBD).

  

**Back-End:**<br/>

* Linguagem de Programação FASTApi: O back-end será desenvolvido utilizando um framework de phython chamado de FASTApi

  

**Front-End:**<br/>

* Flutter: Uma tecnologia de desenvolvimento de interface de usuário multiplataforma da Google, utilizado para criar aplicativos móveis com uma única base de código.

  

**Banco de Dados:**<br/>

* PostgreSQL: Será usado como o Sistema de Gerenciamento de Banco de Dados (SGBD) principal. O PostgreSQL é um sistema de banco de dados relacional robusto e altamente escalável. Além disso, a núvem AWS está sendo utilizada para tornar o banco de dados compartilhado entre os contribuidores do projeto.

  

### Critérios de Aceitação

Os critérios de aceitação para este projeto incluem:

  

* Todas as funcionalidades especificadas nos requisitos funcionais estão implementadas e funcionando corretamente.

* A plataforma passou por testes de qualidade e os bugs foram corrigidos.

* A documentação está completa e bem organizada.

* A equipe apresentou o projeto de forma clara e demonstrou todas as funcionalidades.

  
  

### Entregáveis

Os principais entregáveis deste projeto incluem:

  

*  **Documentação de Requisitos:** Especificação detalhada dos requisitos funcionais e não funcionais do sistema.<br/>

*  **Documentação de Design:** Descrição da arquitetura de software e design da plataforma.<br/>

*  **Código Fonte:** O código-fonte do sistema hospedado no GitHub.<br/>

*  **Relatórios de Progresso:** Relatórios de progresso semanais ou quinzenais para acompanhamento.<br/>

*  **Apresentação Final:** Uma apresentação que destaca as funcionalidades e realizações do projeto.<br/>

  

### Equipe de Projeto

[Vinícius Maciel Pires](https://github.com/ViniciusDevelopment/)<br/>

<br/>[Dante Ungarelli](https://github.com/danteungarelli)<br/>

<br/>[Daniel Nolêto](https://github.com/Daniel-Noleto/)<br/>

<br/>[Saulo Ferraz](https://github.com/SauloFerrazTC)<br/>

<br/>[João Victor Walcacer](https://github.com/joaovictorwg)<br/>

  
  

###

## Épicos

  

### Épico 1: Gerenciamento de Usuário -> RF01, RF02, RF03, RF04, RF05, RF06

### Épico 2: Funcionalidades para os usuários -> RF07, RF08, RF09, RF10, RF11
  

## Iteração 1- (25/Março-- 7/ Abril)



- [X] RF01 - Cadastrar prestador de serviço. [Vinícius Maciel Pires](https://github.com/ViniciusDevelopment) Revisado por [Dante Ungarelli](https://github.com/danteungarelli )

- [X] RF02 - Cadastrar usuário. [Vinícius Maciel Pires](https://github.com/ViniciusDevelopment/) Revisado por [Dante Ungarelli](https://github.com/danteungarelli)

- [X] RF03 - Realizar Login. [Vinícius Maciel Pires](https://github.com/ViniciusDevelopment/) Revisado por [Dante Ungarelli](https://github.com/danteungarelli/)

- [X] RF04 - Ver informações do pefil. [Daniel Nolêto](https://github.com/Daniel-Noleto) Revisado por [Saulo](https://github.com/SauloFerrazTC)

- [X] RF05 - Atualizar informações do perfil. [Daniel Nolêto](https://github.com/Daniel-Noleto) Revisado por [Vinícius Maciel Pires](https://github.com/ViniciusDevelopment)

- [X] RF06 - Deletar perfil. [Saulo](https://github.com/SauloFerrazTC) Revisado por [João Victor](https://github.com/joaovictorwg)

  
  

<br/>

  
  
  

---

## **RF01 - Cadastrar prestador de serviço**

<br/>

<br/>


| Item            | Descrição                                                                           |
| --------------- | ----------------------------------------------------------------------------------- |
| Caso de uso     | RF03 - Cadastrar prestador de serviço;                                                       |
| Resumo          | Cadastrar um prestador de serviço ao sistema; |
| Ator principal  | Prestador de serviço;                                                    |
| Ator secundário | -                                                                                   |
| Pré-condição    | -                          |
| Pós-condição    |                                          |

<br/>

#### Fluxo principal

| Passos  | Descrição                                           |
| ------- | --------------------------------------------------- |
| Passo 1 | O prestador digita seus dados cadastrais nos campos adequados.            |
| Passo 2 | Após preencher seus dados o prestador deve marcar a opção 'sou um prestador de serviços'. |
| Passo 3 | Ao clicar no botão 'cadastrar' no final do formulário, o prestador de serviços é cadastrado. |

<br/>

#### Campos do formulário

| Campo            | Obrigatório? | Editável? | Formato      |
| ---------------- | ------------ | --------- | ------------ |
| Nome  | Sim          | Sim       | Texto        |
| Email             | Sim          | Sim       | Email         |
| Senha            | Sim          | Sim       | Password        |
| Confirmar senha  | Sim          | Não       | Password        |

<br/>

#### Opções dos usúarios

| Opção            | Descrição | Atalho |
| ---------------- | ------------ | --------- |
| Cadastrar | Cadastra um novo prestador de serviço          | Não possui       |
| Realizar login             | Redireciona o prestador para a tela de login          | Não possui       |

<br/>

#### Relatório de usuário

| Campo                      | Descrição                                                             | Formato |
| -------------------------- | --------------------------------------------------------------------- | ------- |
| Cadastro realizado com sucesso | Informa que o cadastro foi efetuado com sucesso  | Texto   |
| Erro ao realizar o cadastro | Informa que ocorreu um erro durante o cadastro  | Texto   |
| Senha e confirmar senha não conferem | Informa a senha e a confirmação da senha estão diferentes  | Texto   |

<br/>

### US01 - Cadastrar prestador de serviço

**Prestador de serviços**

| User Story | Critério de aceitação |
| --------- | --------------------- |
| Enquanto **um prestador de serviços** eu preciso ser capaz de **criar uma conta** para que **eu possa oferecer meus serviços** | O **prestador de serviços** deve poder se cadastrar no sistema.|

<br />

### Prototipação de telas
**Tela de cadastro com marcação da opção 'Sou um prestador de serviços'**

## Protótipo:

![tela1](https://github.com/joaovictorwg/prototipos_ServicoCerto/blob/develop/PaginaInicial.png)
![tela2](https://github.com/joaovictorwg/prototipos_ServicoCerto/blob/develop/PaginaCadastro.png)


<br />
---

## **RF02 - Cadastrar usuário**

<br/>

<br/>

| Item            | Descrição                                                                           |
| --------------- | ----------------------------------------------------------------------------------- |
| Caso de uso     | RF04 - Cadastrar usuário;                                                       |
| Resumo          | Cadastrar um usuário no sistema; |
| Ator principal  | Usuário;                                                    |
| Ator secundário | -                                                                                   |
| Pré-condição    | -                          |
| Pós-condição    |                                                                                    |

<br/>

#### Fluxo principal

| Passos  | Descrição                                           |
| ------- | --------------------------------------------------- |
| Passo 1 | O usuário digita seus dados cadastrais nos campos adequados.            |
| Passo 2 | Ao clicar no botão 'cadastrar' no final do formulário, o usuário é cadastrado. |

<br/>

#### Opções dos usúarios

| Opção            | Descrição | Atalho |
| ---------------- | ------------ | --------- |
| Cadastrar | Cadastra um novo usuário          | Não possui       |
| Realizar login             | Redireciona o usuário para a tela de login          | Não possui       |

<br/>

#### Relatório de usuário

| Campo                      | Descrição                                                             | Formato |
| -------------------------- | --------------------------------------------------------------------- | ------- |
| Cadastro realizado com sucesso | Informa que o cadastro foi efetuado com sucesso  | Texto   |
| Erro ao realizar o cadastro | Informa que ocorreu um erro durante o cadastro  | Texto   |
| Senha e confirmar senha não conferem | Informa a senha e a confirmação da senha estão diferentes  | Texto   |
<br/>






<br/>

#### Campos do formulário

| Campo            | Obrigatório? | Editável? | Formato      |
| ---------------- | ------------ | --------- | ------------ |
| Nome  | Sim          | Sim       | Texto        |
| Email             | Sim          | Sim       | Email         |
| Senha            | Sim          | Sim       | Password        |
| Confirmar senha  | Sim          | Não       | Password        |

<br/>


<br/>


<br/>

### US02 - Cadastrar usuário

**Prestador de serviços**

| User Story | Critério de aceitação |
| --------- | --------------------- |
| Enquanto **usuário** eu preciso ser capaz de **criar uma conta** para que **eu possa contratar os serviços** | Informações corretas no formulário de cadastro|

<br />

### Prototipação de telas

## Protótipo:

![tela1](https://github.com/joaovictorwg/prototipos_ServicoCerto/blob/develop/PaginaCadastro.png)

<br />
---



## **RF03 - Realizar Login**

<br/>

<br/>

| Item            | Descrição                                                                           |
| --------------- | ----------------------------------------------------------------------------------- |
| Caso de uso     | RF05 - Realizar Login;                                                       |
| Resumo          | Realizar o login dos atores; |
| Ator principal  | Usuario/Prestador de serviço;                                                    |
| Ator secundário | -                                                                             |
| Pré-condição    | O(s) ator(es) devem ter um cadastro no sistema.                         |
| Pós-condição    | Os dados do(s) ator(er) devem estar corretos                                                                                      |

<br/>

#### Fluxo principal

| Passos  | Descrição                                           |
| ------- | --------------------------------------------------- |
| Passo 1 | O(s) Ator(es) informam seus dados           |
| Passo 2 | A verificação das credenciais é efetuada |
| Passo 3 | A sessão é iniciada em caso de login correto. |

<br/>

#### Fluxo alternativo

| Passos  | Descrição                                           |
| ------- | --------------------------------------------------- |
| Passo 1 | O(s) Ator(es) informam seus dados            |
| Passo 2 | A verificação das credenciais é efetuada |
| Passo 3 | A sessão não é iniciada e o usuário é redirecionado para a tela de login. |

<br/>

#### Campos do formulário

| Campo            | Obrigatório? | Editável? | Formato      |
| ---------------- | ------------ | --------- | ------------ |
| Email             | Sim          | Sim       | Email         |
| Senha            | Sim          | Sim       | Password        |

<br/>

#### Opções dos usúarios

| Opção            | Descrição | Atalho |
| ---------------- | ------------ | --------- |
| Login | Valida as credenciais do ator          | Não possui       |
| Cadastre-se             | Redireciona o usuario para a tela de cadastro          | Não possui       |

<br />

#### Relatório de usuário

| Campo                      | Descrição                                                             | Formato |
| -------------------------- | --------------------------------------------------------------------- | ------- |
| Email e/ou senha incorretos | Informa que as credenciais são inválidas  | Texto   |

<br />

### US03 - Realizar Login

**Prestador de serviço/Usuário**

|  User Story                                        | Critério de aceitação                                 |
| ------------------------------------------------- | ----------------------------------------------------- |
| Enquanto **um ator do aplicativo** eu preciso ser capaz de **realizar login**, para que **eu possa ter acesso as funcionalidades do sistema** | Certifique-se de que o usuário é capaz de **acessar o aplicativo**. |

<br/>

### Prototipação de telas
**Tela de login**

## Protótipo:

![tela1](https://github.com/joaovictorwg/prototipos_ServicoCerto/blob/develop/PaginaLogin.png)

<br />

---

## **RF04 - Ver informações do perfil**

<br />



<br />


|Item             | Descrição                                                           |
| --------------- | -----------------------------------------------------------------   |
| Caso de uso     | Ver informações do perfil                                                |
| Resumo          | É esperado que o usuário e prestador de serviço consiga visualizar as informações do seu perfil|
| Ator principal  |usuários                                 |
| Ator secundário | -                                                          |
| Pré-condição    | É necessário que o prestador de serviço e usuário tenha efetuado o login.            |
| Pós-condição    | Todos os campos do formulário de cadastro de serviço devem ser preenchidos corretamente.  |

<br />

#### Fluxo principal

| Passos  | Descrição                                                                   |
| ------- | -----------------------------------------                                   |
| Passo 1 | Digita as suas credenciais na tela de login                                        |
| Passo 2 | Clicar no botão "Efetuar login"                                            |
| Passo 3 | Apertar o botão "Ver perfil"                                                 |

<br />


<br />

#### Opções do usuário


| Opção         | Descrição                 | Atalho |
| ------------- | ------------------------- | ------ |
| Ver perfil | Ver informações do seu perfil       |
| Fechar | Retorna Para a tela home | Não possui       |
<br />


<br />


### US04 - Ver informações do perfil.

**Usuário/Prestador de serviços**

| User Story | Critério de aceitação |
| --------- | --------------------- |
| Enquanto prestador de serviço e usuário desejo ver as informações do meu perfil. | O prestador de serviços e usuário deve ser capaz de visualizar suas informações. |

<br/>

### Prototipação de telas
## Protótipo:

![tela1](https://github.com/joaovictorwg/prototipos_ServicoCerto/blob/develop/PaginaPerfilPrestador.png)
![tela2](https://github.com/joaovictorwg/prototipos_ServicoCerto/blob/develop/PerfilCliente.png)


## *RF05 -  Atualizar informações do perfil*

<br />

<br />

|Item             | Descrição                                                         |
| --------------- | ----------------------------------------------------------------- |
| Caso de uso     | Atualizar informações do perfil.                                                   |
| Resumo          | É esperado que o usuário tenha a possibilidade de atualizar as informações adicionadas quando foi feito o cadastro do perfil|
| Ator principal  | Atores |
| Ator secundário | Não possui                                                        | 
| Pré-condição    |  É necessário que para realizar a atualização o usuário ja tenha cadastro         |
| Pós-condição    | Os dados informados devem ser válidos |
<br />

#### Fluxo principal
| Passos  | Descrição                                 |
| ------- | ----------------------------------------- |
| Passo 1 | Realizar cadastro               |
| Passo 2 | Realizar login                |
| Passo 3 | Atualizar dados da conta              |
| Passo 4 | Submeter o formulário atualizado                                    |
<br />

#### Campos do formulário
| Campo            | Obrigatório? | Editável? | Formato      |
| ---------------- | ------------ | --------- | ------------ |
| Dados da conta           | Sim          | Sim       | Texto        |

<br />

#### Opções do usuário
| Opção         | Descrição                 | Atalho |
| ------------- | ------------------------- | ------ |
| Atualizar Perfil | Os atores do aplicativo vão poder ser capazes de atualizar os seus dados cadastrais |  Não possui      |
<br />

#### Relatório de usuário

| Campo                      | Descrição                                                             | Formato |
| -------------------------- | --------------------------------------------------------------------- | ------- |
| Informações atualizadas com sucesso! | As informações da conta foram atualizadas com sucesso.   | Texto   |
<br />


### US05 - Usuário deseja atualizar as informações do seu perfil.

*Atores*

| User Story | Critério de aceitação |
| --------- | --------------------- |
| Enquanto "um ator" do sistema preciso conseguir mudar os dados da minha conta. | Digitar dados válidos nos campos determinados  |

<br/>

![tela1](https://github.com/joaovictorwg/prototipos_ServicoCerto/blob/develop/InformacaoCliente.png)
![tela2](https://github.com/joaovictorwg/prototipos_ServicoCerto/blob/develop/InformacaoPrestador.png)



---

## *RF06 - Deletar perfil*

<br/>


<br/>

|Item             | Descrição                                                         |
| --------------- | ----------------------------------------------------------------- |
| Caso de uso     | Deletar perfil.                                             |
| Resumo          | É esperado que o ator tenha a possibilidade de deletar seu próprio perfil                                                                     |
| Ator principal  | Usuário/Prestador de serviço|
| Ator secundário | Não possui                                                        | 
| Pré-condição    | É necessário que o ator tenha feito o cadastro e efetuado o login.        |
| Pós-condição    | - |

<br/>

#### Fluxo principal
| Passos  | Descrição                                 |
| ------- | ----------------------------------------- |
| Passo 1 | Realizar o cadastro      |
| Passo 2 | Realizar o login |
| Passo 3 | Na aba "Meu perfil" deve apertar a opção "exluir"|
|Passo 4|  Confirmar exclusão do perfil|

<br/>

#### Campos do formulário
| Campo            | Obrigatório? | Editável? | Formato      |
| ---------------- | ------------ | --------- | ------------ |
| Excluir        |Sim          |Não      | Texto        |

<br/>

#### Opções do usuário
| Opção             | Descrição                 | Atalho |
| -------------     | ------------------------- | ------ |
| Excluir perfil | Excluir o perfil criado pelo usuário |        |

<br/>

#### Relatório de usuário

| Campo      | Descrição   | Formato |
| ---------- | ----------- |---------|
| Erro ao excluir perfil | Ocorreu um erro ao confirmar a exclusão do perfil |  Texto  |

<br/>

### US06 - Deletar perfil

*Atores*

| User Story | Critério de aceitação |
| --------- | --------------------- |
| Enquanto *um ator* preciso ser capaz de excluir meu perfil | O ator deve digitar a mensagem sugerida corretamente para realizar a exclusão
<br/>

### Prototipação de telas
*Tela com o botão de deletar perfil*

![tela1](https://github.com/joaovictorwg/prototipos_ServicoCerto/blob/develop/InformacaoCliente.png)
![tela2](https://github.com/joaovictorwg/prototipos_ServicoCerto/blob/develop/InformacaoPrestador.png)





---


======

## Iteração 2  (8/Abril - 22/Abril)

**Objetivo:** O objetivo dessa iteração 2 é esculpir a aplicação para que ela se torne o mais útil, prática e facil para os nossos usuários finais, dessa maneira, buscamos desenvolver requisitos funcionais de extrema importância tanto para os clientes quanto para os prestadores de serviço.
       Ao alcançar esses objetivos, espera-se que a segunda iteração do projeto contribua significativamente para a melhoria da experiência do usuário e para a expansão das funcionalidades essenciais do aplicativo, aproximando-se cada vez mais da versão final desejada.

- [X] RF07 - Desenvolver tela inicial do cliente. [Daniel Nolêto](https://github.com/Daniel-Noleto) Revisado por [Dante Ungarelli](https://github.com/danteungarelli )

- [X] RF08 - Desenvolver barra inferior do app. [Saulo Ferraz](https://github.com/SauloFerrazTC/) Revisado por [Daniel Nolêto](https://github.com/Daniel-Noleto)

- [X] RF09 - Desenvolver barra de pesquisa funcional. [Dante Ungarelli](https://github.com/danteungarelli/) Revisado por [João Victor Walcacer](https://github.com/joaovictorwg/)

- [X] RF10 - Ver informações do pefil de outros usuários. [João Victor Walcacer](https://github.com/joaovictorwg) Revisado por [Dante Ungarelli](https://github.com/danteungarelli)

- [X] RF11 - Cadastrar serviço por parte do prestador de serviço. [Vinicius Maciel](https://github.com/ViniciusDevelopment) Revisado por [Vinícius Maciel Pires](https://github.com/ViniciusDevelopment)
<br/>
---

## *RF07 - Desenvolver tela inicial do cliente*
**US07:**

| User Story                                                         | Critério de Aceitação                                                                                    |
| ------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------- |
| Eu, enquanto *um cliente* preciso ser capaz de visualizar a home do meu aplicativo | O cliente deve ter realizado o cadastro e login                                                          |


**Protótipo da tela:**


![tela home do usuario](https://github.com/joaovictorwg/prototipos_ServicoCerto/blob/develop/Tela%20home%20do%20usuario.png)

## *RF08 - Barra inferior do app*
**US08:**
| User Story | Critério de aceitação |
| --------- | --------------------- |
| Eu, enquanto *um usuário* desejo navegar entre as abas do app| O cliente deve ter realizado o cadastro e login

**Protótipo da tela:**
![barra inferior do app](https://github.com/joaovictorwg/prototipos_ServicoCerto/blob/develop/barra%20inferior%20do%20app.png)



## *RF09 - Barra de pesquisa funcional*
**US09:**

| User Story | Critério de aceitação |
| --------- | --------------------- |
| Eu, enquanto *um cliente* desejo pesquisar por diaristas| O cliente deve ter realizado o cadastro e login

**Protótipo da tela:**

![barra de pesquisa do app](https://github.com/joaovictorwg/prototipos_ServicoCerto/blob/develop/barra%20de%20pesquisa.png)
![tela de resultados da pesquisa](https://github.com/joaovictorwg/prototipos_ServicoCerto/blob/develop/P%C3%A1gina%20de%20Resultados.png)

## *RF10 - Visualizar insformações de outros usuarios:*
**US10:**
| User Story | Critério de aceitação |
| --------- | --------------------- |
| Eu, enquanto *um usuario* desejo ver as informações de outros perfis| O cliente deve ter realizado o cadastro e login e pesquisado pelo perfil que ele deseja visualizar

**Protótipo da tela:**
![tela de visualização dos outros perfis](https://github.com/joaovictorwg/prototipos_ServicoCerto/blob/develop/Tela%20meu%20perfil%20de%20prestadora%20de%20servi%C3%A7o.png)

## *RF11 - Cadastrar serviço:*
**US11:**

| User Story | Critério de aceitação |
| --------- | --------------------- |

| Enquanto *um prestador de serviço* desejo ofertar o meu trabalho para clientes| O prestador deve ter realizado seu cadastro e login

**Protótipo da tela:**

![tela de outros perfis](https://github.com/joaovictorwg/prototipos_ServicoCerto/blob/develop/Tela%20meu%20perfil%20de%20prestadora%20de%20servi%C3%A7o.png)


======

  

## Iteração 3 (22/Abril - 06/Maio)

**Objetivo:** O objetivo dessa iteração 3 foi estabelecido pelo grupo no final da iteração 2 através de conversas, utilização do aplicativo em produção e brainstorming.    
O objetivo da iteração, foi aprimorar o código legado de iterações anteriores, visando melhorar sua qualidade e eficiência. Além disso, foram adicionadas novas funcionalidades para enriquecer a aplicação e atender às necessidades emergentes do projeto.
  

- [X] RF12 - [Autenticação por tipo de usuário](https://github.com/ViniciusDevelopment/Projeto_de_sistemas-2024.1/pull/22). [Dante Ungarelli](https://github.com/danteungarelli) Revisado por [Dante Ungarelli](https://github.com/danteungarelli)

  

- [X] RF13 - [Tela inicial do prestador de serviço](https://github.com/ViniciusDevelopment/Projeto_de_sistemas-2024.1/pull/23). [Daniel Nolêto](https://github.com/Daniel-Noleto/) Revisado por [Dante Ungarelli](https://github.com/danteungarelli)

  

- [X] RF14 - [Tela de calendário](https://github.com/ViniciusDevelopment/Projeto_de_sistemas-2024.1/pull/19). [Saulo Ferraz](https://github.com/Saulo-Ferraz-TC/) Revisado por [Daniel Nolêto](https://github.com/Daniel-Noleto)

  

- [X] RF15 - [Ver informações do pefil de outros usuários](https://github.com/ViniciusDevelopment/Projeto_de_sistemas-2024.1/pull/21). [João Victor Walcacer](https://github.com/joaovictorwg) Revisado por [Daniel Nolêto](https://github.com/Danie-Noleto)

  

- [X] RF16 - Ajustar listagem de usuários na home. [Vinicius Maciel](https://github.com/ViniciusDevelopment) Revisado por [Vinícius Maciel Pires](https://github.com/ViniciusDevelopment)



- [X] RF17 - [Adicionar mais informações nas recomendações de usuários na home](https://github.com/ViniciusDevelopment/Projeto_de_sistemas-2024.1/pull/26). [Benedito Jaime](https://github.com/beneX90) Revisado por [Saulo Ferraz](https://github.com/Saulo-Ferraz-TC)


- [X] RF18 - [Tela meu perfil do cliente](https://github.com/ViniciusDevelopment/Projeto_de_sistemas-2024.1/pull/27). [Dante Ungarelli](https://github.com/danteungarelli) Revisado por [Daniel Nolêto](https://github.com/Daniel-Noleto)


- [X] RF19 - [Tela meu perfil do prestador de serviço](https://github.com/ViniciusDevelopment/Projeto_de_sistemas-2024.1/pull/28). [Daniel Nolêto](https://github.com/Daniel-Noleto) Revisado por [Dante Ungarelli](https://github.com/danteungarelli)

<br/>

---
  
Na iteração 3, dedicamos especial atenção à documentação de UI/UX, utilizando o Figma para criar protótipos detalhados das telas. Seguindo os princípios de design de interface do usuário e experiência do usuário (UI/UX), cada tela foi meticulosamente projetada para oferecer uma experiência fluida e intuitiva aos usuários. Os protótipos no Figma serviram como uma base sólida para o desenvolvimento das telas no projeto, garantindo consistência visual e funcional em todo o sistema. Ao integrar os elementos de UI/UX desde o estágio de prototipagem, buscamos não apenas melhorar a estética, mas também otimizar a usabilidade e a interatividade do produto final. Essa abordagem centrada no usuário reflete nosso compromisso em oferecer uma experiência de alta qualidade e satisfatória para os usuários finais.

Link do repositório no figma: https://www.figma.com/file/saQzOFctzuMek2as0GkOba/Untitled?type=design&node-id=49-349&mode=design&t=LAAH2sBRwBLETJzu-0