
--
-- Job usado para monitorar Testes criados ou alterados

BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
            job_name => 'JOB_MONITORAR_NOVOS_TESTES',
            job_type => 'STORED_PROCEDURE',
            job_action => 'MONITORAR_NOVOS_TESTES.PROCESSAR',
            number_of_arguments => 0,
            start_date => TO_TIMESTAMP_TZ('2023-09-21 22:26:58.000000000 AMERICA/SAO_PAULO','YYYY-MM-DD HH24:MI:SS.FF TZR'),
            repeat_interval => 'FREQ=SECONDLY;INTERVAL=5',
            end_date => NULL,
            enabled => FALSE,
            auto_drop => FALSE,
            comments => 'Job que monitora quando testes TDD são criados ou alterados');

         
     
 
    DBMS_SCHEDULER.SET_ATTRIBUTE( 
             name => 'JOB_MONITORAR_NOVOS_TESTES', 
             attribute => 'store_output', value => TRUE);
    DBMS_SCHEDULER.SET_ATTRIBUTE( 
             name => 'JOB_MONITORAR_NOVOS_TESTES', 
             attribute => 'logging_level', value => DBMS_SCHEDULER.LOGGING_OFF);
      
   
  
    
    DBMS_SCHEDULER.enable(
             name => 'JOB_MONITORAR_NOVOS_TESTES');
END;
/

