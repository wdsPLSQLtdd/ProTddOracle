

--
-- Função de teste
CREATE OR REPLACE FUNCTION REALIZAR_VENDA_PRODUTO RETURN BOOLEAN IS
/*
{NOME:Realiza uma venda}
{INFO:Realiza um processo de venda sobre um determinado produto do estoque }
{ALVO_OWNER:VENDAS_ESTOQUE}
{ALVO_OBJECT:REALIZAR_VENDA}
*/

    v_ID_PRODUTO NUMBER := 3;

    v_QTD_COMPRA NUMBER := 8;

    v_FLAG_VENDA_REALIZADA NUMBER;

BEGIN

    -- Realiza a Venda
	VENDAS_ESTOQUE.REALIZAR_VENDA( v_ID_PRODUTO, v_QTD_COMPRA );


    -- Verifica se a venda foi realizada
    SELECT
        COUNT(1) INTO v_FLAG_VENDA_REALIZADA
    FROM
        VENDAS_ESTOQUE.VENDAS
    WHERE 
        PRODUTO_ID = v_ID_PRODUTO
        AND QUANTIDADE_VENDIDA = v_QTD_COMPRA;
    

    RETURN v_FLAG_VENDA_REALIZADA > 0;

		
END;
/