

--
-- Função de teste
CREATE OR REPLACE FUNCTION VALIDA_BAIXA_NO_ESTOQUE( p_NOME_PRODUTO IN VARCHAR2, p_QUANTIDADE_ESTOQUE IN NUMBER, p_QUANTIDADE_VENDA IN NUMBER ) RETURN BOOLEAN IS
/*
{NOME:Realiza a validação de baixa no estoque}
{INFO:Após um processo de venda deve ser realizado a baixo do estoque e esse processo valida se está realizando a baixa de acordo com a venda}
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


    v_PRODUTO c_PRODUTO%ROWTYPE;

    v_ESTOQUE_VALIDO NUMBER;

BEGIN

    -- Coleta o produto do Estoque
    OPEN c_PRODUTO( p_NOME_PRODUTO );
    FETCH c_PRODUTO INTO v_PRODUTO;
    CLOSE c_PRODUTO;


    v_ESTOQUE_VALIDO := ( p_QUANTIDADE_ESTOQUE - p_QUANTIDADE_VENDA );

    -- Um estoque não pode ficar negativo
    IF v_ESTOQUE_VALIDO < 0 THEN

        v_ESTOQUE_VALIDO := 0;

    END IF;

    
    RETURN v_ESTOQUE_VALIDO = v_PRODUTO.QUANTIDADE;

		
END;
/





