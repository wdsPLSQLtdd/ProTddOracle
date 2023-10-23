--
-- Responsável por armazenar todas as constantes de uso comum
CREATE OR REPLACE PACKAGE CONSTANTES AS
--
-- Responsável por armazenar todas as constantes de uso comum
--
-- Autor: Wesley David Santos
-- Skype: wesleydavidsantos		
-- https://www.linkedin.com/in/wesleydavidsantos
--

	--
	-- Usuário Principal que realiza o gerenciamento das ações de TDD
	OWNER_WDS_TDD CONSTANT VARCHAR2(13) := 'WDS_PLSQL_TDD';

	--
	-- Usuário responsável por armazenar os Testes que devem ser executados
	OWNER_WDS_TDD_TESTE CONSTANT VARCHAR2(19) := 'WDS_PLSQL_TDD_TESTE';

	--
	-- Nome onde o script de execução do TKPROF fica armazenado - Diretório registrado em ALL_DIRECTORIES
	NOME_DIRETORIO_SCRIPT_TKPROF CONSTANT VARCHAR2(50) := 'WDS_PLSQL_TDD_SCRIPT';

	--
	-- Nome onde os traces ficam armazenados após processado pelo TKPROF - Diretório registrado em ALL_DIRECTORIES
	NOME_DIRETORIO_TRACE CONSTANT VARCHAR2(50) := 'WDS_PLSQL_TDD_TRACE';

	--
	-- Informa o nome do parâmetro usado como prefixo para criar os nomes das procedures responsáveis pelo primeiro encapsulamento do Teste
	PREFIXO_NOME_CAPSULA_FILHA CONSTANT VARCHAR2(500) := 'CAPSULA_FILHA_T_{TESTE_ID}';
	
	--
	-- Informa o nome do parâmetro usado como prefixo para criar os nomes das procedures responsáveis pelo encapsulamento final do Teste
	PREFIXO_NOME_CAPSULA_PAI CONSTANT VARCHAR2(500) := 'CAPSULA_PAI_T_{TESTE_ID}';

	--
	-- Informa o nome do parâmetro usado como prefixo para criar os nomes dos arquivos de trace
	PREFIXO_NOME_TRACEFILE_IDENTIFIER CONSTANT VARCHAR2(500) := 'WDS_T_{TESTE_ID}_{DATA_TESTE}';

			
END CONSTANTES;
/

