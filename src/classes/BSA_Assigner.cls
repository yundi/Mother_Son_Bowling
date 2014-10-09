/*
*   @Class : BSA_Assigner.cls
*
*   @Author         :   Gonzalo Abruña
*   @Created        :   20 April 2014
*   @Description    :   Apex class to automatically assign Lanes of Campaign records according to requirements of TopCoder
*                       challenge: http://www.topcoder.com/challenge-details/30042041/?type=&nocache=true#.U1Ptcv3lTeE
*                       All the assignation algorithm is here, just run BSA_Assigner.assignLanes();
*
*      ----------------------------------------------------------------------------------------------------------------------------                                
*      Modification Log     : 
*      ----------------------------------------------------------------------------------------------------------------------------
*      Developer             Date                Description
*      ----------------------------------------------------------------------------------------------------------------------------   
*      Gonzalo Abruña        20 April 2014        Creation
*
*/
public class BSA_Assigner{
    public static void assignLanes(){
        Map<Integer, List<BowlingLane>> mapGradesAndLanes = new Map<Integer, List<BowlingLane>>();
        Set<Id> setAssignedCampaigns = new Set<Id>();
        String parentCampaignName = BSA_Utils.getParentCampaignName();
        Map<Id, Set<Id>> campaignsIWantToPlayWith = new Map<Id, Set<Id>>();
        Map<Id, Integer> mapCampaignGrade = new Map<Id, Integer>();
        Map<Id, Campaign> campaignOfAccount = new Map<Id, Campaign>();
        Map<Id, Campaign> mapCampaings = new Map<Id, Campaign>([SELECT Id, Name, MSB_Lane__c, MSB_Household__c, MSB_of_Members__c, 
                                            (SELECT MSB_Household__c FROM MSB_Group_Me_Withs_Appl__r), //People that want to play with us
                                            (SELECT MSB_Grade__c FROM CampaignMembers) //To calculate the grade of a Campaign
                                    FROM Campaign
                                    WHERE Parent.Name = :parentCampaignName
                                        AND Parent.RecordType.DeveloperName = :BSA_Utils.EVENT_RECTYPE_DEVNAME
                                        AND Status = :BSA_Utils.CAMPAIGN_STATUS
                                        AND RecordType.DeveloperName = :BSA_Utils.APPLICATION_RECTYPE_DEVNAME
                                        AND MSB_of_Members__c > 0]);
        //Clear Lanes values stored previously:
        BSA_Utils.clearPreviousLanes(mapCampaings.values());

        //Populate map from AccountId to Campaign and assign Grades to this Campaign
        for(Campaign c : mapCampaings.values()){
            campaignOfAccount.put(c.MSB_Household__c, c);
            Integer gradeNumber = 0;
            for(CampaignMember cm : c.CampaignMembers){
                if(BSA_Utils.GRADE_NUMBER.containsKey(cm.MSB_Grade__c) && BSA_Utils.GRADE_NUMBER.get(cm.MSB_Grade__c) > gradeNumber){ //Grade is the grade of the oldest
                    gradeNumber = BSA_Utils.GRADE_NUMBER.get(cm.MSB_Grade__c);
                }
            }
            mapCampaignGrade.put(c.Id, gradeNumber);
        }

        
        //Get the people that we want to play with (MSB_Application__r.MSB_Household__c)
        List<MSB_Group_Me_With__c> groupMeWiths = [SELECT Id, MSB_Household__c, MSB_Application__c, MSB_Application__r.MSB_Household__c
                                                        FROM MSB_Group_Me_With__c WHERE MSB_Application__c IN :mapCampaings.keySet()];
        //Populate map of Accounts that I want to play with
        for(MSB_Group_Me_With__c g : groupMeWiths){
            Id myCampaignId = g.MSB_Application__c;
            if(campaignOfAccount.containsKey(g.MSB_Household__c)){
                Campaign campaignIWant = campaignOfAccount.get(g.MSB_Household__c);
                if(!campaignsIWantToPlayWith.containsKey(campaignIWant.Id))
                    campaignsIWantToPlayWith.put(campaignIWant.Id, new Set<Id>());
                campaignsIWantToPlayWith.get(campaignIWant.Id).add(myCampaignId);
            }
        }


        List<BowlingLane> listLanes = new List<BowlingLane>();
        Integer indextifier = 0;
        //We already have all the information that we need. Iterate over campaigns to match Accounts:
        for(Campaign c : mapCampaings.values()){
            Integer numberOfParticipants = 0;
            Integer currentGrade = mapCampaignGrade.get(c.Id);

            //Add the contacts of this campaign
            numberOfParticipants += Integer.valueOf(c.MSB_of_Members__c);

            //1. Check if I was already in a Lane
            Integer myLaneIndex = -1;
            for(Integer laneIndex = 0; laneIndex<listLanes.size(); laneIndex++){
                BowlingLane lane = listLanes[laneIndex];
                if(lane.campaignIds.contains(c.Id)){
                    myLaneIndex = laneIndex;
                    break;
                }
            }

            //2. If I want to play with someone: add the people that I want to play with
            if(campaignsIWantToPlayWith.containsKey(c.Id) && !campaignsIWantToPlayWith.isEmpty() && numberOfParticipants < BSA_Utils.MAX_PEOPLE_PER_LANE){
                Set<Id> campaignImpossible = new Set<Id>(); //In case that the Lane of my friends was already full
                for(Id campaignIwant : campaignsIWantToPlayWith.get(c.Id)){
                    //try to find these campaigns on the ListLanes

                    //If I was not assigned to any Lane yet, try to see if one of the others were assigned to a Lane
                    //If the others were not assigned to any Lane, create a Lane for them and me
                    for(Integer laneIndex = 0; laneIndex<listLanes.size(); laneIndex++){
                        BowlingLane lane = listLanes[laneIndex];
                        if(myLaneIndex == -1 && lane.campaignIds.contains(campaignIwant) 
                                && (lane.numberOfParticipants + Integer.valueOf(c.MSB_of_Members__c)) <= BSA_Utils.MAX_PEOPLE_PER_LANE){
                            //Join the Lane where my friends are
                            lane.campaignIds.add(c.Id);
                            lane.numberOfParticipants += Integer.valueOf(c.MSB_of_Members__c);
                            lane.gradeNumber = currentGrade > lane.gradeNumber ? currentGrade : lane.gradeNumber;
                            myLaneIndex = laneIndex;
                            //Since I joined an existing Lane, the rest of people that I want to play with should join that Lane too
                        }
                        //If my friends are playing in a full lane, it is impossible to play with them
                        else if(lane.campaignIds.contains(campaignIwant) && (lane.numberOfParticipants + Integer.valueOf(c.MSB_of_Members__c)) > BSA_Utils.MAX_PEOPLE_PER_LANE){
                            campaignImpossible.add(campaignIWant); //I could not add this to my Lane because it is playing in a Lane which is full
                        }
                        //If my friends are already playing on a Lane different than mine
                        else if(myLaneIndex != -1 && lane.campaignIds.contains(campaignIwant)){
                            campaignImpossible.add(campaignIWant); //I could not add this to my Lane because it is playing in a Lane which is full
                        }
                    }
                }

                //If I was not assigned to any Lane, create a new Lane entry and try to add as many of my friends as possible to that new Lane
                if(myLaneIndex == -1){
                    Set<Id> setCampIds = new Set<Id>{c.Id};
                    listLanes.add(new BowlingLane(currentGrade, Integer.valueOf(c.MSB_of_Members__c), setCampIds, String.valueOf(indextifier)));
                    myLaneIndex = listLanes.size()-1;
                    indextifier++;
                }

                //Now that I have been assigned to a Lane, try to add my friends to that Lane
                for(Id campaignIwant : campaignsIWantToPlayWith.get(c.Id)){
                    if(!campaignImpossible.contains(campaignIwant) 
                            && mapCampaings.get(campaignIwant).MSB_of_Members__c + listLanes[myLaneIndex].numberOfParticipants <= BSA_Utils.MAX_PEOPLE_PER_LANE){
                        BowlingLane lane = listLanes[myLaneIndex];
                        //Send my friends to this lane
                        lane.campaignIds.add(campaignIwant);
                        lane.numberOfParticipants += Integer.valueOf(mapCampaings.get(campaignIwant).MSB_of_Members__c);
                        Integer myFriendsGrade = mapCampaignGrade.get(campaignIwant);
                        lane.gradeNumber = myFriendsGrade > lane.gradeNumber ? myFriendsGrade : lane.gradeNumber;
                    }
                }
            }
            //3. If I don´t have any friends to play with and I was not assigned not any Lane yet, create a new Lane just for me
            else if(myLaneIndex == -1 && numberOfParticipants <= BSA_Utils.MAX_PEOPLE_PER_LANE){
                Set<Id> setCampIds = new Set<Id>{c.Id};
                listLanes.add(new BowlingLane(currentGrade, Integer.valueOf(c.MSB_of_Members__c), setCampIds, String.valueOf(indextifier)));
                indextifier++;
            }
        }      

        Integer lanesOccupied = listLanes.size();

        mapGradesAndLanes = buildMapGradesAndLanes(listLanes);

        //Now take decisions: if we have more than 30 Lanes, try to put people in the same Lane. If not, let them play together without anyone else bothering them.
        //Match people by grades.
        if(lanesOccupied > BSA_Utils.NUMBER_OF_LANES){
            //Order Lanes to ensure that the kids go together with other kids (start optimizing from the youngest).
            listLanes.clear();
            listLanes = new List<BowlingLane>();
            listLanes = getOrderedLanesByGrade(mapGradesAndLanes);
            for(BowlingLane lane : listLanes){
                if(!lane.obsolete && lane.numberOfParticipants <= (BSA_Utils.MAX_PEOPLE_PER_LANE - 2)){
                    if(mapGradesAndLanes.containsKey(lane.gradeNumber)){ //Try to merge with groups of the same grade
                        for(BowlingLane gradeMate : mapGradesAndLanes.get(lane.gradeNumber)){
                            if(!gradeMate.obsolete && gradeMate.identifier != lane.identifier
                                    && (lane.numberOfParticipants + gradeMate.numberOfParticipants) <= BSA_Utils.MAX_PEOPLE_PER_LANE){
                                gradeMate.obsolete = true;
                                lane.campaignIds.addAll(gradeMate.campaignIds);
                                lane.numberOfParticipants += gradeMate.numberOfParticipants;
                                lanesOccupied--;
                                //The goal is to fill all the Lanes, if we wanted to maximize the people per lane, remove this break sentence
                                if(lanesOccupied <= BSA_Utils.NUMBER_OF_LANES){
                                    break;
                                }
                            }
                        }
                    }
                }
                //The goal is to fill all the Lanes, if we wanted to maximize the people per lane, remove this break sentence
                if(lanesOccupied <= BSA_Utils.NUMBER_OF_LANES){
                    break;
                }
            }

            mapGradesAndLanes = new Map<Integer, List<BowlingLane>>();
            mapGradesAndLanes = buildMapGradesAndLanes(listLanes);
        }
        Integer totalPlayers = updateCampaigns(mapGradesAndLanes);
    }

    private static Map<Integer, List<BowlingLane>> buildMapGradesAndLanes(List<BowlingLane> listLanes){
        Map<Integer, List<BowlingLane>> result = new Map<Integer, List<BowlingLane>>();
        for(BowlingLane lane : listLanes){
            if(!lane.obsolete){
                if(!result.containsKey(lane.gradeNumber)){
                    result.put(lane.gradeNumber, new List<BowlingLane>());
                }
                result.get(lane.gradeNumber).add(lane);
            }
        }
        return result;
    }

    private static List<BowlingLane> getOrderedLanesByGrade(Map<Integer, List<BowlingLane>> mapGradeLanes){
        List<BowlingLane> result = new List<BowlingLane>();

        for(Integer key=0; key<BSA_Utils.GRADE_NUMBER.size(); key++){
            if(mapGradeLanes.containsKey(key)){
                result.addAll(mapGradeLanes.get(key));
            }
        }

        return result;
    }

    private static Integer updateCampaigns(Map<Integer, List<BowlingLane>> mapGradeLanes){
        List<Campaign> campaignsToUpdate = new List<Campaign>();

        Integer currentLane = 0;
        Integer totalPlayers = 0;
        for(Integer i=0; i<BSA_Utils.GRADE_NUMBER.size(); i++){
            if(mapGradeLanes.containsKey(i)){
                for(BowlingLane bLane : mapGradeLanes.get(i)){
                    if(!bLane.obsolete){
                        currentLane++;
                        for(Id campaignId : bLane.campaignIds){
                            campaignsToUpdate.add(new Campaign(Id=campaignId, MSB_Lane__c=String.valueOf(currentLane)));
                        }
                        totalPlayers += bLane.numberOfParticipants;
                    }
                    if(currentLane >= BSA_Utils.NUMBER_OF_LANES){
                        break;
                    }
                }
            }
            if(currentLane >= BSA_Utils.NUMBER_OF_LANES){
                break;
            }
        }

        if(!campaignsToUpdate.isEmpty())
            update campaignsToUpdate;

        return totalPlayers;
    }

    public class BowlingLane{
        Boolean         obsolete{get;set;}
        Integer         gradeNumber{get;set;}
        Integer         numberOfParticipants{get;set;}
        Set<Id>         campaignIds{get;set;}
        Integer         laneNumber{get;set;}
        String          identifier{get;set;}

        public BowlingLane(Integer gradeNr, Integer numberOfPartic, Set<Id> campaigns, String ident){
            gradeNumber = gradeNr;
            numberOfParticipants = numberOfPartic;
            campaignIds = campaigns;
            identifier = ident;
            obsolete = false;
        }
    }
}