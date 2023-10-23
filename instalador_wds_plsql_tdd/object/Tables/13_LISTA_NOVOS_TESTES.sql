

-- Tabela: ALVO
-- Descrição: Registra o nome das Function de teste criados ou atualizados




CREATE TABLE LISTA_NOVOS_TESTES 
(
     ASSERCAO VARCHAR(200) NOT NULL
    ,DATA_REGISTRO DATE DEFAULT SYSDATE NOT NULL 
);

ALTER TABLE LISTA_NOVOS_TESTES ADD CONSTRAINT LISTA_NOVOS_TESTES_UK UNIQUE ( ASSERCAO ) ENABLE;


COMMENT ON TABLE LISTA_NOVOS_TESTES IS '--

-- Registra o nome das Function de teste criados ou atualizados
--
-- Autor: Wesley David Santos
-- Skype: wesleydavidsantos		
-- https://www.linkedin.com/in/wesleydavidsantos
--';


COMMENT ON COLUMN LISTA_NOVOS_TESTES.ASSERCAO IS 'Nome da Function de teste';

COMMENT ON COLUMN LISTA_NOVOS_TESTES.DATA_REGISTRO IS 'Data em que o teste foi registrado';
