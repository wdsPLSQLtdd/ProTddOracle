
--
-- Job usado para executar todos os testes ativos

BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
            job_name => 'EXECUTAR_TESTES_AUTOMATIZADOS',
            job_type => 'STORED_PROCEDURE',
            job_action => 'EXECUTAR_TESTES_TDD.DISPARAR_TESTES_TDD',
            number_of_arguments => 0,
            start_date => TO_TIMESTAMP_TZ('2023-09-21 19:58:30.000000000 AMERICA/SAO_PAULO','YYYY-MM-DD HH24:MI:SS.FF TZR'),
            repeat_interval => 'FREQ=SECONDLY;INTERVAL=5',
            end_date => NULL,
            enabled => FALSE,
            auto_drop => FALSE,
            comments => 'Job que verifica se existem novos testes a serem executados');

         
     
 
    DBMS_SCHEDULER.SET_ATTRIBUTE( 
             name => 'EXECUTAR_TESTES_AUTOMATIZADOS', 
             attribute => 'store_output', value => TRUE);
    DBMS_SCHEDULER.SET_ATTRIBUTE( 
             name => 'EXECUTAR_TESTES_AUTOMATIZADOS', 
             attribute => 'logging_level', value => DBMS_SCHEDULER.LOGGING_OFF);
      
   
  
    
    DBMS_SCHEDULER.enable(
             name => 'EXECUTAR_TESTES_AUTOMATIZADOS');
END;
/

