--
-- Package responsável por atualizar todos os Testes considerados primário
-- Identificar novos Testes Primários criados
-- Identificar testes que não são mais primários e realizar o drop do objeto de teste e excluir a identificação como primário
CREATE OR REPLACE PACKAGE IDENTIFICAR_TESTES_TDD AS
--
-- Package responsável por atualizar todos os Testes considerados primário
-- Identificar novos Testes Primários criados
-- Identificar testes que não são mais primários e realizar o drop do objeto de teste e excluir a identificação como primário
--
-- Autor: Wesley David Santos
-- Skype: wesleydavidsantos		
-- https://www.linkedin.com/in/wesleydavidsantos
--

    FUNCTION INICIAR RETURN BOOLEAN;

    PROCEDURE PROCESSAR;

	
END IDENTIFICAR_TESTES_TDD;
/





CREATE OR REPLACE PACKAGE BODY IDENTIFICAR_TESTES_TDD AS
--
-- Autor: Wesley David Santos
-- Skype: wesleydavidsantos		
-- https://www.linkedin.com/in/wesleydavidsantos
--


    RAISE_ERRO_ENCONTRADO EXCEPTION;


    PROCEDURE IDENTIFICAR_NOVOS_TESTES AS

        CURSOR c_LISTA_NOVOS_TESTES IS
                                SELECT
                                    T.ID TESTE_ID
                                FROM
                                    TESTE T
                                    INNER JOIN TDD_CAPSULA_FILHA E ON E.FK_TESTE_ID = T.ID
                                WHERE
                                    E.ENCAPSULADO = 'Y'
                                    AND T.AUXILIAR = 'N'
                                    AND NOT EXISTS( SELECT 1 FROM TDD_CAPSULA_PAI P WHERE P.FK_TESTE_ID = T.ID );

        v_LISTA_NOVOS_TESTES c_LISTA_NOVOS_TESTES%ROWTYPE;

    BEGIN

        BEGIN

            OPEN c_LISTA_NOVOS_TESTES;
            LOOP
            FETCH c_LISTA_NOVOS_TESTES INTO v_LISTA_NOVOS_TESTES;
            EXIT WHEN c_LISTA_NOVOS_TESTES%NOTFOUND;

                INSERT INTO TDD_CAPSULA_PAI
                    ( FK_TESTE_ID, DATA_ALTERADO, ENCAPSULADO )
                VALUES
                    ( v_LISTA_NOVOS_TESTES.TESTE_ID, SYSDATE, 'N' );

            END LOOP;

            COMMIT;

        EXCEPTION

            WHEN OTHERS THEN

                LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao inserir na tabela TDD_CAPSULA_PAI a lista de novos testes primários. Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                RAISE RAISE_ERRO_ENCONTRADO;

        END;

    END;


    PROCEDURE REMOVER_TESTES_PRIMARIO AS

        CURSOR c_REMOVER_TESTES IS
                            SELECT
                                 T.ID TESTE_ID
                                ,T.NOME TESTE_NOME
                            FROM
                                TESTE T
                                INNER JOIN TDD_CAPSULA_PAI P ON P.FK_TESTE_ID = T.ID
                            WHERE
                                T.AUXILIAR = 'Y';

        
        v_TESTE_REMOVER c_REMOVER_TESTES%ROWTYPE;


        v_STMT_DROP_TESTE VARCHAR2(4000);

    BEGIN

        BEGIN

            OPEN c_REMOVER_TESTES;
            LOOP
            FETCH c_REMOVER_TESTES INTO v_TESTE_REMOVER;
            EXIT WHEN c_REMOVER_TESTES%NOTFOUND;

                BEGIN
                    
                    DELETE FROM TDD_CAPSULA_PAI WHERE FK_TESTE_ID = v_TESTE_REMOVER.TESTE_ID;

                    LOG_GERENCIADOR.ADD_SUCESSO( 'SISTEMA', 'Removido Teste que não é mais considerado como primário. Teste ID: ' || v_TESTE_REMOVER.TESTE_ID || ' - Teste Nome: ' || v_TESTE_REMOVER.TESTE_NOME );
                
                EXCEPTION

                    WHEN OTHERS THEN

                        LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao realizar o DELETE na tabela TDD_CAPSULA_PAI de um Teste que não é mais primário. Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                END;



                BEGIN


                    v_STMT_DROP_TESTE := 'DROP PROCEDURE ' || REPLACE( CONSTANTES.PREFIXO_NOME_CAPSULA_PAI, '{TESTE_ID}', v_TESTE_REMOVER.TESTE_ID );

                    
                    EXECUTE IMMEDIATE v_STMT_DROP_TESTE;


                EXCEPTION

                    WHEN OTHERS THEN

                        LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao realizar o DROP de um Teste que não é mais primário. Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                END;
                

            END LOOP;

            COMMIT;

        EXCEPTION

            WHEN OTHERS THEN

                LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha no processo de remover testes primários. Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                RAISE RAISE_ERRO_ENCONTRADO;

        END;


    END;



    PROCEDURE DESCOBRIR_TESTES_DESENCAPSULADO AS

        CURSOR c_LISTA_CAPSULA_PAI IS
                            SELECT  
                                FK_TESTE_ID TESTE_ID
                            FROM
                                TDD_CAPSULA_PAI
                            WHERE
                                ENCAPSULADO = 'Y';


        v_CAPSULA_PAI c_LISTA_CAPSULA_PAI%ROWTYPE;

        v_FLAG_DESENCAPSULADO NUMBER;

    BEGIN

        BEGIN


            OPEN c_LISTA_CAPSULA_PAI;
            LOOP
            FETCH c_LISTA_CAPSULA_PAI INTO v_CAPSULA_PAI;
            EXIT WHEN c_LISTA_CAPSULA_PAI%NOTFOUND;
            
                            
                SELECT
                    SUM( TESTE_DESENCAPSULADO ) INTO v_FLAG_DESENCAPSULADO
                FROM
                    (
                        SELECT 
                            COUNT(1) TESTE_DESENCAPSULADO
                        FROM
                            VW_HIERARQUIA_TESTE
                        WHERE
                            PATRIARCA_TESTE_ID = v_CAPSULA_PAI.TESTE_ID 
                            AND CAPSULA_PAI_ENCAPSULADO = 'N' 
                            AND CAPSULA_FILHA_ENCAPSULADO = 'N'

                        UNION ALL

                        SELECT 
                            COUNT(1) TESTE_DESENCAPSULADO
                        FROM
                            VW_CAPSULA_FILHA
                        WHERE
                            TESTE_ID = v_CAPSULA_PAI.TESTE_ID
                            AND ENCAPSULADO = 'N'
                    );



                IF v_FLAG_DESENCAPSULADO > 0 THEN

                    UPDATE
                        TDD_CAPSULA_PAI
                    SET
                        ENCAPSULADO = 'N'
                    WHERE
                        FK_TESTE_ID = v_CAPSULA_PAI.TESTE_ID;
                    

                END IF;

            END LOOP;
            CLOSE c_LISTA_CAPSULA_PAI;


            COMMIT;

        EXCEPTION

            WHEN OTHERS THEN

                LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha no processo que registra que a Capsula Pai está desencapsulado. Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                RAISE RAISE_ERRO_ENCONTRADO;

        END;

    END;



    FUNCTION INICIAR RETURN BOOLEAN IS

        v_ATUALIZADO_COM_SUCESSO BOOLEAN DEFAULT TRUE;

    BEGIN

        -- Validação
        BEGIN

            IDENTIFICAR_NOVOS_TESTES;
        
        EXCEPTION

            WHEN OTHERS THEN
                
                v_ATUALIZADO_COM_SUCESSO := FALSE;

        END;

        
        -- Validação
        BEGIN

            REMOVER_TESTES_PRIMARIO;
        
        EXCEPTION

            WHEN OTHERS THEN
                
                v_ATUALIZADO_COM_SUCESSO := FALSE;

        END;


        -- Validação
        BEGIN

            DESCOBRIR_TESTES_DESENCAPSULADO;
        
        EXCEPTION

            WHEN OTHERS THEN
                
                v_ATUALIZADO_COM_SUCESSO := FALSE;

        END;


        RETURN v_ATUALIZADO_COM_SUCESSO;

    END;


    PROCEDURE PROCESSAR AS

        v_FLAG_EXECUCAO BOOLEAN;
        
    BEGIN

        
        BEGIN

            v_FLAG_EXECUCAO := INICIAR;

        EXCEPTION

            WHEN OTHERS THEN

                LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao iniciar o processo de atualização da Capsula Pai. Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                RAISE RAISE_ERRO_ENCONTRADO;
                
        END;


    END;



END IDENTIFICAR_TESTES_TDD;
/


