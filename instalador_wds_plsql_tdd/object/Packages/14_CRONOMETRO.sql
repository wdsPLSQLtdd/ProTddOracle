--
-- Responsável por cronometrar tempos de execução dos processos de monitoramento
CREATE OR REPLACE PACKAGE CRONOMETRO AS
--
-- Package responsável por cronometrar e registrar simultaneamente vários tempos de execução sobre qualquer tipo de procedimento.
-- Com o uso desta package é possível determinar analisar quanto tempo demora a execução de determinados procedimentos
--
-- Autor: Wesley David Santos
-- Skype: wesleydavidsantos		
-- https://www.linkedin.com/in/wesleydavidsantos
--
--
--
--
-- Como Usar:
--/
---> Exemplo no GitHub
---> https://github.com/wesleydavidsantos/cronometro-PLSQL
--\


  
  PROCEDURE INICIAR( p_SESSAO_ID IN VARCHAR2);
  PROCEDURE PARAR( p_SESSAO_ID IN VARCHAR2);
  PROCEDURE EXCLUIR( p_SESSAO_ID IN VARCHAR2);
  FUNCTION  GET_TEMPO( p_SESSAO_ID IN VARCHAR2) RETURN VARCHAR2;
  
  FUNCTION GET_MSG_ERROR RETURN VARCHAR2;
  
END;
/





CREATE OR REPLACE PACKAGE BODY CRONOMETRO AS
--
-- Autor: Wesley David Santos
-- Skype: wesleydavidsantos		
-- https://www.linkedin.com/in/wesleydavidsantos
--
    

	
	TYPE SESSAO_INFO IS RECORD (
		SESSAO_ID VARCHAR2(100),
		TEMPO_INICIO TIMESTAMP,
		TEMPO_FINAL TIMESTAMP
	);

	
	TYPE TBL_SESSAO_INFO IS TABLE OF SESSAO_INFO INDEX BY BINARY_INTEGER;
	
	
	LISTA_SESSAO TBL_SESSAO_INFO;
	
	
	MSG_ERROR VARCHAR2(4000);
	
	
	-- Retonar a última mensagem de erro registrada
	FUNCTION GET_MSG_ERROR RETURN VARCHAR2 IS
	BEGIN

		RETURN MSG_ERROR;
		
	END;
	
	
	PROCEDURE ADD_ERRO( p_MSG_ERROR VARCHAR2 ) IS
	BEGIN
		
		MSG_ERROR := p_MSG_ERROR;
	
	END;
	
	
	FUNCTION SESSAO_ID_EXISTE( p_SESSAO_ID VARCHAR2 ) RETURN BOOLEAN IS
	BEGIN
	
		FOR v_INDEX IN 1..LISTA_SESSAO.COUNT LOOP
		
			IF LISTA_SESSAO( v_INDEX ).SESSAO_ID = p_SESSAO_ID THEN
			
				RETURN TRUE;
				
			END IF;
			
		END LOOP;
	
	
		RETURN FALSE;
	
	END;
	

	PROCEDURE INICIAR( p_SESSAO_ID IN VARCHAR2 ) IS

		v_INDEX BINARY_INTEGER;
		
		RAISE_ERRO_SESSAO_ID_EXISTE EXCEPTION;
		
		RAISE_ERRO_OTHERS EXCEPTION;

	BEGIN
	
		BEGIN
	
			IF SESSAO_ID_EXISTE( p_SESSAO_ID ) THEN
				
				RAISE RAISE_ERRO_SESSAO_ID_EXISTE;
			
			END IF;


			v_INDEX := LISTA_SESSAO.COUNT + 1;

			LISTA_SESSAO( v_INDEX ).SESSAO_ID := p_SESSAO_ID;

			LISTA_SESSAO( v_INDEX ).TEMPO_INICIO := SYSTIMESTAMP();

			
		EXCEPTION
			
			WHEN RAISE_ERRO_SESSAO_ID_EXISTE THEN
				
				ADD_ERRO( 'A sessão de id única para registro do cronometro já está ativa. Sessão: ' || p_SESSAO_ID );
			
				RAISE RAISE_ERRO_SESSAO_ID_EXISTE;
				
				
			WHEN OTHERS THEN
				
				ADD_ERRO( 'Falha ao realizar a ação de INICIAR do cronômetro.  Sessão: ' || p_SESSAO_ID  || ' - Quantidade Sessões: ' || LISTA_SESSAO.COUNT  || ' - Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );
												   
				RAISE RAISE_ERRO_OTHERS;
		
		END;

	END;



	PROCEDURE PARAR( p_SESSAO_ID IN VARCHAR2) IS

		v_TEMPO_EXECUCAO INTERVAL DAY TO SECOND;
		
		RAISE_ERRO_SESSAO_ID_NAO_EXISTE EXCEPTION;
		
		RAISE_ERRO_OTHERS EXCEPTION;

	BEGIN
		
		
		BEGIN
		
			IF NOT SESSAO_ID_EXISTE( p_SESSAO_ID ) THEN
					
				RAISE RAISE_ERRO_SESSAO_ID_NAO_EXISTE;
			
			END IF;
					
		
			FOR ITEM_SESSAO IN 1..LISTA_SESSAO.COUNT LOOP
			
			  IF LISTA_SESSAO( ITEM_SESSAO ).SESSAO_ID = p_SESSAO_ID THEN
			  
				LISTA_SESSAO( ITEM_SESSAO ).TEMPO_FINAL := SYSTIMESTAMP();
				
				v_TEMPO_EXECUCAO := LISTA_SESSAO( ITEM_SESSAO ).TEMPO_FINAL - LISTA_SESSAO( ITEM_SESSAO ).TEMPO_INICIO;
				
				EXIT;
				
			  END IF;
			  
			END LOOP;
		
		
		EXCEPTION
			
			WHEN RAISE_ERRO_SESSAO_ID_NAO_EXISTE THEN
				
				ADD_ERRO( 'A sessão id única para PARAR o cronometro não foi encontrada. Sessão: ' || p_SESSAO_ID );
			
				RAISE RAISE_ERRO_SESSAO_ID_NAO_EXISTE;
				
				
			WHEN OTHERS THEN
				
				ADD_ERRO( 'Falha ao realizar a ação de PARAR do cronômetro. Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );
			
				RAISE RAISE_ERRO_OTHERS;
		
		END;
		
		
		
		
	END;
	
	
	
	PROCEDURE EXCLUIR( p_SESSAO_ID IN VARCHAR2) IS
	
		LISTA_SESSAO_TEMP TBL_SESSAO_INFO;
		
		INDEX_LISTA_TEMP NUMBER DEFAULT 1;
	
		RAISE_ERRO_SESSAO_ID_NAO_EXISTE EXCEPTION;
		
		RAISE_ERRO_OTHERS EXCEPTION;

	BEGIN
	
	
		BEGIN
	

			IF NOT SESSAO_ID_EXISTE( p_SESSAO_ID ) THEN
					
				RAISE RAISE_ERRO_SESSAO_ID_NAO_EXISTE;

			END IF;
			
			
			-- Exclui e Reorganiza os indexes
			FOR ITEM_SESSAO IN 1..LISTA_SESSAO.COUNT LOOP			
			
				IF LISTA_SESSAO( ITEM_SESSAO ).SESSAO_ID != p_SESSAO_ID THEN
			
					LISTA_SESSAO_TEMP( INDEX_LISTA_TEMP ) := LISTA_SESSAO( ITEM_SESSAO );
				
					INDEX_LISTA_TEMP := INDEX_LISTA_TEMP + 1;
					
				END IF;				
				
			END LOOP;
			
			
			LISTA_SESSAO := LISTA_SESSAO_TEMP;
			
			
		EXCEPTION
			
			WHEN RAISE_ERRO_SESSAO_ID_NAO_EXISTE THEN
				
				ADD_ERRO( 'A sessão id única para PARAR o cronometro não foi encontrada. Sessão: ' || p_SESSAO_ID );
			
				NULL;
				
				
			WHEN OTHERS THEN
				
				ADD_ERRO( 'Falha ao realizar a ação de RESET do cronômetro. Sessão: ' || p_SESSAO_ID || '. Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );
			
				RAISE RAISE_ERRO_OTHERS;
		
		END;
		
		
		
	END;
	


	FUNCTION GET_TEMPO( p_SESSAO_ID IN VARCHAR2 ) RETURN VARCHAR2 IS
	
		v_TEMPO_EXECUCAO NUMBER DEFAULT NULL;
		
		RAISE_ERRO_SESSAO_ID_NAO_EXISTE EXCEPTION;
		
		RAISE_ERRO_OTHERS EXCEPTION;
		
	BEGIN
		
		BEGIN
		
			IF NOT SESSAO_ID_EXISTE( p_SESSAO_ID ) THEN
						
				RAISE RAISE_ERRO_SESSAO_ID_NAO_EXISTE;
			
			END IF;
			
			
			
			FOR ITEM_SESSAO IN 1..LISTA_SESSAO.COUNT LOOP
			
			  IF LISTA_SESSAO( ITEM_SESSAO ).SESSAO_ID = p_SESSAO_ID THEN
				
				-- Calcular o tempo de execução em segundos
				v_TEMPO_EXECUCAO := EXTRACT(SECOND FROM ( LISTA_SESSAO( ITEM_SESSAO ).TEMPO_FINAL - LISTA_SESSAO( ITEM_SESSAO ).TEMPO_INICIO ));
				v_TEMPO_EXECUCAO := v_TEMPO_EXECUCAO + (EXTRACT(MINUTE FROM ( LISTA_SESSAO( ITEM_SESSAO ).TEMPO_FINAL - LISTA_SESSAO( ITEM_SESSAO ).TEMPO_INICIO )) * 60);
				v_TEMPO_EXECUCAO := v_TEMPO_EXECUCAO + (EXTRACT(HOUR FROM ( LISTA_SESSAO( ITEM_SESSAO ).TEMPO_FINAL - LISTA_SESSAO( ITEM_SESSAO ).TEMPO_INICIO )) * 3600);
				
				RETURN v_TEMPO_EXECUCAO;
				
			  END IF;

			END LOOP;
			
					
			RETURN NULL;
			
			
		EXCEPTION
			
			WHEN RAISE_ERRO_SESSAO_ID_NAO_EXISTE THEN
				
				ADD_ERRO( 'A sessão id única para o GET_TEMPO do cronometro não foi encontrada. Sessão: ' || p_SESSAO_ID );
			
				RAISE RAISE_ERRO_SESSAO_ID_NAO_EXISTE;
				
				
			WHEN OTHERS THEN
				
				ADD_ERRO( 'Falha ao realizar a ação de GET_TEMPO do cronômetro. Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );
			
				RAISE RAISE_ERRO_OTHERS;
		
		END;
		
        
	END;
  
END;
/

