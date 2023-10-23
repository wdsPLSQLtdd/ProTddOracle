--
-- Responsável por registrar novos ALVOS criados ou atualizados
CREATE OR REPLACE PACKAGE MANUTENCAO_ALVO AS
--
-- Responsável por registrar novos ALVOS criados ou atualizados
--
-- Autor: Wesley David Santos
-- Skype: wesleydavidsantos		
-- https://www.linkedin.com/in/wesleydavidsantos
--

    --
    -- Retorna o ID do ALVO registrado no TDD
    FUNCTION GET_ALVO_ID RETURN NUMBER;

	--
	-- Realiza o cadastro ou atualização de um teste
	FUNCTION SALVA_ALVO( p_OWNER IN VARCHAR2, p_OBJECT_NAME IN VARCHAR2 ) RETURN BOOLEAN;
	
	
END MANUTENCAO_ALVO;
/





CREATE OR REPLACE PACKAGE BODY MANUTENCAO_ALVO AS
--
-- Autor: Wesley David Santos
-- Skype: wesleydavidsantos		
-- https://www.linkedin.com/in/wesleydavidsantos
--

	TYPE ITEM_ALVO IS RECORD (
         ALVO_ID NUMBER
        ,OWNER VARCHAR2(50)
        ,OBJECT_NAME VARCHAR2(200)
    );


    ALVO ITEM_ALVO;

    RAISE_ERRO_ENCONTRADO EXCEPTION;


	FUNCTION RESULTADO RETURN VARCHAR2 AS
	BEGIN
		
		RETURN LOG_GERENCIADOR.GET_MSG;
	
	END;


    FUNCTION GET_ALVO_ID RETURN NUMBER IS
    BEGIN

        RETURN ALVO.ALVO_ID;

    END;


    FUNCTION ALVO_EXISTE RETURN BOOLEAN IS

        p_OWNER VARCHAR2(50);

        p_OBJECT_NAME VARCHAR2(200);

    BEGIN

        BEGIN

            p_OWNER := ALVO.OWNER;

            p_OBJECT_NAME := ALVO.OBJECT_NAME;


            SELECT
                ID INTO ALVO.ALVO_ID
            FROM
                ALVO
            WHERE
                OWNER = p_OWNER
                AND OBJECT_NAME = p_OBJECT_NAME;

            RETURN TRUE;

        EXCEPTION

            WHEN NO_DATA_FOUND THEN

                RETURN FALSE;

            WHEN OTHERS THEN

                LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao identificar as informações do ALVO. ALVO: ' || ALVO.OWNER || '.' || ALVO.OBJECT_NAME || ' - Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                RAISE RAISE_ERRO_ENCONTRADO;

        END;
        
    END;


    PROCEDURE REGISTRA_OWNER_COMO_MONITORADO AS

        p_OWNER VARCHAR2(50);

        v_OWNER_EXISTE VARCHAR2(50);

    BEGIN


        BEGIN

            p_OWNER := ALVO.OWNER;


            SELECT
                OWNER INTO v_OWNER_EXISTE
            FROM
                OWNER_MONITORADO
            WHERE
                OWNER = p_OWNER;

            
        EXCEPTION

            WHEN NO_DATA_FOUND THEN

                BEGIN

                    INSERT INTO OWNER_MONITORADO
                        ( DATA_REGISTRO, OWNER, ATIVADO )
                    VALUES
                        ( SYSDATE, p_OWNER, 'Y' );
                
                EXCEPTION

                    WHEN OTHERS THEN

                        LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao registrar o Owner como Monitorado. Owner: ' || ALVO.OWNER || '.' || ALVO.OBJECT_NAME || ' - Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                        RAISE RAISE_ERRO_ENCONTRADO;

                END;

            WHEN OTHERS THEN

                    LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha no processo de valiar o Owner como Monitorado. Owner: ' || ALVO.OWNER || '.' || ALVO.OBJECT_NAME || ' - Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                    RAISE RAISE_ERRO_ENCONTRADO;


        END;



    END;


    PROCEDURE ADD_ALVO AS

        p_ALVO_ID NUMBER;

        p_OWNER VARCHAR2(50);

        p_OBJECT_NAME VARCHAR2(200);

    BEGIN

        BEGIN

            p_OWNER := ALVO.OWNER;

            p_OBJECT_NAME := ALVO.OBJECT_NAME;


            INSERT INTO ALVO
                    ( OWNER, OBJECT_NAME )
            VALUES
                    ( p_OWNER, p_OBJECT_NAME )
            RETURNING ID INTO p_ALVO_ID;


            -- Registra o Owner como monitorado para realizar a validação dos DDL's gerados por ele
            REGISTRA_OWNER_COMO_MONITORADO;

            
            COMMIT;
            

            ALVO.ALVO_ID := p_ALVO_ID;

        EXCEPTION

            WHEN OTHERS THEN

                LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao registrar as informações do ALVO. ALVO: ' || ALVO.OWNER || '.' || ALVO.OBJECT_NAME || ' - Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                RAISE RAISE_ERRO_ENCONTRADO;

        END;

    END;


    FUNCTION SALVA_ALVO( p_OWNER IN VARCHAR2, p_OBJECT_NAME IN VARCHAR2 ) RETURN BOOLEAN IS
    BEGIN

        BEGIN

            ALVO.OWNER := p_OWNER;

            ALVO.OBJECT_NAME := p_OBJECT_NAME;


            IF NOT ALVO_EXISTE THEN

                ADD_ALVO;

            END IF;
            
            RETURN TRUE;

        EXCEPTION

            WHEN OTHERS THEN

                LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao salvar as informações do ALVO. ALVO: ' || p_OWNER || '.' || p_OBJECT_NAME || ' - Erro: ' || SQLERRM );
				
				RETURN FALSE;

        END;

    END;


END MANUTENCAO_ALVO;
/
