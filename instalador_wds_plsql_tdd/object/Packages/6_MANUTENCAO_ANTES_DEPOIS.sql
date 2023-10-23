--
-- Responsável por registrar novas ações de ANTES e DEPOIS
CREATE OR REPLACE PACKAGE MANUTENCAO_ANTES_DEPOIS AS
--
-- Responsável por registrar novas ações de ANTES e DEPOIS
--
-- Esse processo funciona de Forma Recursiva em conjunto com a Package MANUTENCAO_TESTE
--
-- Autor: Wesley David Santos
-- Skype: wesleydavidsantos		
-- https://www.linkedin.com/in/wesleydavidsantos
--	

	FUNCTION GET_QTD_ITEM_ANTES RETURN NUMBER;

	FUNCTION GET_QTD_ITEM_DEPOIS RETURN NUMBER;

	PROCEDURE RESETAR_QTD_ITEM_ANTES_DEPOIS;

	--
	-- Realiza o cadastro ou atualização de testes de execução ANTES ou DEPOIS do TESTE Principal
	FUNCTION SALVA_TESTE( p_NOME_TESTE_PAI IN VARCHAR2, p_TESTE_JSON_PAI EXTRAI_METADADOS_TESTE.ITEM_TESTE ) RETURN BOOLEAN;
	
	
END MANUTENCAO_ANTES_DEPOIS;
/



CREATE OR REPLACE PACKAGE BODY MANUTENCAO_ANTES_DEPOIS AS
--
-- Autor: Wesley David Santos
-- Skype: wesleydavidsantos		
-- https://www.linkedin.com/in/wesleydavidsantos
--

	
	RAISE_ERRO_ENCONTRADO EXCEPTION;

	v_QTD_ITEM_ANTES NUMBER DEFAULT 0;

	v_QTD_ITEM_DEPOIS NUMBER DEFAULT 0;
	

	FUNCTION RESULTADO RETURN VARCHAR2 AS
	BEGIN
		
		RETURN LOG_GERENCIADOR.GET_MSG;
	
	END;


	FUNCTION GET_QTD_ITEM_ANTES RETURN NUMBER IS
	BEGIN

		RETURN v_QTD_ITEM_ANTES;

	END;


	FUNCTION GET_QTD_ITEM_DEPOIS RETURN NUMBER IS
	BEGIN

		RETURN v_QTD_ITEM_DEPOIS;

	END;


	PROCEDURE RESETAR_QTD_ITEM_ANTES_DEPOIS AS
	BEGIN

		v_QTD_ITEM_ANTES := 0;

		v_QTD_ITEM_DEPOIS := 0;

	END;


	FUNCTION GET_ID_FUNCTION_TESTE( p_FUNCTION_TESTE IN VARCHAR2 ) RETURN NUMBER IS

		v_ID NUMBER;

		v_FUNCTION_TESTE VARCHAR2(200);

		v_FLAG_ATUALIZA_TESTE BOOLEAN;

	BEGIN

		BEGIN

			v_FUNCTION_TESTE := p_FUNCTION_TESTE;

			BEGIN

				SELECT
					ID INTO v_ID
				FROM
					TESTE
				WHERE
					ASSERCAO = v_FUNCTION_TESTE;

				RETURN v_ID;
			
			EXCEPTION

				WHEN NO_DATA_FOUND THEN

					LOG_GERENCIADOR.ADD_ERRO( 'TESTE', 'Não foi encontrado na tabela TESTE o ID do teste informado na ação de ANTES_DEPOIS. TESTE: ' || v_FUNCTION_TESTE || ' - Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE  );

					RAISE RAISE_ERRO_ENCONTRADO;

				
				WHEN OTHERS THEN

					LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao identificar na tabela TESTE o ID do teste informado na ação de ANTES_DEPOIS. TESTE: ' || v_FUNCTION_TESTE || ' - Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

					RAISE RAISE_ERRO_ENCONTRADO;

			END;


		EXCEPTION

			WHEN OTHERS THEN

				RAISE RAISE_ERRO_ENCONTRADO;

		END;


	END;


	
	FUNCTION MANUTENCAO_TESTE_FILHA( p_FUNCTION_TESTE IN VARCHAR2 ) RETURN BOOLEAN IS
	-- Essa ação gera recursividade

		v_FLAG_ATUALIZA_TESTE BOOLEAN;

		v_FUNCTION_TESTE VARCHAR2(200);

	BEGIN

		BEGIN

			v_FUNCTION_TESTE := p_FUNCTION_TESTE;

			-- Recursividade - Realiza o cadastro/atualização do TESTE Filha - ANTES_DEPOIS
			BEGIN

				v_FLAG_ATUALIZA_TESTE := MANUTENCAO_TESTE.SALVA_TESTE( v_FUNCTION_TESTE );

				
				RETURN v_FLAG_ATUALIZA_TESTE;


			EXCEPTION

				WHEN OTHERS THEN

					LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha na Recursividade que Salva os dados do Teste Filha dentro da Package de ANTES_DEPOIS. TESTE Filha: ' || v_FUNCTION_TESTE );

					RETURN FALSE;

			END;

		EXCEPTION

			WHEN OTHERS THEN

				LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha no processo de Recursividade onde Salva os dados do Teste Filha dentro da Package de ANTES_DEPOIS. TESTE Filha: ' || v_FUNCTION_TESTE || ' - Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

				RAISE RAISE_ERRO_ENCONTRADO;

		END;


	END;



	PROCEDURE REMOVE_FILHOS_ATUAIS( v_TESTE_ID_PAI NUMBER ) AS
	BEGIN

		BEGIN

			DELETE FROM 
				ANTES_DEPOIS
			WHERE
				FK_TESTE_ID = v_TESTE_ID_PAI;

		EXCEPTION

			WHEN OTHERS THEN

				LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao limpar os registros antigos da tabela ANTES_DEPOIS. Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

				RAISE RAISE_ERRO_ENCONTRADO;

		END;


	END;


	PROCEDURE ADD_ACAO( p_POSICAO IN NUMBER, p_TESTE_ID_PAI NUMBER, p_TESTE_ID_FILHA IN NUMBER, p_ACAO IN VARCHAR2 ) AS
	BEGIN

		BEGIN

			--
			-- Não precisa de COMMIT
			-- Essa ação é chamada de forma recursiva, o COMMIT é realizado no final do processo


			IF p_TESTE_ID_PAI = p_TESTE_ID_FILHA THEN

				LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Um teste não pode ser um auxiliar ANTES_DEPOIS dele mesmo. Teste Principal: ' || p_TESTE_ID_PAI || ' - Teste Filha: ' || p_TESTE_ID_FILHA || ' - Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

				RAISE RAISE_ERRO_ENCONTRADO;

			END IF;


			INSERT INTO ANTES_DEPOIS 
				( POSICAO, FK_TESTE_ID, FK_TESTE_ACAO_ID, ACAO )
			VALUES
				( p_POSICAO, p_TESTE_ID_PAI, p_TESTE_ID_FILHA, p_ACAO );
		


			IF p_ACAO = 'ANTES' THEN

				v_QTD_ITEM_ANTES := v_QTD_ITEM_ANTES + 1;

			ELSE

				v_QTD_ITEM_DEPOIS := v_QTD_ITEM_DEPOIS + 1;

			END IF;



		EXCEPTION

			WHEN OTHERS THEN

				LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao registrar na tabela ANTES_DEPOIS um teste do tipo ANTES_DEPOIS. Ação: ' || p_ACAO || ' - Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

				RAISE RAISE_ERRO_ENCONTRADO;

		END;

	END;


    FUNCTION ADICIONA_FILHOS_ACAO_ANTES( p_TESTE_ID_PAI NUMBER, p_TESTE_JSON_PAI EXTRAI_METADADOS_TESTE.ITEM_TESTE ) RETURN BOOLEAN IS

		v_TESTE_ID_PAI NUMBER;

		v_TESTE_JSON_PAI EXTRAI_METADADOS_TESTE.ITEM_TESTE;


		v_TESTE_ID_FILHA NUMBER;

		v_NOME_FUNCTION_FILHA VARCHAR2(200);

    BEGIN

		BEGIN

			v_TESTE_ID_PAI := p_TESTE_ID_PAI;

			v_TESTE_JSON_PAI := p_TESTE_JSON_PAI;

				
			FOR POSICAO IN 1..v_TESTE_JSON_PAI.ANTES.COUNT LOOP

				BEGIN

					IF v_TESTE_JSON_PAI.ANTES( POSICAO ) IS NULL THEN

						EXIT;
					
					END IF;

					v_NOME_FUNCTION_FILHA := v_TESTE_JSON_PAI.ANTES( POSICAO );

					
					BEGIN

						-- Recursividade
						IF NOT MANUTENCAO_TESTE_FILHA( v_NOME_FUNCTION_FILHA ) THEN

							RETURN FALSE;

						END IF;


						v_TESTE_ID_FILHA := GET_ID_FUNCTION_TESTE( v_NOME_FUNCTION_FILHA );
						

					EXCEPTION

						WHEN OTHERS THEN

							RETURN FALSE;

					END;


				EXCEPTION

					WHEN OTHERS THEN

						LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha no processo de registrar um teste do tipo ANTES_DEPOIS. TESTE Filha: ' || v_NOME_FUNCTION_FILHA || ' -  Ação: ANTES - Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

						RAISE RAISE_ERRO_ENCONTRADO;

				END;

				ADD_ACAO( POSICAO, v_TESTE_ID_PAI, v_TESTE_ID_FILHA, 'ANTES' ) ;

			END LOOP;


			RETURN TRUE;

		EXCEPTION

			WHEN RAISE_ERRO_ENCONTRADO THEN

				RETURN FALSE;
				

			WHEN OTHERS THEN

				LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao pecorrer a Lista de Testes do tipo ANTES. Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

				RETURN FALSE;

		END;


    END;


    FUNCTION ADICIONA_FILHOS_ACAO_DEPOIS( p_TESTE_ID_PAI NUMBER, p_TESTE_JSON_PAI EXTRAI_METADADOS_TESTE.ITEM_TESTE ) RETURN BOOLEAN IS

		v_TESTE_ID_PAI NUMBER;

		v_TESTE_JSON_PAI EXTRAI_METADADOS_TESTE.ITEM_TESTE;


		v_TESTE_ID_FILHA NUMBER;

		v_NOME_FUNCTION_FILHA VARCHAR2(200);

    BEGIN

		BEGIN

			v_TESTE_ID_PAI := p_TESTE_ID_PAI;

			v_TESTE_JSON_PAI := p_TESTE_JSON_PAI;

				
			FOR POSICAO IN 1..v_TESTE_JSON_PAI.DEPOIS.COUNT LOOP
				
				BEGIN

					IF v_TESTE_JSON_PAI.DEPOIS( POSICAO ) IS NULL THEN

						EXIT;
					
					END IF;

					v_NOME_FUNCTION_FILHA := v_TESTE_JSON_PAI.DEPOIS( POSICAO );


					BEGIN

						-- Recursividade
						IF NOT MANUTENCAO_TESTE_FILHA( v_NOME_FUNCTION_FILHA ) THEN

							RETURN FALSE;

						END IF;

						v_TESTE_ID_FILHA := GET_ID_FUNCTION_TESTE( v_NOME_FUNCTION_FILHA );

					EXCEPTION

						WHEN OTHERS THEN

							RETURN FALSE;

					END;



				EXCEPTION

					WHEN OTHERS THEN

						LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao registrar um teste do tipo ANTES_DEPOIS. TESTE: ' || v_NOME_FUNCTION_FILHA || ' -  Ação: DEPOIS - Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

						RAISE RAISE_ERRO_ENCONTRADO;

				END;


				ADD_ACAO( POSICAO, v_TESTE_ID_PAI, v_TESTE_ID_FILHA, 'DEPOIS' ) ;


			END LOOP;


			RETURN TRUE;

		EXCEPTION

			WHEN RAISE_ERRO_ENCONTRADO THEN

				RETURN FALSE;


			WHEN OTHERS THEN

				LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao pecorrer a Lista de Testes do tipo DEPOIS. Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

				RETURN FALSE;

		END;


    END;


    FUNCTION SALVA_TESTE( p_NOME_TESTE_PAI IN VARCHAR2, p_TESTE_JSON_PAI EXTRAI_METADADOS_TESTE.ITEM_TESTE ) RETURN BOOLEAN IS

		v_TESTE_ID_PAI NUMBER;

		v_NOME_TESTE_PAI VARCHAR2(200);

		v_TESTE_JSON_PAI EXTRAI_METADADOS_TESTE.ITEM_TESTE;

    BEGIN

        BEGIN

			v_NOME_TESTE_PAI := p_NOME_TESTE_PAI;



			BEGIN

            	v_TESTE_ID_PAI := GET_ID_FUNCTION_TESTE( v_NOME_TESTE_PAI );

			EXCEPTION

				WHEN OTHERS THEN

					RETURN FALSE;

			END;




			v_TESTE_JSON_PAI := p_TESTE_JSON_PAI;



			REMOVE_FILHOS_ATUAIS( v_TESTE_ID_PAI );

			

			IF NOT ADICIONA_FILHOS_ACAO_ANTES( v_TESTE_ID_PAI, v_TESTE_JSON_PAI ) THEN

				RETURN FALSE;

			END IF;


			
			IF NOT ADICIONA_FILHOS_ACAO_DEPOIS( v_TESTE_ID_PAI, v_TESTE_JSON_PAI ) THEN

				RETURN FALSE;

			END IF;


			RETURN TRUE;


        EXCEPTION

			WHEN RAISE_ERRO_ENCONTRADO THEN

				RAISE RAISE_ERRO_ENCONTRADO;


            WHEN OTHERS THEN

				LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao salvar um teste do tipo ANTES_DEPOIS. TESTE Principal: ' || v_NOME_TESTE_PAI || ' - Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

				RAISE RAISE_ERRO_ENCONTRADO;

        END;

    END;


END MANUTENCAO_ANTES_DEPOIS;
/