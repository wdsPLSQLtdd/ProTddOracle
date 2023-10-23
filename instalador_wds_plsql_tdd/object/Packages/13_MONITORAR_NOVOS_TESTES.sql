--
-- Responsável por realizar o monitoramento de Testes criados ou alterados
CREATE OR REPLACE PACKAGE MONITORAR_NOVOS_TESTES AS
--
-- Responsável por realizar o monitoramento de Testes criados ou alterados
--
-- Autor: Wesley David Santos
-- Skype: wesleydavidsantos		
-- https://www.linkedin.com/in/wesleydavidsantos
--

    FUNCTION INICIAR RETURN BOOLEAN;


    PROCEDURE PROCESSAR;


END MONITORAR_NOVOS_TESTES;
/



CREATE OR REPLACE PACKAGE BODY MONITORAR_NOVOS_TESTES AS
--
-- Autor: Wesley David Santos
-- Skype: wesleydavidsantos		
-- https://www.linkedin.com/in/wesleydavidsantos
--

    RAISE_ERRO_ENCONTRADO EXCEPTION;


    PROCEDURE MANUTENCAO( p_ASSERCAO IN VARCHAR2 ) AS

        v_ASSERCAO VARCHAR2(200);

        v_FLAG_MANUTENCAO_TESTE BOOLEAN;

    BEGIN

        BEGIN

            v_ASSERCAO := p_ASSERCAO;


            MANUTENCAO_ANTES_DEPOIS.RESETAR_QTD_ITEM_ANTES_DEPOIS;


            v_FLAG_MANUTENCAO_TESTE := MANUTENCAO_TESTE.SALVA_TESTE( v_ASSERCAO );


            IF v_FLAG_MANUTENCAO_TESTE THEN

                LOG_GERENCIADOR.ADD_SUCESSO( 'TESTE', 'Teste adicionado/atualizado com sucesso. Assercao: ' || v_ASSERCAO || ' - Quantidade Testes do tipo Antes: ' || MANUTENCAO_ANTES_DEPOIS.GET_QTD_ITEM_ANTES || ' - Quantidade Testes do tipo Depois: ' || MANUTENCAO_ANTES_DEPOIS.GET_QTD_ITEM_DEPOIS );

            ELSE
                
                LOG_GERENCIADOR.ADD_ALERTA( 'TESTE', 'Falha ao adicionar/atualizar o teste. Assercao: ' || v_ASSERCAO || ' - Quantidade Testes do tipo Antes: ' || MANUTENCAO_ANTES_DEPOIS.GET_QTD_ITEM_ANTES || ' - Quantidade Testes do tipo Depois: ' || MANUTENCAO_ANTES_DEPOIS.GET_QTD_ITEM_DEPOIS );

            END IF;
            

        EXCEPTION

            WHEN OTHERS THEN

                LOG_GERENCIADOR.ADD_ERRO( 'TESTE', 'Falha no processo de Manutenção de um novo Teste. Assercao: ' || v_ASSERCAO || ' - Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

        END;


    END;



    PROCEDURE INICIAR_MONITORAMENTO AS

        -- Coleta novos TESTES criados ou alterados
        CURSOR c_LISTA_NOVOS_TESTES IS 
                            SELECT
                                ASSERCAO
                            FROM
                                LISTA_NOVOS_TESTES;


        v_NOVO_TESTE c_LISTA_NOVOS_TESTES%ROWTYPE;

        v_FLAG_MANUTENCAO_TESTE BOOLEAN;


    BEGIN

        BEGIN


            OPEN c_LISTA_NOVOS_TESTES;
            LOOP
            FETCH c_LISTA_NOVOS_TESTES INTO v_NOVO_TESTE;
            EXIT WHEN c_LISTA_NOVOS_TESTES%NOTFOUND;

                BEGIN

                    MANUTENCAO( v_NOVO_TESTE.ASSERCAO );

                    --
                    -- Remove o teste da lista
                    DELETE FROM LISTA_NOVOS_TESTES WHERE ASSERCAO = v_NOVO_TESTE.ASSERCAO;


                EXCEPTION

                    WHEN OTHERS THEN

                        NULL;

                END;


            END LOOP;
            CLOSE c_LISTA_NOVOS_TESTES;


            COMMIT;


        EXCEPTION

            WHEN OTHERS THEN

                LOG_GERENCIADOR.ADD_ERRO( 'TESTE', 'Falha ao percorrer a lista de novos Testes criados ou atualizados. Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                RAISE RAISE_ERRO_ENCONTRADO;

        END;


    END;



    FUNCTION INICIAR RETURN BOOLEAN IS
    BEGIN

        BEGIN

            BEGIN

                INICIAR_MONITORAMENTO;

            EXCEPTION

                WHEN OTHERS THEN

                    LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao processar testes que foram adicionados ou alterados . Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

            END;


            BEGIN

                IDENTIFICAR_TESTES_TDD.PROCESSAR;

            EXCEPTION

                WHEN OTHERS THEN

                    LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao atualizar os testes que foram adicionados ou alterados . Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

            END;


            BEGIN

                ENCAPSULAR.INICIAR;

            EXCEPTION

                WHEN OTHERS THEN

                    LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha no processo de Encapsulamento das Capsulas Base e Capsulas Pai . Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

            END;


            RETURN TRUE;

        EXCEPTION

            WHEN OTHERS THEN

                RETURN FALSE;

        END;

    END;


    PROCEDURE PROCESSAR AS

        v_FLAG_PROCESSAR NUMBER;

        v_FLAG_EXECUCAO BOOLEAN;
        
    BEGIN

        
        BEGIN

            SELECT COUNT(1) INTO v_FLAG_PROCESSAR FROM LISTA_NOVOS_TESTES;

            IF v_FLAG_PROCESSAR > 0 THEN
                
                v_FLAG_EXECUCAO := INICIAR;

                DELETE FROM LISTA_NOVOS_TESTES;

                COMMIT;

            END IF;


        EXCEPTION

            WHEN OTHERS THEN

                LOG_GERENCIADOR.ADD_ERRO( 'SISTEMA', 'Falha ao iniciar o processo que monitora novos testes criados ou atualizados. Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

                RAISE RAISE_ERRO_ENCONTRADO;
                
        END;


    END;


END MONITORAR_NOVOS_TESTES;
/

