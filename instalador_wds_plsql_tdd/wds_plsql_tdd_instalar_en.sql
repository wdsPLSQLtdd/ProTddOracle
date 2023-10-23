--
-- Load the files in the required installation order.
--
-- Autor: Wesley David Santos
-- Skype: wesleydavidsantos		
-- https://www.linkedin.com/in/wesleydavidsantos
--
--
-- How to Execute:
--
-- After creating the WDS_PLSQL_TDD user, connect to SqlPlus using the WDS_PLSQL_TDD user.
--
--


SET SERVEROUTPUT ON



PROMPT
PROMPT

PROMPT Installer for the PL/SQL TDD System - WDS_PLSQL_TDD
PROMPT 
PROMPT Before running it, create the user and grant user access permissions.
PROMPT 
PROMPT User creation script: wds_tdd_criar_usuario.sql
PROMPT


ACCEP CHAR PROMPT 'Press ENTER to continue.'

PROMPT

ACCEPT password CHAR PROMPT 'Enter the password for the username WDS_PLSQL_TDD  '



-- Conecta com o usuário usando as variáveis de entrada
CONNECT WDS_PLSQL_TDD/&password

PROMPT
PROMPT

SHOW USER;

PROMPT
PROMPT




--
-- Create tables

PROMPT @object/Tables/1_ALVO.sql
@object/Tables/1_ALVO.sql

PROMPT @object/Tables/2_TESTE.sql
@object/Tables/2_TESTE.sql

PROMPT @object/Tables/3_ANTES_DEPOIS.sql
@object/Tables/3_ANTES_DEPOIS.sql

PROMPT @object/Tables/4_TDD_CAPSULA_FILHA.sql
@object/Tables/4_TDD_CAPSULA_FILHA.sql

PROMPT @object/Tables/5_TDD_CAPSULA_PAI.sql
@object/Tables/5_TDD_CAPSULA_PAI.sql

PROMPT @object/Tables/6_TRACE_METADADOS.sql
@object/Tables/6_TRACE_METADADOS.sql

PROMPT @object/Tables/7_TRACE.sql
@object/Tables/7_TRACE.sql

PROMPT @object/Tables/8_DISPARAR_TESTES_TDD.sql
@object/Tables/8_DISPARAR_TESTES_TDD.sql

PROMPT @object/Tables/9_HISTORICO_EXECUCAO_TESTES.sql
@object/Tables/9_HISTORICO_EXECUCAO_TESTES.sql

PROMPT @object/Tables/10_TEMPO_EXECUCAO_TESTE.sql
@object/Tables/10_TEMPO_EXECUCAO_TESTE.sql

PROMPT @object/Tables/11_TESTE_EM_EXECUCAO.sql
@object/Tables/11_TESTE_EM_EXECUCAO.sql

PROMPT @object/Tables/12_TESTE_EM_MANUTENCAO.sql
@object/Tables/12_TESTE_EM_MANUTENCAO.sql

PROMPT @object/Tables/13_LISTA_NOVOS_TESTES.sql
@object/Tables/13_LISTA_NOVOS_TESTES.sql

PROMPT @object/Tables/14_LOG_DISPARO_TESTES_TDD.sql
@object/Tables/14_LOG_DISPARO_TESTES_TDD.sql

PROMPT @object/Tables/15_LOG_INFO.sql
@object/Tables/15_LOG_INFO.sql

PROMPT @object/Tables/16_LOG_RAISE_ERRO_EXECUCAO_TESTE.sql
@object/Tables/16_LOG_RAISE_ERRO_EXECUCAO_TESTE.sql

PROMPT @object/Tables/17_OWNER_MONITORADO.sql
@object/Tables/17_OWNER_MONITORADO.sql

PROMPT @object/Tables/18_SHELL_EXECUTAR_TKPROF_TRACE.sql
@object/Tables/18_SHELL_EXECUTAR_TKPROF_TRACE.sql




--
-- Create Views
--

PROMPT
PROMPT ATTENTION....
PROMPT
PROMPT Create all the Views using SqlDeveloper because SqlPlus may not recognize the WITH command.
PROMPT
PROMPT Only proceed after creating the VIEWS.
PROMPT


ACCEP CHAR PROMPT 'Press ENTER to continue.'


--
-- Create Functions
--

PROMPT @object/Functions/1_GERAR_HASH.sql
@object/Functions/1_GERAR_HASH.sql



--
-- Create Packages
--

PROMPT @object/Packages/1_CONSTANTES.sql
@object/Packages/1_CONSTANTES.sql

PROMPT @object/Packages/2_LOG_GERENCIADOR.sql
@object/Packages/2_LOG_GERENCIADOR.sql

PROMPT @object/Functions/4_GERAR_CODIGO.sql
@object/Functions/4_GERAR_CODIGO.sql


--
-- Create functions
--

PROMPT @object/Functions/2_GERAR_NOME_TRACE.sql
@object/Functions/2_GERAR_NOME_TRACE.sql

PROMPT @object/Functions/3_VALIDA_OBJETO_TESTE.sql
@object/Functions/3_VALIDA_OBJETO_TESTE.sql





--
-- Create Packages
--

PROMPT @object/Packages/3_MONITORAR_NOVO_OWNER.sql
@object/Packages/3_MONITORAR_NOVO_OWNER.sql

PROMPT @object/Packages/4_EXTRAI_METADADOS_TESTE.sql
@object/Packages/4_EXTRAI_METADADOS_TESTE.sql

PROMPT @object/Packages/5_MANUTENCAO_ALVO.sql
@object/Packages/5_MANUTENCAO_ALVO.sql


PROMPT
PROMPT ATTENTION....
PROMPT
PROMPT The MANUTENCAO_ANTES_DEPOIS and CAPSULA_FILHA packages will compile with errors
PROMPT due to the dependency between them and the MANUTENCAO_TESTE package
PROMPT resulting from the recursive process in the TDD development architecture.
PROMPT Do not worry, they will be recompiled after creation.
PROMPT


ACCEP CHAR PROMPT 'Press ENTER to continue.'



--
-- Create Packages - The packages will compile with errors due to the dependency between them; then, execute the command to compile each one.
--

PROMPT @object/Packages/6_MANUTENCAO_ANTES_DEPOIS.sql
@object/Packages/6_MANUTENCAO_ANTES_DEPOIS.sql

PROMPT @object/Packages/7_CAPSULA_FILHA.sql
@object/Packages/7_CAPSULA_FILHA.sql

PROMPT @object/Packages/8_MANUTENCAO_TESTE.sql
@object/Packages/8_MANUTENCAO_TESTE.sql


PROMPT Recompiling the package. MANUTENCAO_ANTES_DEPOIS
ALTER PACKAGE MANUTENCAO_ANTES_DEPOIS COMPILE;
ALTER PACKAGE MANUTENCAO_ANTES_DEPOIS COMPILE BODY;


PROMPT Recompiling the package. CAPSULA_FILHA
ALTER PACKAGE CAPSULA_FILHA COMPILE;
ALTER PACKAGE CAPSULA_FILHA COMPILE BODY;


PROMPT Recompiling the package. MANUTENCAO_TESTE
ALTER PACKAGE MANUTENCAO_TESTE COMPILE;
ALTER PACKAGE MANUTENCAO_TESTE COMPILE BODY;




--
-- Create Packages

PROMPT @object/Packages/9_IDENTIFICAR_TESTES_TDD.sql
@object/Packages/9_IDENTIFICAR_TESTES_TDD.sql

PROMPT @object/Packages/10_HIERARQUIA_TESTE.sql
@object/Packages/10_HIERARQUIA_TESTE.sql

PROMPT @object/Packages/11_CAPSULA_PAI.sql
@object/Packages/11_CAPSULA_PAI.sql

PROMPT @object/Packages/12_ENCAPSULAR.sql
@object/Packages/12_ENCAPSULAR.sql

PROMPT @object/Packages/13_MONITORAR_NOVOS_TESTES.sql
@object/Packages/13_MONITORAR_NOVOS_TESTES.sql

PROMPT @object/Packages/14_CRONOMETRO.sql
@object/Packages/14_CRONOMETRO.sql

PROMPT @object/Packages/15_EXECUTAR_TESTES_TDD.sql
@object/Packages/15_EXECUTAR_TESTES_TDD.sql

PROMPT @object/Packages/16_EXPORTADOR_TRACE.sql
@object/Packages/16_EXPORTADOR_TRACE.sql

PROMPT @object/Packages/17_GERENCIAR_TRACE.sql
@object/Packages/17_GERENCIAR_TRACE.sql

PROMPT @object/Packages/18_REGISTRA_EXECUCAO_TESTE.sql
@object/Packages/18_REGISTRA_EXECUCAO_TESTE.sql




--
-- Create Jobs

PROMPT @object/Jobs/1_EXECUTAR_TESTES_AUTOMATIZADOS.sql
@object/Jobs/1_EXECUTAR_TESTES_AUTOMATIZADOS.sql

PROMPT @object/Jobs/2_JOB_EXPORTADOR_TRACE.sql
@object/Jobs/2_JOB_EXPORTADOR_TRACE.sql

PROMPT @object/Jobs/3_JOB_MONITORAR_NOVOS_TESTES.sql
@object/Jobs/3_JOB_MONITORAR_NOVOS_TESTES.sql

PROMPT @object/Jobs/4_JOB_VALIDAR_CAPSULAS.sql
@object/Jobs/4_JOB_VALIDAR_CAPSULAS.sql





--
-- Create Triggers
--

PROMPT @object/Triggers/1_TRG_GERENCIA_TDD_CAPSULA_FILHA.sql
@object/Triggers/1_TRG_GERENCIA_TDD_CAPSULA_FILHA.sql

PROMPT @object/Triggers/2_TRG_GERENCIA_TDD_CAPSULA_PAI.sql
@object/Triggers/2_TRG_GERENCIA_TDD_CAPSULA_PAI.sql

PROMPT @object/Triggers/3_TRG_IDENTIFICA_DDL_TESTE_TDD.sql
@object/Triggers/3_TRG_IDENTIFICA_DDL_TESTE_TDD.sql

PROMPT @object/Triggers/4_TRG_MONITORA_DDL_DISPARO_TDD.sql
@object/Triggers/4_TRG_MONITORA_DDL_DISPARO_TDD.sql





PROMPT
PROMPT
PROMPT End of the PL/SQL TDD System Installation - WDS_PLSQL_TDD
PROMPT
PROMPT

