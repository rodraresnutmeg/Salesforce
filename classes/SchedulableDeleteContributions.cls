global with sharing class SchedulableDeleteContributions implements Schedulable{
    global void execute(SchedulableContext sc) {
       if(!Test.isRunningTest()) {  
        SchedulableDeleteContributions.runSchedule();
      }
   }
   public static void start(Integer hora, Integer minutes) {
       hora = (hora==null) ? 0 : hora;
       //Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
       if(!Test.isRunningTest()) {  
           System.schedule('Batch to delete old contributions ' + hora +' hs.', '0 '+minutes+' '+hora+' * * ?', new SchedulableDeleteContributions());
       }
   } 
    
   public static void runSchedule() {
       if(!Test.isRunningTest()) {  
           BatchDeleteContributions.startBatch();

           system.debug(LoggingLevel.INFO, '### starting contributions deletion batch ...');  
          // BatchDeleteContributions.start();
       }
   } 
}