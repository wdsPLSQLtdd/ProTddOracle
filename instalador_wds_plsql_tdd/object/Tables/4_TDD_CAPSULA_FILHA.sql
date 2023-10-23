


-- Tabela: TDD_CAPSULA_FILHA
-- Descrição: Armazena os TESTES que passaram pelo processo de encapsulamento que gera o Objeto final que realiza o teste


--
-- Sequence para a definição do ID
CREATE SEQUENCE SEQ_TDD_CAPSULA_FILHA START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;




CREATE TABLE TDD_CAPSULA_FILHA 
(
  ID NUMBER DEFAULT SEQ_TDD_CAPSULA_FILHA.NEXTVAL NOT NULL 
, FK_TESTE_ID NUMBER NOT NULL 
, DATA_ALTERADO DATE NOT NULL 
, ENCAPSULADO CHAR(1) NOT NULL 
, CONSTRAINT TDD_CAPSULA_FILHA_PK PRIMARY KEY 
  (
    ID 
  )
  ENABLE 
);

ALTER TABLE TDD_CAPSULA_FILHA ADD CONSTRAINT TDD_CAPSULA_FILHA_FK_TESTE_ID FOREIGN KEY ( FK_TESTE_ID ) REFERENCES TESTE ( ID ) ENABLE;

ALTER TABLE TDD_CAPSULA_FILHA ADD CONSTRAINT TDD_CAPSULA_FILHA_CHK_ENCAPSULADO CHECK ( ENCAPSULADO IN ( 'Y', 'N' ) ) ENABLE;


COMMENT ON TABLE TDD_CAPSULA_FILHA IS '--

-- Armazena os TESTES que passaram pelo processo de encapsulamento que gera o Objeto final que realiza o teste
--
-- Autor: Wesley David Santos
-- Skype: wesleydavidsantos		
-- https://www.linkedin.com/in/wesleydavidsantos
--';


COMMENT ON COLUMN TDD_CAPSULA_FILHA.ID IS 'Identificação única do encapsulamento';

COMMENT ON COLUMN TDD_CAPSULA_FILHA.FK_TESTE_ID IS 'Identifica o teste do DEV que foi encapsulado';

COMMENT ON COLUMN TDD_CAPSULA_FILHA.DATA_ALTERADO IS 'Identifica a data em que a capsula foi compilada ou descompilada';

COMMENT ON COLUMN TDD_CAPSULA_FILHA.ENCAPSULADO IS 'Informa se o encapsulamento é válido, se o teste Primário e os testes Antes e Depois que acompanham o teste primário não sofreu alteração.';
