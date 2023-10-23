
--
-- View que apresenta a Hierarquia de um TESTE
-- Apresenta todos os testes com ligação direta e indireta entre eles
--
-- Observacao:
-- Na clausula JOIN fora do WITH a tabela TDD_CAPSULA_FILHA repetida está correta, porque todas os testes
-- são encapsulados em uma CAPSULA Filha, desta forma todo Teste possui uma Capsula FILHA
-- o ALIAS que identifica se essa Filha é Pai de outros
--
--

CREATE OR REPLACE VIEW VW_HIERARQUIA_TESTE AS
--
-- View que apresenta a Hierarquia de um TESTE
-- Apresenta todos os testes com ligação direta e indireta entre eles
--
-- Observacao:
-- Na clausula JOIN fora do WITH a tabela TDD_CAPSULA_FILHA repetida está correta, porque todas os testes
-- são encapsulados em uma CAPSULA Filha, desta forma todo Teste possui uma Capsula FILHA
-- o ALIAS que identifica se essa Filha é Pai de outros
--
-- Autor: Wesley David Santos
-- Skype: wesleydavidsantos		
-- https://www.linkedin.com/in/wesleydavidsantos
-- 
WITH HIERARQUIA (PATRIARCA_TESTE_ID, PAI_TESTE_ID, FILHA_TESTE_ID, FILHA_ACAO, FILHA_POSICAO, NIVEL_HIERARQUIA) AS (
    SELECT
         PAI_TESTE_ID PATRIARCA_TESTE_ID
        ,PAI_TESTE_ID
        ,FILHA_TESTE_ID
        ,FILHA_ACAO
        ,FILHA_POSICAO
        ,1 AS NIVEL_HIERARQUIA
    FROM
        (
            SELECT
                 T.ID PAI_TESTE_ID
                ,AD.FK_TESTE_ACAO_ID AS FILHA_TESTE_ID
                ,AD.ACAO AS FILHA_ACAO
                ,AD.POSICAO AS FILHA_POSICAO
            FROM
                TESTE T
                LEFT JOIN ANTES_DEPOIS AD ON AD.FK_TESTE_ID = T.ID
        )
    WHERE
        FILHA_TESTE_ID IS NOT NULL
    UNION ALL
    SELECT
         H.PATRIARCA_TESTE_ID
        ,AD.FK_TESTE_ID PAI_TESTE_ID
        ,AD.FK_TESTE_ACAO_ID AS FILHA_TESTE_ID
        ,AD.ACAO AS FILHA_ACAO
        ,AD.POSICAO AS FILHA_POSICAO
        ,H.NIVEL_HIERARQUIA + 1 AS NIVEL_HIERARQUIA
    FROM
        ANTES_DEPOIS AD
        INNER JOIN HIERARQUIA H ON H.FILHA_TESTE_ID = AD.FK_TESTE_ID
        
)
SELECT
     PATRIARCA_TESTE_ID
    ,PAI_TESTE_ID
    ,FILHA_TESTE_ID
    ,( SELECT ASSERCAO FROM TESTE WHERE ID = H.PAI_TESTE_ID ) ASSERCAO_PAI
    ,( SELECT ASSERCAO FROM TESTE WHERE ID = H.FILHA_TESTE_ID ) ASSERCAO_FILHA
    ,FILHA_ACAO
    ,FILHA_POSICAO
    ,( SELECT ATIVADO FROM TESTE WHERE ID = H.PAI_TESTE_ID ) PAI_TESTE_ATIVADO
    ,( SELECT ATIVADO FROM TESTE WHERE ID = H.FILHA_TESTE_ID ) FILHA_TESTE_ATIVADO
    ,( SELECT ENCAPSULADO FROM TDD_CAPSULA_PAI WHERE FK_TESTE_ID = CAPSULA_PAI.FK_TESTE_ID ) CAPSULA_PAI_ENCAPSULADO
    ,CAPSULA_FILHA.ENCAPSULADO CAPSULA_FILHA_ENCAPSULADO
    ,NIVEL_HIERARQUIA
FROM
    HIERARQUIA H
    INNER JOIN TDD_CAPSULA_FILHA CAPSULA_PAI ON CAPSULA_PAI.FK_TESTE_ID = H.PAI_TESTE_ID
    INNER JOIN TDD_CAPSULA_FILHA CAPSULA_FILHA ON CAPSULA_FILHA.FK_TESTE_ID = H.FILHA_TESTE_ID
ORDER BY
    NIVEL_HIERARQUIA, FILHA_ACAO, FILHA_POSICAO;



