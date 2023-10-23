--
-- Cria Hierarquia de execução das capsulas de teste
-- Essa Package vai retornar a estrutura de execução dos ANTES e DEPOIS de cada Teste que faz parte do processo
--
CREATE OR REPLACE PACKAGE HIERARQUIA_TESTE AS
--
-- Cria Hierarquia de execução das capsulas de teste
-- Essa Package vai retornar a estrutura de execução dos ANTES e DEPOIS de cada Teste que faz parte do processo
--
-- Autor: Wesley David Santos
-- Skype: wesleydavidsantos		
-- https://www.linkedin.com/in/wesleydavidsantos
--

	TYPE INFO_HIERARQUIA IS RECORD (
		 CAPSULA_FILHA VARCHAR2(200)
		,ACAO VARCHAR2(20)
        ,NOME_TESTE VARCHAR2(4000)
        ,INFO_TESTE VARCHAR2(4000)
        ,ASSERCAO VARCHAR2(4000)
        ,DATA_REGISTRO_TESTE VARCHAR2(4000)
        ,QUERY_ARGUMENTO VARCHAR2(4000)
        ,DATA_ALTERADO_DDL VARCHAR2(4000)
        ,VERSAO_TESTE VARCHAR2(4000)
	);

	
	TYPE HIERARQUIA IS TABLE OF INFO_HIERARQUIA INDEX BY BINARY_INTEGER;
	    
	--
	-- Realiza o cadastro ou atualização de um teste
	FUNCTION MONTAR( p_TESTE_ID IN NUMBER ) RETURN BOOLEAN;
	

    --
    -- Retorna a Hierarquia criada sobre um determinado TESTE
    FUNCTION GET_HIERARQUIA RETURN HIERARQUIA;

	
END HIERARQUIA_TESTE;
/



CREATE OR REPLACE PACKAGE BODY HIERARQUIA_TESTE AS
--
-- Autor: Wesley David Santos
-- Skype: wesleydavidsantos		
-- https://www.linkedin.com/in/wesleydavidsantos
--


    RAISE_ERRO_ENCONTRADO EXCEPTION;


	v_HIERARQUIA_INFO HIERARQUIA;


    v_INDEX_HIERARQUIA BINARY_INTEGER;



    FUNCTION GET_HIERARQUIA RETURN HIERARQUIA IS
    BEGIN

        RETURN v_HIERARQUIA_INFO;

    END;


    FUNCTION EXISTE_ANTES_DEPOIS( p_TESTE_ID IN NUMBER ) RETURN BOOLEAN IS

        v_TESTE_ID NUMBER;

        v_EXISTE_FILHA NUMBER;

    BEGIN

        BEGIN


            v_TESTE_ID := p_TESTE_ID;


            SELECT 
                COUNT(*) INTO v_EXISTE_FILHA
            FROM
                VW_HIERARQUIA_TESTE
            WHERE
                PATRIARCA_TESTE_ID = v_TESTE_ID 
                AND PAI_TESTE_ID = v_TESTE_ID;


            RETURN v_EXISTE_FILHA > 0;

        EXCEPTION

            WHEN NO_DATA_FOUND THEN

                --Não existe antes depois
                RETURN FALSE;


            WHEN OTHERS THEN

                 LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao validar se existe hierarquia. Teste Primário ID: ' || v_TESTE_ID || ' - Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );
                
                RAISE RAISE_ERRO_ENCONTRADO;

        END;

    END;



    PROCEDURE ADD_HIERARQUIA( p_TESTE_ID IN NUMBER, p_ACAO IN VARCHAR2 ) AS

        CURSOR c_TESTE_INFO( p_TESTE_ID IN NUMBER ) IS 
                                SELECT
                                    ID TESTE_ID
                                    ,T.NOME NOME_TESTE
                                    ,T.INFO INFO_TESTE
                                    ,T.ASSERCAO ASSERCAO
                                    ,T.DATA_REGISTRO DATA_REGISTRO_TESTE
                                    ,T.QUERY_ARGUMENTO QUERY_ARGUMENTO
                                    ,T.DATA_ALTERADO_DDL DATA_ALTERADO_DDL
                                    ,T.VERSAO_TESTE
                                FROM
                                    TESTE T
                                WHERE
                                    ID = p_TESTE_ID;


        v_TESTE_INFO c_TESTE_INFO%ROWTYPE;

    BEGIN

        BEGIN

            OPEN c_TESTE_INFO( p_TESTE_ID );
            FETCH c_TESTE_INFO INTO v_TESTE_INFO;
            CLOSE c_TESTE_INFO;


            v_INDEX_HIERARQUIA := v_HIERARQUIA_INFO.COUNT + 1;                    

            v_HIERARQUIA_INFO( v_INDEX_HIERARQUIA ).CAPSULA_FILHA := REPLACE( CONSTANTES.PREFIXO_NOME_CAPSULA_FILHA, '{TESTE_ID}', v_TESTE_INFO.TESTE_ID );

            v_HIERARQUIA_INFO( v_INDEX_HIERARQUIA ).ACAO := p_ACAO;

            v_HIERARQUIA_INFO( v_INDEX_HIERARQUIA ).NOME_TESTE := v_TESTE_INFO.NOME_TESTE;

            v_HIERARQUIA_INFO( v_INDEX_HIERARQUIA ).INFO_TESTE := v_TESTE_INFO.INFO_TESTE;

            v_HIERARQUIA_INFO( v_INDEX_HIERARQUIA ).ASSERCAO := v_TESTE_INFO.ASSERCAO;

            v_HIERARQUIA_INFO( v_INDEX_HIERARQUIA ).DATA_REGISTRO_TESTE := v_TESTE_INFO.DATA_REGISTRO_TESTE;

            v_HIERARQUIA_INFO( v_INDEX_HIERARQUIA ).QUERY_ARGUMENTO := v_TESTE_INFO.QUERY_ARGUMENTO;

            v_HIERARQUIA_INFO( v_INDEX_HIERARQUIA ).DATA_ALTERADO_DDL := v_TESTE_INFO.DATA_ALTERADO_DDL;

            v_HIERARQUIA_INFO( v_INDEX_HIERARQUIA ).VERSAO_TESTE := v_TESTE_INFO.VERSAO_TESTE;
            

        EXCEPTION

            WHEN OTHERS THEN

                LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao adicionar registro na hierarquia. Teste Primário ID: ' || p_TESTE_ID  || ' - Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                RAISE RAISE_ERRO_ENCONTRADO;

        END;


    END;



    FUNCTION CRIA_HIERARQUIA( p_TESTE_ID IN NUMBER, p_ACAO IN VARCHAR2 ) RETURN BOOLEAN IS

        CURSOR c_FILHAS( p_PAI_TESTE_ID NUMBER ) IS
                                                SELECT 
                                                     FILHA_TESTE_ID
                                                    ,FILHA_ACAO
                                                    ,NIVEL_HIERARQUIA
                                                    ,FILHA_POSICAO
                                                FROM
                                                    VW_HIERARQUIA_TESTE
                                                WHERE
                                                    PATRIARCA_TESTE_ID = p_PAI_TESTE_ID 
                                                    AND PAI_TESTE_ID = p_PAI_TESTE_ID;


        v_FILHAS c_FILHAS%ROWTYPE;

        v_TESTE_ID NUMBER;

        v_ACAO VARCHAR2(20);

        v_FILHA_TESTE_ID NUMBER;

        v_FLAG_PAI_ADD_HIERARQUIA BOOLEAN DEFAULT FALSE;

    BEGIN

        BEGIN


            v_TESTE_ID := p_TESTE_ID;

            v_ACAO := p_ACAO;


            OPEN c_FILHAS( v_TESTE_ID );
            LOOP
            FETCH c_FILHAS INTO v_FILHAS;
            EXIT WHEN c_FILHAS%NOTFOUND;


                IF NOT v_FLAG_PAI_ADD_HIERARQUIA AND v_FILHAS.FILHA_ACAO = 'DEPOIS' THEN

                    v_FLAG_PAI_ADD_HIERARQUIA := TRUE;

                    ADD_HIERARQUIA( v_TESTE_ID, v_ACAO );
                    
                END IF;

                
                --
                -- Chamada Recursiva, se o resultado vier como FALSE então é adicionado o TESTE atual, 
                -- senão, quer dizer que o teste já foi adicionado dentro da chamada recursiva
                IF NOT CRIA_HIERARQUIA( v_FILHAS.FILHA_TESTE_ID, v_FILHAS.FILHA_ACAO ) THEN

                    ADD_HIERARQUIA( v_FILHAS.FILHA_TESTE_ID, v_FILHAS.FILHA_ACAO );

                END IF;


            END LOOP;
            CLOSE c_FILHAS;

           
            RETURN v_FLAG_PAI_ADD_HIERARQUIA;


        EXCEPTION

            WHEN OTHERS THEN

                LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao iniciar a criação da hierarquia. Teste Primário ID: ' || p_TESTE_ID  || ' - Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                RAISE RAISE_ERRO_ENCONTRADO;

        END;


    END;



	FUNCTION MONTAR( p_TESTE_ID IN NUMBER ) RETURN BOOLEAN IS

        v_HIERARQUIA HIERARQUIA;


        v_FLAG_HIERARQUIA BOOLEAN;

        v_TESTE_ID NUMBER;

	BEGIN

        BEGIN

            v_HIERARQUIA_INFO := v_HIERARQUIA;


            v_TESTE_ID := p_TESTE_ID;
            

            IF EXISTE_ANTES_DEPOIS( v_TESTE_ID ) THEN

                -- Se o retorno for FALSE, então, não existe a ação do tipo DEPOIS, desta forma o TESTE PRINCIPAL deve ser adicionado na Hierarquia
                IF NOT CRIA_HIERARQUIA( v_TESTE_ID, 'TESTE' ) THEN

                    ADD_HIERARQUIA( v_TESTE_ID, 'TESTE' );

                END IF;


                v_FLAG_HIERARQUIA := v_HIERARQUIA_INFO.COUNT > 0;


            ELSE


                BEGIN
                    
                    ADD_HIERARQUIA( v_TESTE_ID, 'TESTE' );

                    v_FLAG_HIERARQUIA := TRUE;

                EXCEPTION

                    WHEN OTHERS THEN

                        v_FLAG_HIERARQUIA := FALSE;

                END;


            END IF;


            RETURN v_FLAG_HIERARQUIA;


        EXCEPTION

            WHEN RAISE_ERRO_ENCONTRADO THEN


                RETURN FALSE;


            WHEN OTHERS THEN

                LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao iniciar a montagem da hierarquia. Teste Primário ID: ' || p_TESTE_ID  || ' - Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                RETURN FALSE;


        END;

	END;


END HIERARQUIA_TESTE;
/


