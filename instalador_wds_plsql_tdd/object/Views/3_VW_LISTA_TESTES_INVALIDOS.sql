
--
-- View que retorna a quantidade de testes que são considerados inválidos para execução
--

CREATE OR REPLACE VIEW VW_LISTA_TESTES_INVALIDOS AS
--
-- View que retorna a quantidade de testes que são considerados inválidos para execução
--
-- Autor: Wesley David Santos
-- Skype: wesleydavidsantos		
-- https://www.linkedin.com/in/wesleydavidsantos
-- 
WITH TESTES_INVALIDOS ( TESTE_ID ) AS (
    SELECT
        DISTINCT ID
    FROM
        (
            SELECT
                PATRIARCA_TESTE_ID ID
            FROM
                VW_HIERARQUIA_TESTE
            WHERE
                (
                    PAI_TESTE_ATIVADO = 'N'
                    OR FILHA_TESTE_ATIVADO = 'N'
                    OR CAPSULA_PAI_ENCAPSULADO = 'N'
                    OR CAPSULA_FILHA_ENCAPSULADO = 'N'
                )
            
            UNION ALL
            
            SELECT
                FK_TESTE_ID ID
            FROM
                TDD_CAPSULA_PAI
            WHERE
                ENCAPSULADO = 'N'
        )
)
SELECT
    TESTE_ID
FROM
    TESTES_INVALIDOS
    INNER JOIN TDD_CAPSULA_PAI CAPSULA ON CAPSULA.FK_TESTE_ID = TESTES_INVALIDOS.TESTE_ID;
    




