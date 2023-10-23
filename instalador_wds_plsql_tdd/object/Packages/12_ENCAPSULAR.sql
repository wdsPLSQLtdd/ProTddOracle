--
-- Package responsável por Encapsular nos formatos CapsulaFilha e CapsulaPai os Testes TDD existentes.
CREATE OR REPLACE PACKAGE ENCAPSULAR AS
--
-- Package responsável por Encapsular nos formatos CapsulaFilha e CapsulaPai os Testes TDD existentes.
--
-- Autor: Wesley David Santos
-- Skype: wesleydavidsantos		
-- https://www.linkedin.com/in/wesleydavidsantos
--

    PROCEDURE INICIAR;

	
END ENCAPSULAR;
/





CREATE OR REPLACE PACKAGE BODY ENCAPSULAR AS
--
-- Autor: Wesley David Santos
-- Skype: wesleydavidsantos		
-- https://www.linkedin.com/in/wesleydavidsantos
--


    RAISE_ERRO_ENCONTRADO EXCEPTION;


    PROCEDURE REENCAPSULAR_CAPSULA_PAI AS

        CURSOR c_LISTA_CAPSULA_PAI IS
                            SELECT 
                                TESTE_ID
                            FROM
                                (

                                    SELECT
                                        TESTE_ID
                                        ,CASE
                                            WHEN OBJ.TIMESTAMP IS NULL OR CAP.DATA_ALTERADO_DDL != OBJ.TIMESTAMP THEN 'Y'
                                            ELSE 'N'
                                        END REENCAPSULAR
                                    FROM
                                        (    
                                            SELECT  
                                                FK_TESTE_ID TESTE_ID
                                                ,REPLACE( CONSTANTES.PREFIXO_NOME_CAPSULA_PAI, '{TESTE_ID}', FK_TESTE_ID ) CAPSULA
                                                ,DATA_ALTERADO_DDL
                                            FROM
                                                TDD_CAPSULA_PAI O
                                                INNER JOIN TESTE T ON T.ID = O.FK_TESTE_ID
                                            WHERE
                                                ENCAPSULADO = 'N'
                                        ) CAP
                                        LEFT JOIN DBA_OBJECTS OBJ ON OBJ.OBJECT_NAME = CAP.CAPSULA AND OBJECT_TYPE = 'PROCEDURE' AND OWNER = CONSTANTES.OWNER_WDS_TDD
                                        
                                )
                            WHERE
                                REENCAPSULAR = 'Y';


        v_CAPSULA_PAI c_LISTA_CAPSULA_PAI%ROWTYPE;

        v_FLAG BOOLEAN;

    BEGIN

        BEGIN

            --
            -- Verifica se existem capsulas inválidas, se sim, elas são marcadas como inválidas no sistema de TDD
            BEGIN

                UPDATE
                    TDD_CAPSULA_PAI
                SET
                     ENCAPSULADO = 'N'
                    ,DATA_ALTERADO = SYSDATE
                WHERE
                    FK_TESTE_ID IN (
                                        SELECT
                                            TESTE_ID
                                        FROM
                                            DBA_OBJECTS O
                                            INNER JOIN (
                                                            SELECT 
                                                                FK_TESTE_ID TESTE_ID
                                                               ,REPLACE( CONSTANTES.PREFIXO_NOME_CAPSULA_PAI, '{TESTE_ID}', FK_TESTE_ID ) NOME
                                                            FROM
                                                                TDD_CAPSULA_PAI
                                                        ) CAPSULA ON CAPSULA.NOME = O.OBJECT_NAME
                                        WHERE
                                            OWNER = CONSTANTES.OWNER_WDS_TDD
                                            AND STATUS = 'INVALID'
                                            AND OBJECT_TYPE = 'PROCEDURE'
                                    );

                COMMIT;

            EXCEPTION

                WHEN OTHERS THEN

                    LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao identificar se existe Capsula Pai descompilada. Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );


            END;





            OPEN c_LISTA_CAPSULA_PAI;
            LOOP
            FETCH c_LISTA_CAPSULA_PAI INTO v_CAPSULA_PAI;
            EXIT WHEN c_LISTA_CAPSULA_PAI%NOTFOUND;
            

                BEGIN

                    v_FLAG := CAPSULA_PAI.ENCAPSULAR( v_CAPSULA_PAI.TESTE_ID );

                EXCEPTION

                    WHEN OTHERS THEN

                        LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao tentar Recompilar a Capsula Pai. TESTE_ID: ' || v_CAPSULA_PAI.TESTE_ID || ' - Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );
                        
                        CONTINUE;

                END;


            END LOOP;
            CLOSE c_LISTA_CAPSULA_PAI;


        EXCEPTION

            WHEN OTHERS THEN

                LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao Recompilar as Capsulas Pai. Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                RAISE RAISE_ERRO_ENCONTRADO;

        END;

    END;



    PROCEDURE REENCAPSULAR_CAPSULA_FILHA AS

        CURSOR c_LISTA_CAPSULA_FILHA IS
                                SELECT
                                    ASSERCAO
                                FROM
                                    (

                                        SELECT
                                            ASSERCAO
                                            ,CASE
                                                WHEN OBJ.TIMESTAMP IS NULL OR CAP.DATA_ALTERADO_DDL != OBJ.TIMESTAMP THEN 'Y'
                                                ELSE 'N'
                                            END REENCAPSULAR
                                        FROM
                                            (
                                                SELECT
                                                    ASSERCAO
                                                    ,REPLACE( CONSTANTES.PREFIXO_NOME_CAPSULA_FILHA, '{TESTE_ID}', C.FK_TESTE_ID ) CAPSULA
                                                    ,DATA_ALTERADO_DDL
                                                FROM
                                                    TDD_CAPSULA_FILHA C
                                                    INNER JOIN TESTE T ON T.ID = C.FK_TESTE_ID
                                                WHERE
                                                    C.ENCAPSULADO = 'N'
                                                    
                                            ) CAP
                                            LEFT JOIN DBA_OBJECTS OBJ ON OBJ.OBJECT_NAME = CAP.CAPSULA AND OBJECT_TYPE = 'PROCEDURE' AND OWNER = CONSTANTES.OWNER_WDS_TDD
                                    
                                    )
                                WHERE
                                    REENCAPSULAR = 'Y';
                                    


        v_CAPSULA_FILHA c_LISTA_CAPSULA_FILHA%ROWTYPE;

        v_FLAG BOOLEAN;

    BEGIN

        BEGIN

            --
            -- Verifica se existem capsulas inválidas, se sim, elas são marcadas como inválidas no sistema de TDD
            BEGIN

                UPDATE
                    TDD_CAPSULA_FILHA
                SET
                     ENCAPSULADO = 'N'
                    ,DATA_ALTERADO = SYSDATE
                WHERE
                    FK_TESTE_ID IN (
                                        SELECT
                                            TESTE_ID
                                        FROM
                                            DBA_OBJECTS O
                                            INNER JOIN (
                                                            SELECT 
                                                                FK_TESTE_ID TESTE_ID
                                                               ,REPLACE( CONSTANTES.PREFIXO_NOME_CAPSULA_FILHA, '{TESTE_ID}', FK_TESTE_ID ) NOME
                                                            FROM
                                                                TDD_CAPSULA_FILHA
                                                        ) CAPSULA ON CAPSULA.NOME = O.OBJECT_NAME
                                        WHERE
                                            OWNER = CONSTANTES.OWNER_WDS_TDD
                                            AND STATUS = 'INVALID'
                                            AND OBJECT_TYPE = 'PROCEDURE'
                                    );

                COMMIT;

            EXCEPTION

                WHEN OTHERS THEN

                    LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao identificar se existe Capsula Filha descompilada. Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );


            END;





            OPEN c_LISTA_CAPSULA_FILHA;
            LOOP
            FETCH c_LISTA_CAPSULA_FILHA INTO v_CAPSULA_FILHA;
            EXIT WHEN c_LISTA_CAPSULA_FILHA%NOTFOUND;
            

                BEGIN

                    v_FLAG := CAPSULA_FILHA.ENCAPSULAR( v_CAPSULA_FILHA.ASSERCAO );

                EXCEPTION

                    WHEN OTHERS THEN

                        LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao tentar Recompilar a Capsula Filha. TESTE_ID: ' || v_CAPSULA_FILHA.ASSERCAO || ' - Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );
                        
                        CONTINUE;

                END;


            END LOOP;
            CLOSE c_LISTA_CAPSULA_FILHA;


        EXCEPTION

            WHEN OTHERS THEN

                LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao Recompilar as Capsulas Filha. Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                RAISE RAISE_ERRO_ENCONTRADO;

        END;

    END;



    PROCEDURE INICIAR AS
    BEGIN

        BEGIN

            
            BEGIN

                REENCAPSULAR_CAPSULA_FILHA;

            EXCEPTION

                WHEN OTHERS THEN

                    NULL;

            END;



            BEGIN

                REENCAPSULAR_CAPSULA_PAI;

            EXCEPTION

                WHEN OTHERS THEN

                    NULL;

            END;


        EXCEPTION

            WHEN OTHERS THEN

                NULL;

        END;


    END;


END ENCAPSULAR;
/
