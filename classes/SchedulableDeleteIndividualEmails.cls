global with sharing class SchedulableDeleteIndividualEmails implements Schedulable{
    global void execute(SchedulableContext sc) {
       if(!Test.isRunningTest()) {  
        SchedulableDeleteIndividualEmails.runSchedule();
      }
   }
   public static void start(Integer hora, Integer minutes) {
       hora = (hora==null) ? 0 : hora;
       //Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
       if(!Test.isRunningTest()) {  
           System.schedule('Batch to delete old individual emails ' + hora +' hs.', '0 '+minutes+' '+hora+' * * ?', new SchedulableDeleteIndividualEmails());
       }
   } 
    
   public static void runSchedule() {
       if(!Test.isRunningTest()) {  
        BatchDeleteIndividualEmails.startBatch();

           system.debug(LoggingLevel.INFO, '### starting contributions deletion batch ...');  
       }
   } 
}