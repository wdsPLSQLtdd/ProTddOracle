

--
-- Função de teste
CREATE OR REPLACE FUNCTION VALIDA_VALOR_FINAL_DA_VENDA( p_NOME_PRODUTO IN VARCHAR2, p_QUANTIDADE_ESTOQUE IN NUMBER, p_QUANTIDADE_VENDA IN NUMBER ) RETURN BOOLEAN IS
/*
{NOME:Realiza a validação sobre o valor final da venda}
{INFO:Após um processo de venda deve ser realizado a multiplicação do valor do produto pela quantidade de itens comprados, essa validação verifica se o valor final corresponde com o valor final da compra}
{ALVO_OWNER:VENDAS_ESTOQUE}
{ALVO_OBJECT:REALIZAR_VENDA}
{QUERY_ARGUMENTO:SELECT
                    NOME NOME_PRODUTO,
                    QUANTIDADE QUANTIDADE_ESTOQUE,
                    (SELECT QUANTIDADE FROM WDS_PLSQL_TDD_TESTE.PRODUTOS_PARA_VENDA V WHERE V.NOME = P.NOME) QUANTIDADE_VENDA
                FROM
                    WDS_PLSQL_TDD_TESTE.PRODUTOS_PARA_ESTOQUE P}
{ANTES:REALIZAR_VENDA_PRODUTO}
*/

    CURSOR c_PRODUTO( p_NOME_PRODUTO VARCHAR2 ) IS 
                    SELECT ID, QUANTIDADE, PRECO FROM VENDAS_ESTOQUE.ESTOQUE WHERE NOME = p_NOME_PRODUTO;


    CURSOR c_VENDA( p_PRODUTO_ID NUMBER ) IS 
                    SELECT QUANTIDADE_VENDIDA, VALOR_VENDA FROM VENDAS_ESTOQUE.VENDAS WHERE PRODUTO_ID = p_PRODUTO_ID;


    v_PRODUTO c_PRODUTO%ROWTYPE;

    v_VENDA c_VENDA%ROWTYPE;

    v_VALOR_FINAL_VENDA BINARY_FLOAT;

BEGIN

    -- Coleta o produto do Estoque
    OPEN c_PRODUTO( p_NOME_PRODUTO );
    FETCH c_PRODUTO INTO v_PRODUTO;
    CLOSE c_PRODUTO;


    -- Coleta a venda realizada
    OPEN c_VENDA( v_PRODUTO.ID );
    FETCH c_VENDA INTO v_VENDA;
    CLOSE c_VENDA;


    v_VALOR_FINAL_VENDA := ( v_PRODUTO.PRECO * p_QUANTIDADE_VENDA );


    -- Um estoque não pode ficar negativo
    IF v_VALOR_FINAL_VENDA < 0 THEN

        RETURN FALSE;

    END IF;

    
    RETURN v_VALOR_FINAL_VENDA = v_VENDA.VALOR_VENDA;

		
END;
/



