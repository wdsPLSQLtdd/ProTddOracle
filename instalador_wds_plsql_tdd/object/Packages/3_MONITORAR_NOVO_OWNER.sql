--
-- Responsável por realizar o cadastro de um novo Owner para ser monitorado
CREATE OR REPLACE PACKAGE MONITORAR_NOVO_OWNER AS
--
-- Responsável por realizar o cadastro de um novo Owner para ser monitorado
--
-- Autor: Wesley David Santos
-- Skype: wesleydavidsantos		
-- https://www.linkedin.com/in/wesleydavidsantos
--

    PROCEDURE ADD( p_NOME_OWNER IN VARCHAR2);

END MONITORAR_NOVO_OWNER;
/



CREATE OR REPLACE PACKAGE BODY MONITORAR_NOVO_OWNER AS
--
-- Autor: Wesley David Santos
-- Skype: wesleydavidsantos		
-- https://www.linkedin.com/in/wesleydavidsantos
--

	PROCEDURE ADD( p_NOME_OWNER IN VARCHAR2 ) AS
		
		v_NOME_OWNER VARCHAR2(100);
		
		RAISE_ERRO_OWNER_NAO_EXISTE EXCEPTION;
		
		RAISE_ERRO_OWNER_JA_REGISTRADO EXCEPTION;
		
		RAISE_ERRO_FALHA_ADD_OWNER EXCEPTION;
		
		RAISE_ERRO_ENCONTRADO EXCEPTION;
		
		v_FLAG_VALIDA_OWNER VARCHAR2(100);
		
	BEGIN
		
		
		BEGIN
		
			v_NOME_OWNER := UPPER( p_NOME_OWNER );
		
			
			--
			-- Owner existe no banco de dados
			BEGIN
				
				SELECT USERNAME INTO v_FLAG_VALIDA_OWNER FROM DBA_USERS WHERE USERNAME = v_NOME_OWNER;
			
			EXCEPTION
			
				WHEN NO_DATA_FOUND THEN
				
					LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Owner não registrado. Owner não existe no banco de dados. Owner: ' || v_NOME_OWNER );
					
					RAISE RAISE_ERRO_OWNER_NAO_EXISTE;
			
				WHEN OTHERS THEN
				
					LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao registrar um novo Owner para ser monitorado. Owner: ' || v_NOME_OWNER || ' - Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );
				
					RAISE RAISE_ERRO_ENCONTRADO;
			
			END;
			
			
			--
			-- Owner já está sendo monitorado
			BEGIN
				
				SELECT OWNER INTO v_FLAG_VALIDA_OWNER FROM OWNER_MONITORADO WHERE OWNER = v_NOME_OWNER;
				
				RAISE RAISE_ERRO_OWNER_JA_REGISTRADO;
			
			EXCEPTION
			
				WHEN NO_DATA_FOUND THEN
				
					NULL;
			
				WHEN OTHERS THEN
				
					LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao registrar um novo Owner para ser monitorado. Owner: ' || v_NOME_OWNER || ' - Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );
				
					RAISE RAISE_ERRO_ENCONTRADO;
			
			END;
		
			
			--
			-- Registra o novo Owner
			BEGIN
			
				INSERT INTO OWNER_MONITORADO ( OWNER, ATIVADO ) VALUES ( v_NOME_OWNER, 'Y' );
				
				COMMIT;
				
				LOG_GERENCIADOR.ADD_SUCESSO( 'SISTEMA', 'Novo Owner registrado com sucesso. ' || v_NOME_OWNER );
				
				DBMS_OUTPUT.PUT_LINE( 'Novo Owner registrado com sucesso. ' || v_NOME_OWNER );
				
			EXCEPTION
			
				WHEN OTHERS THEN
				
					LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao registrar um novo Owner para ser monitorado. Owner: ' || v_NOME_OWNER || ' - Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );
				
					RAISE RAISE_ERRO_ENCONTRADO;
			
			END;
			
			
		EXCEPTION
			
			WHEN OTHERS THEN
				
				DBMS_OUTPUT.PUT_LINE( 'Falha ao registrar o novo Owner. Acesse a tabela de LOG_INFO.' );
				
				NULL;
		
		END;
		
	
	END;
		

END MONITORAR_NOVO_OWNER;
/
