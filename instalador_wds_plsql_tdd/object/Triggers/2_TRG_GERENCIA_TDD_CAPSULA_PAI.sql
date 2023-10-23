



CREATE OR REPLACE TRIGGER TRG_GERENCIA_TDD_CAPSULA_PAI
--
-- Trigger responsável por gerenciar uma capsula Pai quando ela sofre alteração no encapsulamento
--
-- Autor: Wesley David Santos
-- Skype: wesleydavidsantos		
-- https://www.linkedin.com/in/wesleydavidsantos
--
BEFORE UPDATE OF TRACE_ATIVADO ON TDD_CAPSULA_PAI 
REFERENCING OLD AS OLD NEW AS NEW 
FOR EACH ROW
BEGIN

    :NEW.ENCAPSULADO := 'N';


    UPDATE
        TESTE
    SET 
        DATA_ALTERADO_DDL = SYSDATE
    WHERE
        ID = :OLD.FK_TESTE_ID;

END;
/

