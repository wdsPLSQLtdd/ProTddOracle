

-- Tabela: DISPARAR_TESTES_TDD
-- Descrição: Tabela usada como uma Flag, quando existir algum registro nela devem ser disparados os testes, quando os testes são finalizados essa tabela é apagada.
-- Toda vez que algum objeto dos Owners monitorados são alterados um registro é inserido nessa tabela.




--
-- Sequence para a definição do ID
CREATE SEQUENCE SEQ_DISPARAR_TESTES_TDD START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;




CREATE TABLE DISPARAR_TESTES_TDD 
(
   ID NUMBER DEFAULT SEQ_DISPARAR_TESTES_TDD.NEXTVAL NOT NULL
  ,DATA_REGISTRO DATE NOT NULL
  ,OWNER VARCHAR2(50)
  ,OBJECT_NAME VARCHAR2(200)
  ,OBJECT_TYPE VARCHAR2(200)
  ,EVENTO VARCHAR2(200)
  ,TERMINAL VARCHAR2(2000)
  ,CURRENT_USER VARCHAR2(100)
  ,SESSION_USER VARCHAR2(100)
  ,HOST VARCHAR2(200)
  ,OS_USER VARCHAR2(200)
  ,EXTERNAL_NAME VARCHAR2(200)
  ,IP_ADDRESS VARCHAR2(100)
  ,TDD_EXECUTADO CHAR(1) DEFAULT 'N' NOT NULL
);





ALTER TABLE DISPARAR_TESTES_TDD ADD CONSTRAINT DISPARAR_TDD_EXECUTADO_CHK CHECK ( TDD_EXECUTADO IN ( 'Y', 'N' ) ) ENABLE;


COMMENT ON TABLE DISPARAR_TESTES_TDD IS '--

-- Tabela usada como uma Flag, quando existir algum registro nela devem ser disparados os testes, quando os testes são finalizados essa tabela é apagada
-- Toda vez que algum objeto dos Owners monitorados são alterados um registro é inserido nessa tabela.
--
-- Autor: Wesley David Santos
-- Skype: wesleydavidsantos		
-- https://www.linkedin.com/in/wesleydavidsantos
--';


COMMENT ON COLUMN DISPARAR_TESTES_TDD.DATA_REGISTRO IS 'Informa o momento da alteração de algum objeto dos Owners monitorados';

COMMENT ON COLUMN DISPARAR_TESTES_TDD.OWNER IS 'Owner que sofreu alteração';
