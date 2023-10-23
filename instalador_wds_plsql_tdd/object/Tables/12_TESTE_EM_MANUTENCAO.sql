

-- Tabela: TESTE_EM_MANUTENCAO
-- Descrição: Armazena de forma temporária os testes que estão sofrendo manutenção de encapsulamento, desta forma evita que um mesmo teste fique em manutenção de forma paralela


CREATE TABLE TESTE_EM_MANUTENCAO
(
  ASSERCAO VARCHAR2(500) NOT NULL
, DATA_INICIO DATE DEFAULT SYSDATE NOT NULL 
);

ALTER TABLE TESTE_EM_MANUTENCAO ADD CONSTRAINT TESTE_EM_MANUTENCAO_UK UNIQUE ( ASSERCAO ) ENABLE;


COMMENT ON TABLE TESTE_EM_MANUTENCAO IS '--

-- Armazena de forma temporária os testes que estão sofrendo manutenção de encapsulamento, desta forma evita que um mesmo teste fique em manutenção de forma paralela
--
-- Autor: Wesley David Santos
-- Skype: wesleydavidsantos		
-- https://www.linkedin.com/in/wesleydavidsantos
--';


COMMENT ON COLUMN TESTE_EM_MANUTENCAO.ASSERCAO IS 'Identificação do nome da Function de teste';

COMMENT ON COLUMN TESTE_EM_MANUTENCAO.DATA_INICIO IS 'Data de manutenção do teste';
