
create or replace TRIGGER TRG_IDENTIFICA_DDL_TESTE_TDD
--
-- Trigger responsável por identificar a criação ou alteração de testes TDD
--
-- Autor: Wesley David Santos
-- Skype: wesleydavidsantos		
-- https://www.linkedin.com/in/wesleydavidsantos
--
    BEFORE DDL
	ON DATABASE
DECLARE

BEGIN

	IF ora_dict_obj_owner = CONSTANTES.OWNER_WDS_TDD_TESTE AND ora_dict_obj_type = 'FUNCTION' THEN

		BEGIN

			-- Registra que o teste foi alterado
			INSERT INTO LISTA_NOVOS_TESTES ( ASSERCAO ) VALUES ( ora_dict_obj_name );


			-- Força o registro que os dependentes deste teste foi alterado
			INSERT INTO LISTA_NOVOS_TESTES ( ASSERCAO ) 
											SELECT
												ASSERCAO
											FROM
												TESTE T
											WHERE
												ID IN (
															SELECT
																FILHAS.FK_TESTE_ID ID_PAI
															FROM
																TESTE T
																INNER JOIN ANTES_DEPOIS FILHAS ON FILHAS.FK_TESTE_ACAO_ID = T.ID
															WHERE
																ASSERCAO = ora_dict_obj_name
													)
												AND NOT EXISTS ( SELECT 1 FROM LISTA_NOVOS_TESTES WHERE ASSERCAO = T.ASSERCAO );




			-- Força a atualização do TESTE, mesmo se o compilação do TESTE TDD não sofreu alteração em seu código.
			UPDATE TESTE SET DATA_ALTERADO_DDL = SYSDATE WHERE ASSERCAO = ora_dict_obj_name;



			-- Caso exista, força a atualização de todos os Pais do Teste que está sendo atualizado
			UPDATE TESTE SET DATA_ALTERADO_DDL = SYSDATE WHERE ID IN (
																		SELECT
																			FILHAS.FK_TESTE_ID ID_PAI
																		FROM
																			TESTE T
																			INNER JOIN ANTES_DEPOIS FILHAS ON FILHAS.FK_TESTE_ACAO_ID = T.ID
																		WHERE
																			ASSERCAO = ora_dict_obj_name
																	 );


		EXCEPTION

			WHEN OTHERS THEN

				NULL;

		END;

	END IF;

END;
/

