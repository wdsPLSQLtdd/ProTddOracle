

-- Tabela: LOG_RAISE_ERRO_EXECUCAO_TESTE
-- Descrição: Armazena o histórico de erros do tipo RAISE gerado na execução dos testes



--
-- Sequence para a definição do ID
CREATE SEQUENCE SEQ_LOG_RAISE_ERRO_EXC_TESTE START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;



CREATE TABLE LOG_RAISE_ERRO_EXECUCAO_TESTE
(
  ID NUMBER DEFAULT SEQ_LOG_RAISE_ERRO_EXC_TESTE.NEXTVAL NOT NULL 
, FK_TESTE_ID NUMBER NOT NULL
, ID_EXECUCAO NUMBER(16) NOT NULL
, CODIGO NUMBER NOT NULL
, DATA_REGISTRO DATE DEFAULT SYSDATE NOT NULL 
, ROWID_ARGUMENTO VARCHAR2(100) NOT NULL
, MSG VARCHAR2(4000) NOT NULL
, CONSTRAINT LOG_RAISE_ERRO_EXECUCAO_TESTE_PK PRIMARY KEY 
  (
    ID 
  )
  ENABLE 
);


ALTER TABLE LOG_RAISE_ERRO_EXECUCAO_TESTE ADD CONSTRAINT LOG_FALHA_EXC_TESTE_FK_TESTE_ID FOREIGN KEY ( FK_TESTE_ID ) REFERENCES TESTE ( ID ) ENABLE;


COMMENT ON TABLE LOG_RAISE_ERRO_EXECUCAO_TESTE IS '--

-- Armazena o histórico de erros do tipo RAISE ERROR gerado no teste
--
-- Autor: Wesley David Santos
-- Skype: wesleydavidsantos		
-- https://www.linkedin.com/in/wesleydavidsantos
--';

COMMENT ON COLUMN LOG_RAISE_ERRO_EXECUCAO_TESTE.ID IS 'Identificador único do LOG_RAISE_ERRO_EXECUCAO_TESTE';

COMMENT ON COLUMN LOG_RAISE_ERRO_EXECUCAO_TESTE.FK_TESTE_ID IS 'Identificação do teste';

COMMENT ON COLUMN LOG_RAISE_ERRO_EXECUCAO_TESTE.ID_EXECUCAO IS 'ID que identifica de forma única todos os TESTE realizados em um único processo de validação';

COMMENT ON COLUMN LOG_RAISE_ERRO_EXECUCAO_TESTE.CODIGO IS 'Código de identificação do teste, usado como identificação na tabela HISTORICO_EXECUCAO_TESTES';

COMMENT ON COLUMN LOG_RAISE_ERRO_EXECUCAO_TESTE.DATA_REGISTRO IS 'Data de execução do teste';

COMMENT ON COLUMN LOG_RAISE_ERRO_EXECUCAO_TESTE.ROWID_ARGUMENTO IS 'Identifica a linha com os argumentos que gerou o erro';

COMMENT ON COLUMN LOG_RAISE_ERRO_EXECUCAO_TESTE.MSG IS 'Mensagem de erro gerada SQLERRM';

