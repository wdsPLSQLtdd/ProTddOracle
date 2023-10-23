

-- Tabela: LOG_DISPARO_TESTES_TDD
-- Descrição: Armazena os logs sobre os disparos de testes TDD que foram realizados



--
-- Sequence para a definição do ID
CREATE SEQUENCE SEQ_LOG_DISPARO_TESTES_TDD START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;



CREATE TABLE LOG_DISPARO_TESTES_TDD 
(
  ID NUMBER DEFAULT SEQ_LOG_DISPARO_TESTES_TDD.NEXTVAL NOT NULL
, DATA_REGISTRO DATE NOT NULL 
, TOTAL_TESTES NUMBER NOT NULL 
, SUCESSO NUMBER NOT NULL 
, FALHA NUMBER NOT NULL 
, INVALIDOS NUMBER NOT NULL 
, TEMPO_EXECUCAO BINARY_FLOAT NOT NULL
, CONSTRAINT LOG_DISPARO_TESTES_TDD_PK PRIMARY KEY 
  (
    ID 
  )
  ENABLE 
);



COMMENT ON TABLE LOG_DISPARO_TESTES_TDD IS '--

-- Armazena os logs sobre os disparos de testes TDD que foram realizados
--
-- Autor: Wesley David Santos
-- Skype: wesleydavidsantos		
-- https://www.linkedin.com/in/wesleydavidsantos
--';

COMMENT ON COLUMN LOG_DISPARO_TESTES_TDD.ID IS 'Identificador único do log do teste';

COMMENT ON COLUMN LOG_DISPARO_TESTES_TDD.DATA_REGISTRO IS 'Data em que o teste foi executado';

COMMENT ON COLUMN LOG_DISPARO_TESTES_TDD.TOTAL_TESTES IS 'Quantidade de testes que existem sendo válidos ou inválidos';

COMMENT ON COLUMN LOG_DISPARO_TESTES_TDD.SUCESSO IS 'Quantidade de testes executados com sucesso';

COMMENT ON COLUMN LOG_DISPARO_TESTES_TDD.FALHA IS 'Quantidade de testes executados com falha';

COMMENT ON COLUMN LOG_DISPARO_TESTES_TDD.INVALIDOS IS 'Quantidade de testes existentes e estão inválidos';

COMMENT ON COLUMN LOG_DISPARO_TESTES_TDD.TEMPO_EXECUCAO IS 'Tempo de execução de todos os testes';



