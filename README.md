# wdsPLSQLtdd - Automated Unit Testing in PL/SQL (TDD)


**Readme** - Versão em Português: https://github.com/wdsPLSQLtdd/wdsPLSQLtdd/blob/main/README_ptBR.md


**BUILT IN PL/SQL FOR PL/SQL**

wdsPLSQLtdd is an automated testing system developed in PL/SQL, designed to simplify and expedite the process of creating unit tests in the PL/SQL language.

Oracle Database is the undisputed leader in technology and market share in Brazil and around the world.

However, most robust testing systems available for the PL/SQL language were not originally developed in PL/SQL. These systems belong to other languages and were adapted to the PL/SQL language rather than being exclusively dedicated to it.

There is a significant difference between an adapted system and a dedicated one, and wdsPLSQLtdd is dedicated to the PL/SQL language.

Unlike other solutions that involve the use of additional programming languages, such as jUnit which uses Java, wdsPLSQLtdd allows PL/SQL developers to create tests directly, eliminating the need to learn a new language and significantly reducing the learning curve.

## Video tutorial

[![wdsPLSQLtdd - Tutorial](https://img.youtube.com/vi/02SgxiF0VIA/0.jpg)](https://www.youtube.com/watch?v=02SgxiF0VIA "wdsPLSQLtdd - Tutorial")

## Problem to Be Solved

Often, PL/SQL developers and teams encounter the need to create unit tests for their Procedures, Functions, and Packages. However, most available solutions involve the use of additional programming languages, which can be complex and time-consuming. wdsPLSQLtdd aims to address this issue by allowing tests to be written directly in PL/SQL, simplifying and streamlining the process.

## Key Development Environment Features

- Create unit tests directly in PL/SQL.
- Automatically execute tests.
- Easily integrate with existing PL/SQL projects.
- Reduce the learning curve by eliminating the need to learn a new programming language.
- Automatically generate traces.
- Maintain a history of all performed tests.
- Maintain a history containing runtime metrics for each test.
- Enable independent testing on a dataset.

## Key Production Environment Features

- Monitor DDL actions performed in a production environment.
- Monitor and test new update script applications in production environments.
- Use the system for debugging and identifying records that are encountering errors in a production environment.

Here are the steps to get started using wdsPLSQLtdd in your project:

## Installation - User Creation

1. Download the wdsPLSQLtdd system scripts.

2. To install and use the wdsPLSQLtdd system, you need to create two users.

   **CREATING THE MAIN MANAGEMENT USER**

   ```sql
        -- Main user responsible for management. It is up to you to define the password and tablespace.
        CREATE USER WDS_PLSQL_TDD IDENTIFIED BY WDS_PLSQL_TDD;
   ```

   Assign the necessary permissions.

   Use the SYS user.

   ```sql
        -- Use the SYS user.
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

   **CREATING THE USER FOR STORING CREATED TESTS**

   ```sql
        -- User responsible for storing the created tests. It is up to you to define the password and tablespace.
        CREATE USER WDS_PLSQL_TDD_TESTE IDENTIFIED BY WDS_PLSQL_TDD_TESTE;
   ```

   Assign the necessary permissions.

   Use the SYS user.

   ```sql
        -- Use the SYS user.
        GRANT CREATE SESSION TO WDS_PLSQL_TDD_TESTE;
        GRANT DBA TO WDS_PLSQL_TDD_TESTE;
        GRANT EXECUTE ANY PROCEDURE TO WDS_PLSQL_TDD_TESTE;
        GRANT SELECT ANY TABLE TO WDS_PLSQL_TDD_TESTE;
        GRANT DELETE ANY TABLE TO WDS_PLSQL_TDD_TESTE;
        GRANT CREATE PROCEDURE TO WDS_PLSQL_TDD_TESTE;
        GRANT INSERT ANY TABLE TO WDS_PLSQL_TDD_TESTE;
   ```

## Installation - Configuring the TRACE Collection Script

Note: Currently, TRACE collection is only performed on LINUX environments.

1. To configure the TRACE collection process, you will need to create two directories on the database server.

2. You can choose the local directory where the other two directories will be created, but here is a suggested directory structure:

   ```bash
     -- Create the directory with the ORACLE user

     -- First directory
     mkdir /u01/aplic/wds_plsql_tdd/

     -- Second directory. This directory should be created inside the first directory
     mkdir /u01/aplic/wds_plsql_tdd/trace
   ```

3. Upload the Shell Script encoded file to the first directory you just created.

   File name: wds_identificar_novo_trace.sh

4. Make the file executable with the following command:

```bash
    chmod +x wds_identificar_novo_trace.sh
```

5. Create an empty file named: trace_gerado.wds

   For example, use the command: touch trace_gerado.wds

```bash
   touch trace_gerado.wds
```

6. Open the file wds_identificar_novo_trace.sh and edit the local variables.

   Inside the file, it is described which variables need to be edited.

7. Execute the file by providing the full path. Running this file should return an ERROR message because no TRACE collections have been made yet.

8. Connect to the database with the WDS_PLSQL_TDD user to create the directories. Execute the following command.

   Make sure to correctly specify the full path of the directories you created earlier.

   ```sql
       -- Specify the full path of the first directory defined in the "Installation - Configuring the TRACE Collection Script" section
       -- Do not include a trailing "/" at the end of the directory
       CREATE DIRECTORY WDS_PLSQL_TDD_SCRIPT AS '/u01/aplic/wds_plsql_tdd';

       -- Specify the full path of the second directory defined in the "Installation - Configuring the TRACE Collection Script" section
       -- Do not include a trailing "/" at the end of the directory
       CREATE DIRECTORY WDS_PLSQL_TDD_TRACE AS '/u01/aplic/wds_plsql_tdd/trace';
   ```

## Installation - Creating TDD System Objects

Note: The wdsPLSQLtdd system was developed using the "Oracle Database 19c Release 19.0.0.0.0" version. If you encounter any issues with earlier versions, please contact us.

You can perform either a Manual or Automatic installation.

In the Manual installation, you will need to execute 50 SQL files in a specific order to avoid compilation problems.

In the Automatic version, you will use a single file that installs 47 objects, and you will only need to manually execute 3 files.

## Automatic Installation - Creating TDD System Objects

1. Upload the "Instalador" folder to the "TEMP" folder of your Oracle server.

   Folder name containing the installer: "instalador_wds_plsql_tdd"

2. Important: When the installation process starts, after creating the tables, you will be prompted to execute the creation of the 3 Views via SQLDeveloper. Only continue with the automatic installation after creating the Views.

   The scripts for creating the Views are:

   ```sql
       object/Views/1_VW_CAPSULA_FILHA.sql
       object/Views/2_VW_HIERARQUIA_TESTE.sql
       object/Views/3_VW_LISTA_TESTES_INVALIDOS.sql
   ```

3. Connect to SQLPlus.

4. Call the installation file.

   There are two installation files, one in English and one in Portuguese.

   Installer in English: "wds_plsql_tdd_instalar_en.sql"

   Installer in Portuguese: "wds_plsql_tdd_instalar_ptbr.sql"

   ```sql
        cd instalador_wds_plsql_tdd/

        . oraenv <<< SID_DATABASE

        sqlplus / as sysdba

        @wds_plsql_tdd_instalar_ptbr.sql

        exit
   ```

## Manual Installation - Creating TDD System Objects

1. Download the "Instalador" folder.

2. Connect with the WDS_PLSQL_TDD user.

3. The scripts can be executed via SQLPlus or SQLDeveloper.

4. Execute the scripts in the order defined below.

   ```sql
       --
       -- Table Creation

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
       -- View Creation - Create all the Views using SQLDeveloper because SQLPlus may not recognize the WITH command

       1_VW_CAPSULA_FILHA.sql
       2_VW_HIERARQUIA_TESTE.sql
       3_VW_LISTA_TESTES_INVALIDOS.sql

       --
       -- Function Creation

       1_GERAR_HASH.sql

       --
       -- Package Creation
       1_CONSTANTES.sql
       2_LOG_GERENCIADOR.sql

       --
       -- Function Creation

       2_GERAR_NOME_TRACE.sql
       3_VALIDA_OBJETO_TESTE.sql
       4_GERAR_CODIGO.sql

       --
       -- Package Creation
       3_MONITORAR_NOVO_OWNER.sql
       4_EXTRAI_METADADOS_TESTE.sql
       5_MANUTENCAO_ALVO.sql

       --
       -- Package Creation - The packages will compile with errors due to dependencies between them. Then execute the command to Compile each one.
       --
       -- WARNING....
       --
       -- The MANUTENCAO_ANTES_DEPOIS and CAPSULA_FILHA packages will compile with errors
       -- due to their dependency on the MANUTENCAO_TESTE package,
       -- as a result of the recursion process in the TDD development architecture.
       -- After creation, execute the command listed below to Compile each package.
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
       -- Package Creation

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
       -- Job Creation

       1_EXECUTAR_TESTES_AUTOMATIZADOS.sql
       2_JOB_EXPORTADOR_TRACE.sql
       3_JOB_MONITORAR_NOVOS_TESTES.sql
       4_JOB_VALIDAR_CAPSULAS.sql

       --
       -- Trigger Creation

       1_TRG_GERENCIA_TDD_CAPSULA_FILHA.sql
       2_TRG_GERENCIA_TDD_CAPSULA_PAI.sql
       3_TRG_IDENTIFICA_DDL_TESTE_TDD.sql
       4_TRG_MONITORA_DDL_DISPARO_TDD.sql
   ```

## Installation Completed

After performing the manual or automatic execution of the scripts, the installation process is complete.

Now, let's begin creating tests.

## How to Create a Test

All tests must be created within the **WDS_PLSQL_TDD_TESTE** owner.

Creating a test is straightforward.

A test can only be created using an object of the FUNCTION type.

The Function associated with the test should return a BOOLEAN value.

During the test creation process, provide the test data in a comment block within the function's body (/* */).

You can create a test before the object to be tested. The test function will become invalid due to its dependency on the object to be tested, but once the object is created, the test becomes valid.

All tests are executed whenever there is a DDL (Data Definition Language) change to an object of the monitored owners.

**PARAMETERS THAT CAN BE USED**

There is a list of parameters in JSON format that must be defined for creating a test.

Here is the list of parameters:

```sql
   /*
   {NOME: Unique Test Name}
   {INFO: Information about the process being tested}
   {ALVO_OWNER: Owner of the TARGET being Tested}
   {ALVO_OBJECT: Owner of the object being Tested}
   {QUERY_ARGUMENTO: SELECT VALUE_A, VALUE_B FROM WDS_TDD_TEST.TEST_CALCULATOR}
   {ANTES: TEST_01, TEST_02, TEST_03}
   {DEPOIS: TEST_21, TEST_22, TEST_23}
   {TESTE_AUXILIAR}
   {TESTE_DESATIVADO}
   */
```

1. The minimum information required to create a test includes: NAME | INFO | ALVO_OWNER | ALVO_OBJECT.

2. With just these 4 parameters, you define that the function is a valid test object.

3. After that, no further intervention or configuration is necessary.

4. Monitor test executions whenever a TARGET_OWNER undergoes a DDL change.

5. All active tests are executed together.

The mandatory parameters for use are:

```sql
   /*
   {NOME: Unique Test Name}
   {INFO: Information about the process being tested}
   {ALVO_OWNER: Owner of the TARGET being Tested}
   {ALVO_OBJECT: Owner of the object being Tested}
   */
```

Here is a description of each parameter:

**NAME** – Can be a descriptive name but must be unique.

**INFO** – Add notes related to the test and the test's expectation. These notes make it easier for other developers.

**ALVO_OWNER** – Name of the OWNER of the object or action to be executed.

**ALVO_OBJECT** – Name of the object to be analyzed. This does not need to be linked to an existing object.

**QUERY_ARGUMENTO** – Allows multiple tests, each with its own metric. The test function must have the same number of parameters as the number of columns in the query. Do not use JOIN queries or queries that access more than one table.

**ANTES** – List of TESTS that should be executed BEFORE the main TEST.

**DEPOIS** – List of TESTS that should be executed AFTER the main TEST.

**TESTE_AUXILIAR** – Every test created is considered the main test, but a test can be configured to be only an AUXILIARY test. In this case, it will only be executed when declared as ANTES or DEPOIS.

**TESTE_DESATIVADO** – If you want to deactivate a test, just add this parameter, and the test will be deactivated.

## TARGET - Example of a target we will use in our test

The focus of the TEST is to point to a specific TARGET on an existing object within the database.

This Object can be of any type because the validation of the correct execution of this TARGET object is defined in the TEST you create.

Let's create an example of a TARGET that we will use for the test.

Our TARGET is an object that performs the SUM of two values.

```sql
   -- User: CALCULATOR
   --
   -- Object: TARGET
   --

   CREATE OR REPLACE FUNCTION ADD(A NUMBER, B NUMBER) RETURN NUMBER AS

      RESULT NUMBER;

   BEGIN

      RESULT := A + B;

      RETURN RESULT;

   END ADD;
   /
```

**Example - SIMPLE TEST**

```sql
   -- User: WDS_PLSQL_TDD_TEST
   --
   -- Creation of the TEST Function before creating the Object to be tested.
   --

   CREATE OR REPLACE FUNCTION CALCULATOR_ADDITION RETURN BOOLEAN IS
   /*
   {NOME:Calculator Addition Test}
   {INFO:Performs mathematical tests of the ADD operation}
   {ALVO_OWNER:CALCULATOR}
   {ALVO_OBJECT:ADD}
   */
   BEGIN

      RETURN CALCULATOR.ADD( 2, 3 ) = 5;

   END;
   /
```

**Example - TEST WITH PARAMETERS**

```sql
   -- User: WDS_PLSQL_TDD_TEST
   --
   -- Table to store test values
   --
   CREATE TABLE TEST_CALCULATOR (
      VALUE_A NUMBER NOT NULL,
      VALUE_B NUMBER NOT NULL
   );


   --
   -- Registering the values to be tested
   --

   INSERT INTO TEST_CALCULATOR ( VALUE_A, VALUE_B ) VALUES ( 2, 1 );
   INSERT INTO TEST_CALCULATOR ( VALUE_A, VALUE_B ) VALUES ( 2, 2 );
   INSERT INTO TEST_CALCULATOR ( VALUE_A, VALUE_B ) VALUES ( 2, 3 );
   INSERT INTO TEST_CALCULATOR ( VALUE_A, VALUE_B ) VALUES ( 2, 4 );
   INSERT INTO TEST_CALCULATOR ( VALUE_A, VALUE_B ) VALUES ( 2, 5 );
   INSERT INTO TEST_CALCULATOR ( VALUE_A, VALUE_B ) VALUES ( 2, 6 );
   INSERT INTO TEST_CALCULATOR ( VALUE_A, VALUE_B ) VALUES ( 2, 7 );
   INSERT INTO TEST_CALCULATOR ( VALUE_A, VALUE_B ) VALUES ( 2, 8 );
   INSERT INTO TEST_CALCULATOR ( VALUE_A, VALUE_B ) VALUES ( 2, 9 );
   INSERT INTO TEST_CALCULATOR ( VALUE_A, VALUE_B ) VALUES ( 2, 10 );

   COMMIT;



   -- User: WDS_PLSQL_TDD_TEST
   --
   -- Creation of the TEST Function before creating the Object to be tested.
   --


   CREATE OR REPLACE FUNCTION CALCULATOR_ADDITION( p_VALUE_A IN NUMBER, p_VALUE_B IN NUMBER ) RETURN BOOLEAN IS
   /*
   {NOME:Calculator Addition Test}
   {INFO:Performs mathematical tests of the ADD operation}
   {ALVO_OWNER:CALCULATOR}
   {ALVO_OBJECT:ADD}
   {QUERY_ARGUMENTO:SELECT VALUE_A, VALUE_B FROM WDS_PLSQL_TDD_TEST.TEST_CALCULATOR}
   */
   BEGIN

      RETURN CALCULATOR.ADD( p_VALUE_A, p_VALUE_B ) = ( p_VALUE_A + p_VALUE_B );

   END;
   /
```


**Example - TEST THAT PERFORMS ACTIONS BEFORE THE MAIN TEST**

```sql
   -- User: WDS_PLSQL_TDD_TEST
   --
   -- Table to store test values
   --
   CREATE TABLE TEST_CALCULATOR (
      VALUE_A NUMBER NOT NULL,
      VALUE_B NUMBER NOT NULL
   );



   -- User: WDS_PLSQL_TDD_TEST
   --
   -- Performing an action before executing the Real TEST.
   -- This TEST Function creates dynamic values for the TEST.
   --
   CREATE OR REPLACE FUNCTION GENERATE_TEST_VALUES_CALCULATOR RETURN BOOLEAN IS
   /*
   {NOME:Generate values for Calculator test}
   {INFO:Creates random values that will be used in mathematical calculations of the tests }
   {ALVO_OWNER:CALCULATOR}
   {ALVO_OBJECT:CALCULATE}
   {TEST_AUXILIAR}
   */

      v_NUM_A NUMBER;
      v_NUM_B NUMBER;
      v_RESULT NUMBER;
   BEGIN

      FOR i IN 1..10 LOOP
         v_NUM_A := TRUNC( DBMS_RANDOM.VALUE(1, 100) );
         v_NUM_B := TRUNC( DBMS_RANDOM.VALUE(1, 100) );

         INSERT INTO WDS_PLSQL_TDD_TEST.TEST_CALCULATOR ( VALUE_A, VALUE_B ) VALUES ( v_NUM_A, v_NUM_B );
      END LOOP;

      v_RESULT := SQL%ROWCOUNT;

      COMMIT;

      RETURN ( v_RESULT > 0 );
   END;
   /





   -- User: WDS_PLSQL_TDD_TEST
   --
   -- Creation of the TEST Function before creating the Object to be tested.
   --

   CREATE OR REPLACE FUNCTION CALCULATOR_ADDITION( p_VALUE_A IN NUMBER, p_VALUE_B IN NUMBER ) RETURN BOOLEAN IS
   /*
   {NOME:Calculator Addition Test}
   {INFO:Performs mathematical tests of the ADD operation}
   {ALVO_OWNER:CALCULATOR}
   {ALVO_OBJECT:ADD}
   {QUERY_ARGUMENTO:SELECT VALUE_A, VALUE_B FROM WDS_PLSQL_TDD_TEST.TEST_CALCULATOR}
   {ANTES:GENERATE_TEST_VALUES_CALCULATOR}
   */

      v_LOG_REGISTERED NUMBER;

   BEGIN

      RETURN CALCULATOR.ADD( p_VALUE_A, p_VALUE_B ) = ( p_VALUE_A + p_VALUE_B );

   END;
   /
```


**Example - TEST THAT PERFORMS ACTIONS BEFORE AND AFTER THE MAIN TEST**

```sql
   -- User: WDS_PLSQL_TDD_TEST
   --
   -- Table to store test values
   --
   CREATE TABLE TEST_CALCULATOR (
      VALUE_A NUMBER NOT NULL,
      VALUE_B NUMBER NOT NULL
   );


   -- User: WDS_PLSQL_TDD_TEST
   --
   -- Performing an action before executing the Real TEST.
   -- This TEST Function creates dynamic values for the TEST.
   --
   CREATE OR REPLACE FUNCTION GENERATE_TEST_VALUES_CALCULATOR RETURN BOOLEAN IS
   /*
   {NOME:Generate values for Calculator test}
   {INFO:Creates random values that will be used in mathematical calculations of the tests }
   {ALVO_OWNER:CALCULATOR}
   {ALVO_OBJECT:CALCULATE}
   {TEST_AUXILIAR}
   */

      v_NUM_A NUMBER;
      v_NUM_B NUMBER;
      v_RESULT NUMBER;
   BEGIN

      FOR i IN 1..10 LOOP
         v_NUM_A := TRUNC( DBMS_RANDOM.VALUE(1, 100) );
         v_NUM_B := TRUNC( DBMS_RANDOM.VALUE(1, 100) );

         INSERT INTO WDS_PLSQL_TDD_TEST.TEST_CALCULATOR ( VALUE_A, VALUE_B ) VALUES ( v_NUM_A, v_NUM_B );
      END LOOP;

      v_RESULT := SQL%ROWCOUNT;

      COMMIT;

      RETURN ( v_RESULT > 0 );
   END;
   /




   -- User: WDS_PLSQL_TDD_TEST
   --
   -- Performing an action after executing the Real TEST.
   -- This TEST Function rolls back the tested values.
   --
   CREATE OR REPLACE FUNCTION ROLLBACK_TEST_VALUES_CALCULATOR RETURN BOOLEAN IS
   /*
   {NOME:Delete calculator test values}
   {INFO:Deletes the values generated for the mathematical tests to be performed }
   {ALVO_OWNER:CALCULATOR}
   {ALVO_OBJECT:SUM}
   {TEST_AUXILIAR}
   */
      v_RESULT NUMBER;

   BEGIN

      DELETE FROM WDS_PLSQL_TDD_TEST.TEST_CALCULATOR;

      v_RESULT := SQL%ROWCOUNT;

      COMMIT;

      RETURN ( v_RESULT > 0 );

   END;
   /


   -- User: WDS_PLSQL_TDD_TEST
   --
   -- Creating the TEST Function before creating the Object to be tested.
   --

   CREATE OR REPLACE FUNCTION CALCULATOR_SUM( p_VALUE_A IN NUMBER, p_VALUE_B IN NUMBER ) RETURN BOOLEAN IS
   /*
   {NOME:Calculator Sum Test}
   {INFO:Performs mathematical tests for the SUM operation }
   {ALVO_OWNER:CALCULATOR}
   {ALVO_OBJECT:SUM}
   {QUERY_ARGUMENT:SELECT VALUE_A, VALUE_B FROM WDS_PLSQL_TDD_TEST.TEST_CALCULATOR}
   {ANTES:GENERATE_TEST_VALUES_CALCULATOR}
   {DEPOIS:ROLLBACK_TEST_VALUES_CALCULATOR}
   */

      v_LOG_REGISTERED NUMBER;

   BEGIN

      RETURN CALCULATOR.SUM( p_VALUE_A, p_VALUE_B ) = ( p_VALUE_A + p_VALUE_B );

   END;
   /
```

**How to Enable/Disable TRACE on a TEST**

To enable the collection of TRACE data, you need to call a Function belonging to the WDS_PLSQL_TDD Owner and pass the TEST_ID as a parameter.

```sql

   -- Enabling TRACE collection
   SELECT WDS_PLSQL_TDD.MANUTENCAO_TESTE.ATIVAR_TRACE( TEST_ID ) FROM DUAL;


   -- Disabling TRACE collection
   SELECT WDS_PLSQL_TDD.MANUTENCAO_TESTE.DESATIVAR_TRACE( TEST_ID ) FROM DUAL;

```

## Test Examples - Video

[![wdsPLSQLtdd - Test Examples](https://img.youtube.com/vi/Ozswl1GJFdE/0.jpg)](https://www.youtube.com/watch?v=Ozswl1GJFdE "wdsPLSQLtdd - Test Examples")

## Financial Contributions (Optional)

If you found this framework useful and would like to support its ongoing development, you can make a financial contribution. Your contributions are welcome and help keep this project active.

**Crypto**

Bitcoin >> bc1qk8uextsv83gwz9ups9k7ejfj35zenfa96rjnxs

Ethereum - BNB - MATIC >> 0x74d6b623e488e76ea522915edf2c9bcaeebff190

**Pix**

Key >> 7b9c9a6a-a4be-4caa-bcf3-2c760aac9d94

Banco Inter - Wesley David Santos

Please remember that financial contributions are entirely optional and by no means a requirement for using or supporting this project. Any assistance, whether through code, issue reports, or simply sharing your experience, is highly appreciated.

Thank you for being part of the PL/SQL community and for considering supporting this project!

## License

This project is licensed under the Apache License 2.0.

**Commercial Use Clause:**

1. For any use of this software in a commercial context, including but not limited to incorporating this software into commercial products or services offered by companies, the commercial entity must enter into a commercial license agreement with Wesley David Santos via email (wdsplsqltdd@gmail.com / wesleydavidsantos@gmail.com) and pay the applicable licensing fees.

2. Non-commercial use of this software, including its use in open-source projects, is exempt from this clause and may be carried out in accordance with the terms of the Apache 2.0 License.