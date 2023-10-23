
--
-- View que apresenta as informações do Teste e da Capsula Filha
--  

CREATE OR REPLACE VIEW VW_CAPSULA_FILHA AS
--
-- View que apresenta as informações do Teste e da Capsula Filha
--  
-- Autor: Wesley David Santos
-- Skype: wesleydavidsantos		
-- https://www.linkedin.com/in/wesleydavidsantos
-- 
SELECT
     T.ID TESTE_ID
    ,T.FK_ALVO_ID ALVO_ID
    ,T.ASSERCAO
    ,T.ATIVADO
    ,T.VERSAO_TESTE
    ,C.ENCAPSULADO
FROM
    TESTE T 
    INNER JOIN TDD_CAPSULA_FILHA C ON C.FK_TESTE_ID = T.ID;

