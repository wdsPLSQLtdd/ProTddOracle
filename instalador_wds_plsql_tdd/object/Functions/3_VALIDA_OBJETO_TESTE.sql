--
-- Responsável por verificar se a Function que realiza o TESTE foi criado de forma correta
CREATE OR REPLACE FUNCTION VALIDA_OBJETO_TESTE( p_NOME_FUNCTION_TESTE IN VARCHAR2 ) RETURN BOOLEAN IS
--
-- Responsável por verificar se a Function que realiza o TESTE foi criado de forma correta
--
-- Autor: Wesley David Santos
-- Skype: wesleydavidsantos		
-- https://www.linkedin.com/in/wesleydavidsantos
--

    v_OBJ_TYPE VARCHAR2(100);

    v_TIPO_RETORNO_FUNCTION VARCHAR2(100);

    RAISE_ERRO_ENCONTRADO EXCEPTION;

BEGIN

    BEGIN

        -- Verifica existência e tipo de objeto TESTE
        BEGIN

            SELECT 
                OBJECT_TYPE INTO v_OBJ_TYPE
            FROM
                SYS.DBA_OBJECTS
            WHERE
                OWNER = CONSTANTES.OWNER_WDS_TDD_TESTE
                AND OBJECT_NAME = p_NOME_FUNCTION_TESTE;


            IF v_OBJ_TYPE != 'FUNCTION' THEN

                LOG_GERENCIADOR.ADD_ERRO( 'TESTE', 'Objeto que realiza o teste deve ser do tipo FUNCTION. TESTE: ' || p_NOME_FUNCTION_TESTE || ' - Tipo: ' || v_OBJ_TYPE );

                RETURN FALSE;

            END IF;

        EXCEPTION

            WHEN NO_DATA_FOUND THEN

                LOG_GERENCIADOR.ADD_ERRO( 'TESTE', 'Objeto que realiza o teste não encontrado. TESTE: ' || p_NOME_FUNCTION_TESTE );

                RETURN FALSE;

            WHEN OTHERS THEN

                LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao identificar o objeto que realiza o teste. TESTE: ' || p_NOME_FUNCTION_TESTE || ' - Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                RAISE RAISE_ERRO_ENCONTRADO;

        END;



        -- Verifica se a FUNCTION de teste tem o retorno correto
        BEGIN

            SELECT
				PLS_TYPE INTO v_TIPO_RETORNO_FUNCTION
			FROM
				SYS.DBA_ARGUMENTS
			WHERE
				IN_OUT = 'OUT' 
				AND OWNER = CONSTANTES.OWNER_WDS_TDD_TESTE
				AND OBJECT_NAME = p_NOME_FUNCTION_TESTE;


			IF v_TIPO_RETORNO_FUNCTION != 'BOOLEAN' THEN

				LOG_GERENCIADOR.ADD_ERRO( 'TESTE', 'Função de TESTE sempre deve retornar um BOOLEAN. TESTE: ' || p_NOME_FUNCTION_TESTE || ' retorna ' || v_TIPO_RETORNO_FUNCTION );

                RETURN FALSE;

			END IF;


        EXCEPTION

            WHEN NO_DATA_FOUND THEN

                LOG_GERENCIADOR.ADD_ERRO( 'TESTE', 'Não foi encontrado o argumento de retorno da função de teste. TESTE: ' || p_NOME_FUNCTION_TESTE );

                RETURN FALSE;

            WHEN OTHERS THEN

                LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao encontrar argumento de retorno da função de teste. TESTE: ' || p_NOME_FUNCTION_TESTE || ' - Erro: ' || SQLERRM  || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                RAISE RAISE_ERRO_ENCONTRADO;

        END;


        RETURN TRUE;


    EXCEPTION

        WHEN OTHERS THEN

            RAISE RAISE_ERRO_ENCONTRADO;

    END;

END;
/