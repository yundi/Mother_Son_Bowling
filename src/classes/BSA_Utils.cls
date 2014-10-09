/*
*   @Class : BSA_Utils.cls
*
*   @Author         :   Gonzalo Abruña
*   @Created        :   20 April 2014
*   @Description    :   Apex class that will store default values that might be used by different classes, according to requirements of TopCoder
*                       challenge: http://www.topcoder.com/challenge-details/30042041/?type=&nocache=true#.U1Ptcv3lTeE
*
*      ----------------------------------------------------------------------------------------------------------------------------                                
*      Modification Log     : 
*      ----------------------------------------------------------------------------------------------------------------------------
*      Developer             Date                Description
*      ----------------------------------------------------------------------------------------------------------------------------   
*      Gonzalo Abruña        20 April 2014        Creation
*
*/
public class BSA_Utils{
    public  static  final String  CAMPAIGN_BOWLING_NAME       = Label.BSA_ParentCampaign_Name;  //Name of Campaign.
    public  static  final Integer MAX_PEOPLE_PER_LANE         = 9;  //Maximum 9 persons per lane
    public  static  	  Integer NUMBER_OF_LANES             = 30; //Total number of bowling lanes. Don´t set it to final to be able to play with it in testmethods
    public  static  final String  CAMPAIGN_STATUS             = 'Registered'; //Total number of bowling lanes
    public  static  final String  APPLICATION_RECTYPE_DEVNAME = 'MSB_BowlingApplication'; //Total number of bowling lanes
    public  static  final String  EVENT_RECTYPE_DEVNAME       = 'MSB_Event'; //Total number of bowling lanes
    public  static  final Map<String, Integer>  GRADE_NUMBER  = new Map<String, Integer>{'Adult'=>0, 'Kindergarten'=>1, '1st'=>2, '2nd'=>3, '3rd'=>4, '4th'=>5};
    public  static  final Map<Integer, String>  GRADE_NAME    = new Map<Integer, String>{0=>'Adult', 1=>'Kindergarten', 2=>'1st', 2=>'2nd', 3=>'3rd', 5=>'4th'}; 
    public	static	final String  ADULT 					  = 'Adult';  
    public	static	final String  KINDERGARTEN 				  = 'Kindergarten';
    public	static	final String  FIRST_GRADE 				  = '1st';
    public	static	final String  SECOND_GRADE 				  = '2nd';
    public	static	final String  THIRD_GRADE 				  = '3rd';
    public	static	final String  FOURTH_GRADE 				  = '4th';

    public static String getParentCampaignName(){
    	return CAMPAIGN_BOWLING_NAME;
    }

    public static void clearPreviousLanes(List<Campaign> lCampaigns){
    	for(Campaign c : lCampaigns)
    		c.MSB_Lane__c = null;
    	if(lCampaigns != null && !lCampaigns.isEmpty())
    	update lCampaigns;
    }
}