# wdsPLSQLtdd - Testes Unitários Automatizados em PL/SQL (TDD)

**FEITO EM PL/SQL PARA PL/SQL**

O wdsPLSQLtdd é um sistema de testes automatizados desenvolvido em PL/SQL, projetado para simplificar e acelerar o processo de criação de testes de unidade em linguagem PL/SQL.

O Banco de Dados Oracle é o líder absoluto em Tecnologia e de Mercado no Brasil e no Mundo.

No entanto, a maioria dos sistemas de teste robustos disponíveis para a linguagem PL/SQL não foram originalmente desenvolvidos em PL/SQL. Esses sistemas pertencem a outras linguagens e foram adaptados para a linguagem PL/SQL, em vez de serem dedicados exclusivamente a ela.

Existe uma diferença significativa entre um sistema adaptado e um sistema dedicado e o wdsPLSQLtdd é dedicado a linguagem PL/SQL.

Ao contrário de outras soluções que envolvem o uso de linguagens de programação adicionais, como o jUnit que utiliza o Java, o wdsPLSQLtdd permite que os desenvolvedores PL/SQL criem testes de forma direta, eliminando a necessidade de aprender uma nova linguagem e reduzindo significativamente a curva de aprendizado.

## Problema a Ser Resolvido

Muitas vezes, desenvolvedores e equipes de PL/SQL se deparam com a necessidade de criar testes de unidade para suas Procedures, Functions e Packages. No entanto, a maioria das soluções disponíveis envolve o uso de linguagens de programação adicionais, o que pode ser complexo e demorado. O wdsPLSQLtdd busca resolver esse problema, permitindo que os testes sejam escritos diretamente em PL/SQL, tornando o processo mais simples e eficiente.

## Principais Recursos para Ambiente de Desenvolvimento

- Crie testes de unidade diretamente em PL/SQL.
- Execute testes de forma automática.
- Integração fácil com projetos PL/SQL existentes.
- Reduza a curva de aprendizado ao eliminar a necessidade de aprender uma nova linguagem de programação.
- Gere Traces de forma automática.
- Mantém um histórico de todos os testes já realizados.
- Mantém um histórico contendo métricas de tempo de execução de cada teste.
- Permite realizar testes independentes sobre um conjunto de dados.

## Principais Recursos para Ambiente de Produção

- Monitore ações de DDL realizadas em ambiente de produção.
- Monitore e teste novas aplicações de scripts de atualização em ambientes de produção.
- Utilize o sistema para realizar debug e identificar registros que estão apresentando erro em ambiente de produção.

Aqui estão os passos para começar a usar o wdsPLSQLtdd em seu projeto:

## Instalação - Criação dos Usuários

1. Realize o Download contendo os Scripts do sistema wdsPLSQLtdd.

2. Para instalação e uso do sistema wdsPLSQLtdd são necessários a criação de dois usuários.

   **CRIANDO O USUÁRIO PRINCIPAL QUE REALIZA O GERENCIAMENTO**

   ```sql
        -- Usuário Principal que realiza o gerenciamento. Fica a seu critério a definição de senha e tablespace.
        CREATE USER WDS_PLSQL_TDD IDENTIFIED BY WDS_PLSQL_TDD;
   ```

   Atribua as permissões necessárias.

   Use o usuário SYS.

   ```sql
        -- Use o usuário SYS.
        GRANT CREATE SESSION TO WDS_PLSQL_TDD;
        GRANT UNLIMITED TABLESPACE TO WDS_PLSQL_TDD;
        GRANT DBA TO WDS_PLSQL_TDD;
        GRANT CREATE ANY PROCEDURE TO WDS_PLSQL_TDD;
        GRANT EXECUTE ANY PROCEDURE TO WDS_PLSQL_TDD;
        GRANT SELECT ANY TABLE TO WDS_PLSQL_TDD;
        GRANT SELECT ON SYS.DBA_USERS TO WDS_PLSQL_TDD;
        GRANT SELECT ON SYS.DBA_OBJECTS TO WDS_PLSQL_TDD;
        GRANT SELECT ON SYS.DBA_ARGUMENTS TO WDS_PLSQL_TDD;
        GRANT SELECT ON SYS.GV_$SESSION TO WDS_PLSQL_TDD;
        GRANT SELECT ON SYS.GV_$PROCESS TO WDS_PLSQL_TDD;
        GRANT EXECUTE ON DBMS_SYSTEM TO WDS_PLSQL_TDD;
        GRANT EXECUTE ON DBMS_SESSION TO WDS_PLSQL_TDD;
        GRANT EXECUTE ON DBMS_PIPE TO WDS_PLSQL_TDD;
        GRANT ALTER SESSION TO WDS_PLSQL_TDD;
        GRANT ALTER SYSTEM TO WDS_PLSQL_TDD;
        GRANT CREATE JOB TO WDS_PLSQL_TDD;
        GRANT EXECUTE ON DBMS_SCHEDULER TO WDS_PLSQL_TDD;
        GRANT MANAGE SCHEDULER TO WDS_PLSQL_TDD;
        GRANT SELECT ON SYS.DBA_DEPENDENCIES TO WDS_PLSQL_TDD;
        GRANT ALTER ANY PROCEDURE TO WDS_PLSQL_TDD;
   ```

   **CRIANDO O USUÁRIO QUE ARMAZENA OS TESTES CRIADOS**

   ```sql
        -- Usuário responsável por armazenar os Testes que serão criados. Fica a seu critério a definição de senha e tablespace.
        CREATE USER WDS_PLSQL_TDD_TESTE IDENTIFIED BY WDS_PLSQL_TDD_TESTE;
   ```

   Atribua as permissões necessárias.

   Use o usuário SYS.

   ```sql
        -- Use o usuário SYS.
        GRANT CREATE SESSION TO WDS_PLSQL_TDD_TESTE;
        GRANT DBA TO WDS_PLSQL_TDD_TESTE;
        GRANT EXECUTE ANY PROCEDURE TO WDS_PLSQL_TDD_TESTE;
        GRANT SELECT ANY TABLE TO WDS_PLSQL_TDD_TESTE;
        GRANT DELETE ANY TABLE TO WDS_PLSQL_TDD_TESTE;
        GRANT CREATE PROCEDURE TO WDS_PLSQL_TDD_TESTE;
        GRANT INSERT ANY TABLE TO WDS_PLSQL_TDD_TESTE;
   ```

## Instalação - Configurando o Script que realiza a coleta do TRACE

Observação: Até o momento, a coleta de TRACE é realizada somente em ambientes LINUX.

1. Para configurar o processo de coleta do Trace serão necessários a criação de dois diretórios dentro do servidor do banco de dados.

2. Fica a seu critério a definição do diretório local onde os outros dois diretórios serão criados, mas segue uma sugestão de diretório.

   ```bash
     -- Crie o diretório com o usuário ORACLE

     -- Primeiro diretório
     mkdir /u01/aplic/wds_plsql_tdd/


     -- Segundo diretório. Esse diretório deve ser criado dentro do primeiro diretório
     mkdir /u01/aplic/wds_plsql_tdd/trace
   ```

3. Realize o Upload do arquivo codificado em Shell Script para o primeiro diretório recém criado por você.

   Nome do arquivo: wds_identificar_novo_trace.sh

4. Transforme o arquivo em executável com o comando:

```bash
    chmod +x wds_identificar_novo_trace.sh
```

5. Crie um arquivo em branco com o nome: trace_gerado.wds

   Exemplo: Use o comando: touch trace_gerado.wds

```bash
   touch trace_gerado.wds
```

6. Abra o arquivo wds_identificar_novo_trace.sh e realize a edição das variáveis locais.

   Dentro do arquivo está descrito quais variáveis devem ser editadas.

7. Execute o arquivo apontando o caminho completo. A execução deste arquivo deve retornar a mensagem ERRO, pois, ainda não foram realizadas coletas de TRACE.

8. Se conecte no banco de dados com o usuário WDS_PLSQL_TDD para que seja realizada a criação dos diretórios, execute o comando abaixo.

   Não se esqueça de informar corretamente o caminho completo dos diretórios que você criou anteriormente.

   ```sql
       -- Informe o caminho completo do primeiro diretório definido na parte: Instalação - Configurando o Script que realiza a coleta do TRACE
       -- Não coloque a barra "/" no final do diretório
       CREATE DIRECTORY WDS_PLSQL_TDD_SCRIPT AS '/u01/aplic/wds_plsql_tdd';

       -- Informe o caminho completo do segundo diretório definido na parte: Instalação - Configurando o Script que realiza a coleta do TRACE
       -- Não coloque a barra "/" no final do diretório
       CREATE DIRECTORY WDS_PLSQL_TDD_TRACE AS '/u01/aplic/wds_plsql_tdd/trace';
   ```

## Instalação - Criação dos objetos referentes ao sistema TDD

Observação: O sistema wdsPLSQLtdd foi desenvolvido usando a versão "Oracle Database 19c Release 19.0.0.0.0", se você identificar algum problema referente a versões anteriores, favor entrar em contato.

Você pode realizar a instalação Manual ou Automática.

Na instalação Manual você vai precisar executar 50 arquivos SQL em uma ordem específica para evitar problemas de compilação.

Na versão Automática, você vai utilizar um arquivo que realiza a instalação de 47 arquivos e você vai precisar executar manualmente apenas 3 arquivos.

## Instalação Automática - Criação dos objetos referentes ao sistema TDD

1. Realize o upload da pasta Instalador para a pasta TEMP do seu servidor Oracle.

   Nome da pasta contendo o instalador: instalador_wds_plsql_tdd

2. Atenção, Quando o processo de instalação iniciar, após a criação das tabelas será solicitado que você execute a criação das 3 Views via SQLDeveloper. Só continue a instalação automática após criar as Views.

   Os scripts referentes a criação das Views são:

   ```sql
       object/Views/1_VW_CAPSULA_FILHA.sql
       object/Views/2_VW_HIERARQUIA_TESTE.sql
       object/Views/3_VW_LISTA_TESTES_INVALIDOS.sql
   ```

3. Se conecte no SQLPlus.

4. Realize a chamada do arquivo de instalação.

   Existem dois arquivos de instalação um em Português e outro em Inglês

   Instalador em inglês: wds_plsql_tdd_instalar_en.sql

   Instalador em português: wds_plsql_tdd_instalar_ptbr.sql

   ```sql

        cd instalador_wds_plsql_tdd/

        . oraenv <<< SID_BANCO_DE_DADOS

        sqlplus / as sysdba

        @wds_plsql_tdd_instalar_ptbr.sql

        exit

   ```

## Instalação Manual - Criação dos objetos referentes ao sistema TDD

1. Realize o download da pasta Instalador.

2. Necessário conectar com o usuário WDS_PLSQL_TDD

3. Os scripts podem ser executados via SQLPlus ou SQLDeveloper

4. Execute os scripts na ordem definida abaixo.

   ```sql
       --
       -- Criação tabelas

       1_ALVO.sql
       2_TESTE.sql
       3_ANTES_DEPOIS.sql
       4_TDD_CAPSULA_FILHA.sql
       5_TDD_CAPSULA_PAI.sql
       6_TRACE_METADADOS.sql
       7_TRACE.sql
       8_DISPARAR_TESTES_TDD.sql
       9_HISTORICO_EXECUCAO_TESTES.sql
       10_TEMPO_EXECUCAO_TESTE.sql
       11_TESTE_EM_EXECUCAO.sql
       12_TESTE_EM_MANUTENCAO.sql
       13_LISTA_NOVOS_TESTES.sql
       14_LOG_DISPARO_TESTES_TDD.sql
       15_LOG_INFO.sql
       16_LOG_RAISE_ERRO_EXECUCAO_TESTE.sql
       17_OWNER_MONITORADO.sql
       18_SHELL_EXECUTAR_TKPROF_TRACE.sql


       --
       -- Criação Views - Crie todas as  Views usando o SqlDeveloper porque o SqlPlus pode não reconhecer o comando WITH

       1_VW_CAPSULA_FILHA.sql
       2_VW_HIERARQUIA_TESTE.sql
       3_VW_LISTA_TESTES_INVALIDOS.sql


       --
       -- Criação functions

       1_GERAR_HASH.sql


       --
       -- Criação Packages
       1_CONSTANTES.sql
       2_LOG_GERENCIADOR.sql


       --
       -- Criação functions

       2_GERAR_NOME_TRACE.sql
       3_VALIDA_OBJETO_TESTE.sql
       4_GERAR_CODIGO.sql


       --
       -- Criação Packages
       3_MONITORAR_NOVO_OWNER.sql
       4_EXTRAI_METADADOS_TESTE.sql
       5_MANUTENCAO_ALVO.sql


       --
       -- Criação Packages - As packages vão compilar com erro por causa da dependência entre elas, depois execute o comando para Compilar cada uma
       --
       -- ATENÇÃO....
       --
       -- As Package MANUTENCAO_ANTES_DEPOIS e CAPSULA_FILHA vão compilar com erro
       -- por causa da dependência entre elas com a Package MANUTENCAO_TESTE
       -- decorrente do processo de recursividade existente na arquitetura de desenvolvimento do TDD.
       -- Após o criação execute o comando listado em seguida para Compilar cada package.
       --


       6_MANUTENCAO_ANTES_DEPOIS.sql
       7_CAPSULA_FILHA.sql
       8_MANUTENCAO_TESTE.sql

       ALTER PACKAGE MANUTENCAO_ANTES_DEPOIS COMPILE;
       ALTER PACKAGE MANUTENCAO_ANTES_DEPOIS COMPILE BODY;

       ALTER PACKAGE CAPSULA_FILHA COMPILE;
       ALTER PACKAGE CAPSULA_FILHA COMPILE BODY;

       ALTER PACKAGE MANUTENCAO_TESTE COMPILE;
       ALTER PACKAGE MANUTENCAO_TESTE COMPILE BODY;


       --
       -- Criação Packages

       9_IDENTIFICAR_TESTES_TDD.sql
       10_HIERARQUIA_TESTE.sql
       11_CAPSULA_PAI.sql
       12_ENCAPSULAR.sql
       13_MONITORAR_NOVOS_TESTES.sql
       14_CRONOMETRO.sql
       15_EXECUTAR_TESTES_TDD.sql
       16_EXPORTADOR_TRACE.sql
       17_GERENCIAR_TRACE.sql
       18_REGISTRA_EXECUCAO_TESTE.sql


       --
       -- Criação Jobs

       1_EXECUTAR_TESTES_AUTOMATIZADOS.sql
       2_JOB_EXPORTADOR_TRACE.sql
       3_JOB_MONITORAR_NOVOS_TESTES.sql
       4_JOB_VALIDAR_CAPSULAS.sql


       --
       -- Criação Triggers

       1_TRG_GERENCIA_TDD_CAPSULA_FILHA.sql
       2_TRG_GERENCIA_TDD_CAPSULA_PAI.sql
       3_TRG_IDENTIFICA_DDL_TESTE_TDD.sql
       4_TRG_MONITORA_DDL_DISPARO_TDD.sql
   ```

## Instalação Finalizada

Após realizar a execução Manual ou Automática do scripts, o processo de instalação está finalizado.

Agora vamos iniciar a criação dos testes.

## Como criar um TESTE

Todos os TESTES devem ser criados dentro do owner **WDS_PLSQL_TDD_TESTE**

A criação de um teste é muito simples.

O Teste só pode ser criado utilizando o objeto do tipo FUNCTION.

A Function referente ao Teste deve retornar um valor do Tipo BOOLEAN.

No processo de criação do Teste informe os dados do Teste no bloco de comentário do tipo /\* \*/ no corpo da function.

Você pode criar um TESTE antes de criar o objeto a ser testado. A Function do Teste vai ficar inválida por causa da dependência com o objeto a ser testado, mas assim que o Objeto for criado o teste se torna válido.

Todos os Testes são executados sempre que algum Objeto dos Owners monitorados sofrerem DDL.

**PARÂMETROS QUE PODEM SER UTILIZADOS**

Existe uma lista de parâmetros em formato JSON que devem ser definidos para a criação de um Teste.

Segue a lista de Parâmetros:

```sql
   /*
   {NOME:Nome Único do Teste}
   {INFO:Informações sobre o processo que está sendo testado}
   {ALVO_OWNER: Owner do ALVO que está sendo Testado}
   {ALVO_OBJECT: Owner objeto do ALVO que está sendo Testado}
   {QUERY_ARGUMENTO:SELECT VALOR_A, VALOR_B FROM WDS_TDD_TESTE.TESTES_CALCULADORA}
   {ANTES:TESTE_01, TESTE_02, TESTE_03}
   {DEPOIS:TESTE_21, TESTE_22, TESTE_23}
   {TESTE_AUXILIAR}
   {TESTE_DESATIVADO}
   */
```

1. As informações mínimas de criação de um teste são: NOME | INFO | ALVO_OWNER | ALVO_OBJECT

2. Com apenas 4 parâmetros você já defini que aquela Function é um objeto de Teste válido.

3. Após isso não é necessário mais nenhuma intervenção ou configuração.

4. Acompanhe as execuções do Teste sempre que algum ALVO_OWNER sofrer um DDL.

5. Todos os TESTES ativos são executados em conjunto.

Os parâmetros de uso obrigatório são:

```sql
   /*
   {NOME:Nome Único do Teste}
   {INFO:Informações sobre o processo que está sendo testado}
   {ALVO_OWNER: Owner do ALVO que está sendo Testado}
   {ALVO_OBJECT: Owner objeto do ALVO que está sendo Testado}
   */
```

Segue a descrição de cada parâmetro:

**NOME** – Pode ser um nome descritivo, mas deve ser um nome único.

**INFO** – Adicione anotações referentes ao teste e a expectativa do teste, essas informações facilitam para outros Dev.

**ALVO_OWNER** – Nome do DONO do objeto ou da ação que será executada.

**ALVO_OBJECT** – Nome do Objeto que será analisado. Esse não precisa estar vinculado a um objeto existente.

**QUERY_ARGUMENTO** – Permite realizar um conjunto de testes cada um com sua própria métrica. A Function de teste deve possuir a mesma quantidade de Parâmetros de acordo com a quantidade de colunas presentes na Query. Não utilizar queries do tipo JOIN ou que acessem mais de uma tabela.

**ANTES** – Lista de TESTES que devem ser executados ANTES do TESTE principal.

**DEPOIS** – Lista de TESTES que devem ser executados DEPOIS do TESTE principal.

**TESTE_AUXILIAR** – Todo TESTE criado é considerado como teste principal, mas, um TESTE pode ser configurado para ser apenas como um AUXILIAR, desta forma ele só será executado quando declarado como ANTES ou DEPOIS.

**TESTE_DESATIVADO** – Se você deseja desativar um TESTE é só adicionar este parâmetro que o TESTE será desativado.

## ALVO - Exemplo de alvo que vamos usar no nosso teste

O foco do TESTE é apontar para um ALVO específico sobre um objeto existente dentro do banco de dados.

Esse Objeto pode ser de qualquer tipo, pois, a validação da correta execução deste objeto ALVO é definido no TESTE que você criar.

Vamos criar um exemplo de ALVO que vamos utilizar para realizar o teste.

Nosso ALVO é um objeto que realiza a SOMA de dois valores.

```sql
   -- User: CALCULADORA
   --
   -- Object: ALVO
   --

   CREATE OR REPLACE FUNCTION SOMA(A NUMBER, B NUMBER) RETURN NUMBER AS

      RESULT NUMBER;

   BEGIN

      RESULT := A + B;

      RETURN RESULT;

   END SOMA;
   /
```

**Exemplo - TESTE SIMPLES**

```sql
   -- User: WDS_PLSQL_TDD_TESTE
   --
   -- Criação da Function de TESTE antes de criar o Objeto que será testado.
   --

   CREATE OR REPLACE FUNCTION CALCULADORA_SOMA RETURN BOOLEAN IS
   /*
   {NOME:Calculadora Teste Soma}
   {INFO:Realiza testes matemáticos da operação SOMA }
   {ALVO_OWNER:CALCULADORA}
   {ALVO_OBJECT:SOMA}
   */

      v_LOG_REGISTRADO NUMBER;

   BEGIN

      RETURN CALCULADORA.SOMA( 2, 3 ) = 5;

   END;
   /
```

**Exemplo - TESTE COM USO DE PARÂMETROS**

```sql
   -- User: WDS_PLSQL_TDD_TESTE
   --
   -- Tabela para armazenar os valores de teste
   --
   CREATE TABLE TESTES_CALCULADORA (
      VALOR_A NUMBER NOT NULL,
      VALOR_B NUMBER NOT NULL
   );


   --
   -- Registrando os valores a serem testados
   --

   INSERT INTO TESTES_CALCULADORA ( VALOR_A, VALOR_B ) VALUES ( 2, 1 );
   INSERT INTO TESTES_CALCULADORA ( VALOR_A, VALOR_B ) VALUES ( 2, 2 );
   INSERT INTO TESTES_CALCULADORA ( VALOR_A, VALOR_B ) VALUES ( 2, 3 );
   INSERT INTO TESTES_CALCULADORA ( VALOR_A, VALOR_B ) VALUES ( 2, 4 );
   INSERT INTO TESTES_CALCULADORA ( VALOR_A, VALOR_B ) VALUES ( 2, 5 );
   INSERT INTO TESTES_CALCULADORA ( VALOR_A, VALOR_B ) VALUES ( 2, 6 );
   INSERT INTO TESTES_CALCULADORA ( VALOR_A, VALOR_B ) VALUES ( 2, 7 );
   INSERT INTO TESTES_CALCULADORA ( VALOR_A, VALOR_B ) VALUES ( 2, 8 );
   INSERT INTO TESTES_CALCULADORA ( VALOR_A, VALOR_B ) VALUES ( 2, 9 );
   INSERT INTO TESTES_CALCULADORA ( VALOR_A, VALOR_B ) VALUES ( 2, 10 );

   COMMIT;



   -- User: WDS_PLSQL_TDD_TESTE
   --
   -- Criação da Function de TESTE antes de criar o Objeto que será testado.
   --


   CREATE OR REPLACE FUNCTION CALCULADORA_SOMA( p_VALOR_A IN NUMBER, p_VALOR_B IN NUMBER ) RETURN BOOLEAN IS
   /*
   {NOME:Calculadora Teste Soma}
   {INFO:Realiza testes matemáticos da operação SOMA }
   {ALVO_OWNER:CALCULADORA}
   {ALVO_OBJECT:SOMA}
   {QUERY_ARGUMENTO:SELECT VALOR_A, VALOR_B FROM WDS_PLSQL_TDD_TESTE.TESTES_CALCULADORA}
   */

      v_LOG_REGISTRADO NUMBER;

   BEGIN

      RETURN CALCULADORA.SOMA( p_VALOR_A, p_VALOR_B ) = ( p_VALOR_A + p_VALOR_B );

   END;
   /
```

**Exemplo - TESTE QUE REALIZA AÇÕES ANTES DO TESTE PRINCIPAL**

```sql
   -- User: WDS_PLSQL_TDD_TESTE
   --
   -- Tabela para armazenar os valores de teste
   --
   CREATE TABLE TESTES_CALCULADORA (
      VALOR_A NUMBER NOT NULL,
      VALOR_B NUMBER NOT NULL
   );



   -- User: WDS_PLSQL_TDD_TESTE
   --
   -- Realizando uma ação antes de executar o TESTE Real.
   -- Essa Function TESTE cria valore dinâmicos para o TESTE.
   --
   CREATE OR REPLACE FUNCTION GERAR_VALORES_TESTE_CALCULADORA RETURN BOOLEAN IS
   /*
   {NOME:Gera valores para teste Calculadora}
   {INFO:Cria os valores que aleatórios que serão usados nos calculos matemáticos dos testes }
   {ALVO_OWNER:CALCULADORA}
   {ALVO_OBJECT:CALCULAR}
   {TESTE_AUXILIAR}
   */

      v_NUM_A NUMBER;
      v_NUM_B NUMBER;
      v_RESULTADO NUMBER;
   BEGIN

      FOR i IN 1..10 LOOP
         v_NUM_A := TRUNC( DBMS_RANDOM.VALUE(1, 100) );
         v_NUM_B := TRUNC( DBMS_RANDOM.VALUE(1, 100) );

         INSERT INTO WDS_PLSQL_TDD_TESTE.TESTES_CALCULADORA ( VALOR_A, VALOR_B ) VALUES ( v_NUM_A, v_NUM_B );
      END LOOP;

      v_RESULTADO := SQL%ROWCOUNT;

      COMMIT;

      RETURN ( v_RESULTADO > 0 );
   END;
   /





   -- User: WDS_PLSQL_TDD_TESTE
   --
   -- Criação da Function de TESTE antes de criar o Objeto que será testado.
   --

   CREATE OR REPLACE FUNCTION CALCULADORA_SOMA( p_VALOR_A IN NUMBER, p_VALOR_B IN NUMBER ) RETURN BOOLEAN IS
   /*
   {NOME:Calculadora Teste Soma}
   {INFO:Realiza testes matemáticos da operação SOMA }
   {ALVO_OWNER:CALCULADORA}
   {ALVO_OBJECT:SOMA}
   {QUERY_ARGUMENTO:SELECT VALOR_A, VALOR_B FROM WDS_PLSQL_TDD_TESTE.TESTES_CALCULADORA}
   {ANTES:GERAR_VALORES_TESTE_CALCULADORA}
   */

      v_LOG_REGISTRADO NUMBER;

   BEGIN

      RETURN CALCULADORA.SOMA( p_VALOR_A, p_VALOR_B ) = ( p_VALOR_A + p_VALOR_B );

   END;
   /
```

**Exemplo - TESTE QUE REALIZA AÇÕES ANTES E DEPOIS DO TESTE PRINCIPAL**

```sql
   -- User: WDS_PLSQL_TDD_TESTE
   --
   -- Tabela para armazenar os valores de teste
   --
   CREATE TABLE TESTES_CALCULADORA (
      VALOR_A NUMBER NOT NULL,
      VALOR_B NUMBER NOT NULL
   );


   -- User: WDS_PLSQL_TDD_TESTE
   --
   -- Realizando uma ação antes de executar o TESTE Real.
   -- Essa Function TESTE cria valore dinâmicos para o TESTE.
   --
   CREATE OR REPLACE FUNCTION GERAR_VALORES_TESTE_CALCULADORA RETURN BOOLEAN IS
   /*
   {NOME:Gera valores para teste Calculadora}
   {INFO:Cria os valores que aleatórios que serão usados nos calculos matemáticos dos testes }
   {ALVO_OWNER:CALCULADORA}
   {ALVO_OBJECT:CALCULAR}
   {TESTE_AUXILIAR}
   */

      v_NUM_A NUMBER;
      v_NUM_B NUMBER;
      v_RESULTADO NUMBER;
   BEGIN

      FOR i IN 1..10 LOOP
         v_NUM_A := TRUNC( DBMS_RANDOM.VALUE(1, 100) );
         v_NUM_B := TRUNC( DBMS_RANDOM.VALUE(1, 100) );

         INSERT INTO WDS_PLSQL_TDD_TESTE.TESTES_CALCULADORA ( VALOR_A, VALOR_B ) VALUES ( v_NUM_A, v_NUM_B );
      END LOOP;

      v_RESULTADO := SQL%ROWCOUNT;

      COMMIT;

      RETURN ( v_RESULTADO > 0 );
   END;
   /




   -- User: WDS_PLSQL_TDD_TESTE
   --
   -- Realizando uma ação depois de executar o TESTE Real.
   -- Essa Function TESTE realiza o Rollback dos valores testados.
   --
   CREATE OR REPLACE FUNCTION ROLLBACK_VALORES_TESTE_CALCULADORA RETURN BOOLEAN IS
   /*
   {NOME:Deleta valores do teste da calculadora}
   {INFO:Apaga os valores que foram gerados para os testes matemáticos a serem realizados }
   {ALVO_OWNER:CALCULADORA}
   {ALVO_OBJECT:SOMA}
   {TESTE_AUXILIAR}
   */
      v_RESULTADO NUMBER;

   BEGIN

      DELETE FROM WDS_PLSQL_TDD_TESTE.TESTES_CALCULADORA;

      v_RESULTADO := SQL%ROWCOUNT;

      COMMIT;

      RETURN ( v_RESULTADO > 0 );

   END;
   /


   -- User: WDS_PLSQL_TDD_TESTE
   --
   -- Criação da Function de TESTE antes de criar o Objeto que será testado.
   --

   CREATE OR REPLACE FUNCTION CALCULADORA_SOMA( p_VALOR_A IN NUMBER, p_VALOR_B IN NUMBER ) RETURN BOOLEAN IS
   /*
   {NOME:Calculadora Teste Soma}
   {INFO:Realiza testes matemáticos da operação SOMA }
   {ALVO_OWNER:CALCULADORA}
   {ALVO_OBJECT:SOMA}
   {QUERY_ARGUMENTO:SELECT VALOR_A, VALOR_B FROM WDS_PLSQL_TDD_TESTE.TESTES_CALCULADORA}
   {ANTES:GERAR_VALORES_TESTE_CALCULADORA}
   {DEPOIS:ROLLBACK_VALORES_TESTE_CALCULADORA}
   */

      v_LOG_REGISTRADO NUMBER;

   BEGIN

      RETURN CALCULADORA.SOMA( p_VALOR_A, p_VALOR_B ) = ( p_VALOR_A + p_VALOR_B );

   END;
   /
```

**Como Ativar / Desativar o TRACE sobre um TESTE**

Para realizar a ativação da coleta do TRACE é simples, você precisar realizar a chamada de uma Function que pertence ao Owner WDS_PLSQL_TDD passando como parâmetro o ID do Teste.

```sql

   -- Ativando a coleta de TRACE
   SELECT WDS_PLSQL_TDD.MANUTENCAO_TESTE.ATIVAR_TRACE( TESTE_ID ) FROM DUAL;


   -- Desativando a coleta de TRACE
   SELECT WDS_PLSQL_TDD.MANUTENCAO_TESTE.DESATIVAR_TRACE( TESTE_ID ) FROM DUAL;

```

## Exemplos de Testes - Vídeo

[![wdsPLSQLtdd - Exemplos de Testes](https://img.youtube.com/vi/Ozswl1GJFdE/0.jpg)](https://www.youtube.com/watch?v=Ozswl1GJFdE "wdsPLSQLtdd - Exemplos de Testes")

## Contribuições Financeiras (Opcional)

Se você achou este Framework útil e deseja apoiar seu desenvolvimento contínuo, você pode fazer uma contribuição financeira. Suas contribuições são bem-vindas e ajudam a manter este projeto ativo.

**Crypto**

Bitcoin >> bc1qk8uextsv83gwz9ups9k7ejfj35zenfa96rjnxs

Ethereum - BNB - MATIC >> 0x74d6b623e488e76ea522915edf2c9bcaeebff190

**Pix**

Chave >> 7b9c9a6a-a4be-4caa-bcf3-2c760aac9d94

Banco Inter - Wesley David Santos

Lembre-se de que as contribuições financeiras são completamente opcionais e não são de forma alguma um requisito para o uso ou o suporte deste projeto. Qualquer ajuda, seja através de código, relatórios de problemas, ou simplesmente compartilhando sua experiência, é altamente valorizada.

Obrigado por fazer parte da comunidade PL/SQL e por considerar apoiar este projeto!

## Licença

Este projeto é licenciado sob a Apache License 2.0.

**Cláusula de Uso Comercial:**

1. Para qualquer uso deste software em um contexto comercial, incluindo, mas não se limitando a, incorporação deste software em produtos comerciais ou serviços oferecidos por empresas, a entidade comercial deve entrar em um acordo de licença comercial com Wesley David Santos por email ( wdsplsqltdd@gmail.com / wesleydavidsantos@gmail.com ) e pagar as taxas de licenciamento aplicáveis.

2. O uso não comercial deste software, incluindo seu uso em projetos de código aberto, é isento desta cláusula e pode ser realizado de acordo com os termos da Licença Apache 2.0.

