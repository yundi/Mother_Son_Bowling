/*
*   @Class : BSA_LanesAssignment_Controller.cls
*
*   @Author         :   Gonzalo Abruña
*   @Created        :   21 April 2014
*   @Description    :   Apex controller class that will show all per lane, according to requirements of TopCoder
*                       challenge: http://www.topcoder.com/challenge-details/30042041/?type=&nocache=true#.U1Ptcv3lTeE
*
*      ----------------------------------------------------------------------------------------------------------------------------                                
*      Modification Log     : 
*      ----------------------------------------------------------------------------------------------------------------------------
*      Developer             Date                Description
*      ----------------------------------------------------------------------------------------------------------------------------   
*      Gonzalo Abruña        21 April 2014        Creation
*
*/
public class BSA_LanesAssignment_Controller{
	public Map<String, List<Campaign>> mapCampaignsPerLane{get;set;}
	public Map<String, Integer> mapNrParticipantsInLane{get;set;} //To know the number of participants per Lane
	public Map<Id, List<CampaignMember>> mapMembersPerCampaign{get;set;}
	public List<String> orderedLanes{get;set;} //Because maps are not ordered

	public BSA_LanesAssignment_Controller(){
		try{
			initOrderedLanes();
			showLanes();
		}catch(Exception e){
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
        	ApexPages.addMessage(myMsg);
        	return;
		}
	}

	//Just set values from 1 to NUMBER_OF_LANES
	private void initOrderedLanes(){
		orderedLanes = new List<String>();
		for(integer i=1; i<=BSA_Utils.NUMBER_OF_LANES;i++)
			orderedLanes.add(String.valueOf(i));
	}

	//Populate values for listOfLanes that will be used by the Visualforce page
	public void showLanes(){
		initLaneCampaigns();
		mapMembersPerCampaign = new Map<Id, List<CampaignMember>>();

		for(Campaign c : [SELECT Id, Name, MSB_Lane__c, MSB_Household__c, MSB_of_Members__c, MSB_Household__r.Name,
                                            (SELECT Id, ContactId, Contact.Name, MSB_Grade__c FROM CampaignMembers ORDER BY MSB_Grade__c) //To calculate the grade of a Campaign
                                    FROM Campaign
                                    WHERE Parent.Name = :BSA_Utils.getParentCampaignName()
                                        AND Parent.RecordType.DeveloperName = :BSA_Utils.EVENT_RECTYPE_DEVNAME
                                        AND Status = :BSA_Utils.CAMPAIGN_STATUS
                                        AND RecordType.DeveloperName = :BSA_Utils.APPLICATION_RECTYPE_DEVNAME
                                        AND MSB_Lane__c != null
                                        AND MSB_of_Members__c > 0]){
			mapCampaignsPerLane.get(c.MSB_Lane__c).add(c);
			if(!mapMembersPerCampaign.containsKey(c.Id)){
				mapMembersPerCampaign.put(c.Id, new List<CampaignMember>());
			}
			if(c.CampaignMembers != null && !c.CampaignMembers.isEmpty()){
				mapNrParticipantsInLane.put(c.MSB_Lane__c, mapNrParticipantsInLane.get(c.MSB_Lane__c)+c.CampaignMembers.size());
				mapMembersPerCampaign.get(c.Id).addAll(c.CampaignMembers);
			}
		}
	}

	//Ensure that every Lane has a defined a key value for each lane to avoid null pointer exceptions
	private void initLaneCampaigns(){
		mapCampaignsPerLane = new Map<String, List<Campaign>>();
		mapNrParticipantsInLane = new Map<String, Integer>();

		for(integer i=1; i<=BSA_Utils.NUMBER_OF_LANES;i++){
			mapCampaignsPerLane.put(String.valueOf(i), new List<Campaign>());
			mapNrParticipantsInLane.put(String.valueOf(i), 0);
		}
	}

	//Re-run assignation algorithm
	public void reorganizeLanes(){
		try{
			BSA_Assigner.assignLanes();
			showLanes();
		}catch(Exception e){
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
        	ApexPages.addMessage(myMsg);
        	return;
		}
		ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Lanes recalculated successfully');
        ApexPages.addMessage(myMsg);
	}
}