/*
*   @Class : TestClass_BSA_Utils.cls
*
*   @Author         :   Gonzalo Abruña
*   @Created        :   22 April 2014
*   @Description    :   Apex Test class that will ease test executions of BSA Tests. Factory Pattern applied here.
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

public class TestClass_BSA_Utils{
	//Singleton for RecordTypes
	public static Id eventRecordTypeId{
		get{
			if(eventRecordTypeId == null){
				List<RecordType> lRecordTypes = [SELECT Id FROM RecordType WHERE DeveloperName = :BSA_Utils.EVENT_RECTYPE_DEVNAME];
				if(lRecordTypes != null && !lRecordTypes.isEmpty())
					eventRecordTypeId = lRecordTypes[0].Id;
			}
			return eventRecordTypeId;
		}
		set;
	}
	//Singleton for RecordTypes
	public static Id applicationRecordTypeId{
		get{
			if(applicationRecordTypeId == null){
				List<RecordType> lRecordTypes = [SELECT Id FROM RecordType WHERE DeveloperName = :BSA_Utils.APPLICATION_RECTYPE_DEVNAME];
				if(lRecordTypes != null && !lRecordTypes.isEmpty())
					applicationRecordTypeId = lRecordTypes[0].Id;
			}
			return applicationRecordTypeId;
		}
		set;
	}
	//Create a new Parent campaign the first time it is instatiated
	public static Campaign parentCampaign{get{
			if(parentCampaign == null){
				List<Campaign> campaigns = [SELECT Id FROM Campaign WHERE Name =:BSA_Utils.getParentCampaignName() 
												AND RecordType.DeveloperName = :BSA_Utils.EVENT_RECTYPE_DEVNAME];
				if(campaigns != null && !campaigns.isEmpty()){
					parentCampaign = campaigns[0];
					return parentCampaign;
				}
				Campaign pc = new Campaign(Name = BSA_Utils.getParentCampaignName(), RecordTypeId = eventRecordTypeId);
				insert pc;
				parentCampaign = pc;
			}
			return parentCampaign;
	}set;}

	//To create a lot of mockup records
	public static void createTestScenario(){
		Map<String, List<String>> mapAcNameAndContacts = new Map<String, List<String>>();
		Map<String, String> mapNameAndGrade = new Map<String, String>();

		//KINDERGARTEN BOYS
		mapAcNameAndContacts.put('Steward Family', new List<String>{'Thomas', 'David'});
		mapNameAndGrade.putAll(new Map<String, String>{'Thomas' => BSA_Utils.ADULT, 'David' => BSA_Utils.KINDERGARTEN});
		mapAcNameAndContacts.put('Johnson Family', new List<String>{'Mick', 'Richard'});
		mapNameAndGrade.putAll(new Map<String, String>{'Mick' => BSA_Utils.ADULT, 'Richard' => BSA_Utils.KINDERGARTEN});
		mapAcNameAndContacts.put('Vaughan Family', new List<String>{'Stevie', 'Junior'});
		mapNameAndGrade.putAll(new Map<String, String>{'Stevie' => BSA_Utils.ADULT, 'Junior' => BSA_Utils.KINDERGARTEN});
		mapAcNameAndContacts.put('Irish Family', new List<String>{'Miah', 'Joo'});
		mapNameAndGrade.putAll(new Map<String, String>{'Miah' => BSA_Utils.ADULT, 'Joo' => BSA_Utils.KINDERGARTEN});
		mapAcNameAndContacts.put('French Family', new List<String>{'Jean Paul', 'Jasmine', 'Audrie'});
		mapNameAndGrade.putAll(new Map<String, String>{'Jean Paul' => BSA_Utils.ADULT, 'Jasmine' => BSA_Utils.KINDERGARTEN, 'Audrie' => BSA_Utils.KINDERGARTEN});
		mapAcNameAndContacts.put('Spain Family', new List<String>{'Manuela', 'Paco'});
		mapNameAndGrade.putAll(new Map<String, String>{'Manuela' => BSA_Utils.ADULT, 'Paco' => BSA_Utils.KINDERGARTEN});
		mapAcNameAndContacts.put('Rodgers Family', new List<String>{'Jimmy', 'Joseph'});
		mapNameAndGrade.putAll(new Map<String, String>{'Jimmy' => BSA_Utils.ADULT, 'Joseph' => BSA_Utils.KINDERGARTEN});
		mapAcNameAndContacts.put('Abrume Family', new List<String>{'Gonzalo', 'Luisa'});
		mapNameAndGrade.putAll(new Map<String, String>{'Gonzalo' => BSA_Utils.ADULT, 'Luisa' => BSA_Utils.KINDERGARTEN});
		mapAcNameAndContacts.put('Ibanez Family', new List<String>{'Leticia', 'Miguel'});
		mapNameAndGrade.putAll(new Map<String, String>{'Leticia' => BSA_Utils.ADULT, 'Miguel' => BSA_Utils.KINDERGARTEN});
		mapAcNameAndContacts.put('Redding Family', new List<String>{'Eric', 'Charlotte', 'Inma'});
		mapNameAndGrade.putAll(new Map<String, String>{'Eric' => BSA_Utils.ADULT, 'Charlotte' => BSA_Utils.KINDERGARTEN, 'Inma' => BSA_Utils.KINDERGARTEN});
		mapAcNameAndContacts.put('Zorita Family', new List<String>{'Fernando', 'Cristina', 'Mirella'});
		mapNameAndGrade.putAll(new Map<String, String>{'Fernando' => BSA_Utils.ADULT, 'Cristina' => BSA_Utils.KINDERGARTEN, 'Mirella' => BSA_Utils.KINDERGARTEN});
		mapAcNameAndContacts.put('Sadonie Family', new List<String>{'Mortadelo', 'Filemon'});
		mapNameAndGrade.putAll(new Map<String, String>{'Mortadelo' => BSA_Utils.ADULT, 'Filemon' => BSA_Utils.KINDERGARTEN});
		mapAcNameAndContacts.put('Morla Family', new List<String>{'Vetusta', 'Filipo'});
		mapNameAndGrade.putAll(new Map<String, String>{'Vetusta' => BSA_Utils.ADULT, 'Filipo' => BSA_Utils.KINDERGARTEN});
		mapAcNameAndContacts.put('Vanish Family', new List<String>{'Goku', 'Vegeta'});
		mapNameAndGrade.putAll(new Map<String, String>{'Goku' => BSA_Utils.ADULT, 'Vegeta' => BSA_Utils.KINDERGARTEN});
		mapAcNameAndContacts.put('Skywalker Family', new List<String>{'Anakin', 'Sidious'});
		mapNameAndGrade.putAll(new Map<String, String>{'Anakin' => BSA_Utils.ADULT, 'Sidious' => BSA_Utils.KINDERGARTEN});
		mapAcNameAndContacts.put('Brooke Family', new List<String>{'Damien', 'Tetris', 'Luigi'});
		mapNameAndGrade.putAll(new Map<String, String>{'Damien' => BSA_Utils.ADULT, 'Tetris' => BSA_Utils.KINDERGARTEN, 'Luigi' => BSA_Utils.KINDERGARTEN});
		mapAcNameAndContacts.put('Mears Family', new List<String>{'Janvis', 'Allaan'});
		mapNameAndGrade.putAll(new Map<String, String>{'Janvis' => BSA_Utils.ADULT, 'Allaan' => BSA_Utils.KINDERGARTEN});
		mapAcNameAndContacts.put('Feriante Family', new List<String>{'Coletilla', 'Chacho'});
		mapNameAndGrade.putAll(new Map<String, String>{'Coletilla' => BSA_Utils.ADULT, 'Chacho' => BSA_Utils.KINDERGARTEN});
		mapAcNameAndContacts.put('Erizo Family', new List<String>{'Pelopincho', 'Slapper'});
		mapNameAndGrade.putAll(new Map<String, String>{'Pelopincho' => BSA_Utils.ADULT, 'Slapper' => BSA_Utils.KINDERGARTEN});
		mapAcNameAndContacts.put('Cold Family', new List<String>{'Deriven', 'Integraler'});
		mapNameAndGrade.putAll(new Map<String, String>{'Deriven' => BSA_Utils.ADULT, 'Integraler' => BSA_Utils.KINDERGARTEN});
		mapAcNameAndContacts.put('Cool Family', new List<String>{'Hellen', 'Monikachu', 'Condoleeza'});
		mapNameAndGrade.putAll(new Map<String, String>{'Hellen' => BSA_Utils.ADULT, 'Monikachu' => BSA_Utils.KINDERGARTEN, 'Condoleeza' => BSA_Utils.KINDERGARTEN});
		mapAcNameAndContacts.put('Pokemon Family', new List<String>{'Pikachu', 'Charmander', 'Ash'});
		mapNameAndGrade.putAll(new Map<String, String>{'Pikachu' => BSA_Utils.ADULT, 'Charmander' => BSA_Utils.KINDERGARTEN, 'Ash' => BSA_Utils.KINDERGARTEN});

		//1st GRADE BOYS
		mapAcNameAndContacts.put('Stones Family', new List<String>{'Keef', 'Keith'});
		mapNameAndGrade.putAll(new Map<String, String>{'Keef' => BSA_Utils.ADULT, 'Keith' => BSA_Utils.FIRST_GRADE});
		mapAcNameAndContacts.put('Springfield Family', new List<String>{'Otto', 'Tomatito'});
		mapNameAndGrade.putAll(new Map<String, String>{'Otto' => BSA_Utils.ADULT, 'Tomatito' => BSA_Utils.FIRST_GRADE});
		mapAcNameAndContacts.put('Rajoyo Family', new List<String>{'Mariner', 'Sailor'});
		mapNameAndGrade.putAll(new Map<String, String>{'Mariner' => BSA_Utils.ADULT, 'Sailor' => BSA_Utils.FIRST_GRADE});
		mapAcNameAndContacts.put('Campeones Family', new List<String>{'Oliver', 'Benji'});
		mapNameAndGrade.putAll(new Map<String, String>{'Oliver' => BSA_Utils.ADULT, 'Benji' => BSA_Utils.FIRST_GRADE});
		mapAcNameAndContacts.put('Salamanca Family', new List<String>{'Amaia', 'Ibaid', 'Unai'});
		mapNameAndGrade.putAll(new Map<String, String>{'Amaia' => BSA_Utils.ADULT, 'Ibaid' => BSA_Utils.FIRST_GRADE, 'Unai' => BSA_Utils.FIRST_GRADE});
		mapAcNameAndContacts.put('Gibson Family', new List<String>{'Hannaha', 'Anette'});
		mapNameAndGrade.putAll(new Map<String, String>{'Hannaha' => BSA_Utils.ADULT, 'Anette' => BSA_Utils.FIRST_GRADE});
		mapAcNameAndContacts.put('Marion Family', new List<String>{'Mariona', 'Marionlittle'});
		mapNameAndGrade.putAll(new Map<String, String>{'Mariona' => BSA_Utils.ADULT, 'Marionlittle' => BSA_Utils.FIRST_GRADE});
		mapAcNameAndContacts.put('Superman Family', new List<String>{'Lois', 'Clark'});
		mapNameAndGrade.putAll(new Map<String, String>{'Lois' => BSA_Utils.ADULT, 'Clark' => BSA_Utils.FIRST_GRADE});
		mapAcNameAndContacts.put('Comembra Family', new List<String>{'Joao', 'Pinto'});
		mapNameAndGrade.putAll(new Map<String, String>{'Joao' => BSA_Utils.ADULT, 'Pinto' => BSA_Utils.FIRST_GRADE});
		mapAcNameAndContacts.put('Cabriolaux Family', new List<String>{'Michel', 'Iniesta', 'Tomasa'});
		mapNameAndGrade.putAll(new Map<String, String>{'Michel' => BSA_Utils.ADULT, 'Iniesta' => BSA_Utils.FIRST_GRADE, 'Tomasa' => BSA_Utils.FIRST_GRADE});
		mapAcNameAndContacts.put('Knauff Family', new List<String>{'Placasa', 'Laminada', 'Encimera'});
		mapNameAndGrade.putAll(new Map<String, String>{'Placasa' => BSA_Utils.ADULT, 'Laminada' => BSA_Utils.FIRST_GRADE, 'Encimera' => BSA_Utils.FIRST_GRADE});
		mapAcNameAndContacts.put('Nemymar Family', new List<String>{'Mei', 'Miranda'});
		mapNameAndGrade.putAll(new Map<String, String>{'Mei' => BSA_Utils.ADULT, 'Miranda' => BSA_Utils.FIRST_GRADE});
		mapAcNameAndContacts.put('Liada Family', new List<String>{'Zipi', 'Zape'});
		mapNameAndGrade.putAll(new Map<String, String>{'Zipi' => BSA_Utils.ADULT, 'Zape' => BSA_Utils.FIRST_GRADE});
		mapAcNameAndContacts.put('Vanish Family', new List<String>{'Tomo', 'Lomo'});
		mapNameAndGrade.putAll(new Map<String, String>{'Tomo' => BSA_Utils.ADULT, 'Lomo' => BSA_Utils.FIRST_GRADE});
		mapAcNameAndContacts.put('AmidalaSkywalker Family', new List<String>{'Leiaca', 'Little Lei'});
		mapNameAndGrade.putAll(new Map<String, String>{'Leiaca' => BSA_Utils.ADULT, 'Little Lei' => BSA_Utils.FIRST_GRADE});
		mapAcNameAndContacts.put('Startup Family', new List<String>{'Michu', 'Hungara', 'Javivi'});
		mapNameAndGrade.putAll(new Map<String, String>{'Michu' => BSA_Utils.ADULT, 'Hungara' => BSA_Utils.FIRST_GRADE, 'Javivi' => BSA_Utils.FIRST_GRADE});
		mapAcNameAndContacts.put('Bic Family', new List<String>{'Hook', 'Peter Pan'});
		mapNameAndGrade.putAll(new Map<String, String>{'Hook' => BSA_Utils.ADULT, 'Peter Pan' => BSA_Utils.FIRST_GRADE});
		mapAcNameAndContacts.put('Swift Family', new List<String>{'Cinderella', 'Bambi'});
		mapNameAndGrade.putAll(new Map<String, String>{'Cinderella' => BSA_Utils.ADULT, 'Bambi' => BSA_Utils.FIRST_GRADE});
		mapAcNameAndContacts.put('Skip Family', new List<String>{'Pinocchio', 'Piccolino'});
		mapNameAndGrade.putAll(new Map<String, String>{'Pinocchio' => BSA_Utils.ADULT, 'Piccolino' => BSA_Utils.FIRST_GRADE});
		mapAcNameAndContacts.put('Jumper Family', new List<String>{'Anastasiam', 'Romanevko'});
		mapNameAndGrade.putAll(new Map<String, String>{'Anastasiam' => BSA_Utils.ADULT, 'Romanevko' => BSA_Utils.FIRST_GRADE});
		mapAcNameAndContacts.put('Greender Family', new List<String>{'Marcin', 'Krzysiek', 'Gosia'});
		mapNameAndGrade.putAll(new Map<String, String>{'Marcin' => BSA_Utils.ADULT, 'Krzysiek' => BSA_Utils.FIRST_GRADE, 'Gosia' => BSA_Utils.FIRST_GRADE});
		mapAcNameAndContacts.put('Fireman Family', new List<String>{'Babara', 'Basia', 'Jacek'});
		mapNameAndGrade.putAll(new Map<String, String>{'Babara' => BSA_Utils.ADULT, 'Basia' => BSA_Utils.FIRST_GRADE, 'Jacek' => BSA_Utils.FIRST_GRADE});

		//2st GRADE BOYS
		mapAcNameAndContacts.put('Lewandowski Family', new List<String>{'Ignazio', 'Mauro'});
		mapNameAndGrade.putAll(new Map<String, String>{'Ignazio' => BSA_Utils.ADULT, 'Mauro' => BSA_Utils.SECOND_GRADE});
		mapAcNameAndContacts.put('Iwanowski Family', new List<String>{'Bonilla', 'Mihai'});
		mapNameAndGrade.putAll(new Map<String, String>{'Bonilla' => BSA_Utils.ADULT, 'Mihai' => BSA_Utils.SECOND_GRADE});
		mapAcNameAndContacts.put('Tomanewski Family', new List<String>{'Velarde', 'Ramirote'});
		mapNameAndGrade.putAll(new Map<String, String>{'Velarde' => BSA_Utils.ADULT, 'Ramirote' => BSA_Utils.SECOND_GRADE});
		mapAcNameAndContacts.put('Romanowska Family', new List<String>{'Kluivert', 'Robertinho'});
		mapNameAndGrade.putAll(new Map<String, String>{'Kluivert' => BSA_Utils.ADULT, 'Robertinho' => BSA_Utils.SECOND_GRADE});
		mapAcNameAndContacts.put('Espanowska Family', new List<String>{'Simeone', 'Bielsa', 'Marina'});
		mapNameAndGrade.putAll(new Map<String, String>{'Simeone' => BSA_Utils.ADULT, 'Bielsa' => BSA_Utils.SECOND_GRADE, 'Marina' => BSA_Utils.SECOND_GRADE});
		mapAcNameAndContacts.put('Greco Family', new List<String>{'Duvi', 'Cesareo'});
		mapNameAndGrade.putAll(new Map<String, String>{'Duvi' => BSA_Utils.ADULT, 'Cesareo' => BSA_Utils.SECOND_GRADE});
		mapAcNameAndContacts.put('Velazquez Family', new List<String>{'Vijia', 'Mariaje'});
		mapNameAndGrade.putAll(new Map<String, String>{'Vijia' => BSA_Utils.ADULT, 'Mariaje' => BSA_Utils.SECOND_GRADE});
		mapAcNameAndContacts.put('Serrano Family', new List<String>{'Balbina', 'Angelito'});
		mapNameAndGrade.putAll(new Map<String, String>{'Balbina' => BSA_Utils.ADULT, 'Angelito' => BSA_Utils.SECOND_GRADE});
		mapAcNameAndContacts.put('Porlier Family', new List<String>{'Marc', 'Macia'});
		mapNameAndGrade.putAll(new Map<String, String>{'Marc' => BSA_Utils.ADULT, 'Macia' => BSA_Utils.SECOND_GRADE});
		mapAcNameAndContacts.put('Silvela Family', new List<String>{'Arnau', 'Oihane', 'Borjita'});
		mapNameAndGrade.putAll(new Map<String, String>{'Arnau' => BSA_Utils.ADULT, 'Oihane' => BSA_Utils.SECOND_GRADE, 'Borjita' => BSA_Utils.SECOND_GRADE});
		mapAcNameAndContacts.put('Mola Family', new List<String>{'Hodei', 'Madeira', 'LitMichaella'});
		mapNameAndGrade.putAll(new Map<String, String>{'Hodei' => BSA_Utils.ADULT, 'Madeira' => BSA_Utils.SECOND_GRADE, 'LitMichaella' => BSA_Utils.SECOND_GRADE});
		mapAcNameAndContacts.put('Salim Family', new List<String>{'Alexander', 'Graham'});
		mapNameAndGrade.putAll(new Map<String, String>{'Alexander' => BSA_Utils.ADULT, 'Graham' => BSA_Utils.SECOND_GRADE});
		mapAcNameAndContacts.put('Juncos Family', new List<String>{'PedroPablo', 'AnaMaria'});
		mapNameAndGrade.putAll(new Map<String, String>{'PedroPablo' => BSA_Utils.ADULT, 'AnaMaria' => BSA_Utils.SECOND_GRADE});
		mapAcNameAndContacts.put('Herreros Family', new List<String>{'Lazarias', 'Zacariano'});
		mapNameAndGrade.putAll(new Map<String, String>{'Lazarias' => BSA_Utils.ADULT, 'Zacariano' => BSA_Utils.SECOND_GRADE});
		mapAcNameAndContacts.put('Suavecita Family', new List<String>{'Mandinho', 'Huggo'});
		mapNameAndGrade.putAll(new Map<String, String>{'Mandinho' => BSA_Utils.ADULT, 'Huggo' => BSA_Utils.SECOND_GRADE});
		mapAcNameAndContacts.put('Interna Family', new List<String>{'Carapinha', 'Robinho', 'Rubivi'});
		mapNameAndGrade.putAll(new Map<String, String>{'Carapinha' => BSA_Utils.ADULT, 'Robinho' => BSA_Utils.SECOND_GRADE, 'Rubivi' => BSA_Utils.SECOND_GRADE});
		mapAcNameAndContacts.put('Escola Family', new List<String>{'Hiracio', 'Franchesco'});
		mapNameAndGrade.putAll(new Map<String, String>{'Hiracio' => BSA_Utils.ADULT, 'Franchesco' => BSA_Utils.SECOND_GRADE});

		//3rd GRADE BOYS
		mapAcNameAndContacts.put('Gordo Family', new List<String>{'Groucho', 'Harpo'});
		mapNameAndGrade.putAll(new Map<String, String>{'Groucho' => BSA_Utils.ADULT, 'Harpo' => BSA_Utils.THIRD_GRADE});
		mapAcNameAndContacts.put('Gross Family', new List<String>{'LuisaFernanda', 'Limoncella'});
		mapNameAndGrade.putAll(new Map<String, String>{'LuisaFernanda' => BSA_Utils.ADULT, 'Limoncella' => BSA_Utils.THIRD_GRADE});
		mapAcNameAndContacts.put('Fatty Family', new List<String>{'Wallman', 'Biker'});
		mapNameAndGrade.putAll(new Map<String, String>{'Wallman' => BSA_Utils.ADULT, 'Biker' => BSA_Utils.THIRD_GRADE});
		mapAcNameAndContacts.put('Balling Family', new List<String>{'RobbenHol', 'Bommel', 'Lukaku'});
		mapNameAndGrade.putAll(new Map<String, String>{'RobbenHol' => BSA_Utils.ADULT, 'Bommel' => BSA_Utils.THIRD_GRADE, 'Lukaku' => BSA_Utils.THIRD_GRADE});
		mapAcNameAndContacts.put('Stratocaster Family', new List<String>{'Fderrica', 'Samia', 'Salmah'});
		mapNameAndGrade.putAll(new Map<String, String>{'Fderrica' => BSA_Utils.ADULT, 'Samia' => BSA_Utils.THIRD_GRADE, 'Salmah' => BSA_Utils.THIRD_GRADE});
		mapAcNameAndContacts.put('Trappist Family', new List<String>{'Ebro', 'Tajo'});
		mapNameAndGrade.putAll(new Map<String, String>{'Ebro' => BSA_Utils.ADULT, 'Tajo' => BSA_Utils.THIRD_GRADE});
		mapAcNameAndContacts.put('Davidson Family', new List<String>{'Orbigo', 'Quiruelas'});
		mapNameAndGrade.putAll(new Map<String, String>{'Orbigo' => BSA_Utils.ADULT, 'Quiruelas' => BSA_Utils.THIRD_GRADE});
		mapAcNameAndContacts.put('Peterson Family', new List<String>{'Santibanez', 'Pelease'});
		mapNameAndGrade.putAll(new Map<String, String>{'Santibanez' => BSA_Utils.ADULT, 'Pelease' => BSA_Utils.THIRD_GRADE});
		mapAcNameAndContacts.put('OHaras Family', new List<String>{'Luna', 'Venecia', 'Duero'});
		mapNameAndGrade.putAll(new Map<String, String>{'Luna' => BSA_Utils.ADULT, 'Venecia' => BSA_Utils.THIRD_GRADE, 'Duero' => BSA_Utils.THIRD_GRADE});
		mapAcNameAndContacts.put('OSheas Family', new List<String>{'Mear', 'Fryar', 'Yoma'});
		mapNameAndGrade.putAll(new Map<String, String>{'Mear' => BSA_Utils.ADULT, 'Fryar' => BSA_Utils.THIRD_GRADE, 'Yoma' => BSA_Utils.THIRD_GRADE});

		//4th GRADE BOYS
		mapAcNameAndContacts.put('Pirineos Family', new List<String>{'Everest', 'Annapurna'});
		mapNameAndGrade.putAll(new Map<String, String>{'Everest' => BSA_Utils.ADULT, 'Annapurna' => BSA_Utils.FOURTH_GRADE});
		mapAcNameAndContacts.put('Betica Family', new List<String>{'Telecaster', 'LesPaul'});
		mapNameAndGrade.putAll(new Map<String, String>{'Telecaster' => BSA_Utils.ADULT, 'LesPaul' => BSA_Utils.FOURTH_GRADE});
		mapAcNameAndContacts.put('MontesLeon Family', new List<String>{'Moorena', 'Monromina'});
		mapNameAndGrade.putAll(new Map<String, String>{'Moorena' => BSA_Utils.ADULT, 'Monromina' => BSA_Utils.FOURTH_GRADE});
		mapAcNameAndContacts.put('MontesToledo Family', new List<String>{'PapaOso', 'Carlitos', 'Pablito'});
		mapNameAndGrade.putAll(new Map<String, String>{'PapaOso' => BSA_Utils.ADULT, 'Carlitos' => BSA_Utils.FOURTH_GRADE, 'Pablito' => BSA_Utils.FOURTH_GRADE});
		mapAcNameAndContacts.put('Galicia Family', new List<String>{'Enzo', 'AnaBelenLi', 'Adela'});
		mapNameAndGrade.putAll(new Map<String, String>{'Enzo' => BSA_Utils.ADULT, 'AnaBelenLi' => BSA_Utils.FOURTH_GRADE, 'Adela' => BSA_Utils.FOURTH_GRADE});
		mapAcNameAndContacts.put('Euskadi Family', new List<String>{'Renault', 'Ford'});
		mapNameAndGrade.putAll(new Map<String, String>{'Renault' => BSA_Utils.ADULT, 'Ford' => BSA_Utils.FOURTH_GRADE});
		mapAcNameAndContacts.put('Castilla Family', new List<String>{'Ferrari', 'Lamborghini'});
		mapNameAndGrade.putAll(new Map<String, String>{'Ferrari' => BSA_Utils.ADULT, 'Lamborghini' => BSA_Utils.FOURTH_GRADE});
		mapAcNameAndContacts.put('Valencian Family', new List<String>{'Toyota', 'Seat'});
		mapNameAndGrade.putAll(new Map<String, String>{'Toyota' => BSA_Utils.ADULT, 'Seat' => BSA_Utils.FOURTH_GRADE});
		mapAcNameAndContacts.put('Vidrieras Family', new List<String>{'Honda', 'Yamaha', 'Squier'});
		mapNameAndGrade.putAll(new Map<String, String>{'Honda' => BSA_Utils.ADULT, 'Yamaha' => BSA_Utils.FOURTH_GRADE, 'Squier' => BSA_Utils.FOURTH_GRADE});
		mapAcNameAndContacts.put('Penhia Family', new List<String>{'Adidas', 'Nike', 'Reebook'});
		mapNameAndGrade.putAll(new Map<String, String>{'Adidas' => BSA_Utils.ADULT, 'Nike' => BSA_Utils.FOURTH_GRADE, 'Reebook' => BSA_Utils.FOURTH_GRADE});
		mapAcNameAndContacts.put('Varada Family', new List<String>{'Presa', 'Hamiltinho', 'Lewis'});
		mapNameAndGrade.putAll(new Map<String, String>{'Presa' => BSA_Utils.ADULT, 'Hamiltinho' => BSA_Utils.FOURTH_GRADE, 'Lewis' => BSA_Utils.FOURTH_GRADE});

		Set<Id> setAccountIds = createAccountsWithContacts(mapAcNameAndContacts, mapNameAndGrade);
		createHouseHoldStructure(setAccountIds);
	}

	//Create a List of Accounts and Related Contacts to them, so as to:
	//Account Type = Household
	//Contacts are children of given account
	public static Set<Id> createAccountsWithContacts(Map<String, List<String>> accountNameAndContacts, Map<String, String> mapContactNameAndGrade){
		List<Account> listAccounts = new List<Account>();
		List<Contact> listContacts = new List<Contact>();
		Set<Id> insertedAccounts = new Set<Id>();

		for(String acName : accountNameAndContacts.keySet()){
			listAccounts.add(new Account(Name = acName, Type = 'Household', Active__c = 'Yes'));
		}

		Integer previousNumberOfAccounts = [SELECT count() FROM Account];
		insert listAccounts;
		System.assert([SELECT count() FROM Account] - previousNumberOfAccounts == listAccounts.size(), 'Accounts not inserted properly');

		Map<String, Id> mapAccountNameToId = new Map<String, Id>();
		for(Account a : listAccounts){
			mapAccountNameToId.put(a.Name, a.Id);
			insertedAccounts.add(a.Id);
		}

		for(String acName : accountNameAndContacts.keySet()){
			for(String lName : accountNameAndContacts.get(acName))
				listContacts.add(new Contact(LastName = lName, AccountId = mapAccountNameToId.get(acName), MSB_Grade__c = mapContactNameAndGrade.get(lName)));
		}

		Integer previousNumberOfContacts = [SELECT count() FROM Contact];
		insert listContacts;
		System.assert([SELECT count() FROM Contact] - previousNumberOfContacts == listContacts.size(), 'Contacts not inserted properly');	

		return insertedAccounts;
	}

	//Create a full householdStructure for a given Account (family)
	//Household Structure will create per each Account & Contacts of the Account:
	//1. Campaign child of ParengCampaign (status of the campaign BSA_Utils.CAMPAIGN_STATUS, recordtype devname BSA_Utils.APPLICATION_RECTYPE_DEVNAME)
	//2. Campaign members for all contacts of the Account
	public static void createHouseHoldStructure(Set<Id> setAccountIds){
		String endOfName = ' Campaign';

		Map<Id, Account> mapAccounts = new Map<Id, Account>([SELECT Id, Name, (SELECT Id FROM Contacts) FROM Account WHERE Id in :setAccountIds]);

		//Create Campaigns
		List<Campaign> listCampaigns = new List<Campaign>();
		for(Account a : mapAccounts.values()){
			listCampaigns.add(new Campaign(Status = 'Registered', IsActive=true, Name=a.Name+endOfName,RecordTypeId = applicationRecordTypeId, MSB_Household__c = a.Id, ParentId = parentCampaign.Id));
		}
		Integer previousNumberOfCampaigns = [SELECT count() FROM Campaign];
		insert listCampaigns;
		System.assert([SELECT count() FROM Campaign] - previousNumberOfCampaigns == listCampaigns.size(), 'Campaigns not inserted properly');	

		//Create campaign members
		List<CampaignMember> listCampaignMembers = new List<CampaignMember>();
		for(Campaign camp : [SELECT Id, MSB_Household__c FROM Campaign WHERE MSB_Household__c = :mapAccounts.keySet()]){
			for(Contact contact : mapAccounts.get(camp.MSB_Household__c).Contacts){ //Create a new campaign member per each contact of that household
				listCampaignMembers.add(new CampaignMember(CampaignId = camp.Id, ContactId = contact.Id));
			}
		}
		Integer previousNumberOfCampaignMembers = [SELECT count() FROM CampaignMember];
		insert listCampaignMembers;
		System.assert([SELECT count() FROM CampaignMember] - previousNumberOfCampaignMembers == listCampaignMembers.size(), 'Campaign Members not inserted properly');	
	}

	//Create a Group Me With record
	public static MSB_Group_Me_With__c insertGroupMeWith(Account acc, Campaign camp){
		MSB_Group_Me_With__c result = new MSB_Group_Me_With__c(MSB_Household__c = acc.Id, MSB_Application__c = camp.Id);
		insert result;
		System.assert(result.id != null, 'Group Me With was not inserted properly');
		return result;
	}
}