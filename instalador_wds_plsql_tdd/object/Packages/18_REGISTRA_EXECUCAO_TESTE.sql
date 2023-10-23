--
-- Responsável por registrar as execuções dos testes
CREATE OR REPLACE PACKAGE REGISTRA_EXECUCAO_TESTE AS
--
-- Responsável por registrar as execuções dos testes
--
-- Autor: Wesley David Santos
-- Skype: wesleydavidsantos		
-- https://www.linkedin.com/in/wesleydavidsantos
--
	
	PROCEDURE SET_TESTE_ID( p_ASSERCAO IN VARCHAR2 );
	
	PROCEDURE NOVO_HISTORICO( 
								 p_ID_EXECUCAO IN NUMBER
								,p_TIPO_TESTE IN VARCHAR2
								,p_DATA_INICIO DATE
								,p_QTD_TOTAL_TESTE IN NUMBER
								,p_QTD_TESTE_REALIZADO IN NUMBER
								,p_QTD_TESTE_SUCESSO IN NUMBER
								,p_QTD_TESTE_FALHA IN NUMBER
								,p_QTD_TESTE_RAISE_ERRO IN NUMBER 
								,p_TEMPO BINARY_FLOAT 
							 );
	
	PROCEDURE TEMPO_EXECUCAO( p_ID_EXECUCAO IN NUMBER, p_SITUACAO IN VARCHAR2, p_ROWID_ARGUMENTO IN VARCHAR, p_TEMPO BINARY_FLOAT );
	
	PROCEDURE RAISE_ERROR( p_ID_EXECUCAO IN NUMBER, p_ROWID_ARGUMENTO IN VARCHAR2, p_MSG IN VARCHAR2 );
	
	
END REGISTRA_EXECUCAO_TESTE;
/




CREATE OR REPLACE PACKAGE BODY REGISTRA_EXECUCAO_TESTE AS
--
-- Autor: Wesley David Santos
-- Skype: wesleydavidsantos		
-- https://www.linkedin.com/in/wesleydavidsantos
--

	RAISE_ERRO_ENCONTRADO EXCEPTION;

	TESTE_ID NUMBER;
	
	CODIGO NUMBER;

	v_NOME_ASSERCAO_TESTE VARCHAR2(500);

	v_TRACE_ATIVADO BOOLEAN;

	v_COLETA_TRACE_INICIADO BOOLEAN;
	
	v_SESSION_SID NUMBER DEFAULT NULL;

	v_SESSION_SERIAL NUMBER DEFAULT NULL;

	
	FUNCTION GET_TESTE_ID RETURN NUMBER AS
	BEGIN
	
		RETURN TESTE_ID;
		
	END;
	
	
	FUNCTION GET_CODIGO RETURN NUMBER AS
	BEGIN
	
		RETURN CODIGO;
		
	END;
	
	
	PROCEDURE GERA_NOVO_CODIGO IS
	BEGIN
	
		CODIGO := GERAR_CODIGO;
			
	END;
	
	
	PROCEDURE INICIAR_TESTE IS
		
		v_TESTE_ID NUMBER := GET_TESTE_ID;
		
		v_FLAG_TESTE_EXECUCAO NUMBER;
	
		RAISE_ERRO_TESTE_EM_EXECUCAO EXCEPTION;
	
		RAISE_ERRO_FALHA_AO_INICIAR EXCEPTION;
	
	BEGIN
		
		BEGIN
				
			SELECT FK_TESTE_ID INTO v_FLAG_TESTE_EXECUCAO FROM TESTE_EM_EXECUCAO WHERE FK_TESTE_ID = v_TESTE_ID;
			
			RAISE RAISE_ERRO_TESTE_EM_EXECUCAO;
		
		EXCEPTION
		
			WHEN NO_DATA_FOUND THEN
			
				NULL;
		
			WHEN OTHERS THEN
			
				LOG_GERENCIADOR.ADD_ERRO( 'TESTE', 'O teste já está em execução. Teste: ' || GET_TESTE_ID || ' - Asserção: ' || v_NOME_ASSERCAO_TESTE || ' - Valide a tabela TESTE_EM_EXECUCAO.' );
			
				RAISE RAISE_ERRO_TESTE_EM_EXECUCAO;
				
		END;
	
	
	
		BEGIN
			
			INSERT INTO TESTE_EM_EXECUCAO ( FK_TESTE_ID ) VALUES ( v_TESTE_ID );
			
			COMMIT;
			
		
		EXCEPTION
		
			WHEN OTHERS THEN
			
				LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao registrar o INICIO do teste. Teste: ' || GET_TESTE_ID  || ' - Asserção: ' || v_NOME_ASSERCAO_TESTE );
										
				RAISE RAISE_ERRO_FALHA_AO_INICIAR;
		
		
		END;
	
		
	END;
	
	
	PROCEDURE FINALIZAR_TESTE IS
		
		v_TESTE_ID NUMBER := GET_TESTE_ID;
		
		RAISE_ERRO_FALHA_AO_FINALIZAR EXCEPTION;
	
	BEGIN
		
		BEGIN
			
			DELETE FROM TESTE_EM_EXECUCAO WHERE FK_TESTE_ID = v_TESTE_ID;
			
			COMMIT;
			
		
		EXCEPTION
		
			WHEN OTHERS THEN
			
				LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao registrar o FIM do teste. Teste: ' || GET_TESTE_ID || ' - Asserção: ' || v_NOME_ASSERCAO_TESTE );
										
				RAISE RAISE_ERRO_FALHA_AO_FINALIZAR;
		
		
		END;
	
		
	END;


	PROCEDURE VALIDA_TRACE_ATIVADO AS

		v_TESTE_ID NUMBER;

		v_FLAG_TESTE_ATIVADO CHAR(1) DEFAULT NULL;

		v_SID NUMBER;

		v_SERIAL NUMBER;

	BEGIN

		BEGIN


			v_TESTE_ID := GET_TESTE_ID;


			--
			-- Verifica se o TRACE está ativado
			SELECT
				TRACE_ATIVADO INTO v_FLAG_TESTE_ATIVADO
			FROM
				TDD_CAPSULA_PAI
			WHERE
				FK_TESTE_ID = v_TESTE_ID;


			--
			-- Se ativado, realiza a coleta as informações de Session
			IF v_FLAG_TESTE_ATIVADO = 'Y' THEN


				v_TRACE_ATIVADO := TRUE;


				SELECT 
						SID, SERIAL#
					INTO
						v_SID, v_SERIAL
				FROM 
					SYS.GV_$SESSION
				WHERE
					SID = (SELECT SYS_CONTEXT('userenv', 'sid') FROM DUAL);

								
				v_SESSION_SID := v_SID;

				v_SESSION_SERIAL := v_SERIAL;

			END IF;


		EXCEPTION

			WHEN NO_DATA_FOUND THEN

				NULL;
				

			WHEN OTHERS THEN

				LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao verificar se a coleta de TRACE está ativado '
												   || 'Teste: ' || GET_TESTE_ID 
												   || ' - Asserção: ' || v_NOME_ASSERCAO_TESTE
												   || ' - Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
										);
										
				RAISE RAISE_ERRO_ENCONTRADO;

		END;


	END;



	PROCEDURE DESATIVAR_COLETA_TRACE AS

		v_SID_NUMBER NUMBER;

		v_SERIAL_NUMBER NUMBER;

		RAISE_TRACE_NAO_ATIVADO EXCEPTION;

	BEGIN

		BEGIN


			IF NOT v_TRACE_ATIVADO THEN

				RAISE RAISE_TRACE_NAO_ATIVADO;

			END IF;


			v_SID_NUMBER := v_SESSION_SID;

			v_SERIAL_NUMBER := v_SESSION_SERIAL;


			LOG_GERENCIADOR.ADD_ALERTA( 'SISTEMA', 'Desativando coleta de TRACE - ' 
														|| 'Teste: ' || GET_TESTE_ID 
														|| ' - Asserção: ' || v_NOME_ASSERCAO_TESTE
														|| ' - v_SID_NUMBER: ' || v_SID_NUMBER 
														|| ' - v_SERIAL_NUMBER: ' || v_SERIAL_NUMBER
									 );


			SYS.DBMS_SYSTEM.SET_SQL_TRACE_IN_SESSION(v_SID_NUMBER, v_SERIAL_NUMBER, FALSE);


		EXCEPTION

			WHEN RAISE_TRACE_NAO_ATIVADO THEN

				NULL;


			WHEN OTHERS THEN
			
				LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao ativar a coleta de TRACE '
												   || ' - Teste: ' || GET_TESTE_ID 
												   || ' - Asserção: ' || v_NOME_ASSERCAO_TESTE
												   || ' - Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
										);

				RAISE RAISE_ERRO_ENCONTRADO;

		END;


	END;
	
	
	
	PROCEDURE SET_TESTE_ID( p_ASSERCAO IN VARCHAR2 ) IS
		
		RAISE_ERRO_TESTE_NAO_ENCONTRADO EXCEPTION;
	
	BEGIN
		
		
		BEGIN

			v_NOME_ASSERCAO_TESTE := p_ASSERCAO;

			v_TRACE_ATIVADO := FALSE;

			v_COLETA_TRACE_INICIADO := FALSE;

		
			SELECT ID INTO TESTE_ID FROM TESTE WHERE ASSERCAO = p_ASSERCAO;
			
			
			INICIAR_TESTE;


			GERA_NOVO_CODIGO;
		

		EXCEPTION
			
			WHEN NO_DATA_FOUND THEN
			
				LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Teste não identificado. Teste: ' || p_ASSERCAO );
				
				FINALIZAR_TESTE;

				RAISE RAISE_ERRO_TESTE_NAO_ENCONTRADO;
		
		END;
		
	
	END;
  
	
	PROCEDURE TEMPO_EXECUCAO( p_ID_EXECUCAO IN NUMBER, p_SITUACAO IN VARCHAR2, p_ROWID_ARGUMENTO IN VARCHAR, p_TEMPO BINARY_FLOAT ) IS
	
		v_TESTE_ID NUMBER := GET_TESTE_ID;
		
		v_CODIGO NUMBER := GET_CODIGO;
	
	BEGIN
		
		BEGIN
		
			INSERT INTO TEMPO_EXECUCAO_TESTE 
				( FK_TESTE_ID, ID_EXECUCAO, CODIGO, ROWID_ARGUMENTO, TEMPO_EXECUCAO, SITUACAO ) 
			VALUES
				(
					 v_TESTE_ID
					,p_ID_EXECUCAO
					,v_CODIGO
					,p_ROWID_ARGUMENTO
					,p_TEMPO
					,p_SITUACAO
				);
			
		EXCEPTION
			
			WHEN OTHERS THEN
			
				LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao registrar o tempo de execução do teste. '
												   || 'Teste: ' || GET_TESTE_ID
												   || ' - Asserção: ' || v_NOME_ASSERCAO_TESTE
												   || ' - Rowid: ' || p_ROWID_ARGUMENTO
										);

		
		END;
		
	END;
		
	
    PROCEDURE RAISE_ERROR( p_ID_EXECUCAO IN NUMBER, p_ROWID_ARGUMENTO IN VARCHAR2, p_MSG IN VARCHAR2 ) IS
	
		v_TESTE_ID NUMBER := GET_TESTE_ID;
		
		v_CODIGO NUMBER := GET_CODIGO;
	
	BEGIN
		
		BEGIN
		
			INSERT INTO LOG_RAISE_ERRO_EXECUCAO_TESTE 
				( FK_TESTE_ID, ID_EXECUCAO, CODIGO, ROWID_ARGUMENTO, MSG ) 
			VALUES
				(
						v_TESTE_ID
					,p_ID_EXECUCAO
					,v_CODIGO
					,p_ROWID_ARGUMENTO
					,p_MSG
				);
				
		EXCEPTION
			
			WHEN OTHERS THEN
			
				LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao registrar uma mensagem de ERRO de um TESTE executado. '
												   || 'Teste: ' || GET_TESTE_ID
												   || ' - Asserção: ' || v_NOME_ASSERCAO_TESTE
												   || ' - Rowid: ' || p_ROWID_ARGUMENTO
										);
										
				NULL;
		
		END;
		
	END;


    PROCEDURE NOVO_HISTORICO( 
								 p_ID_EXECUCAO IN NUMBER
								,p_TIPO_TESTE IN VARCHAR2
								,p_DATA_INICIO DATE
								,p_QTD_TOTAL_TESTE IN NUMBER
								,p_QTD_TESTE_REALIZADO IN NUMBER
								,p_QTD_TESTE_SUCESSO IN NUMBER
								,p_QTD_TESTE_FALHA IN NUMBER
								,p_QTD_TESTE_RAISE_ERRO IN NUMBER 
								,p_TEMPO BINARY_FLOAT 
							 ) IS
		
		v_TESTE_ID NUMBER := GET_TESTE_ID;
		
		v_CODIGO NUMBER := GET_CODIGO;

		v_ORDEM_EXECUCAO NUMBER;
		
		RAISE_ERRO_FALHA_REGISTRO EXCEPTION;
	
	BEGIN
		
		BEGIN

			-- Gera o próximo valor da sequência de execução
			SELECT
				( COUNT( 1 ) + 1 ) INTO v_ORDEM_EXECUCAO
			FROM
				HISTORICO_EXECUCAO_TESTES
			WHERE
				ID_EXECUCAO = p_ID_EXECUCAO;


		

			INSERT INTO HISTORICO_EXECUCAO_TESTES 
						( 
							 FK_TESTE_ID
							,CODIGO
							,ID_EXECUCAO
							,DATA_INICIO
							,ORDEM_EXECUCAO
							,TIPO_TESTE
							,QTD_TOTAL_TESTE
							,QTD_TESTE_REALIZADO
							,QTD_TESTE_SUCESSO
							,QTD_TESTE_FALHA
							,QTD_TESTE_RAISE_ERRO
							,TEMPO_EXECUCAO
						) 
						VALUES
						(
							 v_TESTE_ID
							,v_CODIGO
							,p_ID_EXECUCAO
							,p_DATA_INICIO
							,v_ORDEM_EXECUCAO
							,p_TIPO_TESTE
							,p_QTD_TOTAL_TESTE
							,p_QTD_TESTE_REALIZADO
							,p_QTD_TESTE_SUCESSO
							,p_QTD_TESTE_FALHA
							,p_QTD_TESTE_RAISE_ERRO
							,p_TEMPO
						);
			


			DESATIVAR_COLETA_TRACE;


			FINALIZAR_TESTE;
			

		EXCEPTION
			
			WHEN OTHERS THEN
			
				LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao registrar um novo histórico de execução de teste. '
												   || 'Teste: ' || GET_TESTE_ID
												   || ' - Asserção: ' || v_NOME_ASSERCAO_TESTE
										);
										
				RAISE RAISE_ERRO_FALHA_REGISTRO;
		
		END;
		
	END;		
	
	
END REGISTRA_EXECUCAO_TESTE;
/
