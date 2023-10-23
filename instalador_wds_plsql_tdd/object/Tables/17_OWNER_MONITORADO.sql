

-- Tabela: OWNER_MONITORADO
-- Descrição: Armazena o nome dos Owners que devem ser monitorados para o processo de TDD



--
-- Sequence para a definição do ID
CREATE SEQUENCE SEQ_OWNER_MONITORADO START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;



CREATE TABLE OWNER_MONITORADO
(
  ID NUMBER DEFAULT SEQ_OWNER_MONITORADO.NEXTVAL NOT NULL 
, DATA_REGISTRO DATE DEFAULT SYSDATE NOT NULL 
, OWNER VARCHAR2(50) NOT NULL 
, ATIVADO VARCHAR2(1) NOT NULL 
, CONSTRAINT OWNER_MONITORADO_PK PRIMARY KEY 
  (
    ID 
  )
  ENABLE 
);

ALTER TABLE OWNER_MONITORADO ADD CONSTRAINT OWNER_MONITORADO_UK UNIQUE ( OWNER ) ENABLE;

ALTER TABLE OWNER_MONITORADO ADD CONSTRAINT OWNER_MONITORADO_ATIVADO_CHK CHECK ( ATIVADO IN ( 'Y', 'N' ) ) ENABLE;


COMMENT ON TABLE OWNER_MONITORADO IS '--

-- Armazena o nome dos Owners que devem ser monitorados para o processo de TDD
--
-- Autor: Wesley David Santos
-- Skype: wesleydavidsantos		
-- https://www.linkedin.com/in/wesleydavidsantos
--';

COMMENT ON COLUMN OWNER_MONITORADO.ID IS 'Identificador único do OWNER_MONITORADO';

COMMENT ON COLUMN OWNER_MONITORADO.DATA_REGISTRO IS 'Data de cadastro do Owner';

COMMENT ON COLUMN OWNER_MONITORADO.OWNER IS 'Nome do Owner que está sendo monitorado';

COMMENT ON COLUMN OWNER_MONITORADO.ATIVADO IS 'Informa se o Owner monitorado está ativado ou desativado';
