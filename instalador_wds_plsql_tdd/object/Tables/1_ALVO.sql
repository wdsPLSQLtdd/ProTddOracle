

-- Tabela: ALVO
-- Descrição: Armazena todos os testes que serão realizados, um mesmo ALVO pode possuir vários testes



--
-- Sequence para a definição do ID das ALVO
CREATE SEQUENCE SEQ_ALVO START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;



CREATE TABLE ALVO
(
  ID NUMBER DEFAULT SEQ_ALVO.NEXTVAL NOT NULL
, OWNER VARCHAR2(50) NOT NULL 
, OBJECT_NAME VARCHAR2(500) NOT NULL
, CONSTRAINT ALVO_PK PRIMARY KEY 
  (
    ID 
  )
  ENABLE 
);


ALTER TABLE ALVO ADD CONSTRAINT ALVO_OBJECT_UK UNIQUE ( OWNER, OBJECT_NAME ) ENABLE;


COMMENT ON TABLE ALVO IS '--

-- Armazena os ALVOS que estão sendo testados, um mesmo ALVO pode possuir vários testes.
--
-- Autor: Wesley David Santos
-- Skype: wesleydavidsantos		
-- https://www.linkedin.com/in/wesleydavidsantos
--';

COMMENT ON COLUMN ALVO.ID IS 'Identificador único do ALVO';

COMMENT ON COLUMN ALVO.OWNER IS 'Dono do objeto a ser testado';

COMMENT ON COLUMN ALVO.OBJECT_NAME IS 'Nome do objeto a ser testado';



