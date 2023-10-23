



CREATE OR REPLACE TRIGGER TRG_GERENCIA_TDD_CAPSULA_FILHA
--
-- Trigger responsável por gerenciar uma Capsula Filha quando ela sofre alteração no encapsulamento
--
-- Autor: Wesley David Santos
-- Skype: wesleydavidsantos		
-- https://www.linkedin.com/in/wesleydavidsantos
--
BEFORE UPDATE OF ENCAPSULADO ON TDD_CAPSULA_FILHA 
REFERENCING OLD AS OLD NEW AS NEW 
FOR EACH ROW
BEGIN
  
    IF :NEW.ENCAPSULADO = 'N' THEN
        
        UPDATE
            TDD_CAPSULA_PAI
        SET 
            ENCAPSULADO = 'N'
        WHERE
            FK_TESTE_ID = :NEW.FK_TESTE_ID;



        UPDATE
            TESTE
        SET 
            DATA_ALTERADO_DDL = SYSDATE
        WHERE
            ID = :NEW.FK_TESTE_ID;

    
    END IF;  
  
END;
/

