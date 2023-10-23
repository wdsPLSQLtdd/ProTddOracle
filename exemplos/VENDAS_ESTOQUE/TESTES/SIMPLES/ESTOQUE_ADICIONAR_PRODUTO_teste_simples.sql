--
-- Função de teste
CREATE OR REPLACE FUNCTION ESTOQUE_ADICIONAR_PRODUTO RETURN BOOLEAN IS
/*
{NOME:Adiciona novo produto no Estoque}
{INFO:Realiza o cadastro de um novo produto ao estoque }
{ALVO_OWNER:VENDAS_ESTOQUE}
{ALVO_OBJECT:ADICIONAR_PRODUTO}
*/
	
	v_FLAG_REGISTRADO NUMBER;

    v_NOME_PRODUTO VARCHAR2(100);

    v_PRECO_PRODUTO BINARY_FLOAT;

    v_QUANTIDADE_PRODUTOS NUMBER;


BEGIN

    -- Gera um nome aleatório
    v_NOME_PRODUTO := 'Pneu Top dos Top - X_' || TRUNC( DBMS_RANDOM.VALUE(0, 1001) );

    v_PRECO_PRODUTO := 286.90;

    v_QUANTIDADE_PRODUTOS := 22;


	VENDAS_ESTOQUE.ADICIONAR_PRODUTO( v_NOME_PRODUTO, v_QUANTIDADE_PRODUTOS, v_PRECO_PRODUTO );


    -- Verifica se o produto foi inserido com sucesso
    SELECT COUNT(1)  INTO v_FLAG_REGISTRADO FROM VENDAS_ESTOQUE.ESTOQUE WHERE NOME = v_NOME_PRODUTO;


    RETURN v_FLAG_REGISTRADO > 0;

		
END;
/




