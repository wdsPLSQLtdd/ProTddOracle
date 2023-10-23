--
-- Responsável por realizar o processamento e exportação dos Traces Gerados sobre os Testes TDD
CREATE OR REPLACE PACKAGE EXPORTADOR_TRACE AS
--
-- Responsável por realizar o processamento e exportação dos Traces Gerados sobre os Testes TDD
--
-- Autor: Wesley David Santos
-- Skype: wesleydavidsantos		
-- https://www.linkedin.com/in/wesleydavidsantos
--
	
    PROCEDURE IDENTIFICAR_NOVOS_TRACE;
		
	
END EXPORTADOR_TRACE;
/




CREATE OR REPLACE PACKAGE BODY EXPORTADOR_TRACE AS
--
-- Autor: Wesley David Santos
-- Skype: wesleydavidsantos		
-- https://www.linkedin.com/in/wesleydavidsantos
--

	RAISE_ERRO_ENCONTRADO EXCEPTION;


    v_TESTE_TRACE_ID NUMBER;

    v_TESTE_TRACE_ID_EXECUCAO NUMBER;



    v_NOME_TRACE_METADADOS VARCHAR2(100);



    PROCEDURE ALTERAR_SITUACAO_TRACE( p_ARQUIVO_TRACE IN VARCHAR2, p_NOVA_SITUACAO IN VARCHAR2 ) AS

        v_ARQUIVO_TRACE VARCHAR2(100);

        v_NOVA_SITUACAO VARCHAR2(100);

    BEGIN

        BEGIN

            v_ARQUIVO_TRACE := p_ARQUIVO_TRACE;


            v_NOVA_SITUACAO := p_NOVA_SITUACAO;


            UPDATE
                TRACE_METADADOS
            SET
                SITUACAO = v_NOVA_SITUACAO
            WHERE
                ARQUIVO = v_ARQUIVO_TRACE;


            COMMIT;


        EXCEPTION

            WHEN OTHERS THEN

                LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao alterar a situação na tabela TRACE_METADADOS. Arquivo Trace: ' || v_ARQUIVO_TRACE || '. Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                RAISE RAISE_ERRO_ENCONTRADO;

        END;


    END;



    FUNCTION LER_CONTEUDO_TRACE( p_NOME_ARQUIVO_TRACE IN VARCHAR2 ) RETURN BOOLEAN IS

        v_CONTROLADOR_TRACE UTL_FILE.FILE_TYPE;
        
        v_CONTEUDO_TRACE CLOB;

        v_DIRETORIO_TRACE VARCHAR2(100);
        
        v_NOME_TRACE VARCHAR2(100);

        v_TESTE_ID NUMBER;

        v_TESTE_ID_EXECUCAO NUMBER;

    BEGIN
        

        BEGIN

            v_TESTE_ID := v_TESTE_TRACE_ID;

            v_TESTE_ID_EXECUCAO := v_TESTE_TRACE_ID_EXECUCAO;

            v_NOME_TRACE := p_NOME_ARQUIVO_TRACE;

            v_DIRETORIO_TRACE := CONSTANTES.NOME_DIRETORIO_TRACE;

            v_CONTEUDO_TRACE := '';


            ALTERAR_SITUACAO_TRACE( v_NOME_TRACE_METADADOS, 'PROCESSANDO' );


            BEGIN

                v_CONTROLADOR_TRACE := UTL_FILE.FOPEN( ( v_DIRETORIO_TRACE ), v_NOME_TRACE, 'R');

            EXCEPTION

                WHEN OTHERS THEN

                    LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao realizar a abertura do arquivo de Trace processado. Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                    RAISE RAISE_ERRO_ENCONTRADO;

            END;

            

            --
            -- Realiza a leitura do arquivo de Trace
            BEGIN

                
                LOOP

                    UTL_FILE.GET_LINE( v_CONTROLADOR_TRACE, v_CONTEUDO_TRACE );

                    
                    INSERT INTO TRACE
                        ( FK_TESTE_ID, ID_EXECUCAO, NOME, CONTEUDO )
                    VALUES
                        ( v_TESTE_ID, v_TESTE_ID_EXECUCAO,  p_NOME_ARQUIVO_TRACE, REPLACE( v_CONTEUDO_TRACE, '[LINHA_EM_BRANCO]', ' ' ) );
                
                
                END LOOP;


            EXCEPTION
                
                WHEN NO_DATA_FOUND THEN
                    
                    COMMIT;


                    ALTERAR_SITUACAO_TRACE( v_NOME_TRACE_METADADOS, 'FINALIZADO' );


                    -- Chegou ao final do arquivo
                    RETURN TRUE;


                WHEN OTHERS THEN

                    ALTERAR_SITUACAO_TRACE( v_NOME_TRACE_METADADOS, 'ERRO' );

                    LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao realizar a leitura do arquivo de Trace processado. Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                    RETURN FALSE;

                    
            END;


        EXCEPTION

            WHEN RAISE_ERRO_ENCONTRADO THEN

                RETURN FALSE;


            WHEN OTHERS THEN

                LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha no processo de abertura e leitura do arquivo de Trace processado. Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                RETURN FALSE;

        END;



    END;


    FUNCTION VALIDA_USO_TRACE( p_NOME_ARQUIVO_TRACE IN VARCHAR2 ) RETURN BOOLEAN IS
        
        CURSOR c_IDENTIFICA_TRACE( p_NOME_TRACE VARCHAR2 ) IS
                                    SELECT
                                         FK_TESTE_ID
                                        ,ID_EXECUCAO
                                    FROM
                                        TRACE_METADADOS
                                    WHERE
                                        ARQUIVO = p_NOME_TRACE
                                        AND SITUACAO = 'COLETADO';

        
        v_IDENTIFICA_TRACE c_IDENTIFICA_TRACE%ROWTYPE;
        
        v_NOME_ARQUIVO_TRACE VARCHAR2(100);

        v_NOME_TRACE VARCHAR2(100);

        v_FLAG_VALIDA_EXISTE NUMBER;

    BEGIN

        BEGIN


            v_NOME_TRACE_METADADOS := '';

            
            v_NOME_ARQUIVO_TRACE := p_NOME_ARQUIVO_TRACE;


            --
            -- Verifica se o Trace já foi cadastrado anteriormente
            BEGIN

                SELECT
                    COUNT(1) INTO v_FLAG_VALIDA_EXISTE
                FROM
                    TRACE
                WHERE
                    NOME = v_NOME_ARQUIVO_TRACE;


                IF v_FLAG_VALIDA_EXISTE > 0 THEN

                    RETURN FALSE;

                END IF;

            EXCEPTION

                WHEN OTHERS THEN

                    LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao validar se um Trace já foi registrado na tabela TRACE. Nome Trace: ' || v_NOME_ARQUIVO_TRACE || ' - Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                    RAISE RAISE_ERRO_ENCONTRADO;


            END;



            BEGIN

                
                SELECT
                    DISTINCT
                    REPLACE( SUBSTR( v_NOME_ARQUIVO_TRACE, INSTR( v_NOME_ARQUIVO_TRACE, 'WDS_T_'), LENGTH( v_NOME_ARQUIVO_TRACE )), '.trc', '' ) INTO v_NOME_TRACE
                FROM 
                    DUAL;
                

                
                v_NOME_TRACE_METADADOS := v_NOME_TRACE;


                --
                -- Identifica a qual Teste o Trace pertence
                BEGIN


                    OPEN c_IDENTIFICA_TRACE( v_NOME_TRACE );
                    FETCH c_IDENTIFICA_TRACE INTO v_IDENTIFICA_TRACE;
                    CLOSE c_IDENTIFICA_TRACE;
                    

                    v_TESTE_TRACE_ID := v_IDENTIFICA_TRACE.FK_TESTE_ID;

                    v_TESTE_TRACE_ID_EXECUCAO := v_IDENTIFICA_TRACE.ID_EXECUCAO;


                    RETURN TRUE;


                EXCEPTION

                    WHEN NO_DATA_FOUND THEN

                        RETURN FALSE;

                END;


            EXCEPTION

                
                WHEN OTHERS THEN

                    LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao validar se um Trace já foi registrado na tabela TRACE. Nome Trace: ' || v_NOME_ARQUIVO_TRACE || ' - Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                    RAISE RAISE_ERRO_ENCONTRADO;


            END;


        EXCEPTION

            WHEN OTHERS THEN

                RETURN FALSE;


        END;



    END;



    FUNCTION INICIAR_COLETA RETURN BOOLEAN IS

        CURSOR c_RESULTADO_TKPROF IS
                                SELECT
                                    OUTPUT
                                FROM
                                    SHELL_EXECUTAR_TKPROF_TRACE;
                    

        v_RESULTADO_TKPROF c_RESULTADO_TKPROF%ROWTYPE;

        v_FLAG_VALIDA_COLETA BOOLEAN DEFAULT FALSE;

        v_NOME_ARQUIVO_TRACE VARCHAR2(100);

    BEGIN

        BEGIN

            OPEN c_RESULTADO_TKPROF;
            LOOP
            FETCH c_RESULTADO_TKPROF INTO v_RESULTADO_TKPROF;
            EXIT WHEN c_RESULTADO_TKPROF%NOTFOUND;


                IF v_RESULTADO_TKPROF.OUTPUT = 'ERRO' THEN
                    
                    RETURN FALSE;

                END IF;


                v_NOME_ARQUIVO_TRACE := v_RESULTADO_TKPROF.OUTPUT;


                v_FLAG_VALIDA_COLETA := TRUE;


            END LOOP;
            CLOSE c_RESULTADO_TKPROF;




            IF NOT v_FLAG_VALIDA_COLETA THEN

                RETURN FALSE;

            END IF;



            IF NOT VALIDA_USO_TRACE( v_NOME_ARQUIVO_TRACE ) THEN

                RETURN FALSE;

            END IF;



            RETURN LER_CONTEUDO_TRACE( v_NOME_ARQUIVO_TRACE );



        EXCEPTION

            WHEN OTHERS THEN

                LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao chamar a tabela que executa o TKPROF. Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                RETURN FALSE;

        END;


    END;



    PROCEDURE IDENTIFICAR_NOVOS_TRACE AS

        CURSOR c_LISTA_NOVOS_TRACE IS
                            SELECT
                                 FK_TESTE_ID TESTE_ID
                                ,ARQUIVO
                            FROM
                                TRACE_METADADOS
                            WHERE
                                SITUACAO = 'COLETADO';


        v_LISTA_NOVOS_TRACE c_LISTA_NOVOS_TRACE%ROWTYPE;

    BEGIN

        BEGIN


            OPEN c_LISTA_NOVOS_TRACE;
            LOOP
            FETCH c_LISTA_NOVOS_TRACE INTO v_LISTA_NOVOS_TRACE;
            EXIT WHEN c_LISTA_NOVOS_TRACE%NOTFOUND;

                
                IF NOT INICIAR_COLETA THEN

                    LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao Processar via TKPROF e Coletar os dados gerados via Trace.' );

                    
                    ALTERAR_SITUACAO_TRACE( v_NOME_TRACE_METADADOS, 'ERRO' );


                END IF;


            END LOOP;
            CLOSE c_LISTA_NOVOS_TRACE;




            -- Se  não foi identificado nenhum dos traces, então eles são apresentados como erro
            OPEN c_LISTA_NOVOS_TRACE;
            LOOP
            FETCH c_LISTA_NOVOS_TRACE INTO v_LISTA_NOVOS_TRACE;
            EXIT WHEN c_LISTA_NOVOS_TRACE%NOTFOUND;

                ALTERAR_SITUACAO_TRACE( v_LISTA_NOVOS_TRACE.ARQUIVO, 'ERRO' );

            END LOOP;
            CLOSE c_LISTA_NOVOS_TRACE;            
            


        EXCEPTION

            WHEN OTHERS THEN

                LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha no processo de identificar novos Traces gerados. Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                RAISE RAISE_ERRO_ENCONTRADO;

        END;

    END;

END;
/
