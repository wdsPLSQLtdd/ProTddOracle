


-- Tabela: TDD_CAPSULA_PAI
-- Descrição: Armazena os TESTES que devem ser considerados os testes reais de desenvolvimento. Os testes primários são aqueles que não participam como auxiliares de ANTES_DEPOIS de outro Teste


--
-- Sequence para a definição do ID
CREATE SEQUENCE SEQ_TDD_CAPSULA_PAI START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;




CREATE TABLE TDD_CAPSULA_PAI
(
  ID NUMBER DEFAULT SEQ_TDD_CAPSULA_PAI.NEXTVAL NOT NULL 
, FK_TESTE_ID NUMBER NOT NULL 
, DATA_ALTERADO DATE DEFAULT SYSDATE NOT NULL 
, ENCAPSULADO CHAR(1) NOT NULL
, TRACE_ATIVADO CHAR(1) DEFAULT 'N' NOT NULL
, CONSTRAINT TDD_CAPSULA_PAI_PK PRIMARY KEY 
  (
    ID 
  )
  ENABLE 
);

ALTER TABLE TDD_CAPSULA_PAI ADD CONSTRAINT TDD_CAPSULA_PAI_FK_TESTE FOREIGN KEY ( FK_TESTE_ID ) REFERENCES TESTE ( ID ) ENABLE;

ALTER TABLE TDD_CAPSULA_PAI ADD CONSTRAINT TDD_CAPSULA_PAI_CHK_ENCAPSULADO CHECK ( ENCAPSULADO IN ( 'Y', 'N' ) ) ENABLE;


COMMENT ON TABLE TDD_CAPSULA_PAI IS '--

-- Armazena os TESTES que devem ser considerados os testes reais de desenvolvimento. Os testes primários são aqueles que não participam como auxiliares de ANTES_DEPOIS de outro Teste
--
-- Autor: Wesley David Santos
-- Skype: wesleydavidsantos		
-- https://www.linkedin.com/in/wesleydavidsantos
--';


COMMENT ON COLUMN TDD_CAPSULA_PAI.ID IS 'Identificação única do TESTE primário';

COMMENT ON COLUMN TDD_CAPSULA_PAI.FK_TESTE_ID IS 'Identifica o teste que será avaliado';

COMMENT ON COLUMN TDD_CAPSULA_PAI.DATA_ALTERADO IS 'Identifica a data em que a capsula foi compilada ou descompilada';

COMMENT ON COLUMN TDD_CAPSULA_PAI.ENCAPSULADO IS 'Informa se o teste é válido, se o teste Primário e os testes Antes e Depois que acompanham o teste primário não sofreu alteração.';

COMMENT ON COLUMN TDD_CAPSULA_PAI.TRACE_ATIVADO IS 'Informa se deve ser gerado TRACE nas execuções do Teste';
