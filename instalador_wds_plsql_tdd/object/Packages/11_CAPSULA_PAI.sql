--
-- Um teste após criado é encapsulado várias vezes como uma "Matryoshka" ou "boneca russa".
-- Essa package cria a capsula final (Capsula Pai), essa capsula que realiza a chamada do Teste.
CREATE OR REPLACE PACKAGE CAPSULA_PAI AS
--
-- Um teste após criado é encapsulado várias vezes como uma "Matryoshka" ou "boneca russa".
-- Essa package cria a capsula final (Capsula Pai), essa capsula que realiza a chamada do Teste.
--
-- Autor: Wesley David Santos
-- Skype: wesleydavidsantos		
-- https://www.linkedin.com/in/wesleydavidsantos
--

	--
	-- Realiza o cadastro ou atualização de um teste
	FUNCTION ENCAPSULAR( p_TESTE_PRIMARIO_ID NUMBER ) RETURN BOOLEAN;

END CAPSULA_PAI;
/

CREATE OR REPLACE PACKAGE BODY CAPSULA_PAI AS
--
-- Autor: Wesley David Santos
-- Skype: wesleydavidsantos		
-- https://www.linkedin.com/in/wesleydavidsantos
--


    RAISE_ERRO_ENCONTRADO EXCEPTION;


    v_TESTE_PRIMARIO_ID NUMBER;


    v_NOME_CAPSULA_FILHA_TESTE VARCHAR2(200);


    v_FLAG_TRACE_TESTE_ATIVADO BOOLEAN;


    v_HIERARQUIA_INFO HIERARQUIA_TESTE.HIERARQUIA;


    FUNCTION GET_NOME_PROCEDURE_CAPSULA RETURN VARCHAR2 IS
    BEGIN

        RETURN REPLACE( CONSTANTES.PREFIXO_NOME_CAPSULA_PAI, '{TESTE_ID}', v_TESTE_PRIMARIO_ID );

    END;


    PROCEDURE ALTERAR_STATUS_COMPILADO( p_NOVO_STATUS IN CHAR ) AS
    -- Se uma TESTE vai passar pelo processo de ENCAPSULAR então ele deve ser marcado como Desencapsulado e só no final do processo marcado como ENCAPSULADO

    BEGIN

        BEGIN

            UPDATE
                TDD_CAPSULA_PAI
            SET
                 DATA_ALTERADO = SYSDATE
                ,ENCAPSULADO = p_NOVO_STATUS
            WHERE
                FK_TESTE_ID = v_TESTE_PRIMARIO_ID;

            COMMIT;

        EXCEPTION

            WHEN OTHERS THEN

                LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao alterar o Status de Compilado de um TESTE no processo de Ecapsulamento Pai. Teste Primário ID: ' || v_TESTE_PRIMARIO_ID || ' - Novo Status Compilado: ' || p_NOVO_STATUS || ' - Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                RAISE RAISE_ERRO_ENCONTRADO;

        END;

    END;


    FUNCTION GET_DDL_COMENTARIOS_DEV_CAPSULA_PAI RETURN CLOB IS
        
        v_DDL_COMENTARIO_DEV CLOB;

    BEGIN

        BEGIN
            
            v_DDL_COMENTARIO_DEV := '/*';
            v_DDL_COMENTARIO_DEV := v_DDL_COMENTARIO_DEV || CHR(10) || '                ';
            v_DDL_COMENTARIO_DEV := v_DDL_COMENTARIO_DEV || 'Procedure criada de forma automática para realizar teste de TDD';
            v_DDL_COMENTARIO_DEV := v_DDL_COMENTARIO_DEV || CHR(10) || '                ';
            v_DDL_COMENTARIO_DEV := v_DDL_COMENTARIO_DEV || CHR(10) || '                ';
            v_DDL_COMENTARIO_DEV := v_DDL_COMENTARIO_DEV || 'Essa procedure é considerada a Capsula final contendo a execução do Teste TDD.';
            v_DDL_COMENTARIO_DEV := v_DDL_COMENTARIO_DEV || CHR(10) || '                ';
            v_DDL_COMENTARIO_DEV := v_DDL_COMENTARIO_DEV || 'A capsula final também agrupa as capsulas filha contendo os auxiliares dos processos que executam Antes e Depois do Teste TDD.';
            v_DDL_COMENTARIO_DEV := v_DDL_COMENTARIO_DEV || CHR(10) || '                ';
            v_DDL_COMENTARIO_DEV := v_DDL_COMENTARIO_DEV || '--';
            v_DDL_COMENTARIO_DEV := v_DDL_COMENTARIO_DEV || CHR(10) || '                ';
            v_DDL_COMENTARIO_DEV := v_DDL_COMENTARIO_DEV || '-- Autor: Wesley David Santos';
            v_DDL_COMENTARIO_DEV := v_DDL_COMENTARIO_DEV || CHR(10) || '                ';
            v_DDL_COMENTARIO_DEV := v_DDL_COMENTARIO_DEV || '-- Skype: wesleydavidsantos';
            v_DDL_COMENTARIO_DEV := v_DDL_COMENTARIO_DEV || CHR(10) || '                ';
            v_DDL_COMENTARIO_DEV := v_DDL_COMENTARIO_DEV || '-- https://www.linkedin.com/in/wesleydavidsantos';
            v_DDL_COMENTARIO_DEV := v_DDL_COMENTARIO_DEV || CHR(10) || '                ';
            v_DDL_COMENTARIO_DEV := v_DDL_COMENTARIO_DEV || '--';
            v_DDL_COMENTARIO_DEV := v_DDL_COMENTARIO_DEV || CHR(10) || '                ';
            v_DDL_COMENTARIO_DEV := v_DDL_COMENTARIO_DEV || '*/';

            RETURN v_DDL_COMENTARIO_DEV;

        EXCEPTION

            WHEN OTHERS THEN

                LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao criar os comentários que serão encapsulados ao cabeçalho do DDL da Capsula Pai. Teste Primário ID: ' || v_TESTE_PRIMARIO_ID );

                RAISE RAISE_ERRO_ENCONTRADO;

        END;

    END;



    FUNCTION GET_DDL_CRIA_COMENTARIOS_CAPSULA_FILHA( p_INFO_TESTE HIERARQUIA_TESTE.INFO_HIERARQUIA ) RETURN CLOB IS
        
        v_DDL_COMENTARIO CLOB;

    BEGIN

        BEGIN

            v_DDL_COMENTARIO := '/*';
            v_DDL_COMENTARIO := v_DDL_COMENTARIO || CHR(10) || '                ';
            v_DDL_COMENTARIO := v_DDL_COMENTARIO || 'Nome Teste: ' || p_INFO_TESTE.NOME_TESTE;
            v_DDL_COMENTARIO := v_DDL_COMENTARIO || CHR(10) || '                ';
            v_DDL_COMENTARIO := v_DDL_COMENTARIO || 'Info: ' || p_INFO_TESTE.INFO_TESTE;
            v_DDL_COMENTARIO := v_DDL_COMENTARIO || CHR(10) || '                ';
            v_DDL_COMENTARIO := v_DDL_COMENTARIO || 'Data Criado: ' || p_INFO_TESTE.DATA_REGISTRO_TESTE;
            v_DDL_COMENTARIO := v_DDL_COMENTARIO || CHR(10) || '                ';
            v_DDL_COMENTARIO := v_DDL_COMENTARIO || 'Data última alteração: ' || p_INFO_TESTE.DATA_ALTERADO_DDL;
            v_DDL_COMENTARIO := v_DDL_COMENTARIO || CHR(10) || '                ';
            v_DDL_COMENTARIO := v_DDL_COMENTARIO || 'Function que realiza o teste: ' || p_INFO_TESTE.ASSERCAO;
            v_DDL_COMENTARIO := v_DDL_COMENTARIO || CHR(10) || '                ';
            v_DDL_COMENTARIO := v_DDL_COMENTARIO || 'Versão Teste: ' || p_INFO_TESTE.VERSAO_TESTE;
            v_DDL_COMENTARIO := v_DDL_COMENTARIO || CHR(10) || '                ';
            v_DDL_COMENTARIO := v_DDL_COMENTARIO || '*/';


            RETURN v_DDL_COMENTARIO;

        EXCEPTION

            WHEN OTHERS THEN

                LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao criar os comentários que serão encapsulados ao DDL da Capsula Filha. Function teste: ' || p_INFO_TESTE.CAPSULA_FILHA );

                RAISE RAISE_ERRO_ENCONTRADO;

        END;

    END;



    FUNCTION GET_DDL_CRIAR_JOB_TRACE( p_NOME_CAPSULA_FILHA IN VARCHAR2 ) RETURN CLOB IS

        V_DDL_CRIAR_JOB_TRACE CLOB;

        v_DDL_TRACE CLOB;

    BEGIN

        BEGIN


            v_DDL_CRIAR_JOB_TRACE := '
                                                    BEGIN
                                                    
                                                        GERENCIAR_TRACE.ATIVAR_TRACE( {PREFIXO_NOME_TRACE}, {PARAMETRO_ID_EXECUCAO_CAPSULA} );

                                                        {NOME_CAPSULA_FILHA}( {PARAMETRO_ID_EXECUCAO_CAPSULA}, {PARAMETRO_ACAO_CAPSULA} );

                                                        GERENCIAR_TRACE.DESATIVAR_TRACE;

                                                    END;';
                


            v_DDL_TRACE := '
                -- Coleta de TRACE ativada para esse TESTE.
                -- Essa procedure cria o JOB para executar o TRACE.
                PROCEDURE CRIAR_JOB( p_NOME_JOB_TESTE IN VARCHAR2, p_ID_EXECUCAO IN NUMBER ) AS
                BEGIN

                    BEGIN

                        BEGIN

                            SYS.DBMS_SCHEDULER.create_job (
                                job_name        => p_NOME_JOB_TESTE,
                                job_type        => {JOB_TYPE},
                                job_action      => {JOB_ACTION},
                                start_date      => SYSTIMESTAMP,
                                enabled         => FALSE
                            );

                        END;
                    
                    EXCEPTION

                        WHEN OTHERS THEN

                            LOG_GERENCIADOR.ADD_ERRO( {LOG_GERENCIADOR_TIPO_ERRO}, {MENSAGEM_LOG_ERRO} || SQLERRM || '' - '' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                    END;

                END;';



            -- Defini o tipo de JOB
            v_DDL_TRACE := REPLACE( v_DDL_TRACE, '{JOB_TYPE}', DBMS_ASSERT.ENQUOTE_LITERAL( 'PLSQL_BLOCK' ) );

            -- Informa o tipo de Erro do Log do Gerenciador
            v_DDL_TRACE := REPLACE( v_DDL_TRACE, '{LOG_GERENCIADOR_TIPO_ERRO}', DBMS_ASSERT.ENQUOTE_LITERAL( 'SISTEMA' ) );

            -- Informa a mensagem de Erro do Log do Gerenciador
            v_DDL_TRACE := REPLACE( v_DDL_TRACE, '{MENSAGEM_LOG_ERRO}', DBMS_ASSERT.ENQUOTE_LITERAL( 'Falha ao criar o Job de Teste com Trace. Capsula Filha Teste: ' || p_NOME_CAPSULA_FILHA ) );

            -- Defini o DDL do teste que será realizado
            v_DDL_TRACE := REPLACE( v_DDL_TRACE, '{JOB_ACTION}', DBMS_ASSERT.ENQUOTE_LITERAL( v_DDL_CRIAR_JOB_TRACE ) );

            -- Informa o nome da Capsula Filha que será executada
            v_DDL_TRACE := REPLACE( v_DDL_TRACE, '{NOME_CAPSULA_FILHA}', p_NOME_CAPSULA_FILHA );

            -- Informa o nome do aquivo de TRACE
            v_DDL_TRACE := REPLACE( v_DDL_TRACE, '{PREFIXO_NOME_TRACE}', '''' || DBMS_ASSERT.ENQUOTE_LITERAL( REPLACE( p_NOME_CAPSULA_FILHA, 'CAPSULA_FILHA_T_', '' ) ) || '''' );

            -- Informa o parâmetro repassado para a Capsula Filha de Teste
            v_DDL_TRACE := REPLACE( v_DDL_TRACE, '{PARAMETRO_ACAO_CAPSULA}', '''' || DBMS_ASSERT.ENQUOTE_LITERAL( 'TESTE' ) || '''' );

            -- Informa o parâmetro repassado para a Capsula Filha de Teste
            v_DDL_TRACE := REPLACE( v_DDL_TRACE, '{PARAMETRO_ID_EXECUCAO_CAPSULA}', '''' || ' || p_ID_EXECUCAO || ' || '''' );


            RETURN v_DDL_TRACE;

        EXCEPTION

            WHEN OTHERS THEN

                LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao criar o DDL contendo o Job de execução do Trace do Teste. Teste Primário ID: ' || v_TESTE_PRIMARIO_ID );

                RAISE RAISE_ERRO_ENCONTRADO;


        END;

    END;
    


    FUNCTION GET_DDL_TESTE_COM_TRACE( p_NOME_CAPSULA_FILHA IN VARCHAR2 ) RETURN CLOB IS
    
        v_DDL_TRACE CLOB;

        v_DDL_CRIAR_JOB_TRACE CLOB;

        v_DDL_TESTE_TRACE CLOB;

    BEGIN

        BEGIN

            
            IF NOT v_FLAG_TRACE_TESTE_ATIVADO THEN

                RETURN v_DDL_TRACE;

            END IF;


            v_DDL_CRIAR_JOB_TRACE := GET_DDL_CRIAR_JOB_TRACE( p_NOME_CAPSULA_FILHA );



            v_DDL_TRACE := '
                -- Coleta de TRACE ativada para esse TESTE.
                -- A coleta do TRACE é realizada via execução de JOB, desta forma possibilita uma coleta mais limpa.
                PROCEDURE TESTE_COM_TRACE( p_ID_EXECUCAO IN NUMBER, p_NOME_CAPSULA_TESTE IN VARCHAR2 ) AS

                    RAISE_ERRO_ENCONTRADO EXCEPTION;

                    v_NOME_JOB_TESTE VARCHAR2(36);

                BEGIN

                    BEGIN

                        v_NOME_JOB_TESTE := GERAR_NOME_TRACE( {PARAMENTRO_NOME_JOB} );

                        BEGIN 
                            
                            CRIAR_JOB( v_NOME_JOB_TESTE, p_ID_EXECUCAO );
                        
                        EXCEPTION

                            WHEN OTHERS THEN

                                RAISE RAISE_ERRO_ENCONTRADO;

                        END;
                        
                        
                        DBMS_SCHEDULER.RUN_JOB( v_NOME_JOB_TESTE, TRUE);


                        DBMS_SCHEDULER.DROP_JOB(job_name => v_NOME_JOB_TESTE, defer => false, force => true);
                        
                    
                    EXCEPTION

                        WHEN RAISE_ERRO_ENCONTRADO THEN

                            NULL;

                        WHEN OTHERS THEN

                            LOG_GERENCIADOR.ADD_ERRO( {LOG_GERENCIADOR_TIPO_ERRO}, {MENSAGEM_LOG_ERRO} || SQLERRM || '' - '' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                    END;

                END;';





            -- Informa o nome do JOB que será criado
            v_DDL_TRACE := REPLACE( v_DDL_TRACE, '{PARAMENTRO_NOME_JOB}', DBMS_ASSERT.ENQUOTE_LITERAL( v_TESTE_PRIMARIO_ID ) );

            -- Informa o tipo de Erro do Log do Gerenciador
            v_DDL_TRACE := REPLACE( v_DDL_TRACE, '{LOG_GERENCIADOR_TIPO_ERRO}', DBMS_ASSERT.ENQUOTE_LITERAL( 'SISTEMA' ) );

            -- Informa a mensagem de Erro do Log do Gerenciador
            v_DDL_TRACE := REPLACE( v_DDL_TRACE, '{MENSAGEM_LOG_ERRO}', DBMS_ASSERT.ENQUOTE_LITERAL( 'Falha ao executar o Job de Teste com Trace. Capsula Filha Teste: ' || p_NOME_CAPSULA_FILHA ) );


            
            RETURN ( v_DDL_CRIAR_JOB_TRACE || CHR(10) || CHR(10) || v_DDL_TRACE );


        EXCEPTION

            WHEN OTHERS THEN

                LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao criar o DDL contendo o Job de execução do Trace do Teste. Teste Primário ID: ' || v_TESTE_PRIMARIO_ID );

                RAISE RAISE_ERRO_ENCONTRADO;


        END;

    END;




    FUNCTION GET_DDL_CAPSULA_FILHA( p_INFO_TESTE HIERARQUIA_TESTE.INFO_HIERARQUIA ) RETURN CLOB IS

        v_DDL_CORPO CLOB;

        v_NOME_CAPSULA_FILHA VARCHAR2(200);

        v_VALOR_PARAMETRO_CAPSULA VARCHAR2(200);

    BEGIN

        BEGIN

            v_DDL_CORPO :='

                -- Inicio processamento capsula filha - Tipo Ação: {TIPO_ACAO}
                BEGIN
                
                    {LOCAL_COMENTARIOS}

                    {NOME_CAPSULA_FILHA}( v_ID_EXECUCAO, {VALOR_PARAMETRO_CAPSULA} );

                EXCEPTION

                    WHEN OTHERS THEN

                        NULL;

                END;
                -- Fim processamento capsula filha
            
            ';


            v_NOME_CAPSULA_FILHA := p_INFO_TESTE.CAPSULA_FILHA;

            v_VALOR_PARAMETRO_CAPSULA := p_INFO_TESTE.ACAO;


            -- Se o Trace está ativado, então a chamada é realizada de forma diferente
            IF v_FLAG_TRACE_TESTE_ATIVADO AND p_INFO_TESTE.ACAO = 'TESTE' THEN

                v_NOME_CAPSULA_FILHA_TESTE := p_INFO_TESTE.CAPSULA_FILHA;

                v_NOME_CAPSULA_FILHA := 'TESTE_COM_TRACE';

                v_VALOR_PARAMETRO_CAPSULA := p_INFO_TESTE.CAPSULA_FILHA;

            END IF;



            v_DDL_CORPO := REPLACE( v_DDL_CORPO, '{TIPO_ACAO}', p_INFO_TESTE.ACAO );

            v_DDL_CORPO := REPLACE( v_DDL_CORPO, '{LOCAL_COMENTARIOS}', GET_DDL_CRIA_COMENTARIOS_CAPSULA_FILHA( p_INFO_TESTE ) );

            v_DDL_CORPO := REPLACE( v_DDL_CORPO, '{NOME_CAPSULA_FILHA}', v_NOME_CAPSULA_FILHA );

            v_DDL_CORPO := REPLACE( v_DDL_CORPO, '{VALOR_PARAMETRO_CAPSULA}', DBMS_ASSERT.ENQUOTE_LITERAL( v_VALOR_PARAMETRO_CAPSULA ) );


            RETURN v_DDL_CORPO;

        EXCEPTION

            WHEN OTHERS THEN

                LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao criar o DDL contendo o Corpo da Capsula Filha. Teste Primário ID: ' || v_TESTE_PRIMARIO_ID );

                RAISE RAISE_ERRO_ENCONTRADO;

        END;

    END;



    FUNCTION CRIA_DDL_HIERARQUIA RETURN CLOB IS

        v_DDL_CORPO_CAPSULA_FILHA CLOB;

        v_DDL_CORPO_CAPSULA CLOB;

    BEGIN

        BEGIN


            FOR v_INDEX IN 1..v_HIERARQUIA_INFO.COUNT LOOP

                
                v_DDL_CORPO_CAPSULA_FILHA := GET_DDL_CAPSULA_FILHA( v_HIERARQUIA_INFO( v_INDEX ) );

                IF v_DDL_CORPO_CAPSULA IS NULL THEN

                    v_DDL_CORPO_CAPSULA := v_DDL_CORPO_CAPSULA_FILHA;

                ELSE

                    v_DDL_CORPO_CAPSULA := v_DDL_CORPO_CAPSULA || v_DDL_CORPO_CAPSULA_FILHA;

                END IF;

                
            END LOOP;


            RETURN v_DDL_CORPO_CAPSULA;


        EXCEPTION

            WHEN OTHERS THEN

                LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha no processo de criar o DDL da Hierarquia das Capsulas Filha. TESTE_ID ' || v_TESTE_PRIMARIO_ID || ' - Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                RAISE RAISE_ERRO_ENCONTRADO;

        END;

    END;



    PROCEDURE COMPILAR_CAPSULA AS

        v_DDL_CAPSULA CLOB;

    BEGIN

        BEGIN

            
            v_DDL_CAPSULA :='CREATE OR REPLACE PROCEDURE {LOCAL_NOME_CAPSULA_TESTE_PAI} AS';

                v_DDL_CAPSULA := v_DDL_CAPSULA || CHR(10) || '                ';
                
                v_DDL_CAPSULA := v_DDL_CAPSULA || '{LOCAL_COMENTARIOS}';

                v_DDL_CAPSULA := v_DDL_CAPSULA || CHR(10) || '                ';

                v_DDL_CAPSULA := v_DDL_CAPSULA || 'v_ID_EXECUCAO NUMBER;';

                v_DDL_CAPSULA := v_DDL_CAPSULA || CHR(10);

                v_DDL_CAPSULA := v_DDL_CAPSULA || CHR(10) || '                ';

                v_DDL_CAPSULA := v_DDL_CAPSULA || '{LOCAL_TESTE_COM_TRACE_ATIVADO}';

                v_DDL_CAPSULA := v_DDL_CAPSULA || CHR(10);

            v_DDL_CAPSULA := v_DDL_CAPSULA || 'BEGIN';

                v_DDL_CAPSULA := v_DDL_CAPSULA || CHR(10);

                v_DDL_CAPSULA := v_DDL_CAPSULA || CHR(10) || '                ';

                v_DDL_CAPSULA := v_DDL_CAPSULA || 'v_ID_EXECUCAO := GERAR_CODIGO;';

                v_DDL_CAPSULA := v_DDL_CAPSULA || CHR(10) || '                ';

                v_DDL_CAPSULA := v_DDL_CAPSULA || '{CORPO_CAPSULA_FILHA}';

                v_DDL_CAPSULA := v_DDL_CAPSULA || CHR(10);

            v_DDL_CAPSULA := v_DDL_CAPSULA || 'END;';




            v_DDL_CAPSULA := REPLACE( v_DDL_CAPSULA, '{LOCAL_NOME_CAPSULA_TESTE_PAI}', REPLACE( CONSTANTES.PREFIXO_NOME_CAPSULA_PAI, '{TESTE_ID}', v_TESTE_PRIMARIO_ID ) );

            v_DDL_CAPSULA := REPLACE( v_DDL_CAPSULA, '{LOCAL_COMENTARIOS}', GET_DDL_COMENTARIOS_DEV_CAPSULA_PAI );

            v_DDL_CAPSULA := REPLACE( v_DDL_CAPSULA, '{CORPO_CAPSULA_FILHA}', CRIA_DDL_HIERARQUIA );

            v_DDL_CAPSULA := REPLACE( v_DDL_CAPSULA, '{LOCAL_TESTE_COM_TRACE_ATIVADO}', GET_DDL_TESTE_COM_TRACE( v_NOME_CAPSULA_FILHA_TESTE ) );

                        

            EXECUTE IMMEDIATE v_DDL_CAPSULA;

        EXCEPTION

            WHEN OTHERS THEN

                LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha no processo de compilar a Capsula Pai. TESTE_ID ' || v_TESTE_PRIMARIO_ID || ' - Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                RAISE RAISE_ERRO_ENCONTRADO;

        END;
    END;



    FUNCTION PERMITIDO_ENCAPSULAR_PAI RETURN BOOLEAN IS

        v_PATRIARCA_TESTE_ID NUMBER;

        v_FLAG_VALIDA NUMBER;

    BEGIN

        BEGIN


            BEGIN
                -- Primeiro verifica se existe hierarquia de testes, senão ele é considerado um teste Solitário, desta forma somente valida se ele é um AUXILIAR ou não.

            
                SELECT
                    PATRIARCA_TESTE_ID INTO v_PATRIARCA_TESTE_ID
                FROM
                    VW_HIERARQUIA_TESTE
                WHERE
                    PATRIARCA_TESTE_ID = v_TESTE_PRIMARIO_ID
                    AND ROWNUM = 1;


                
                SELECT
                    COUNT(1) INTO v_FLAG_VALIDA
                FROM
                    VW_HIERARQUIA_TESTE
                WHERE
                    PATRIARCA_TESTE_ID = v_TESTE_PRIMARIO_ID
                    AND PAI_TESTE_ATIVADO = 'Y'
                    AND CAPSULA_PAI_ENCAPSULADO = 'N'
                    AND FILHA_TESTE_ATIVADO = 'Y'
                    AND CAPSULA_FILHA_ENCAPSULADO = 'Y';


            EXCEPTION

                WHEN NO_DATA_FOUND THEN

                    SELECT
                        COUNT(1) INTO v_FLAG_VALIDA
                    FROM
                        TESTE
                    WHERE
                        ID = v_TESTE_PRIMARIO_ID
                        AND ATIVADO = 'Y'
                        AND AUXILIAR = 'N';

            END;



            RETURN v_FLAG_VALIDA > 0;

            

        EXCEPTION
            
            WHEN OTHERS THEN

                LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao verificar se o Teste Primário é valido no processo de criar CAPSULA_PAI. TESTE_ID ' || v_TESTE_PRIMARIO_ID || ' - Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                RAISE RAISE_ERRO_ENCONTRADO;

        END;

    END;


    FUNCTION VALIDA_TRACE_ATIVADO RETURN BOOLEAN IS

        v_TESTE_ID NUMBER;

        v_FLAG_TRACE_ATIVADO CHAR(1);

    BEGIN

        BEGIN

            v_TESTE_ID := v_TESTE_PRIMARIO_ID;


            SELECT
                TRACE_ATIVADO INTO v_FLAG_TRACE_ATIVADO
            FROM
                TDD_CAPSULA_PAI
            WHERE
                FK_TESTE_ID = v_TESTE_ID;

            
            RETURN v_FLAG_TRACE_ATIVADO = 'Y';

        EXCEPTION
            
            WHEN OTHERS THEN

                LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao verificar se o Teste Primário está com o Trace Ativado. TESTE_ID ' || v_TESTE_PRIMARIO_ID || ' - Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                RAISE RAISE_ERRO_ENCONTRADO;

        END;

    END;



    PROCEDURE DESCOMPILAR_CAPSULA AS
    -- Se uma TESTE vai passar pelo processo de COMPILAR então ele deve ser marcado como Descompilado e só no final do processo marcado como COMPILADO

        v_TESTE_ID NUMBER;        

    BEGIN

        BEGIN

            ALTERAR_STATUS_COMPILADO( 'N' );

        EXCEPTION

            WHEN OTHERS THEN

                LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao marcar um TESTE como descompilado antes de um processo de Encapsulamento Pai. Teste Primário ID: ' || v_TESTE_PRIMARIO_ID || ' - Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                RAISE RAISE_ERRO_ENCONTRADO;

        END;

    END;



	FUNCTION ENCAPSULAR( p_TESTE_PRIMARIO_ID NUMBER ) RETURN BOOLEAN IS
	BEGIN

        BEGIN

            v_NOME_CAPSULA_FILHA_TESTE := NULL;

            v_FLAG_TRACE_TESTE_ATIVADO := FALSE;

            v_TESTE_PRIMARIO_ID := p_TESTE_PRIMARIO_ID;

            IF NOT PERMITIDO_ENCAPSULAR_PAI THEN

                RETURN FALSE;

            END IF;



            IF NOT HIERARQUIA_TESTE.MONTAR( p_TESTE_PRIMARIO_ID ) THEN

                RETURN FALSE;

            END IF;



            v_FLAG_TRACE_TESTE_ATIVADO := VALIDA_TRACE_ATIVADO;


            v_HIERARQUIA_INFO := HIERARQUIA_TESTE.GET_HIERARQUIA;


            DESCOMPILAR_CAPSULA;


            COMPILAR_CAPSULA;

            
            ALTERAR_STATUS_COMPILADO( 'Y' );


            LOG_GERENCIADOR.ADD_SUCESSO( 'SISTEMA', 'Teste Principal encapsulado. Teste Primário: ' || GET_NOME_PROCEDURE_CAPSULA );


            RETURN TRUE;


        EXCEPTION

            WHEN OTHERS THEN

                RETURN FALSE;

        END;

	END;


END CAPSULA_PAI;
/


