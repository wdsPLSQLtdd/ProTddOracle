--
-- Responsável por realizar o processamento de todos os testes Primários ( Capsula Pai ) existentes
-- A chamada deste processo deve ser realizada via JOB
CREATE OR REPLACE PACKAGE EXECUTAR_TESTES_TDD AS
--
-- Responsável por realizar o processamento de todos os testes Primários ( Capsula Pai ) existentes
-- A chamada deste processo deve ser realizada via JOB
--
-- Autor: Wesley David Santos
-- Skype: wesleydavidsantos		
-- https://www.linkedin.com/in/wesleydavidsantos
--

    FUNCTION INICIAR RETURN BOOLEAN;

    PROCEDURE DISPARAR_TESTES_TDD;


END EXECUTAR_TESTES_TDD;
/



CREATE OR REPLACE PACKAGE BODY EXECUTAR_TESTES_TDD AS
--
-- Autor: Wesley David Santos
-- Skype: wesleydavidsantos		
-- https://www.linkedin.com/in/wesleydavidsantos
--

    RAISE_ERRO_ENCONTRADO EXCEPTION;


    FUNCTION VALIDA_CAPSULAS_DESCOMPILADAS( p_TESTE_PRIMARIO_ID IN NUMBER ) RETURN BOOLEAN IS

        v_FLAG_VALIDA NUMBER;

    BEGIN

        BEGIN


            SELECT
                COUNT( TESTE_ID ) INTO v_FLAG_VALIDA
            FROM
                VW_LISTA_TESTES_INVALIDOS
            WHERE
                TESTE_ID = p_TESTE_PRIMARIO_ID;


            IF v_FLAG_VALIDA > 0 THEN

                LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Existem Capsulas Inválidas referente a esse teste. Validar as tabelas TDD_CAPSULA_FILHA ou a view VW_HIERARQUIA_TESTE e TDD_CAPSULA_PAI. TESTE_ID: ' || p_TESTE_PRIMARIO_ID );                

            END IF;

            
            RETURN v_FLAG_VALIDA = 0;

        EXCEPTION
            
            WHEN OTHERS THEN

                LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao verificar se o Teste Primário é valido no processo que realiza a execução da CAPSULA_PAI. TESTE_ID ' || p_TESTE_PRIMARIO_ID || ' - Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                RETURN FALSE;

        END;

    END;



    FUNCTION VALIDA_OBJETO_CAPSULA_PAI( p_CAPSULA_PAI IN VARCHAR2 ) RETURN BOOLEAN IS

        v_OBJ_STATUS VARCHAR2(100);

    BEGIN

        BEGIN

            SELECT 
                STATUS INTO v_OBJ_STATUS
            FROM
                SYS.DBA_OBJECTS
            WHERE
                OWNER = CONSTANTES.OWNER_WDS_TDD
                AND OBJECT_NAME = p_CAPSULA_PAI; 


            IF v_OBJ_STATUS != 'VALID' THEN

                LOG_GERENCIADOR.ADD_ERRO( 'TESTE', 'Capsula Pai que realiza o teste está descompilada no Banco de Dados. Capsula: ' || p_CAPSULA_PAI );

                RETURN FALSE;

            END IF;


            RETURN TRUE;


        EXCEPTION

            WHEN NO_DATA_FOUND THEN

                LOG_GERENCIADOR.ADD_ERRO( 'TESTE', 'Capsula Pai não foi identificada como um Objeto do Banco de Dados. Capsula: ' || p_CAPSULA_PAI );

                RETURN FALSE;


            WHEN OTHERS THEN

                LOG_GERENCIADOR.ADD_ERRO( 'TESTE', 'Falha ao identificar a Capsula Pai. Capsula: ' || p_CAPSULA_PAI || ' - Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                RETURN FALSE;

        END;


    END;



    FUNCTION EXECUTAR( p_CAPSULA_PAI IN VARCHAR2 ) RETURN BOOLEAN IS

        v_EXECUTAR_CAPSULA VARCHAR2(500);

    BEGIN

        BEGIN

            v_EXECUTAR_CAPSULA := 'BEGIN
                                    {NOME_CAPSULA};
                                   END;';

            
            v_EXECUTAR_CAPSULA := REPLACE( v_EXECUTAR_CAPSULA, '{NOME_CAPSULA}', p_CAPSULA_PAI );


            EXECUTE IMMEDIATE v_EXECUTAR_CAPSULA;

            RETURN TRUE;

        EXCEPTION

            WHEN OTHERS THEN

                LOG_GERENCIADOR.ADD_ERRO( 'TESTE', 'Falha ao executar a Capsula Pai. Capsula: ' || p_CAPSULA_PAI || ' - Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                RETURN FALSE;

        END;


    END;



    FUNCTION INICIAR RETURN BOOLEAN IS

        PRAGMA AUTONOMOUS_TRANSACTION;

        CURSOR c_LISTA_CAPSULAS_PAI IS
                                        SELECT
                                            FK_TESTE_ID TESTE_ID
                                        FROM
                                            TDD_CAPSULA_PAI CAPSULA
                                        WHERE    
                                            CAPSULA.ENCAPSULADO = 'Y'
                                        ORDER BY
                                            CAPSULA.ID;
                                            

        v_LISTA_CAPSULAS_PAI c_LISTA_CAPSULAS_PAI%ROWTYPE;


        v_NOME_CAPSULA_PAI VARCHAR2(200);

        v_FLAG_FALHA BOOLEAN;


        v_QTD_TOTAL_TESTES NUMBER DEFAULT 0;

        v_QTD_TESTES_INVALIDOS NUMBER DEFAULT 0;

        v_QTD_SUCESSO NUMBER DEFAULT 0;

        v_QTD_FALHA NUMBER DEFAULT 0;

    BEGIN


        BEGIN

            CRONOMETRO.EXCLUIR('CRON_EXECUCAO_TESTE');
            CRONOMETRO.INICIAR('CRON_EXECUCAO_TESTE');


            OPEN c_LISTA_CAPSULAS_PAI;
            LOOP
            FETCH c_LISTA_CAPSULAS_PAI INTO v_LISTA_CAPSULAS_PAI;
            EXIT WHEN c_LISTA_CAPSULAS_PAI%NOTFOUND;

                BEGIN

                    v_FLAG_FALHA := FALSE;


                    v_NOME_CAPSULA_PAI := REPLACE( CONSTANTES.PREFIXO_NOME_CAPSULA_PAI, '{TESTE_ID}', v_LISTA_CAPSULAS_PAI.TESTE_ID );


                    IF NOT v_FLAG_FALHA AND NOT VALIDA_OBJETO_CAPSULA_PAI( v_NOME_CAPSULA_PAI ) THEN

                        v_FLAG_FALHA := TRUE;

                    END IF;



                    IF NOT v_FLAG_FALHA AND NOT VALIDA_CAPSULAS_DESCOMPILADAS( v_LISTA_CAPSULAS_PAI.TESTE_ID ) THEN

                        v_FLAG_FALHA := TRUE;

                    END IF;



                    IF NOT v_FLAG_FALHA AND NOT EXECUTAR( v_NOME_CAPSULA_PAI ) THEN

                        v_FLAG_FALHA := TRUE;

                    END IF;



                    IF v_FLAG_FALHA THEN

                        v_QTD_FALHA := v_QTD_FALHA + 1;

                        CONTINUE;

                    END IF;


                    v_QTD_SUCESSO := v_QTD_SUCESSO + 1;


                EXCEPTION

                    WHEN OTHERS THEN

                        LOG_GERENCIADOR.ADD_ERRO( 'TESTE', 'Falha no Loop que realiza a chamada de execução da Capsula Pai. Capsula: ' || v_NOME_CAPSULA_PAI || ' - Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                        CONTINUE;

                END;


            END LOOP;
            CLOSE c_LISTA_CAPSULAS_PAI;


            CRONOMETRO.PARAR('CRON_EXECUCAO_TESTE');

            
            BEGIN

                SELECT COUNT(1) INTO v_QTD_TOTAL_TESTES FROM TDD_CAPSULA_PAI;

                SELECT COUNT(1) INTO v_QTD_TESTES_INVALIDOS FROM VW_LISTA_TESTES_INVALIDOS;


                INSERT INTO LOG_DISPARO_TESTES_TDD
                    ( DATA_REGISTRO, TOTAL_TESTES, SUCESSO, FALHA, INVALIDOS, TEMPO_EXECUCAO )
                VALUES
                    ( SYSDATE, v_QTD_TOTAL_TESTES, v_QTD_SUCESSO, v_QTD_FALHA, v_QTD_TESTES_INVALIDOS, CRONOMETRO.GET_TEMPO('CRON_EXECUCAO_TESTE') );

                COMMIT;

            EXCEPTION

                WHEN OTHERS THEN

                    LOG_GERENCIADOR.ADD_ERRO( 'TESTE', 'Falha ao registrar o histórico de execução dos Testes. Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                    RAISE RAISE_ERRO_ENCONTRADO;

            END;


            DBMS_OUTPUT.PUT_LINE( 'Testes Executados. Total: ' || ( v_QTD_SUCESSO + v_QTD_FALHA ) || ' - Sucesso: ' || v_QTD_SUCESSO || ' - Falha: ' || v_QTD_FALHA );


            RETURN TRUE;


        EXCEPTION

            WHEN RAISE_ERRO_ENCONTRADO THEN

                RETURN FALSE;
                

            WHEN OTHERS THEN

                LOG_GERENCIADOR.ADD_ERRO( 'TESTE', 'Falha ao Iniciar a execução dos Testes. Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                RAISE RAISE_ERRO_ENCONTRADO;

        END;

    END;


    PROCEDURE COMPILAR_TESTES AS
    -- Verifica se existem testes descompilados, se sim, tenta recompilar.
    -- Essa ação é necessária pela dependência entre o ALVO e o Teste,
    -- se um ALVO estava descompilado e foi compilado, o Teste não é compilado automáticamente

        CURSOR c_LISTA_TESTES IS 
                                SELECT 
                                    DISTINCT
                                    DEP.NAME ASSERCAO
                                FROM
                                    SYS.DBA_DEPENDENCIES DEP
                                    INNER JOIN SYS.DBA_OBJECTS OBJ ON OBJ.OBJECT_NAME = DEP.NAME
                                WHERE
                                    DEP.OWNER = CONSTANTES.OWNER_WDS_TDD_TESTE
                                    AND OBJ.STATUS = 'INVALID'
                                    AND OBJECT_TYPE = 'FUNCTION';


        v_TESTE c_LISTA_TESTES%ROWTYPE;

        v_DDL_COMPILAR CONSTANT VARCHAR2(100) := 'ALTER FUNCTION {OWNER_TESTE}.{OBJETO_TESTE} COMPILE';

        v_DDL VARCHAR2(1000);

        v_FLAG_MANUTENCAO_TESTE BOOLEAN;

        v_FLAG_MONITORAR_TESTES BOOLEAN;

    BEGIN

        BEGIN


            OPEN c_LISTA_TESTES;
            LOOP
            FETCH c_LISTA_TESTES INTO v_TESTE;
            EXIT WHEN c_LISTA_TESTES%NOTFOUND;


                v_DDL := REPLACE( v_DDL_COMPILAR, '{OBJETO_TESTE}', v_TESTE.ASSERCAO );
                v_DDL := REPLACE( v_DDL, '{OWNER_TESTE}', CONSTANTES.OWNER_WDS_TDD_TESTE );


                BEGIN

                    EXECUTE IMMEDIATE v_DDL;

                    LOG_GERENCIADOR.ADD_SUCESSO( 'SISTEMA', 'Função de Teste Recompilado com sucesso. Asserção: ' || v_TESTE.ASSERCAO );


                    --
                    -- Se uma Função de teste foi recompilada, então realiza o processo de encapsulamento para que esse teste passe pelo processo de TDD em execução
                    BEGIN

                        v_FLAG_MANUTENCAO_TESTE := MANUTENCAO_TESTE.SALVA_TESTE( v_TESTE.ASSERCAO );


                        v_FLAG_MONITORAR_TESTES := MONITORAR_NOVOS_TESTES.INICIAR;


                        IF v_FLAG_MANUTENCAO_TESTE AND v_FLAG_MONITORAR_TESTES THEN

                            LOG_GERENCIADOR.ADD_SUCESSO( 'SISTEMA', 'Encapsulamento realizado após Recompilar Asserção: ' || v_TESTE.ASSERCAO );

                        END IF;


                    EXCEPTION

                        WHEN OTHERS THEN

                            LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao encapsular Teste Recompilado. Asserção: ' || v_TESTE.ASSERCAO || ' - Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                    END;


                EXCEPTION

                    WHEN OTHERS THEN

                        LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao compilar o objeto de Teste. Asserção: ' || v_TESTE.ASSERCAO || ' - Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                        NULL;

                END;


            END LOOP;
            CLOSE c_LISTA_TESTES;


        EXCEPTION

            WHEN OTHERS THEN

                LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao forçar a compilação do objeto de Teste. Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                NULL;


        END;

    END;


    PROCEDURE DISPARAR_TESTES_TDD AS
    -- Procedure que deve ser usada para realizar a execução via JOB

        v_FLAG_DISPARAR NUMBER;

        v_TESTES_EXECUTADO BOOLEAN;

    BEGIN

        BEGIN


            SELECT COUNT(1) INTO v_FLAG_DISPARAR FROM DISPARAR_TESTES_TDD WHERE TDD_EXECUTADO = 'N';


            IF v_FLAG_DISPARAR > 0 THEN


                COMPILAR_TESTES;


                UPDATE DISPARAR_TESTES_TDD SET TDD_EXECUTADO = 'Y';


                v_TESTES_EXECUTADO := INICIAR;


                COMMIT;
                
            END IF;


        EXCEPTION

            WHEN OTHERS THEN

                LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao disparar os testes TDD. Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                RAISE RAISE_ERRO_ENCONTRADO;

        END;


    END;


END EXECUTAR_TESTES_TDD;
/
