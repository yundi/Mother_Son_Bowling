/*
*   @Class : TestClass_BSA_Utils.cls
*
*   @Author         :   Gonzalo Abruña
*   @Created        :   22 April 2014
*   @Description    :   Apex Test class that will cover code of BSA_LanesAssignment_Controller class and by extension BSA_Assiner
*						http://www.topcoder.com/challenge-details/30042041/?type=&nocache=true#.U1Ptcv3lTeE
*
*      ----------------------------------------------------------------------------------------------------------------------------                                
*      Modification Log     : 
*      ----------------------------------------------------------------------------------------------------------------------------
*      Developer             Date                Description
*      ----------------------------------------------------------------------------------------------------------------------------   
*      Gonzalo Abruña        22 April 2014        Creation
*
*/
@isTest
public class TestClass_BSA_LanesAssignment_Controller{
	@isTest(seeAllData=false)
	static void assignIn30Lanes(){
		//Create the Records needed For the Test:
		BSA_Utils.NUMBER_OF_LANES = 30;
		TestClass_BSA_Utils.createTestScenario();

		BSA_LanesAssignment_Controller controller = new BSA_LanesAssignment_Controller();
		controller.reorganizeLanes();

		//Ensure that all Campaigns have a Lane Number
		List<Campaign> campaignsWithoutLane = [SELECT Id FROM Campaign WHERE Parent.Name = :BSA_Utils.getParentCampaignName()
                                        AND Parent.RecordType.DeveloperName = :BSA_Utils.EVENT_RECTYPE_DEVNAME
                                        AND Status = :BSA_Utils.CAMPAIGN_STATUS
                                        AND RecordType.DeveloperName = :BSA_Utils.APPLICATION_RECTYPE_DEVNAME
                                        AND MSB_Lane__c = null
                                        AND MSB_of_Members__c > 0];
        
        Boolean success = true;
        if(campaignsWithoutLane != null && !campaignsWithoutLane.isEmpty())
        	success = false;
        System.assert(success, 'With 30 Lanes, we have campaigns without a Lane assigned');
	}

	@isTest(seeAllData=false)
	static void assignIn5Lanes(){
		//Create the Records needed For the Test:
		TestClass_BSA_Utils.createTestScenario();

		BSA_LanesAssignment_Controller controller = new BSA_LanesAssignment_Controller();
		BSA_Utils.NUMBER_OF_LANES = 5;
		controller.reorganizeLanes();

		List<Campaign> campaignsWithoutLane = [SELECT Id FROM Campaign WHERE Parent.Name = :BSA_Utils.getParentCampaignName()
                                        AND Parent.RecordType.DeveloperName = :BSA_Utils.EVENT_RECTYPE_DEVNAME
                                        AND Status = :BSA_Utils.CAMPAIGN_STATUS
                                        AND RecordType.DeveloperName = :BSA_Utils.APPLICATION_RECTYPE_DEVNAME
                                        AND MSB_Lane__c = null
                                        AND MSB_of_Members__c > 0];
		List<Campaign> campaignsWithLane = [SELECT Id FROM Campaign WHERE Parent.Name = :BSA_Utils.getParentCampaignName()
                                        AND Parent.RecordType.DeveloperName = :BSA_Utils.EVENT_RECTYPE_DEVNAME
                                        AND Status = :BSA_Utils.CAMPAIGN_STATUS
                                        AND RecordType.DeveloperName = :BSA_Utils.APPLICATION_RECTYPE_DEVNAME
                                        AND MSB_Lane__c != null
                                        AND MSB_of_Members__c > 0];
        List<AggregateResult> lCamps = [SELECT MSB_Lane__c FROM Campaign WHERE MSB_Lane__c != NULL GROUP BY MSB_Lane__c];
        
        Boolean success = false;
        if(campaignsWithoutLane != null && !campaignsWithoutLane.isEmpty())
        	success = true;
        System.assert(success, 'With 5 Lanes, we assigned all campaigns, which is not possible, we assigned Lanes: ' + lCamps.size());
        success = false;
        if(campaignsWithLane != null && !campaignsWithLane.isEmpty())
        	success = true;
        System.assert(success, 'With 5 Lanes, did not assigned any Lane to a Campaign, which is not possible, we assigned Lanes: ' + lCamps.size());
	}

	@isTest(seeAllData=false)
	static void assignWithSomeGroupMeWith(){
		//Create the Records needed For the Test:
		BSA_Utils.NUMBER_OF_LANES = 30;
		TestClass_BSA_Utils.createTestScenario();

		//Add a couple of Group Me With to ensure that it is working
		Account account1 = [SELECT Id FROM Account LIMIT 1];
		Account account2 = [SELECT Id FROM Account WHERE Id != :account1.Id LIMIT 1];
		Campaign campaign1 = [SELECT Id, MSB_Household__c FROM Campaign WHERE Parent.Name = :BSA_Utils.getParentCampaignName() 
								AND MSB_Household__c != :account1.Id AND MSB_Household__c != :account2.Id LIMIT 1];
		Campaign campaign2 = [SELECT Id, MSB_Household__c FROM Campaign WHERE Parent.Name = :BSA_Utils.getParentCampaignName() 
								AND MSB_Household__c != :account1.Id AND MSB_Household__c != :account2.Id AND Id != :campaign1.Id LIMIT 1];
		Campaign account1HouseHold = [SELECT Id, MSB_Household__c FROM Campaign WHERE MSB_Household__c = :account1.Id LIMIT 1];
		Campaign account2HouseHold = [SELECT Id, MSB_Household__c FROM Campaign WHERE MSB_Household__c = :account2.Id LIMIT 1];
		TestClass_BSA_Utils.insertGroupMeWith(account1, campaign1);
		TestClass_BSA_Utils.insertGroupMeWith(account2, campaign2);

		//Run algorithm
		BSA_LanesAssignment_Controller controller = new BSA_LanesAssignment_Controller();
		controller.reorganizeLanes();

		//Ensure that campaigns associated have the same Lane Number
		String campaign1Lane = [SELECT MSB_Lane__c FROM Campaign WHERE Id = :campaign1.Id LIMIT 1].MSB_Lane__c;
		String pairOfCampaign1Lane = [SELECT MSB_Lane__c FROM Campaign WHERE Id = :account1HouseHold.Id LIMIT 1].MSB_Lane__c;
		System.assert(pairOfCampaign1Lane == campaign1Lane,'Group Me With is not putting people together (1)');

		String campaign2Lane = [SELECT MSB_Lane__c FROM Campaign WHERE Id = :campaign2.Id LIMIT 1].MSB_Lane__c;
		String pairOfCampaign2Lane = [SELECT MSB_Lane__c FROM Campaign WHERE Id = :account2HouseHold.Id LIMIT 1].MSB_Lane__c;
		System.assert(pairOfCampaign2Lane == campaign2Lane,'Group Me With is not putting people together (2)');
	}

	@isTest(seeAllData=false)
	static void forceException(){ //Ensure that try catch will handle this exception and the test is not failing
		//To force an exception we will have to decrease the number of Lanes after running the algorithm
		BSA_Utils.NUMBER_OF_LANES = 30;
		TestClass_BSA_Utils.createTestScenario();

		BSA_Assigner.assignLanes();
		BSA_Utils.NUMBER_OF_LANES = 10;

		BSA_LanesAssignment_Controller controller = new BSA_LanesAssignment_Controller();
		controller.reorganizeLanes();
		BSA_Utils.NUMBER_OF_LANES = 5;
		controller.reorganizeLanes();
	}
}