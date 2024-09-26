

create or replace TRIGGER TRG_MONITORA_DDL_DISPARO_TDD
--
-- Trigger responsável por monitorar se os objetos dos Owners monitorados sofreu algum DDL, se sim, todos os testes serão realizados
-- Os owners que são monitorados ficam registrados na tabela OWNER_MONITORADO
--
-- Autor: Wesley David Santos
-- Skype: wesleydavidsantos		
-- https://www.linkedin.com/in/wesleydavidsantos
--

    AFTER DDL
	ON DATABASE
DECLARE

	v_FLAG_EXISTE NUMBER;

	v_OWNER VARCHAR2(50);
	v_OBJECT_NAME VARCHAR2(200);
	v_OBJECT_TYPE VARCHAR2(200);
	v_EVENTO VARCHAR2(200);
	v_TERMINAL VARCHAR2(2000);
	v_CURRENT_USER VARCHAR2(100);
	v_SESSION_USER VARCHAR2(100);
	v_HOST VARCHAR2(200);
	v_OS_USER VARCHAR2(200);
	v_EXTERNAL_NAME VARCHAR2(200);
	v_IP_ADDRESS VARCHAR2(100);
	
BEGIN

	
	BEGIN

		v_OWNER := ora_dict_obj_owner;


		SELECT COUNT(*) INTO v_FLAG_EXISTE FROM OWNER_MONITORADO WHERE OWNER = v_OWNER AND ATIVADO = 'Y';


		IF v_FLAG_EXISTE > 0 THEN

						
			v_OBJECT_NAME := ora_dict_obj_name;
			v_OBJECT_TYPE := ora_dict_obj_type;
			v_EVENTO := ora_sysevent;


			-- Informações da Sessão		
			SELECT SYS_CONTEXT('USERENV','TERMINAL')  INTO V_TERMINAL FROM DUAL;
			SELECT SYS_CONTEXT('USERENV','CURRENT_USER')  INTO V_CURRENT_USER FROM DUAL;
			SELECT SYS_CONTEXT('USERENV','SESSION_USER')  INTO V_SESSION_USER FROM DUAL;
			SELECT SYS_CONTEXT('USERENV','HOST')  INTO V_HOST FROM DUAL;
			SELECT SYS_CONTEXT('USERENV','OS_USER')  INTO V_OS_USER FROM DUAL;
			SELECT SYS_CONTEXT('USERENV','EXTERNAL_NAME')  INTO V_EXTERNAL_NAME FROM DUAL;
			SELECT SYS_CONTEXT('USERENV','IP_ADDRESS')  INTO V_IP_ADDRESS FROM DUAL;


			IF V_SESSION_USER NOT IN ( 'WDS_PLSQL_TDD' ) THEN

				INSERT INTO DISPARAR_TESTES_TDD 
					(
						 DATA_REGISTRO
						,OWNER
						,OBJECT_NAME
						,OBJECT_TYPE
						,EVENTO
						,TERMINAL
						,CURRENT_USER
						,SESSION_USER
						,HOST
						,OS_USER
						,EXTERNAL_NAME
						,IP_ADDRESS
					) 
				VALUES
					(
						 SYSDATE
						,v_OWNER
						,v_OBJECT_NAME
						,v_OBJECT_TYPE
						,v_EVENTO
						,v_TERMINAL
						,v_CURRENT_USER
						,v_SESSION_USER
						,v_HOST
						,v_OS_USER
						,v_EXTERNAL_NAME
						,v_IP_ADDRESS
					);

			END IF;
		
		END IF;
			

	EXCEPTION

		WHEN OTHERS THEN

			LOG_GERENCIADOR.ADD_SUCESSO( 'SISTEMA', 'Falha na Trigger que verifica alterações de DDL nos Owners monitorados, o que permite o disparo dos testes de TDD. Erro: ' || SQLERRM || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );

	END;


END;
/

