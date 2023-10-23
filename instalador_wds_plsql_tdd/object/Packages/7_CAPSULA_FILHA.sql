--
-- Um teste após criado é encapsulado várias vezes como uma "Matryoshka" ou "boneca russa".
-- Essa package cria a primeira capsula (Capsula Filha), essa capsula que realiza a chamada do Teste criado pelo Dev.
CREATE OR REPLACE PACKAGE CAPSULA_FILHA AS
--
-- Um teste após criado é encapsulado várias vezes como uma "Matryoshka" ou "boneca russa".
-- Essa package cria a primeira capsula (Capsula Filha), essa capsula que realiza a chamada do Teste criado pelo Dev.
--
-- Autor: Wesley David Santos
-- Skype: wesleydavidsantos		
-- https://www.linkedin.com/in/wesleydavidsantos
--

    --
	-- Realiza o primeiro encapsulamento
	FUNCTION ENCAPSULAR( p_ASSERCAO VARCHAR2 ) RETURN BOOLEAN;
	
	
END CAPSULA_FILHA;
/



CREATE OR REPLACE PACKAGE BODY CAPSULA_FILHA AS
--
-- Autor: Wesley David Santos
-- Skype: wesleydavidsantos		
-- https://www.linkedin.com/in/wesleydavidsantos
--

    CURSOR c_COLETA_TESTE( p_ASSERCAO VARCHAR2 ) IS SELECT
                                T.ID TESTE_ID
                                ,A.OWNER ALVO_OWNER
                                ,A.OBJECT_NAME ALVO_OBJECT_NAME
                                ,T.NOME NOME_TESTE
                                ,T.INFO INFO_TESTE
                                ,T.DATA_REGISTRO DATA_REGISTRO_TESTE
                                ,T.DATA_ALTERADO_DDL DATA_ALTERADO_DDL_TESTE
                                ,T.ASSERCAO ASSERCAO
                                ,T.QUERY_ARGUMENTO QUERY_ARGUMENTO
                                ,T.VERSAO_TESTE VERSAO_TESTE
                            FROM
                                TESTE T
                                INNER JOIN ALVO A ON A.ID = T.FK_ALVO_ID
                            WHERE
                                T.ASSERCAO = p_ASSERCAO;

    TESTE c_COLETA_TESTE%ROWTYPE;

    v_QUERY_ARGUMENTO VARCHAR2(4000) DEFAULT NULL;

    RAISE_ERRO_ENCONTRADO EXCEPTION;


    FUNCTION GET_NOME_PROCEDURE_CAPSULA RETURN VARCHAR2 IS
    BEGIN

        RETURN REPLACE( CONSTANTES.PREFIXO_NOME_CAPSULA_FILHA, '{TESTE_ID}', TESTE.TESTE_ID );

    END;


    PROCEDURE COLETAR_INFO_TESTE( p_ASSERCAO VARCHAR2 ) AS

        v_TESTE_ENCONTRADO BOOLEAN DEFAULT TRUE;

        RAISE_ERRO_TESTE_NAO_ENCONTRADO EXCEPTION;

    BEGIN

        BEGIN
        
            OPEN c_COLETA_TESTE( p_ASSERCAO );
            FETCH c_COLETA_TESTE INTO TESTE;

                IF c_COLETA_TESTE%NOTFOUND THEN

                    v_TESTE_ENCONTRADO := FALSE;

                END IF;

            CLOSE c_COLETA_TESTE;

            IF NOT v_TESTE_ENCONTRADO THEN

                RAISE RAISE_ERRO_TESTE_NAO_ENCONTRADO;

            END IF;

        EXCEPTION

            WHEN RAISE_ERRO_TESTE_NAO_ENCONTRADO THEN

                LOG_GERENCIADOR.ADD_ERRO( 'TESTE', 'Não foi identificado o nome da ASSERCAO na tabela TESTE no processo de Encapsulamento Filha. Function Asserção: ' || p_ASSERCAO );

                RAISE RAISE_ERRO_ENCONTRADO;


            WHEN OTHERS THEN

                LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao identificar o teste a ser Encapsulado no processo de Encapsulamento Filha. Function Asserção: ' || p_ASSERCAO );

                RAISE RAISE_ERRO_ENCONTRADO;

        END;

    END;


    FUNCTION GET_QUERY_ARGUMENTO( p_RETURN_TIPO_COUNT BOOLEAN ) RETURN CLOB IS

        v_QUERY CLOB;

        v_QUERY_ARGUMENTO CLOB;

        v_INDEX NUMBER;

        RAISE_ERRO_QUERY EXCEPTION;

    BEGIN

        BEGIN

            v_QUERY_ARGUMENTO := TESTE.QUERY_ARGUMENTO;


            IF p_RETURN_TIPO_COUNT THEN
    
                v_QUERY := 'SELECT COUNT(1) QTD FROM ( ' || v_QUERY_ARGUMENTO || ' )';
            
            ELSE

                v_INDEX := INSTR(v_QUERY_ARGUMENTO, 'SELECT', 1, 1);

                v_QUERY := SUBSTR(v_QUERY_ARGUMENTO, 1, v_INDEX - 1) || 'SELECT ROWID ROWID_WDS,' || SUBSTR(v_QUERY_ARGUMENTO, v_INDEX + 6);

            END IF;


            IF LENGTH( v_QUERY ) <= LENGTH( v_QUERY_ARGUMENTO ) THEN

                RAISE RAISE_ERRO_QUERY;

            END IF;


            RETURN v_QUERY;

        EXCEPTION

            WHEN RAISE_ERRO_QUERY THEN

                LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao manipular a Query do Argumento (json do teste) no processo de Encapsulamento Filha. Verifique se a query é válida. Function Teste: ' || TESTE.ASSERCAO );

                RAISE RAISE_ERRO_ENCONTRADO;

            
            WHEN OTHERS THEN

                LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha no processo de adaptar a Query do Argumento (json do teste) no processo de Encapsulamento Filha. Function Teste: ' || TESTE.ASSERCAO );

                RAISE RAISE_ERRO_ENCONTRADO;

        END;


    END;


    FUNCTION GET_DDL_ESCOPO_DECLARA_VARIAVEIS RETURN CLOB IS
    --
    -- Cria o escopo de variáveis que fazem parte da procedure que será criada para realizar o primeiro encapsulamento

        v_ASSERCAO VARCHAR2(200);

        v_QUERY_ARGUMENTO VARCHAR2(4000);

        v_ESCOPO_VARIAVEIS_FIXA CLOB;

        v_ESCOPO_VARIAVEIS_DINAMICA CLOB;

    BEGIN

        BEGIN

            v_ASSERCAO := TESTE.ASSERCAO;

            v_QUERY_ARGUMENTO := TESTE.QUERY_ARGUMENTO;


            v_ESCOPO_VARIAVEIS_FIXA := '
                --
                -- Variáveis Fixas
                --
                v_NOME_FUNCTION_TESTE CONSTANT VARCHAR2(200) := ' || DBMS_ASSERT.ENQUOTE_LITERAL( v_ASSERCAO ) || ';

                RAISE_ERRO_ENCONTRADO EXCEPTION;

                v_QTD_TESTE NUMBER DEFAULT 1;

                v_ROWID_USADO VARCHAR2(100) DEFAULT ' || DBMS_ASSERT.ENQUOTE_LITERAL( 'SEM_ROWID' ) || ';
                
                v_QTD_TESTE_REALIZADO NUMBER DEFAULT 0;
                
                v_QTD_TESTE_SUCESSO NUMBER DEFAULT 0;
                
                v_QTD_TESTE_FALHA NUMBER DEFAULT 0;
                
                v_QTD_RAISE_ERRO NUMBER DEFAULT 0;

                v_ACAO_TESTE VARCHAR2(4000);
				
				v_RESULTADO_TESTE BOOLEAN;

                v_SITUACAO_RESULTADO VARCHAR2(20);

                v_DATA_INICIO DATE DEFAULT SYSDATE;
                ';


            IF v_QUERY_ARGUMENTO IS NOT NULL THEN

                v_ESCOPO_VARIAVEIS_DINAMICA := '
                
                --
                -- Variáveis dinâmicas
                --
                CURSOR c_COUNT_SQL IS ' || GET_QUERY_ARGUMENTO( TRUE ) || ';
        
                CURSOR c_SQL IS ' || GET_QUERY_ARGUMENTO( FALSE ) || ';
        
                v_SQL c_SQL%ROWTYPE;
                ';

            END IF;

            
            RETURN v_ESCOPO_VARIAVEIS_FIXA || v_ESCOPO_VARIAVEIS_DINAMICA;

        
        EXCEPTION

            WHEN OTHERS THEN

                LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao encapsular o DDL da declaração das variáveis. Function teste: ' || TESTE.ASSERCAO || ' - Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                RAISE RAISE_ERRO_ENCONTRADO;

        END;
        
    END;



    FUNCTION GET_DDL_NOME_FUNCTION_ARGUMENTO RETURN CLOB IS

        v_DDL_FUNCTION CLOB;

        v_DDL_FUNCTION_TESTE VARCHAR2(4000);

        v_QUERY_ARGUMENTO VARCHAR2(4000);
        
        c_CURSOR_COLETA_COLUNAS NUMBER;
        
        v_NUM_COLUNAS NUMBER;
        
        v_INFO_TAB DBMS_SQL.DESC_TAB;
        
        v_NOME_COLUNA VARCHAR2(100);
        
        v_LISTA_PARAMETROS VARCHAR2(4000) DEFAULT NULL;

    BEGIN


        BEGIN

            v_DDL_FUNCTION := CONSTANTES.OWNER_WDS_TDD_TESTE || '.' || TESTE.ASSERCAO;

            v_QUERY_ARGUMENTO := TESTE.QUERY_ARGUMENTO;

            
            --
            -- Verifica se existe argumento, se não existir retorna somente o nome da function
            IF v_QUERY_ARGUMENTO IS NULL THEN

                RETURN v_DDL_FUNCTION;

            END IF;



            BEGIN

                --
                -- Inicia a coleta da lista de argumentos 
                c_CURSOR_COLETA_COLUNAS := DBMS_SQL.OPEN_CURSOR;

                DBMS_SQL.PARSE( c_CURSOR_COLETA_COLUNAS, v_QUERY_ARGUMENTO, DBMS_SQL.NATIVE);

                DBMS_SQL.DESCRIBE_COLUMNS(c_CURSOR_COLETA_COLUNAS, v_NUM_COLUNAS, v_INFO_TAB);


                FOR v_NUM IN 1..v_NUM_COLUNAS LOOP

                    v_NOME_COLUNA := v_INFO_TAB( v_NUM ).COL_NAME;

                    IF v_NOME_COLUNA = 'ROWID_WDS' THEN

                        CONTINUE;

                    END IF;


                    IF v_LISTA_PARAMETROS IS NULL THEN

                        v_LISTA_PARAMETROS := ' || DBMS_ASSERT.ENQUOTE_LITERAL( v_SQL.' || v_NOME_COLUNA || ' ) || ';

                    ELSE

                        v_LISTA_PARAMETROS := v_LISTA_PARAMETROS || ' '','' || DBMS_ASSERT.ENQUOTE_LITERAL( v_SQL.' || v_NOME_COLUNA || ' ) || ';

                    END IF;    


                END LOOP;

                DBMS_SQL.CLOSE_CURSOR( c_CURSOR_COLETA_COLUNAS );

                
                v_DDL_FUNCTION := v_DDL_FUNCTION || '( ''' ||  v_LISTA_PARAMETROS || ''' )';


                RETURN v_DDL_FUNCTION;


            EXCEPTION

                WHEN OTHERS THEN

                    LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao validar a query informada no JSON da Function de Teste. Function teste: ' || TESTE.ASSERCAO || ' - Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                    RAISE RAISE_ERRO_ENCONTRADO;

            END;


        EXCEPTION

            WHEN RAISE_ERRO_ENCONTRADO THEN

                RAISE RAISE_ERRO_ENCONTRADO;


            WHEN OTHERS THEN

                LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao coletar o nome da Function de Teste e a lista de argumentos. Function teste: ' || TESTE.ASSERCAO || ' - Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                RAISE RAISE_ERRO_ENCONTRADO;

        END;


    END;
    


    FUNCTION GET_DDL_CRIA_COMENTARIOS_CAPSULA RETURN CLOB IS
        
        v_DDL_COMENTARIO CLOB;

        v_DDL_COMENTARIO_DEV CLOB;

    BEGIN

        BEGIN

            v_DDL_COMENTARIO := '/*';
            v_DDL_COMENTARIO := v_DDL_COMENTARIO || CHR(10) || '                ';
            v_DDL_COMENTARIO := v_DDL_COMENTARIO || 'Nome Teste: ' || TESTE.NOME_TESTE;
            v_DDL_COMENTARIO := v_DDL_COMENTARIO || CHR(10) || '                ';
            v_DDL_COMENTARIO := v_DDL_COMENTARIO || 'Objeto testado: ' || TESTE.ALVO_OWNER || '.' || TESTE.ALVO_OBJECT_NAME;
            v_DDL_COMENTARIO := v_DDL_COMENTARIO || CHR(10) || '                ';
            v_DDL_COMENTARIO := v_DDL_COMENTARIO || 'Info: ' || TESTE.INFO_TESTE;
            v_DDL_COMENTARIO := v_DDL_COMENTARIO || CHR(10) || '                ';
            v_DDL_COMENTARIO := v_DDL_COMENTARIO || 'Data Criado: ' || TESTE.DATA_REGISTRO_TESTE;
            v_DDL_COMENTARIO := v_DDL_COMENTARIO || CHR(10) || '                ';
            v_DDL_COMENTARIO := v_DDL_COMENTARIO || 'Data última alteração: ' || TESTE.DATA_ALTERADO_DDL_TESTE;
            v_DDL_COMENTARIO := v_DDL_COMENTARIO || CHR(10) || '                ';
            v_DDL_COMENTARIO := v_DDL_COMENTARIO || 'Function que realiza o teste: ' || TESTE.ASSERCAO;
            v_DDL_COMENTARIO := v_DDL_COMENTARIO || CHR(10) || '                ';
            v_DDL_COMENTARIO := v_DDL_COMENTARIO || 'Versão Teste: ' || TESTE.VERSAO_TESTE;
            v_DDL_COMENTARIO := v_DDL_COMENTARIO || CHR(10) || '                ';
            v_DDL_COMENTARIO := v_DDL_COMENTARIO || '*/';

            
            v_DDL_COMENTARIO_DEV := '/*';
            v_DDL_COMENTARIO_DEV := v_DDL_COMENTARIO_DEV || CHR(10) || '                ';
            v_DDL_COMENTARIO_DEV := v_DDL_COMENTARIO_DEV || 'Procedure criada de forma automática para realizar testes de TDD';
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


            RETURN ( v_DDL_COMENTARIO || CHR(10) || CHR(10) || '                ' || v_DDL_COMENTARIO_DEV );

        EXCEPTION

            WHEN OTHERS THEN

                LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao criar os comentários que serão encapsulados ao DDL. Function teste: ' || TESTE.ASSERCAO );

                RAISE RAISE_ERRO_ENCONTRADO;

        END;

    END;



    FUNCTION GET_DDL_CORPO_CAPSULA RETURN CLOB IS

        v_DDL_CORPO CLOB;

    BEGIN

        BEGIN

            v_DDL_CORPO :='
            CREATE OR REPLACE PROCEDURE {LOCAL_NOME_CAPSULA_DE_TESTE}( p_ID_EXECUCAO IN NUMBER, p_TIPO_TESTE IN VARCHAR2 ) AS

                {LOCAL_COMENTARIOS}

                {LOCAL_VARIAVEIS}

            BEGIN


                BEGIN

                    BEGIN

                        --
                        -- Registra o tempo total de execução do TESTE
                        CRONOMETRO.EXCLUIR(' || DBMS_ASSERT.ENQUOTE_LITERAL( 'INICIO_TESTE' ) || ');
                        CRONOMETRO.INICIAR(' || DBMS_ASSERT.ENQUOTE_LITERAL( 'INICIO_TESTE' ) || ');

                        BEGIN

                            REGISTRA_EXECUCAO_TESTE.SET_TESTE_ID( v_NOME_FUNCTION_TESTE );

                        EXCEPTION
								
                            WHEN OTHERS THEN

                                LOG_GERENCIADOR.ADD_ERRO( ''SISTEMA'', 	
                                                                    ''Erro ao iniciar o TESTE. Verificque mensagem de erro anterior referente a esse teste: '' || DBMS_ASSERT.ENQUOTE_LITERAL( v_NOME_FUNCTION_TESTE ) || '' - Erro: ''
                                                                    || SQLERRM || '' - '' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                                        );

                                RAISE RAISE_ERRO_ENCONTRADO;

                        END;

                        
                    
                        {LOCAL_INICIO_CURSOR}
                        
                        
                            BEGIN

                                {LOCAL_SET_ROWID_USADO}
                            
                                v_QTD_TESTE_REALIZADO := v_QTD_TESTE_REALIZADO + 1;
                                
                                
                                CRONOMETRO.EXCLUIR(' || DBMS_ASSERT.ENQUOTE_LITERAL( 'CRON_TESTE' ) || ');
                                CRONOMETRO.INICIAR(' || DBMS_ASSERT.ENQUOTE_LITERAL( 'CRON_TESTE' ) || ');
                                

                                v_SITUACAO_RESULTADO := ' || DBMS_ASSERT.ENQUOTE_LITERAL( '' ) || ';


                                --
                                --/
                                --> Inicio do TESTE que será EXECUTADO e VALIDADO
                                --


                                BEGIN
																										
									-- Comando SQL dinâmico para chamar a função de teste e armazenar o resultado, isso evita problemas quando o objeto ALVO está descompilado
									-- Desta forma não gera dependência com o Objeto de teste
									v_ACAO_TESTE := ''BEGIN
															:1 := {LOCAL_NOME_FUNCTION_ARGUMENTO};
                                                      END;
													'';

												
									EXECUTE IMMEDIATE v_ACAO_TESTE USING OUT v_RESULTADO_TESTE;

                                    
                                    -- Valida o resultado do Teste
                                    IF v_RESULTADO_TESTE THEN

                                        v_SITUACAO_RESULTADO := ' || DBMS_ASSERT.ENQUOTE_LITERAL( 'SUCESSO' ) || ';
                                    
                                        v_QTD_TESTE_SUCESSO := v_QTD_TESTE_SUCESSO + 1;
                                    
                                    ELSE

                                        v_SITUACAO_RESULTADO := ' || DBMS_ASSERT.ENQUOTE_LITERAL( 'FALHA' ) || ';
                                    
                                        v_QTD_TESTE_FALHA := v_QTD_TESTE_FALHA + 1;
                                    
                                    END IF;

																		
								EXCEPTION
								
									WHEN OTHERS THEN

                                        v_SITUACAO_RESULTADO := ' || DBMS_ASSERT.ENQUOTE_LITERAL( 'RAISE_ERROR' ) || ';
										
										v_QTD_RAISE_ERRO := v_QTD_RAISE_ERRO + 1;

										REGISTRA_EXECUCAO_TESTE.RAISE_ERROR( p_ID_EXECUCAO, v_ROWID_USADO, ( SQLERRM || '' - '' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ) );
								
								END;

                                
                                --
                                -- Fim do TESTE que será EXECUTADO e VALIDADO
                                --\
                                --
                                
                                
                                CRONOMETRO.PARAR(' || DBMS_ASSERT.ENQUOTE_LITERAL( 'CRON_TESTE' ) || ');
                                
                                REGISTRA_EXECUCAO_TESTE.TEMPO_EXECUCAO( p_ID_EXECUCAO, v_SITUACAO_RESULTADO, v_ROWID_USADO, CRONOMETRO.GET_TEMPO(' || DBMS_ASSERT.ENQUOTE_LITERAL( 'CRON_TESTE' ) || ')  );
                                
                                
                            EXCEPTION
                                
                                WHEN OTHERS THEN

                                    LOG_GERENCIADOR.ADD_ERRO( ''SISTEMA'', 	
                                                                ''Erro na ação de chamada do Teste: '' || DBMS_ASSERT.ENQUOTE_LITERAL( v_NOME_FUNCTION_TESTE ) || '' - Erro: ''
                                                                 || SQLERRM || '' - '' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                                    );
                            
                            END;
                            
                        
                        {LOCAL_FIM_CURSOR}


                        -- Se o valor de v_QTD_TESTE for zero então não foi identificado registros referentes ao QUERY_ARGUMENTO do teste. Gerando assim erro. Necessário existir no mínimo um teste.
                        IF v_QTD_TESTE = 0 THEN

                            v_SITUACAO_RESULTADO := ' || DBMS_ASSERT.ENQUOTE_LITERAL( 'FALHA' ) || ';

                            v_QTD_TESTE_FALHA := 1;

                            REGISTRA_EXECUCAO_TESTE.TEMPO_EXECUCAO( p_ID_EXECUCAO, v_SITUACAO_RESULTADO, ' || DBMS_ASSERT.ENQUOTE_LITERAL( 'not found register - query_argumento' ) || ', CRONOMETRO.GET_TEMPO(' || DBMS_ASSERT.ENQUOTE_LITERAL( 'CRON_TESTE' ) || ')  );
                            

                        END IF;



                        CRONOMETRO.PARAR(' || DBMS_ASSERT.ENQUOTE_LITERAL( 'INICIO_TESTE' ) || ');
                        
                        
                        
                        REGISTRA_EXECUCAO_TESTE.NOVO_HISTORICO( 
                                                                     p_ID_EXECUCAO
                                                                    ,p_TIPO_TESTE
                                                                    ,v_DATA_INICIO
                                                                    ,v_QTD_TESTE
                                                                    ,v_QTD_TESTE_REALIZADO
                                                                    ,v_QTD_TESTE_SUCESSO
                                                                    ,v_QTD_TESTE_FALHA
                                                                    ,v_QTD_RAISE_ERRO
                                                                    , CRONOMETRO.GET_TEMPO(' || DBMS_ASSERT.ENQUOTE_LITERAL( 'INICIO_TESTE' ) || ') 
                                                               );
                        
                        
                        DBMS_OUTPUT.PUT_LINE( 
                                                ''Teste: '' || v_NOME_FUNCTION_TESTE 
                                                || 
                                                '' - Qtd. Teste: '' || v_QTD_TESTE
                                                ||
                                                '' - Qtd. Teste Realizado: '' || v_QTD_TESTE_REALIZADO
                                                ||
                                                '' - Qtd. Teste Sucesso: '' || v_QTD_TESTE_SUCESSO
                                                ||
                                                '' - Qtd. Teste Falha: '' || v_QTD_TESTE_FALHA
                                                ||
                                                '' - Qtd. Teste Raise Erro: '' || v_QTD_RAISE_ERRO
                                            );
                        
                        
                        
                    EXCEPTION
                        
                        WHEN OTHERS THEN


                             LOG_GERENCIADOR.ADD_ERRO( ''TESTE'', 	
                                                                ''Erro ao executar o teste. Teste: '' || DBMS_ASSERT.ENQUOTE_LITERAL( v_NOME_FUNCTION_TESTE ) || '' - Erro: ''
                                                                 || SQLERRM || '' - '' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                                    );


                            
                            v_SITUACAO_RESULTADO := ' || DBMS_ASSERT.ENQUOTE_LITERAL( 'RAISE_ERROR' ) || ';


                            v_QTD_TESTE_FALHA := 1;

                            
                            REGISTRA_EXECUCAO_TESTE.RAISE_ERROR( p_ID_EXECUCAO, v_ROWID_USADO, ' || DBMS_ASSERT.ENQUOTE_LITERAL( 'verifique mensagens de erro na tabela LOG_INFO' ) || ' );
                            
                            
                            CRONOMETRO.PARAR(' || DBMS_ASSERT.ENQUOTE_LITERAL( 'INICIO_TESTE' ) || ');
                        
                            
                            REGISTRA_EXECUCAO_TESTE.NOVO_HISTORICO( 
                                                                        p_ID_EXECUCAO
                                                                        ,p_TIPO_TESTE
                                                                        ,v_DATA_INICIO
                                                                        ,v_QTD_TESTE
                                                                        ,v_QTD_TESTE_REALIZADO
                                                                        ,v_QTD_TESTE_SUCESSO
                                                                        ,v_QTD_TESTE_FALHA
                                                                        ,v_QTD_RAISE_ERRO
                                                                        , CRONOMETRO.GET_TEMPO(' || DBMS_ASSERT.ENQUOTE_LITERAL( 'INICIO_TESTE' ) || ') 
                                                                );


                            RAISE RAISE_ERRO_ENCONTRADO;

                    END;

                
                EXCEPTION
                    
                    WHEN OTHERS THEN
                    
                        NULL;
                
                END;
                       
            END;
            ';


            RETURN v_DDL_CORPO;

        EXCEPTION

            WHEN OTHERS THEN

                LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao encapsular o DDL contendo o Corpo da Capsula. Function teste: ' || TESTE.ASSERCAO );

                RAISE RAISE_ERRO_ENCONTRADO;

        END;

    END;


    PROCEDURE COMPILAR_CAPSULA_CONFIRMAR AS

        v_TESTE_ID NUMBER;

        v_CAPSULA_FILHA_ID NUMBER;

    BEGIN

        BEGIN

            BEGIN

                v_TESTE_ID := TESTE.TESTE_ID;
                
                SELECT
                    ID INTO v_CAPSULA_FILHA_ID
                FROM
                    TDD_CAPSULA_FILHA
                WHERE
                    FK_TESTE_ID = v_TESTE_ID;


                UPDATE
                    TDD_CAPSULA_FILHA
                SET
                     DATA_ALTERADO = SYSDATE
                    ,ENCAPSULADO = 'Y'
                WHERE
                    FK_TESTE_ID = v_TESTE_ID;

                

                MANUTENCAO_TESTE.ATUALIZAR_DATA_ALTERADO_DDL( v_TESTE_ID, GET_NOME_PROCEDURE_CAPSULA );


            EXCEPTION

                WHEN NO_DATA_FOUND THEN

                    INSERT INTO TDD_CAPSULA_FILHA
                        ( FK_TESTE_ID, DATA_ALTERADO, ENCAPSULADO )
                    VALUES
                        ( v_TESTE_ID, SYSDATE, 'Y' ) RETURNING ID INTO v_CAPSULA_FILHA_ID;

            END;


            COMMIT;

        EXCEPTION

            WHEN OTHERS THEN

                LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao CONFIMAR o encapsulamento do teste. Function teste: ' || TESTE.ASSERCAO || ' - Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                RAISE RAISE_ERRO_ENCONTRADO;

        END;

    END;



    PROCEDURE COMPILAR_CAPSULA( p_ASSERCAO VARCHAR2 ) AS

        v_DDL_CAPSULA CLOB;

        v_DDL_INICIO_CURSOR CONSTANT VARCHAR2(4000) := '
                    OPEN c_COUNT_SQL;
                    FETCH c_COUNT_SQL INTO v_QTD_TESTE;
                    CLOSE c_COUNT_SQL;
                    
                    OPEN c_SQL;
                    LOOP
                    FETCH c_SQL INTO v_SQL;
                    EXIT WHEN c_SQL%NOTFOUND;';

        v_DDL_FIM_CURSOR CONSTANT VARCHAR2(4000) := '
                    END LOOP;
                    CLOSE c_SQL;';

    BEGIN

         BEGIN


            --
            --
            BEGIN

                -- Recebe o DDL do corpo completo da Capsula
                v_DDL_CAPSULA := GET_DDL_CORPO_CAPSULA;

            EXCEPTION

                WHEN OTHERS THEN

                    RAISE RAISE_ERRO_ENCONTRADO;

            END;
            

            --
            --
            BEGIN

                -- Adiciona o nome da Procedure Capsula
                v_DDL_CAPSULA := REPLACE( v_DDL_CAPSULA, '{LOCAL_NOME_CAPSULA_DE_TESTE}', GET_NOME_PROCEDURE_CAPSULA );

            EXCEPTION

                WHEN OTHERS THEN

                    RAISE RAISE_ERRO_ENCONTRADO;

            END;


            --
            --
            BEGIN

                -- Adiciona os comentários da Procedure Capsula
                v_DDL_CAPSULA := REPLACE( v_DDL_CAPSULA, '{LOCAL_COMENTARIOS}', GET_DDL_CRIA_COMENTARIOS_CAPSULA );

            EXCEPTION

                WHEN OTHERS THEN

                    RAISE RAISE_ERRO_ENCONTRADO;

            END;


            --
            --
            BEGIN

                -- Adiciona as variáveis da Capsula
                v_DDL_CAPSULA := REPLACE( v_DDL_CAPSULA, '{LOCAL_VARIAVEIS}', GET_DDL_ESCOPO_DECLARA_VARIAVEIS );

            EXCEPTION

                WHEN OTHERS THEN

                    RAISE RAISE_ERRO_ENCONTRADO;

            END;


            --
            --
            BEGIN
                
                -- Adiciona o nome da Function de teste que será usado
                v_DDL_CAPSULA := REPLACE( v_DDL_CAPSULA, '{LOCAL_NOME_FUNCTION_ARGUMENTO}', GET_DDL_NOME_FUNCTION_ARGUMENTO );

            EXCEPTION

                WHEN OTHERS THEN

                    RAISE RAISE_ERRO_ENCONTRADO;

            END;
                        
            

            -- Adiciona os Cursores caso exista
            IF TESTE.QUERY_ARGUMENTO IS NOT NULL THEN

                v_DDL_CAPSULA := REPLACE( v_DDL_CAPSULA, '{LOCAL_SET_ROWID_USADO}', 'v_ROWID_USADO := v_SQL.ROWID_WDS;' );
                v_DDL_CAPSULA := REPLACE( v_DDL_CAPSULA, '{LOCAL_INICIO_CURSOR}', v_DDL_INICIO_CURSOR );
                v_DDL_CAPSULA := REPLACE( v_DDL_CAPSULA, '{LOCAL_FIM_CURSOR}', v_DDL_FIM_CURSOR );
                
            ELSE

                v_DDL_CAPSULA := REPLACE( v_DDL_CAPSULA, '{LOCAL_SET_ROWID_USADO}', '' );
                v_DDL_CAPSULA := REPLACE( v_DDL_CAPSULA, '{LOCAL_INICIO_CURSOR}', '' );
                v_DDL_CAPSULA := REPLACE( v_DDL_CAPSULA, '{LOCAL_FIM_CURSOR}', '' );
                
            END IF;




            BEGIN

                BEGIN

                    EXECUTE IMMEDIATE v_DDL_CAPSULA;

                EXCEPTION

                    WHEN OTHERS THEN

                        LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao executar o DDL de criação do encapsulamento do teste. Function teste: ' || TESTE.ASSERCAO || ' - Objeto: ' || GET_NOME_PROCEDURE_CAPSULA || ' - Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                        MANUTENCAO_TESTE.ATUALIZAR_DATA_ALTERADO_DDL( TESTE.TESTE_ID, GET_NOME_PROCEDURE_CAPSULA );

                        RAISE RAISE_ERRO_ENCONTRADO;

                END;


                BEGIN

                    COMPILAR_CAPSULA_CONFIRMAR;

                EXCEPTION

                    WHEN OTHERS THEN

                        RAISE RAISE_ERRO_ENCONTRADO;

                END;

            EXCEPTION

                WHEN OTHERS THEN

                    RAISE RAISE_ERRO_ENCONTRADO;

            END;


        EXCEPTION


            WHEN RAISE_ERRO_ENCONTRADO THEN

                RAISE RAISE_ERRO_ENCONTRADO;
                

            WHEN OTHERS THEN

                LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao criar o DDL da Capsula Filha do TESTE. Function teste: ' || TESTE.ASSERCAO || ' - Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                RAISE RAISE_ERRO_ENCONTRADO;

        END;

    END;


    PROCEDURE DESCOMPILAR_CAPSULA AS
    -- Se uma TESTE vai passar pelo processo de COMPILAR então ele deve ser marcado como Desencapsulado e só no final do processo marcado como ENCAPSULADO

        v_TESTE_ID NUMBER;        

    BEGIN

        BEGIN

            v_TESTE_ID := TESTE.TESTE_ID;

            UPDATE
                TDD_CAPSULA_FILHA
            SET
                DATA_ALTERADO = SYSDATE, ENCAPSULADO = 'N'
            WHERE
                FK_TESTE_ID = v_TESTE_ID;

            COMMIT;

        EXCEPTION

            WHEN OTHERS THEN

                LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao marcar um TESTE como desencapsulado antes de um processo de Encapsulamento Filha. Function teste: ' || TESTE.ASSERCAO || ' - Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                RAISE RAISE_ERRO_ENCONTRADO;

        END;

    END;



    PROCEDURE REMOVER_TESTE_CAPSULA_FILHA( p_ASSERCAO IN VARCHAR2 ) AS

        v_TESTE_ID NUMBER;

        v_CAPSULA_PAI_ID NUMBER;

        v_STMT_DROP_TESTE VARCHAR2(4000);

    BEGIN

        BEGIN


            SELECT
                T.ID INTO v_TESTE_ID
            FROM
                TESTE T
                INNER JOIN TDD_CAPSULA_FILHA FILHA ON FILHA.FK_TESTE_ID = T.ID
            WHERE
                T.ATIVADO = 'N'
                AND T.ASSERCAO = p_ASSERCAO;



            BEGIN

                DELETE FROM TDD_CAPSULA_FILHA WHERE FK_TESTE_ID = v_TESTE_ID;


                IF SQL%ROWCOUNT > 0 THEN

                    LOG_GERENCIADOR.ADD_SUCESSO( 'SISTEMA', 'Removido Capsula Filha porque o TESTE foi desativado. Asserção: ' || p_ASSERCAO );

                ELSE

                    LOG_GERENCIADOR.ADD_ALERTA( 'SISTEMA', 'Capsula Filha não foi identificada para ser removida. Asserção: ' || p_ASSERCAO );

                END IF;

                
            
            EXCEPTION

                WHEN OTHERS THEN

                    LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao tentar remover a Capsula Filha. Asserção: ' || p_ASSERCAO || ' - Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                    RAISE RAISE_ERRO_ENCONTRADO;

            END;



            BEGIN

                v_STMT_DROP_TESTE := 'DROP PROCEDURE ' || REPLACE( CONSTANTES.PREFIXO_NOME_CAPSULA_FILHA, '{TESTE_ID}', v_TESTE_ID );

                
                EXECUTE IMMEDIATE v_STMT_DROP_TESTE;


                LOG_GERENCIADOR.ADD_SUCESSO( 'SISTEMA', 'Realizado o DROP da Capsula Filha porque o TESTE foi desativado. Asserção: ' || p_ASSERCAO );


            EXCEPTION

                WHEN OTHERS THEN

                    LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao realizar o DROP da Procedure da Capsula Filha. Asserção: ' || p_ASSERCAO || ' - Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                    RAISE RAISE_ERRO_ENCONTRADO;

            END;



            BEGIN

                -- Verifica se existe Capsula Pai, se sim, ela também é removida

                SELECT ID INTO v_CAPSULA_PAI_ID FROM TDD_CAPSULA_PAI WHERE FK_TESTE_ID = v_TESTE_ID;


                BEGIN

                    DELETE FROM TDD_CAPSULA_PAI WHERE FK_TESTE_ID = v_TESTE_ID;


                    IF SQL%ROWCOUNT > 0 THEN

                        LOG_GERENCIADOR.ADD_SUCESSO( 'SISTEMA', 'Removido Capsula Pai porque o TESTE foi desativado. Asserção: ' || p_ASSERCAO );

                    ELSE

                        LOG_GERENCIADOR.ADD_ALERTA( 'SISTEMA', 'Capsula Pai não foi identificada para ser removida. Asserção: ' || p_ASSERCAO );

                    END IF;
                    
                
                EXCEPTION

                    WHEN OTHERS THEN

                        LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao tentar remover a Capsula Pai. Asserção: ' || p_ASSERCAO || ' - Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                        RAISE RAISE_ERRO_ENCONTRADO;

                END;




                -- Remove a Procedure da Capsula Pai
                BEGIN

                    v_STMT_DROP_TESTE := 'DROP PROCEDURE ' || REPLACE( CONSTANTES.PREFIXO_NOME_CAPSULA_PAI, '{TESTE_ID}', v_TESTE_ID );

                    
                    EXECUTE IMMEDIATE v_STMT_DROP_TESTE;


                    LOG_GERENCIADOR.ADD_SUCESSO( 'SISTEMA', 'Realizado o DROP da Capsula Pai porque o TESTE foi desativado. Asserção: ' || p_ASSERCAO );


                EXCEPTION

                    WHEN OTHERS THEN

                        LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao realizar o DROP da Procedure da Capsula Pai. Asserção: ' || p_ASSERCAO || ' - Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                        RAISE RAISE_ERRO_ENCONTRADO;

                END;




            EXCEPTION

                WHEN NO_DATA_FOUND THEN

                    NULL;


            END;


                

            COMMIT;

        EXCEPTION

            WHEN NO_DATA_FOUND THEN

                NULL;


            WHEN OTHERS THEN

                LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha no processo de remover uma Capsula Filha. Asserção: ' || p_ASSERCAO || ' - Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                RAISE RAISE_ERRO_ENCONTRADO;

        END;


    END;



    FUNCTION PERMITIDO_ENCAPSULAR_FILHA( p_ASSERCAO IN VARCHAR2 ) RETURN BOOLEAN IS

        v_FLAG_VALIDA VARCHAR2(1);
    
    BEGIN

        BEGIN


            SELECT
                ATIVADO INTO v_FLAG_VALIDA
            FROM
                TESTE
            WHERE
                ASSERCAO = p_ASSERCAO;

        
            RETURN v_FLAG_VALIDA = 'Y';


        EXCEPTION

            WHEN NO_DATA_FOUND THEN

                LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha, o TESTE não foi identificado. Function teste: ' || p_ASSERCAO || ' - Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                RETURN FALSE;

            WHEN OTHERS THEN

                LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao verificar se o TESTE está desativado. Function teste: ' || p_ASSERCAO || ' - Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                RETURN FALSE;

        END;

    END;



    FUNCTION ENCAPSULAR( p_ASSERCAO IN VARCHAR2 ) RETURN BOOLEAN IS
    BEGIN

        BEGIN

            -- Verifica se o TESTE está ativado
            IF NOT PERMITIDO_ENCAPSULAR_FILHA( p_ASSERCAO ) THEN


                BEGIN
                    
                    -- Teste desativado a Capsula é removida
                    REMOVER_TESTE_CAPSULA_FILHA( p_ASSERCAO );

                    RETURN TRUE;
                
                EXCEPTION

                    WHEN OTHERS THEN

                        RETURN FALSE;

                END;


            END IF;


            COLETAR_INFO_TESTE( p_ASSERCAO );

            DESCOMPILAR_CAPSULA;

            COMPILAR_CAPSULA( p_ASSERCAO );

            LOG_GERENCIADOR.ADD_SUCESSO( 'SISTEMA', 'Teste encapsulado. Function teste: ' || TESTE.ASSERCAO || ' - Info: ' || TESTE.INFO_TESTE );

            RETURN TRUE;

        EXCEPTION

            WHEN OTHERS THEN

                RETURN FALSE;

        END;

    END;


END CAPSULA_FILHA;
/


