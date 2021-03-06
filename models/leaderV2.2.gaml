/**
* Name: leader
* Author: nicolas
* Description: 
* Tags: Tag1, Tag2, TagN
*/

model leader





global
{
	
	string SERVER <- "localhost"; //"192.168.1.100" "localhost"
	float MOUSE_BUFFER <- 50#m;
	point MOUSE_LOC ;
	float sim_id;
	lever explored_lever;
	list<string> leader_activities;
	string COMMAND_SEPARATOR <- ":";
	string GAME_LEADER <- "GAME_LEADER";
	string MSG_FROM_LEADER <- "MSG_FROM_LEADER";
	string GROUP_NAME <- "Oleron";  
	string BUILT_DIKE_TYPE <- "nouvelle digue"; // Type de nouvelle digue
	float  STANDARD_DIKE_SIZE <- 1.5#m; ////// hauteur d'une nouvelle digue	
	string BUILT_DIKE_STATUS <- "bon"; // status de nouvelle digue
	string LOG_FILE_NAME <- "log_"+machine_time+"csv";
	float START_LOG <- machine_time; 
	bool log_user_action <- true;
	bool activemq_connect <- true;
	int round<-0;		
		
	string UPDATE_ACTION_DONE <- "update_action_done";
	string OBSERVER_MESSAGE_COMMAND <- "observer_command";
	
		
	int ACTION_REPAIR_DIKE <- 5;
	int ACTION_CREATE_DIKE <- 6;
	int ACTION_DESTROY_DIKE <- 7;
	int ACTION_RAISE_DIKE <- 8;
	int ACTION_INSTALL_GANIVELLE <- 29;

	int ACTION_MODIFY_LAND_COVER_AU <- 1;
	int ACTION_MODIFY_LAND_COVER_A <- 2;
	int ACTION_MODIFY_LAND_COVER_U <- 3;
	int ACTION_MODIFY_LAND_COVER_N <- 4;
	int ACTION_MODIFY_LAND_COVER_AUs <-31;	
	int ACTION_MODIFY_LAND_COVER_Us <-32;
	int ACTION_MODIFY_LAND_COVER_Ui <-311;
	int ACTION_EXPROPRIATION <- 9999; // codification spéciale car en fait le code n'est utilisé que pour aller chercher le delai d'exection dans le fichier csv
	list<int> ACTION_LIST <- [CONNECTION_MESSAGE,ACTION_MESSAGE,REFRESH_ALL,ACTION_REPAIR_DIKE,ACTION_CREATE_DIKE,ACTION_DESTROY_DIKE,ACTION_RAISE_DIKE,ACTION_INSTALL_GANIVELLE,ACTION_MODIFY_LAND_COVER_AU,ACTION_MODIFY_LAND_COVER_AUs,ACTION_MODIFY_LAND_COVER_A,ACTION_MODIFY_LAND_COVER_U,ACTION_MODIFY_LAND_COVER_Us,ACTION_MODIFY_LAND_COVER_N];
	
			
	int ACTION_LAND_COVER_UPDATE<-9;
	int ACTION_DIKE_UPDATE<-10;
	int INFORM_ROUND <-34;
	int NOTIFY_DELAY <-35;
	int ENTITY_TYPE_CODE_DEF_COTE <-36;
	int ENTITY_TYPE_CODE_UA <-37;
	
	
	//action to acknwoledge client requests.
//	int ACTION_DIKE_REPAIRED <- 15;
	int ACTION_DIKE_CREATED <- 16;
	int ACTION_DIKE_DROPPED <- 17;
//	int ACTION_DIKE_RAISED <- 18;
	int UPDATE_BUDGET <- 19;
	int REFRESH_ALL <- 20;
	int ACTION_DIKE_LIST <- 21;
	int ACTION_MESSAGE <- 22;
	int CONNECTION_MESSAGE <- 23;
	int INFORM_TAX_GAIN <-24;
	int INFORM_GRANT_RECEIVED <-27;
	int INFORM_FINE_RECEIVED <-28;
	/*int ACTION_CLOSE_PENDING_REQUEST <- 30;*/

	int VALIDATION_ACTION_MODIFY_LAND_COVER_AU <- 11; // Not used. Should detele ?
	int VALIDATION_ACTION_MODIFY_LAND_COVER_A <- 12;// Not used. Should detele ?
	int VALIDATION_ACTION_MODIFY_LAND_COVER_U <- 13;// Not used. Should detele ?
	int VALIDATION_ACTION_MODIFY_LAND_COVER_N <- 14;// Not used. Should detele ?
	
	
	file communes_shape <- file("../includes/zone_etude/communes.shp");
	matrix<string> actions_def <- matrix<string>(csv_file("../includes/actions_def.csv",";"));	
	
	
	commune selected_commune <- nil;
	action_button selected_action <- nil;
	action_done selection_action_done;
	
	
	string current_selected_action -> {selected_action!= nil? selected_action.displayName:"NAN"};
	
	string REORGANISATION_AFFICHAGE <- "Réorganiser l'affichage";
	string ABROGER <- "Abroger";
	string PRELEVER <- "Percevoir Recette";
	string CREDITER <- "Subventionner";
	string RETARDER <- "Retarder";
	string RETARD_1_AN <- "Retarder pour 1 an";
	string RETARD_2_ANS <- "Retarder pour 2 ans";
	string RETARD_3_ANS <- "Retarder pour 3 ans";
	string LEVER_RETARD <- "Lever les retards";
	string LEADER_COMMAND <- "leader_command";
	string AMOUNT <- "amount";
	string DELAY <- "delay";
	string ACTION_ID <- "action_id";
	string DATA <- "data";
	string PLAYER_MSG <-"player_msg";
	string MSG_TO_PLAYER <-"Message au joueur";
	string COMMUNE <- "COMMUNE_ID";
	string ASK_NUM_ROUND <- "Leader demande numero du tour";
	string NUM_ROUND <- "Numero du tour";
	string ASK_INDICATORS_T0 <- "Leader demande Indicateurs a t0";
	string INDICATORS_T0 <- 'Indicateurs a t0';
//	string LEVER_DIKE_CREATION <- "Construit des digues";
//	string LEVER_RAISE_DIKE <- "Rehausse les digues";
//	string LEVER_REPAIR_DIKE <- "Renove les digues";
//	string LEVER_AUorUi_inCoastBorderArea <- "Construit ou densifie non adapté en ZL";
//	string LEVER_AUorUi_inRiskArea <- "Construit ou densifie en ZI";
//	string LEVER_GANIVELLE <- "Construit des ganivelles";
//	string LEVER_Us_outCoastBorderOrRiskArea <- "Habitat adapté hors ZL et ZI";
//	string LEVER_Us_inCoastBorderArea <- "Habitat adapté en ZL";
	
	int SUBVENTIONNER_GANIVELLE <- 1101;
	int SUBVENTIONNER_HABITAT_ADAPTE <- 1102;
	int SANCTION_ELECTORALE <- 1103;
	int HAUSSE_COUT_DIGUE <- 1104;
	int HAUSSE_REHAUSSEMENT_DIGUE <- 1105;
	int HAUSSE_RENOVATION_DIGUE <- 1106;
	int HAUSSE_COUT_BATI <- 1107;
	string SUBVENTIONNER_GANIVELLE_NAME <- "Subventionner ganivelle";
	string SUBVENTIONNER_HABITAT_ADAPTE_NAME <- "Subventionner habitat adapté";
	/*string SANCTION_ELECTORALE <- "Appliquer une sanction électorale";
	string HAUSSE_COUT_DIGUE <- "Hausse du coût de construction des digues";
	string HAUSSE_REHAUSSEMENT_DIGUE <- "Hausse du coût de réhaussement des digues";
	string HAUSSE_RENOVATION_DIGUE <- "Hausse du coût de rénovation des digues";
	string HAUSSE_COUT_BATI <- "Hausse du coût de construction du bâti";*/
	

	
	bool reorganisation_affichage -> {selected_action!= nil and selected_action.displayName= "Réorganiser l'affichage"};
	bool imposer -> {selected_action!= nil and selected_action.displayName= "Imposer"};
	bool subventionner -> {selected_action!= nil and selected_action.displayName= "Subventionner"};
	bool lever_retard -> {selected_action!= nil and selected_action.displayName= "Lever les retards"}; 
	bool subventionner_ganivelle -> {selected_action!= nil and selected_action.displayName= "Subventionner ganivelle"};
	bool subventionner_habitat_adapte -> {selected_action!= nil and selected_action.displayName= "Subventionner habitat adapté"};
	
	geometry shape <- square(100#m);
	
	string BATISSEUR <- "batisseur";
	string DEFENSE_DOUCE <- "défense douce";
	string RETRAIT <- "retrait";
	
//	float time_at_initialization;
	
	map<string,list<map<string,int>>> profils<-[];
	
	action write_profile
	{
		int i <- 0;

		string cm<-"";
		loop cm over:profils.keys
		{
			list<map<string,int>> data_commune <- profils[cm];
			
			write "commune : "+ cm;
			loop while:length(data_commune)>i
			{
				map<string,int> state <- data_commune[i];
				write "tour["+i +"] " + BATISSEUR+": "+state[BATISSEUR]+" ; "+DEFENSE_DOUCE+": "+state[DEFENSE_DOUCE]+" ; "+RETRAIT+": "+state[RETRAIT];
				i<-i+1;
			}
				
		}

	}
	
	action record_leader_activity (string type_msg , string aCommune, string msg)
	{
		string aText <- "<"+string(current_date.hour) +":"+ current_date.minute +">"+type_msg + aCommune+" -> "+ msg;
		write aText; //affiche dans la console
		add ("<"+machine_time+">"+aText) to: leader_activities;
	}
	
	action save_leader_records
	{
		loop a over: leader_activities 
		{
			save a to: "leader_records-"+sim_id+"/leader_activities_Tour"+round+".txt" type: "text" rewrite:false;
		}
		save action_done to: "leader_records-"+sim_id+"/action_done_Tour"+round+".csv" type: "csv";
		save activated_lever to: "leader_records-"+sim_id+"/activated_lever_Tour"+round+".csv" type: "csv"; 
		loop a over:all_levers 
		{
			save a to:"leader_records-"+sim_id+"/all_levers_Tour"+round+".csv"  type:"csv" rewrite:false;
		}
	}
	
	action add_action_done_to_profile(action_done act_dn, int act_round)
	{
		list<map<string,int>> profil_commune<- profils[act_dn.commune_name];
		loop while:length(profil_commune)<=act_round
		{
			map<string,int> state <- [];
			put 0 key:BATISSEUR in: state;
			put 0 key:DEFENSE_DOUCE in: state;
			put 0 key:RETRAIT in: state;
			add state to:profil_commune;
		}
		map<string,int> chosen_round <- profil_commune[act_round];
	//	write "action de type "+ act_dn.tracked_profil + " : "+ chosen_round[act_dn.tracked_profil]; // ToDO NM A voir si il n'y a pas un bug ici
		put chosen_round[act_dn.tracked_profil] +1 key:act_dn.tracked_profil in: chosen_round;
	}
	
	
	string UA_name_of_command (int act) {
		switch act {
			match ACTION_MODIFY_LAND_COVER_AU {return "AU";}
			match ACTION_MODIFY_LAND_COVER_A {return "A";}
			match ACTION_MODIFY_LAND_COVER_U {return "U";}
			match ACTION_MODIFY_LAND_COVER_N {return "N";}
			match ACTION_MODIFY_LAND_COVER_AUs {return "AUs";}
			match ACTION_MODIFY_LAND_COVER_Us {return "Us";}
			match ACTION_MODIFY_LAND_COVER_Ui {return "Ui";}
			match ACTION_EXPROPRIATION {return "N";}
			}
	}
	
	string dike_label_of_command (int act) {
		switch act {
			match ACTION_REPAIR_DIKE {return "Rénover";}
			match ACTION_CREATE_DIKE {return "Nvl Digue";}
			match ACTION_DESTROY_DIKE {return "Nvl Digue";}
			match ACTION_RAISE_DIKE {return "Réhausser";}
			match ACTION_INSTALL_GANIVELLE {return "Ganivelle";}
		}
	}
	
	init
	{
		sim_id <- machine_time;
		create network_leader number:1;
		do create_commune; 
		do create_commune_action_buttons;

		ask commune
		{
			put [] key:self.commune_name in:profils;
		}

		//pour les test
		int i <- 0;

		create action_done number:0
		{
			location <- any_location_in(polygon([{0,0}, {20,0},{20,100},{0,100},{0,0}]));
			id <-i ;
			commune_name<-"dolus";
			i<- i+1;
		}
//		time_at_initialization <- machine_time;
	}
	
//	reflex cancel_activations_for_5_sec_after_initialization when: machine_time < time_at_initialization+5000
//	{
//		do cancel_all_activated_action;
//	}
	
	user_command "Annuler toutes les applications de leviers en cours" action: cancel_all_activated_action;
	action cancel_all_activated_action
	{
		ask all_levers {activation_queue<-[];}
	}
	
	action generate_historique_profils {
		ask commune {
			write "<<"+commune_name+">>";
			write world.generate_historique_profils_for(commune_name);
		}
	}
	
	action generate_historique_profils_for (string aCommune) {
		
		loop prof over: ["batisseur","defense douce", "retrait"]
		{
			list<int> aSerie;
			list<action_done> lad <- action_done where (each.commune_name = aCommune and each.tracked_profil = prof);
			
			
			loop i from: 1 to:round {
				add (length (lad where (each.command_round = i))) to: aSerie ;
			}	
			write prof + " : " +aSerie;
		}
	}
	reflex drag_drop when: selection_action_done != nil and  current_selected_action = REORGANISATION_AFFICHAGE
	{
			selection_action_done.shape <- rectangle(10#m,5#m);
			selection_action_done.location	<-	#user_location;	
	}
	
	action button_commune 
	{
		point loc <- #user_location;
		selected_commune <- (commune first_with (each overlaps loc ));
	}
	
	action button_action
	{
		point loc <- #user_location;
		selected_action <- (action_button first_with (each overlaps loc ));
		if selected_action = nil {return;} 
		switch(selected_action.displayName)
				{
					match PRELEVER {
						if(selected_commune != nil)
						{
							do percevoir_recette( selected_commune);
							selected_action<-nil; // désélection pour etre sur de ne pas appliquer 2 fois la meme action 
						}
					}
					match CREDITER {
						if(selected_commune != nil)
						{
							do subventionner( selected_commune);
							selected_action<-nil; // désélection pour etre sur de ne pas appliquer 2 fois la meme action 
						}
					}
					match SUBVENTIONNER_GANIVELLE_NAME {
						if(selected_commune != nil)
						{
							do subventionner_ganivelle();
							write "SUBVENTIONNER_GANIVELLE Cliqué";
						}
					}	
					match SUBVENTIONNER_HABITAT_ADAPTE_NAME {
						if(selected_commune != nil)
						{
							do subventionner_habitat_adapte();
							write "SUBVENTIONNER_HABITAT_ADAPTE Cliqué";
						}
					}					
				}
	}
	
	action button_action_done
	{
		point loc <- #user_location;
		
		write "selection_action " + current_selected_action;
		
		action_done local_selection <- (action_done first_with (each overlaps loc ));
		switch(current_selected_action)
				{
					match REORGANISATION_AFFICHAGE {
						if(selection_action_done = nil)
						{
							selection_action_done <- local_selection;
						}
						else
						{
							selection_action_done <- nil;
						}
						
					}
				}
	}
	
	action user_click
	{
		point loc <- #user_location;
		unknown aButtonT <- ((all_levers + commune_action_button) first_with (each overlaps loc ));
		if aButtonT = nil {return;} 
		if aButtonT in commune_action_button {ask commune_action_button where (each = aButtonT){do button_cliked();}  
		}
	}
	action percevoir_recette(commune com)
	{
		string answere <- "Montant de la recette : ";
		map values <- user_input("Vous allez prélever une recette en provenance de " +com.com_large_name+"\nMettre un montan de 0 pour annuler",["Montant de la recette : " :: "2000"]);
		map<string, unknown> msg <-[];//LEADER_COMMAND::RECETTE,AMOUNT::int(values[answere]),COMMUNE::com.com_id];
		if int(values[answere])=0 {return;}// permet d'annuler l'action si le leader change d'avis ou est arriver la par hazard
		put PRELEVER key: LEADER_COMMAND in: msg;
		put int(values[answere]) key: AMOUNT in: msg;
		put com.com_id key: COMMUNE in: msg;
		do send_message_from_leader(msg);	
	}

	action subventionner(commune com)
	{
		string answere <- "montant de la subvention : ";
		map values <- user_input("Vous allez subventionner la commune de " +com.com_large_name+"\nMettre un montant de 0 pour annuler",[ "montant de la subvention : " :: "2000"]);
		map<string, unknown> msg <-[]; //LEADER_COMMAND::SUBVENTIONNER,AMOUNT::int(values[answere]),COMMUNE::com.com_id];
		if int(values[answere])=0 {return;}// permet d'annuler l'action si le leader change d'avis ou est arriver la par hazard
		put CREDITER key: LEADER_COMMAND in: msg;
		put int(values[answere]) key: AMOUNT in: msg;
		put com.com_id key: COMMUNE in: msg;
		do send_message_from_leader(msg);	
	}
	action subventionner_ganivelle
	{
		string msg <- ""+SUBVENTIONNER_GANIVELLE+COMMAND_SEPARATOR+999/*pour un mettre un action_id bidon */;
		do send_message_to_commune(msg,selected_commune.commune_name);	
	}
	action subventionner_habitat_adapte
	{	
		string msg <- ""+SUBVENTIONNER_HABITAT_ADAPTE+COMMAND_SEPARATOR+999/*pour un mettre un action_id bidon */;
		do send_message_to_commune(msg,selected_commune.commune_name);	
	}
	
	
	action send_message_from_leader(map<string,unknown> msg)
	{
		ask network_leader
		{
			do send to:MSG_FROM_LEADER contents:msg;
		}		
	}
	
	action send_message_lever (activated_lever lev)
	{
		ask network_leader
		{
			do send to: "activated_lever" contents:lev.build_map_from_attribute();
		}	
	}
	action send_message_to_commune(string msg, string acommune_name)
	{
		ask network_leader
		{
			do send to:acommune_name contents:msg;
		}		
	}
	
	action button_action_move
	{
		if(selection_action_done != nil and  current_selected_action = REORGANISATION_AFFICHAGE)
		{
			selection_action_done.shape <- rectangle(10#m,5#m);
			selection_action_done.location	<-	#user_location;	
		}
	}
			
	action action_move_infobulle
	{
		explored_lever <- nil;
		MOUSE_LOC <- point(#user_location);
		if MOUSE_LOC != nil  and MOUSE_LOC != {0,0} and all_levers != nil and !empty(all_levers)
			{
			list<lever> selected_levers <- all_levers overlapping (MOUSE_LOC);
			if (length(selected_levers)> 0) 
			{
				explored_lever <- first(selected_levers);
			}
		}
	}
		
				
				
	//ask get_all_instances(lever) 
	list<lever> all_levers -> {(lever_create_dike+lever_raise_dike+lever_repair_dike+lever_AUorUi_inCoastBorderArea+lever_AUorUi_inRiskArea
				+lever_ganivelle+lever_Us_outCoastBorderOrRiskArea+lever_Us_inCoastBorderArea+lever_Us_inRiskArea+lever_inland_dike
				+lever_no_dike_creation+lever_no_dike_raise+lever_no_dike_repair+lever_AtoN_inCoastBorderOrRiskArea
				+lever_densification_outCoastBorderAndRiskArea+lever_expropriation+lever_destroy_dike) sort_by (each.my_commune.com_id)};
		
	action create_commune
	{
		int i <- 0;
		create commune from:communes_shape with: [commune_name::string(read("NOM_RAC")),com_id::int(read("id_jeu")),com_large_name::string(read("NOM"))]
		{
			if(com_id = 0)
			{
				do die;
			}
			location <- {5, i*20 + 10};
			i <- i +1;
		
   			create lever_raise_dike number:1 {	my_commune <- myself;}
   			create lever_create_dike number:1 {my_commune <- myself;}
   			create lever_repair_dike number:1 {my_commune <- myself;}	
	 		create lever_AUorUi_inCoastBorderArea number:1 {my_commune <- myself;}
	 		create lever_AUorUi_inRiskArea number:1 {my_commune <- myself;}
	 		create lever_ganivelle number:1 {my_commune <- myself;}
	 		create lever_Us_outCoastBorderOrRiskArea number:1 {my_commune <- myself;}
	 		create lever_Us_inCoastBorderArea number:1 {my_commune <- myself;}
	 		create lever_Us_inRiskArea number:1 {my_commune <- myself;}
	 		create lever_inland_dike number:1 {my_commune <- myself;}
	 		create lever_no_dike_creation number:1 {my_commune <- myself;}
	 		create lever_no_dike_raise number:1 {my_commune <- myself;}
	 		create lever_no_dike_repair number:1 {my_commune <- myself;}
	 		create lever_AtoN_inCoastBorderOrRiskArea number:1 {my_commune <- myself;}
	 		create lever_densification_outCoastBorderAndRiskArea number:1 {my_commune <- myself;}
	 		create lever_expropriation number:1 {my_commune <- myself;}
	 		create lever_destroy_dike number:1 {my_commune <- myself;}
		}
		
		int nb_comm <- length(commune);
		int nb_lev_comm <- length(all_levers) / nb_comm; // nb de leviers par commune
		int nb_rows_comm <- 2 ; // nb de rangées de leviers par commune
		int width_screen_view <- 100;
		int height_screen_view <- 40;
		int nb_rows <- nb_rows_comm * nb_comm;
		int nb_levs_row <- ceil(nb_lev_comm / nb_rows_comm);
		float row_spacing <- (height_screen_view / nb_rows) *0.9;
		float column_spacing <- width_screen_view / (nb_lev_comm / nb_rows_comm) *0.9;
		
		int pos <-0;
		int num_column <-0;
		float num_row <-0;
		string previous_comm_name<-"";
		ask all_levers{
			add self to: my_commune.levers ;
			pos <-pos +1;
			num_column <- num_column +1;
			if previous_comm_name != my_commune.commune_name
			{
				num_column <-1;
				num_row <- num_row+1;
				tout_a_gauche_a_l_affichage<-true;
			}
			if num_column > nb_levs_row
			{
				num_column <-1;
				num_row <- num_row+0.7;
			}
			previous_comm_name <- my_commune.commune_name;
			location <- point(10+(num_column-1) * column_spacing, 10+(num_row - 1 )*row_spacing );
	 	}
	 	
	}
	
action create_commune_action_buttons
	{
		ask commune {
			point aP <- (levers first_with(each.tout_a_gauche_a_l_affichage)).location;
			
			create commune_action_button number: 1
			{
	 			displayName <- "Envoyer de l'argent";
	 			command <- "give_money";
	 			my_commune <- myself;
	 			location <- {aP.x+2,aP.y-2.1};
	 		}
	 		create commune_action_button number: 1
			{
	 			displayName <- "Prélever de l'argent";
	 			command <- "take_money";
	 			my_commune <- myself;
	 			location <- {aP.x+8,aP.y-2.1};
	 		}
	 		create commune_action_button number: 1
			{
	 			displayName <- "Envoyer un message";
	 			command <- "send_msg";
	 			my_commune <- myself;
	 			location <- {aP.x+14,aP.y-2.1};
	 		}
	 	}
	}
	
	string labelOfAction (int action_code)
	{
		string rslt <- "";
		loop i from:0 to: 30
		{
			if ((int(actions_def at {1,i})) = action_code)
			{
				rslt <- actions_def at {3,i};
			}	 
		}
		return rslt;
	}
	
	list<agent> get_all_instances(species<agent> spec)
	{
        return spec.population +  spec.subspecies accumulate (get_all_instances(each));
    }
	
}


species action_done schedules:[]
{
	string id;
	int element_id;
	string commune_name<-"";
	//string command_group <- "";
	int command <- -1 on_change: {label <- world.labelOfAction(command);};
	string label <- "no name";
	int cost <- 0;	
	bool is_applied  ->{round >= initial_application_round} ;
	int initial_application_round <- -1;
	int command_round <- -1;
	int round_delay -> {activated_levers sum_of (each.nb_rounds_delay)} ; // nb rounds of delay
	bool is_delayed ->{round_delay>0};
	//string action_type <- "dike" ; //can be "dike" or "PLU"
	// en attendant que action type soit réparé
	string action_type <-"";//-> {(command in [ACTION_CREATE_DIKE,ACTION_REPAIR_DIKE,ACTION_DESTROY_DIKE])?"dike":"PLU"};
	string previous_ua_name <-"";  // for PLU action
	bool isExpropriation <- false; // for PLU action
	bool inProtectedArea <- false; // for dike action
	bool inCoastBorderArea <- false; // for PLU action // c'est la bande des 400 m par rapport au trait de cote
	bool inRiskArea <- false; // for PLU action / Ca correspond à la zone PPR qui est un shp chargé
	bool isInlandDike <- false; // for dike action // ce sont les rétro-digues
	string tracked_profil <-"";
	geometry element_shape;
	float lever_activation_time;
	list<activated_lever> activated_levers <-[];
	bool shouldWaitLeaderToActivate <- false;
	int length_def_cote;
	bool a_lever_has_been_applied<- false;
	
	reflex save_data
	{
		
		ask world { save action_done to:"/tmp/action_done2.shp" type:"shp" crs: "EPSG:2154" with:[id::"id",cost::"cost",command_round::"cround", initial_application_round::"around", round_delay::"rdelay",is_delayed::"is_delayed", element_id::"chosenId",commune_name::"commune_name",command::"command",label::"label", tracked_profil::"tracked_profil", isInlandDike::"isInlandDike", inRiskArea::"inRiskArea",inCoastBorderArea::"inCoastBorderArea",inProtectedArea::"inProtectedArea",isExpropriation::"isExpropriation", previous_ua_name::"previous_ua_name",action_type::"action_type" ] ; }
	}
	
	init
	{
		 shape <- rectangle(10#m,5#m);
	}
	
	string full_label {
		string res ;
		switch action_type {
				match "dike" {
					if isInlandDike {res <- "Nvl RetroDigue";}
					else {res <- world.dike_label_of_command(command);} 
				}
				match "PLU" {
					res <-previous_ua_name + " -> "+(world.UA_name_of_command(command));
				}
				default {res <-"error";}
				}
		return (res+ " "+(is_applied?("(à T"+initial_application_round+")"):("("+(initial_application_round-round)+")"+(is_delayed?"+"+round_delay:""))));
	}
	
	
	geometry custom_shape {
		if is_applied {return circle(5#m);}
		else {return rectangle(10#m,5#m);} 
	}
	bool requestAttention {
		if action_type = 'dike' and command in [ACTION_CREATE_DIKE, ACTION_RAISE_DIKE] and inProtectedArea
			{return true;}
		/*if action_type = "PLU" and command in [ACTION_MODIFY_LAND_COVER_AU, ACTION_MODIFY_LAND_COVER_U] and inCoastBorderArea
			{return true;}
		if action_type = "PLU" and command in [ACTION_MODIFY_LAND_COVER_AU, ACTION_MODIFY_LAND_COVER_U] and inRiskArea
			{return true;}
		if action_type = "dike" and command in [ACTION_INSTALL_GANIVELLE] 
			{return true;}
		if action_type = "dike" and isInlandDike 
			{return true;}
		if action_type = "PLU" and command in [ACTION_MODIFY_LAND_COVER_AUs, ACTION_MODIFY_LAND_COVER_Us] 
			{return true;}
		if action_type = "dike" and command in [ACTION_DESTROY_DIKE] 
			{return true;}
		if action_type = "PLU" and isExpropriation
			{return true;}*/
		return false;
		
	/*
	 ACTION_REPAIR_DIKE
	ACTION_CREATE_DIKE
	ACTION_DESTROY_DIKE
	ACTION_RAISE_DIKE
	ACTION_INSTALL_GANIVELLE
	ACTION_MODIFY_LAND_COVER_AU
	ACTION_MODIFY_LAND_COVER_A
	ACTION_MODIFY_LAND_COVER_U
	ACTION_MODIFY_LAND_COVER_N
	ACTION_MODIFY_LAND_COVER_AUs	
	ACTION_MODIFY_LAND_COVER_Us
	ACTION_MODIFY_LAND_COVER_Ui
	ACTION_EXPROPRIATION 
	isExpropriation
	inProtectedArea
	inCoastBorderArea
	inRiskArea
	isInlandDike
	*/ 
	}
	string track_profil {
		// profil batisseur
		if action_type = 'dike' and command in [ACTION_CREATE_DIKE, ACTION_RAISE_DIKE]
			{return "batisseur";}
		if action_type = "PLU" and command in [ACTION_MODIFY_LAND_COVER_AU, ACTION_MODIFY_LAND_COVER_U] and inCoastBorderArea
			{return "batisseur";}
		if action_type = "PLU" and command in [ACTION_MODIFY_LAND_COVER_AU, ACTION_MODIFY_LAND_COVER_U] and inRiskArea
			{return "batisseur";}
		// profil def douce
		if action_type = "dike" and command in [ACTION_INSTALL_GANIVELLE] 
			{return "défense douce";}
		if action_type = "dike" and isInlandDike 
			{return "défense douce";}
		if action_type = "PLU" and command in [ACTION_MODIFY_LAND_COVER_AUs, ACTION_MODIFY_LAND_COVER_Us] 
			{return "défense douce";}

		if action_type = "dike" and command in [ACTION_DESTROY_DIKE] 
			{return "retrait";}
		if action_type = "PLU" and isExpropriation
			{return "retrait";}
		return "";
		}
	
	action init_from_map(map<string, string> a )
	{
		self.id <- string(a at "id");
		self.element_id <- int(a at "element_id");
		self.commune_name <- a at "commune_name";
		self.command <- int(a at "command");
		self.label <- a at "label";
		self.cost <- float(a at "cost");
		//self.should_be_applied <- bool(a at "should_be_applied");  Pas besoin. on le recalcul localement 
		self.initial_application_round <- int(a at "initial_application_round");
		self.action_type <- string(a at "action_type"); // Pour l'instant ca marche pas. je sais pas pourquoi
		self.previous_ua_name <- string(a at "previous_ua_name");
		self.isExpropriation <- bool(a at "isExpropriation");
		self.inProtectedArea <- bool(a at "inProtectedArea");
		self.inCoastBorderArea <- bool(a at "inCoastBorderArea");
		self.inRiskArea <- bool(a at "inRiskArea");
		self.isInlandDike <- bool(a at "isInlandDike");
		self.command_round <-int(a at "command_round");
		self.tracked_profil <- track_profil();
		self.element_shape <- geometry(a at "element_shape");
		self.length_def_cote <-int(a at "length_def_cote");
		self.a_lever_has_been_applied <-bool(a at "a_lever_has_been_applied");
//		if action_type = 'dike'
//		{
//			geometry tt <- a at "shape";
//			write tt;
//			write tt.points;
//			write geometry(tt.points[0]);
//						write tt.points[1];
////			list<point> ltt ;
////			loop aa over: tt.points {
////				write "eee  "+aa;
////				write "rrr "+geometry(aa);
////				write {float(aa.x),float(aa.y),0};
////				add point([float(aa.x),float(aa.y),0]) to: ltt;
////			} 
////			self.element_shape <- polyline (ltt,0.1);
////			write element_shape;
////			write (a at "shape")[0];
//			
////		point ori <- {float(data[9]),float(data[10])};
////					point des <- {float(data[11]),float(data[12])};
////					point loc <- {float(data[13]),float(data[14])}; 
////					shape <- polyline([ori,des]);
//		self.element_shape <- geometry(a at "shape");}
//		else
//		{
//			self.element_shape <- geometry(a at "shape");
//		} 		
	}
	
	map<string,string> build_map_from_attribute
	{
		map<string,string> res <- [
			"OBJECT_TYPE"::"action_done",
			"id"::string(id),
			"element_id"::string(element_id),
			"commune_name"::string(commune_name),
			"command"::string(command),
			"label"::string(label),
			"cost"::string(cost),
			"initial_application_round"::string(initial_application_round),
			"action_type"::string(action_type),
			"previous_ua_name"::string(previous_ua_name),
			"isExpropriation"::bool(isExpropriation),
			"inProtectedArea"::bool(inProtectedArea),
			"inCoastBorderArea"::bool(inCoastBorderArea),
			"inRiskArea"::bool(inRiskArea),
			"isInlandDike"::bool(isInlandDike),
			"command_round"::string(command_round)
			]	;
			
	return res;
	
	}
	
	
	rgb color_action_type
	{
		switch(command)
		{
			 match ACTION_CREATE_DIKE { return #blue;}
			 match ACTION_REPAIR_DIKE {return #green;}
			 match ACTION_DESTROY_DIKE {return #brown;}
			 match ACTION_MODIFY_LAND_COVER_A { return #brown;}
			 match ACTION_MODIFY_LAND_COVER_AU {return #orange;}
			 match ACTION_MODIFY_LAND_COVER_N {return #green;}
		}
		return #darkgrey;
	}
	
	rgb color_get_attention
	{
		if requestAttention() {return #red;}
		return #black;
	}
	
	rgb color_tracked_profil
	{
		switch tracked_profil
		{
			match "batisseur" {return #deepskyblue;}
			match "défense douce" {return #lightgreen;}
			match "retrait" {return #moccasin;}
			match "" {return #darkgrey;}
			default {return #red;}
		}	
	}	
	
	aspect base
	{
		if(selected_commune.commune_name = commune_name)
		{
			if !is_applied and requestAttention() {draw custom_shape()+0.5#m color: #red;}
			draw custom_shape() color:selection_action_done=self? #lightyellow:color_tracked_profil() border:#black;
			draw full_label() at:{location.x - 4.5#m, location.y} font: font("Arial", 14 , #bold) color:#black;
	
			switch action_type {
				match "dike" {
					int x <-2;
					draw ("Coût " +string(cost) /*+ " / Longueur "+22 Mettre le shape.perimeter de l'ouvrage*/) at:{location.x - 4#m, location.y+x} font: font("Arial", 14 , #plain) color:#black;
					
					if inProtectedArea {
						x<-x+2;
						draw "En zone protégée" at:{location.x - 4#m, location.y+x} font: font("Arial", 14 , #plain) color:#black;
					}
					if isInlandDike {
						x<-x+2;
						draw "Est une rétro-digue"  at:{location.x - 4#m, location.y+x} font: font("Arial", 14 , #plain) color:#black;
					}
				}
				match "PLU" {
					int x <-2;
					draw "Coût " +string(cost) at:{location.x - 4#m, location.y+x} font: font("Arial", 14 , #plain) color:#black;
					if inProtectedArea {
						x<-x+2;
						draw "En zone protégée" at:{location.x - 4#m, location.y+x} font: font("Arial", 14 , #plain) color:#black;
					}
					if inCoastBorderArea {
						x<-x+2;
						draw "Dans les 400m litroal"  at:{location.x - 4#m, location.y+x} font: font("Arial", 14 , #plain) color:#black;
					}
					if inRiskArea {
						draw "Dans zone à risque" at:{location.x - 4#m, location.y+2+x} font: font("Arial", 14 , #plain) color:#black;
						x<-x+2;
					}
				}
			}
	/*
	 * Dike
	 
	 * inProtectedArea <- false; // for dike action
	 * isInlandDike <- false; // for dike action // ce sont les rétro-digues
	 */			
		}
	}

}



species action_button
{	
	string displayName;
	int commande;
	geometry shape <- rectangle(50#m,5#m);
	bool is_selected -> {selected_action = self};
	
	aspect base
	{
		draw shape color:is_selected ? #green:#blue;
		draw displayName at:{location.x - 4.5#m, location.y} color:#white;
	}
	
}




species commune
{
	string commune_name;
	string com_large_name;
	string budget;
	int com_id;
	bool not_updated <- false;
	geometry shape <- rectangle(50#m,10#m);
	bool is_selected -> {selected_commune = self};
	list<lever> levers ;
	
	// Indicateurs calculés par le Modèle à l’initialisation. Lorsque Leader se connecte, le Modèle lui renvoie la valeur de ces indicateurs en même temps	
	int length_dikes_t0 <- 0#m; //linéaire de digues existant / commune
	int length_dunes_t0 <- 0#m; //linéaire de dune existant / commune
	int count_UA_urban_t0 <-0; //nombre de cellules de bâtis (U , AU), Us et AUs)
	int count_UA_UandAU_inCoastBorderArea_t0 <-0; //nombre de cellules de bâtis (non adapté) en zone littoral (<400m) ZL
	int count_UA_urban_infloodRiskArea_t0 <-0; //nombre de cellules de bâtis en zone inondable (ZI)
	int count_UA_urban_dense_infloodRiskArea_t0 <-0; //nombre de cellules denses en ZI
	int count_UA_urban_dense_inCoastBorderArea_t0 <-0; //nombre de cellules denses en ZL (zone littoral)
	int count_UA_A_t0 <-0; // nombre de cellule A
	int count_UA_N_t0 <- 0; // nombre de cellul N 
	int count_UA_AU_t0 <- 0; // nombre de cellul AU
	int count_UA_U_t0 <- 0; // nombre de cellul U
	
	//Indicateurs actualisés par Leader à chaque fois qu’il reçoit une nouvelle action_done
	int length_dike_created <- 0;//linéaire de digue construit
	int length_dike_raised <- 0; //Linéaires de digue ayant eu une opération de rehaussement.
	int length_dike_repaired <- 0;//Linéaires de digue ayant eu une opération de rénovation 
	int count_AUorUi_inCoastBorderArea <- 0; //nombre d’opérations de construction non adaptée (passage en AU) ou d’opérations de densification en zone littorale (<400m)
	int count_AUorUi_inRiskArea <- 0; //	nombre d’opérations de construction (passage en AU, ou AUs) / ou d’opérations de densification en zone inondable
	int length_ganivelle_created <- 0; //linéaire de ganivelles
	int count_Us <- 0; //nombre d’opérations de construction en habitat adapté 
	int count_Us_outCoastBorderOrRiskArea <- 0; //nombre d’opérations de construction en habitat adapté hors ZL ou ZI
	int count_Us_inCoastBorderArea <- 0; //nombre d’opérations de construction en habitat adapté en zone littoral
	int count_Us_inRiskArea <- 0; //nombre d’opérations de construction en habitat adapté en zone inondable
	int length_inland_dike <- 0; //linéaire de rétro-digue construit (au delà de 100m)
	//n° du tour de la dernière construction de digue //n° du tour du dernier rehaussement de digue  //n° du tour de la dernière rénovation de digue  -->> Implémenté directement ds les leviers correspondant
	int count_AtoN_inCoastBorderOrRiskArea<-0;	//nombre de cellule A qui passe en N en ZL et ZI
	int count_densification_outCoastBorderAndRiskArea <- 0; //nombre d’opérations de densification hors ZL/ZI
	int count_expropriation <- 0;  //nombre d’opérations d’expropriation
	int length_dike_destroyed <-0 ;//linéaire de digues démantelées
//nombre d’opérations de construction


	
	
	action update_indicators_and_register_action_done (action_done act)
	{	if act.is_applied {write "Reception action " +act.id+" -> déjà validé";}
		if act.command = ACTION_CREATE_DIKE and !act.isInlandDike
			{	//write ""+polyline(act.element_shape );
				//write  act.length_def_cote;
				length_dike_created <- length_dike_created + act.length_def_cote;
				ask lever_create_dike where(each.my_commune = self) {
					do register_and_check_activation(act);
				}
				ask lever_no_dike_creation where(each.my_commune = self) {
					do register(act);
				}
			}
		if act.command = ACTION_RAISE_DIKE
			{
				length_dike_raised <- length_dike_raised + act.length_def_cote;
				ask lever_raise_dike where(each.my_commune = self) {
					do register_and_check_activation(act);
				}
				ask lever_no_dike_raise where(each.my_commune = self) {
					do register(act);
				}
			}
		if act.command = ACTION_REPAIR_DIKE
			{
				length_dike_repaired <- length_dike_repaired + act.length_def_cote;
				ask lever_repair_dike where(each.my_commune = self) {
					do register_and_check_activation(act);
				}
				ask lever_no_dike_repair where(each.my_commune = self) {
					do register(act);
				}
			}	
		if  act.inCoastBorderArea and act.command in [ACTION_MODIFY_LAND_COVER_Ui,ACTION_MODIFY_LAND_COVER_AU] and act.previous_ua_name != "Us"
		{
			count_AUorUi_inCoastBorderArea <- count_AUorUi_inCoastBorderArea+1;
			ask lever_AUorUi_inCoastBorderArea where(each.my_commune = self) {
					do register_and_check_activation(act);
				}
		}
		if  act.inRiskArea and act.command in [ACTION_MODIFY_LAND_COVER_Ui,ACTION_MODIFY_LAND_COVER_AU]
		{
			count_AUorUi_inRiskArea <- count_AUorUi_inRiskArea+1;
			ask lever_AUorUi_inRiskArea where(each.my_commune = self) {
					do register_and_check_activation(act);
				}
		}
		if act.command = ACTION_INSTALL_GANIVELLE
		{
			length_ganivelle_created <- length_ganivelle_created + act.length_def_cote;
			ask lever_ganivelle where(each.my_commune = self) {
				do register_and_check_activation(act);
			}
		}
		if act.command = ACTION_MODIFY_LAND_COVER_Us
		{
			count_Us <- count_Us +1;
			if act.inCoastBorderArea {
				count_Us_inCoastBorderArea <- count_Us_inCoastBorderArea +1;
				ask lever_Us_inCoastBorderArea where(each.my_commune = self) {
						do register_and_check_activation(act);
					}
				}
			if act.inRiskArea {
				count_Us_inRiskArea <- count_Us_inRiskArea +1;
				ask lever_Us_inRiskArea where(each.my_commune = self) {
						do register_and_check_activation(act);
					}
			}
			if (!act.inRiskArea) and (!act.inCoastBorderArea) {
				count_Us_outCoastBorderOrRiskArea <- count_Us_outCoastBorderOrRiskArea +1;
				ask lever_Us_outCoastBorderOrRiskArea where(each.my_commune = self) {
						do register_and_check_activation(act);
					}
			} 
		}
		if act.command = ACTION_CREATE_DIKE and act.isInlandDike
			{	
				length_inland_dike <- length_inland_dike + act.length_def_cote;
				ask lever_inland_dike where(each.my_commune = self) {
					do register_and_check_activation(act);
				}
			}
			
		if act.command = ACTION_MODIFY_LAND_COVER_N and act.previous_ua_name = "A" and (act.inCoastBorderArea or act.inRiskArea)
			{	
				count_AtoN_inCoastBorderOrRiskArea <- count_AtoN_inCoastBorderOrRiskArea + 1;
				ask lever_AtoN_inCoastBorderOrRiskArea where(each.my_commune = self) {
					do register (act);
					do checkActivation_andImpactOnFirstElementOf (myself.actions_densification_outCoastBorderAndRiskArea());
				}
			}
		if act.command = ACTION_MODIFY_LAND_COVER_Ui and !act.inCoastBorderArea and !act.inRiskArea 
			{	
				count_densification_outCoastBorderAndRiskArea <- count_densification_outCoastBorderAndRiskArea + 1;
				ask lever_densification_outCoastBorderAndRiskArea where(each.my_commune = self) {
					do register_and_check_activation (act);
				}
			}	
			
		if act.isExpropriation
			{	
				count_expropriation <- count_expropriation + 1;
				ask lever_expropriation where(each.my_commune = self) {
					do register_and_check_activation(act);
				}
			}
		if act.command = ACTION_DESTROY_DIKE
			{
				length_dike_destroyed <- length_dike_destroyed + act.length_def_cote;
				ask lever_destroy_dike where(each.my_commune = self) {
					do register_and_check_activation(act);
				}
			}
			
	}

	
	list<action_done> actions_install_ganivelle
	{
		return ( (lever_ganivelle first_with(each.my_commune = self)).associated_actions sort_by(-each.command_round) );
	}
	
	
	list<action_done> actions_densification_outCoastBorderAndRiskArea
	{
		return ( (lever_densification_outCoastBorderAndRiskArea first_with(each.my_commune = self)).associated_actions sort_by(-each.command_round) );
	}
	
	list<action_done> actions_expropriation
	{
		return ( (lever_expropriation first_with(each.my_commune = self)).associated_actions sort_by(-each.command_round) );
	}
	
	aspect base
	{
		draw shape color:is_selected ? #green:#blue;
		draw com_large_name at:{location.x - 4.5#m, location.y} color:#white;
	}
}


species commune_action_button
{
	string displayName;
	string command;
	commune my_commune;
	geometry shape <- rectangle(5.4,0.8);
	
	aspect base
	{
		draw shape color: rgb(176,97,188) border: #black;
		draw displayName at:{location.x-2.5, location.y+0.2} font: font("Arial", 14 , #plain) color:#white;
	}
	
	action button_cliked 
	{
		switch(displayName)
		{
			match "Prélever de l'argent"
			{			
				string msg1 <- "Les autorités réorientent leur politique: vos actions vous coûtent plus cher que prévu. Vous êtes prélevé de : ";
				string msg2 <- "Les coûts dans le BTP augmentent considérablement et votre budget en est impacté. Vous êtes prélevé de : ";
				string msg3 <-"L’agence du risque prélève une amende en raison de vos actions de gestion des risques. Vous êtes prélevé de : ";
				map values <- user_input("Indiquer le montant prélevé à " +my_commune.com_large_name+"\n(0 pour annuler)\n
Choix du message envoyé au joueur
1 : "+msg1+" 
2 : "+msg2+"
3 : "+msg3+"
OU Tapez votre message personnalisé sans utiliser de guillemets",
						[	"Montant :" :: "2000",
							"Message (1,2,3 ou message personnalisé)" :: "1"
						]);
				map<string, unknown> msg <-[];
				if int(values["Montant :"])=0 {return;}
				string msgJoueur;
				switch int(values["Message (1,2,3 ou message personnalisé)"]) {
					match 1 {msgJoueur<-msg1;}
					match 2 {msgJoueur<-msg2;}
					match 3 {msgJoueur<-msg3;}
					default {msgJoueur<-(values["Message (1,2,3 ou message personnalisé)"]);}
				}
				put PRELEVER key: LEADER_COMMAND in: msg;
				put my_commune.commune_name key: COMMUNE in: msg;
				put int(values["Montant :"]) key: AMOUNT in: msg;
				put msgJoueur key: PLAYER_MSG in:msg;

				ask world {do send_message_from_leader(msg);}	
				ask world {do record_leader_activity("Prélever de l'argent à ", myself.my_commune.commune_name, string(msg at PLAYER_MSG) + string(msg at AMOUNT)+"By");}
						
			}
			match "Envoyer de l'argent"
			{
				string msg1 <- "L’agence du risque finance une partie de vos pratiques de gestion intégrée des risques. Vous recevez : ";
				string msg2 <- "Les autorités subventionnent vos actions de gestion des risques. Vous recevez : ";
				string msg3 <-"Vos efforts en matière de gestion des risques sont financièrement encouragés. Vous recevez : ";
				map values <- user_input("Indiquer le montant envoyé à " +my_commune.com_large_name+"\n(0 pour annuler)\n
Choix du message envoyé au joueur
1 : "+msg1+" 
2 : "+msg2+"
3 : "+msg3+"
OU Tapez votre message personnalisé sans utiliser de guillemets",
						[	"Montant :" :: "2000",
							"Message (1,2,3 ou message personnalisé)" :: "1"
						]);
				map<string, unknown> msg <-[];				
				if int(values["Montant :"])=0 {return;}
				string msgJoueur;
				switch int(values["Message (1,2,3 ou message personnalisé)"]) {
					match 1 {msgJoueur<-msg1;}
					match 2 {msgJoueur<-msg2;}
					match 3 {msgJoueur<-msg3;}
					default {msgJoueur<-(values["Message (1,2,3 ou message personnalisé)"]);}
				}
				put CREDITER key: LEADER_COMMAND in: msg;
				put my_commune.commune_name key: COMMUNE in: msg;
				put int(values["Montant :"]) key: AMOUNT in: msg;
				put msgJoueur key: PLAYER_MSG in:msg;

				ask world {do send_message_from_leader(msg);}
				ask world {do record_leader_activity("Envoyer de l'argent à ", myself.my_commune.commune_name, string(msg at PLAYER_MSG)+ string(msg at AMOUNT)+"By");}							
			}
			match "Envoyer un message"
			{
				string msg1 <- "Un renforcement de la loi Littoral retarde vos mesures de gestion du risque";
				string msg2 <- "L’agence du risque désapprouve votre gestion du risque : vos dossiers sont retardés";
				string msg3 <-"L’agence du risque facilite vos pratiques alternatives de gestion des risques et active vos dossiers";
				string msg4 <-"Un changement législatif est opéré en faveur de vos pratiques de gestion des risques : vous êtes encouragé à poursuivre votre stratégie";
				string msgJoueur;
				map values <- user_input("Indiquer le message envoyé à " +my_commune.com_large_name+"\n(message vide pour annuler)\n
Choix du message envoyé au joueur
1 : "+msg1+" 
2 : "+msg2+"
3 : "+msg3+"
4 : "+msg4+"
OU Tapez votre message personnalisé sans utiliser de guillemets",
						["Message (1,2,3,4 ou message personnalisé)" :: "1"]);
				if (values["Message (1,2,3,4 ou message personnalisé)"])=""{return;}
				switch int(values["Message (1,2,3,4 ou message personnalisé)"]) {
					match 1 {msgJoueur<-msg1;}
					match 2 {msgJoueur<-msg2;}
					match 3 {msgJoueur<-msg3;}
					match 4 {msgJoueur<-msg4;}
					default {msgJoueur<-(values["Message (1,2,3,4 ou message personnalisé)"]);}
				}
				map<string, string> msg <-[];
				put MSG_TO_PLAYER key: LEADER_COMMAND in: msg;
				put my_commune.commune_name key: COMMUNE in: msg;
				put msgJoueur key: PLAYER_MSG in:msg;
				
				ask world {do send_message_from_leader(msg);}
				ask world {do record_leader_activity("Envoyer un message à ", myself.my_commune.commune_name, string(msg at PLAYER_MSG));}			
			}			
		}		
	}
}

species activated_lever 
{
	action_done act_done;
	float activation_time;
	bool applied <- false;
	
	//attributes sent through network
	int id <- length(activated_lever);
	string commune_name;
	string lever_type;
	string lever_explanation <- "";
	string act_done_id <- "";
	int nb_rounds_delay <-0;
	int added_cost <- 0;
	int round_creation;
	int round_application;
	
	action init_from_map(map<string, string> m )
	{
		id <- int(m["id"]);
		lever_type <- m["lever_type"];
		commune_name <- m["commune_name"];
		act_done_id <- m["act_done_id"];
		added_cost <- int(m["added_cost"]);
		nb_rounds_delay <- int(m["nb_rounds_delay"]);
		lever_explanation <- m["lever_explanation"];
		round_creation <- int(m["round_creation"]);
		round_application <- int(m["round_application"]);
	}
	
	map<string,string> build_map_from_attribute
	{
		map<string,string> res <- [
			"OBJECT_TYPE"::"activated_lever",
			"id"::id,
			"lever_type"::lever_type,
			"commune_name"::commune_name,
			"act_done_id"::string(act_done_id),
			"added_cost"::string(added_cost),
			"nb_rounds_delay"::int(nb_rounds_delay),
			"lever_explanation"::lever_explanation,
			"round_creation"::round_creation,
			"round_application"::round_application
			 ]	;
		return res;
	}
}

////////////////////////////////////////////////////////////////////////////////////////////
//////////					LEVER 
//////////////////////////////////////////////////////////////

species lever 
{
	commune my_commune ;
	bool status_on <- true  ;// can be on or off . If off then the checkLeverActivation is not performed
	float threshold;
	float indicator;
	bool should_be_activated -> {indicator > threshold };
	bool threshold_reached <- false;
	bool timer_activated -> {!empty(activation_queue)};
	bool has_activated_levers -> {!empty(activated_levers)};
	float timer_duration <- 240000;// 1 minute = 60000 milliseconds //   4 mn = 240000
	list<action_done> associated_actions;
	list<activated_lever> activation_queue;
	list<activated_lever> activated_levers;
	string profile_name<-"";
	string lever_type <-"";
	string box_title -> {lever_type +' ('+length(associated_actions)+')'};
	string progression_bar<-"";
	string help_lever_msg <-"";
	string player_msg;
	string activation_label_L1<-"";
	string activation_label_L2<-"";
	geometry shape <- rectangle (9,2.6);
	point origin -> { location - {4.2,0.7} } ;
	bool tout_a_gauche_a_l_affichage <-false;
    
	action register_and_check_activation (action_done act_done)
	{
		do register(act_done);
		do checkActivation_andImpactOn(act_done);
	}
	
	action register (action_done act_done)
	{
		add act_done to: associated_actions;	
	}
	action checkActivation_andImpactOn (action_done act_done)
	{
		if  status_on //and !act_done.is_applied 
		{
			if should_be_activated //and !act_done.a_lever_has_been_applied
			{
				threshold_reached <- true;
				do queue_activated_lever(act_done);
			}
			else {threshold_reached <- false;}	
		}
	} 
	action apply_lever(activated_lever lev) {} ///  virtual:true;    CA FAIT PLANTER
	string info_of_next_activated_lever {return "";} //virtual:true;	   CA FAIT PLANTER
	action check_activation_at_new_round {}
	action cancel_lever(activated_lever lev){}
	action checkActivation_andImpactOnFirstElementOf  (list<action_done> list_act_done)
	{
		if !empty(list_act_done)
		{
			do checkActivation_andImpactOn(list_act_done[0]);
		}
	}
	
	action queue_activated_lever( action_done a_act_done)
	{
		create activated_lever number: 1 
		{
			lever_type <- myself.lever_type;
			commune_name <- myself.my_commune.commune_name;
			self.act_done <- a_act_done;
			act_done_id <- a_act_done.id;
			activation_time <-  machine_time + myself.timer_duration ;
			round_creation <- round;
			add self to: myself.activation_queue;
		}
		ask world {do record_leader_activity("Levier "+myself.lever_type+" programmé à ", myself.my_commune.commune_name, string(a_act_done.label)+"("+a_act_done+")");}
	}

	action toogle_status 
	{
		status_on <- !status_on ;
		if !status_on {
			activation_queue <-[];
		}
	}
//	
	
	action write_help_lever_msg 
	{
		map values <- user_input("Explication du levier",[help_lever_msg+"\nValeur seuil : "+threshold:: ""]);
	}
	
	string texte_infobulle {
		return (""+help_lever_msg+" / Valeur seuil : "+threshold);
		}
	
	action change_lever_player_msg 
	{
		map values <- user_input("Message envoyé au joueur lorsque le levier se déclenche",
			["Message :":: player_msg]);
		player_msg <- string(values["Message :"]);
		ask world {do record_leader_activity("Changer levier "+myself.lever_type+" à ", myself.my_commune.commune_name, "-> Le nouveau message envoyé au joueur est : "+string(myself.player_msg));}
	}
	action change_lever_threshold_value
	{
		map values <- user_input(("Le seuil actuel du levier "+lever_type+"\nest de "+string(threshold)),["Entrer la nouvelle valeur seuil du levier :":: threshold]);
		float n_val  <- float(values["Entrer la nouvelle valeur seuil du levier :"]);
		threshold <- n_val ;
		
		ask world {do record_leader_activity("Changer levier "+myself.lever_type+" à ", myself.my_commune.commune_name, "-> La nouvelle valeur seuil est : "+string(myself.threshold));}	
	}
	
	float activation_time
	{
		return activation_queue[0].activation_time;
	}
	
	reflex check_timer when: timer_activated
	{
		if machine_time > activation_time()
		{
			activated_lever act_lever <- activation_queue[0];
			remove index: 0 from: activation_queue ;
			add act_lever to: activated_levers;
			do apply_lever(act_lever);
		}
	}
	
	int remaining_seconds 
	{
		return (int((activation_time() -machine_time) / 1000));
	}
	
	action cancel_next_activated_action
	{		
		if !empty(activation_queue)
			{
				do cancel_lever(activation_queue[0]);
				ask world {do record_leader_activity("Levier "+myself.lever_type+" annulé à ", myself.my_commune.commune_name,  " Annulation de " +myself.activation_queue[0].act_done);}
				remove index: 0 from: activation_queue ;	
	
			}
	}

	action accept_next_activated_action
	{		
		if !empty(activation_queue)
		{
			activation_queue[0].activation_time <- machine_time ;
		} 	
	}

	action accept_all_activated_action
	{	
		loop aa over: activation_queue
		{
			aa.activation_time <- machine_time ;
		} 	
	}
	
	rgb color_profile
	{
		switch profile_name
		{
			match "batisseur" {return #deepskyblue;}
			match "défense douce" {return #lightgreen;}
			match "retrait" {return #moccasin;}
			match "" {return #darkgrey;}
			default {return #red;}
		}	
	}
	aspect base
	{
		if timer_activated {draw shape+0.2#m color: #red;}
		draw shape color: color_profile() border:#black;
		draw box_title at:{origin.x, origin.y} font: font("Arial", 14 , #bold) color:#black;
		float v_pos <-0.5;
		draw progression_bar at:{origin.x , origin.y+v_pos} font: font("Arial", 14 , #plain) color: threshold_reached?#red:#black;
		v_pos<-v_pos+0.5;
		if timer_activated {
				draw string(remaining_seconds())+" sec "+(length(activation_queue)=1?"":"("+length(activation_queue)+")")+"-> " + info_of_next_activated_lever() at:{origin.x, origin.y+v_pos} font: font("Arial", 14 , #plain) color:#black;
			}
		v_pos<-v_pos+0.5;
		if has_activated_levers {
				draw activation_label_L1 at:{origin.x, origin.y+v_pos} font: font("Arial", 14 , #plain) color:#black;
				v_pos<-v_pos+0.5;
				draw activation_label_L2 at:{origin.x, origin.y+v_pos} font: font("Arial", 14 , #plain) color:#black;
			}
		if !status_on {draw shape+0.1#m color: rgb(200,200,200,160) ;}
		
		if tout_a_gauche_a_l_affichage
		{draw my_commune.commune_name  at:{origin.x, origin.y-1} font: font("Arial", 18 , #bold) color:#black;}
		

	}
}


species cost_lever parent: lever
{
	float added_cost_percentage;
	int last_lever_amount <-0; 
		
	
	user_command "Annuler la prochaine application du levier" action: cancel_next_activated_action;	
	user_command "Valider la prochaine application du levier" action: accept_next_activated_action;
	user_command "Valider toutes les applications en cours du levier" action: accept_all_activated_action;
	
	user_command "Changer le message envoyé au joueur" action: change_lever_player_msg;	
	user_command "Changer la valeur du seuil du levier" action: change_lever_threshold_value;
	user_command "Changer le % d'impact sur le prix " action: change_lever_added_cost_percentage;

	user_command "activer/désactiver le levier" action: toogle_status;
	
	user_command "Comment fonctionne ce levier ?" action: write_help_lever_msg;		
	
	action change_lever_added_cost_percentage
	{
		map values <- user_input(("Le % actuel par rapport au cout du levier "+lever_type+"\nest de "+string(added_cost_percentage)),["Entrer le nouveau % :":: added_cost_percentage]);
		float n_val <- float(values["Entrer le nouveau % :"]);
		added_cost_percentage <- n_val;
		
		ask world {do record_leader_activity("Changer levier "+myself.lever_type+" à ", myself.my_commune.commune_name, "-> Le nouveau % du levier est : "+string(myself.added_cost_percentage));}
	}
	
	string info_of_next_activated_lever 
	{
		return ""+int(activation_queue[0].act_done.length_def_cote) + " m. (" + int(activation_queue[0].act_done.cost * added_cost_percentage) + ' By.)';
	}
	
	action apply_lever(activated_lever lev)
	{
		lev.applied <- true;
		lev.round_application <-round;
		lev.lever_explanation <- player_msg;
		lev.added_cost <- int(lev.act_done.cost * added_cost_percentage);
		
		ask world {do send_message_lever(lev) ;}
		
		last_lever_amount <-lev.added_cost;
		activation_label_L1 <- "Dernier "+(last_lever_amount>=0?"prélevement":"versement")+" : "+abs(last_lever_amount)+ ' By.';
		activation_label_L2 <- "Total "+(last_lever_amount>=0?"prélevé":"versé")+" : "+string(abs(tot_lever_amont()))+' By';
		
		ask world {do record_leader_activity("Levier "+myself.lever_type+" validé à ", myself.my_commune.commune_name, myself.help_lever_msg + " : "+(lev.added_cost)+"By"+"("+lev.act_done+")");}
		
	}
	
	int tot_lever_amont 
	{
		return activated_levers sum_of (each.added_cost);
	}
}

species delay_lever parent: lever
{
	int rounds_delay_added;
	
	
	user_command "Annuler la prochaine application du levier" action: cancel_next_activated_action;	
	user_command "Valider la prochaine application du levier" action: accept_next_activated_action;
	user_command "Valider toutes les applications en cours du levier" action: accept_all_activated_action;
	
	user_command "Changer le message envoyé au joueur" action: change_lever_player_msg;	
	user_command "Changer la valeur du seuil du levier" action: change_lever_threshold_value;
	user_command "Changer le % d'impact sur le prix " action: change_lever_rounds_delay_added;

	user_command "activer/désactiver le levier" action: toogle_status;
	user_command "Comment fonctionne ce levier ?" action: write_help_lever_msg;		


	action change_lever_rounds_delay_added
	{
		map values <- user_input(("Le nb de tours de délai actuel du levier "+lever_type+"\nest de "+string(rounds_delay_added)),["Entrer le nouveau nb :":: rounds_delay_added]);
		int n_val <- int(values["Entrer le nouveau nb :"]);
		rounds_delay_added <- n_val;
		
		ask world {do record_leader_activity("Changer levier "+myself.lever_type+" à ", myself.my_commune.commune_name, "-> Le nouveau nb de tours du levier est : "+string(myself.rounds_delay_added));}
	}
	
	action checkActivation_andImpactOn (action_done act_done)
	{
		if  status_on //and !act_done.is_applied
		{
			if should_be_activated //and !act_done.a_lever_has_been_applied
			{
				threshold_reached <- true;
				do queue_activated_lever(act_done);
				act_done.shouldWaitLeaderToActivate <- true;
				do informNetwork_shouldWaitLeaderToActivate(act_done);
			}
			else {threshold_reached <- false;}	
		}
	} 
	action apply_lever(activated_lever lev)
	{
		lev.applied <- true;
		lev.lever_explanation <- player_msg;
		lev.nb_rounds_delay <- rounds_delay_added;
		
		ask world {do send_message_lever(lev) ;}
		
		int aTot <- tot_lever_delay();
		if aTot < 0
		{
			activation_label_L1 <- "Avance total: "+string(abs(tot_lever_delay()))+' tours';
		}
		else
		{
			activation_label_L1 <- "Retard total: "+string(abs(tot_lever_delay()))+' tours';
		}
		
		
		lev.act_done.shouldWaitLeaderToActivate <- false;
		do informNetwork_shouldWaitLeaderToActivate(lev.act_done);
		
		ask world {do record_leader_activity(myself.lever_type+" déclenché à ", myself.my_commune.commune_name, myself.help_lever_msg + " : "+(lev.nb_rounds_delay)+" tours"+"("+lev.act_done+")");}
	}
	
	action cancel_lever(activated_lever lev)
	{
		lev.act_done.shouldWaitLeaderToActivate <- false;
		do informNetwork_shouldWaitLeaderToActivate(lev.act_done);
	}
	
	int tot_lever_delay 
	{
		return activated_levers sum_of (each.nb_rounds_delay);
	}
	
	action informNetwork_shouldWaitLeaderToActivate(action_done act_done)
	{
		map<string, unknown> msg <-[];
		put "action_done shouldWaitLeaderToActivate" key: LEADER_COMMAND in: msg;
		put my_commune.commune_name key: COMMUNE in: msg;
		put act_done.id key: "action_done id" in: msg;
		put act_done.shouldWaitLeaderToActivate key: "action_done shouldWaitLeaderToActivate" in: msg;
		ask world {do send_message_from_leader(msg);}
		//write msg;	
	}
}

species lever_create_dike parent: cost_lever
{
	float indicator -> {my_commune.length_dike_created / my_commune.length_dikes_t0};
	string progression_bar -> {""+my_commune.length_dike_created+ " m. / "+threshold+" * "+ my_commune.length_dikes_t0+" m. à t0"};
	
	init
		{
		lever_type <- "Construit Digue";
		profile_name<-"batisseur";
		threshold <- 0.2;
		added_cost_percentage <- 0.25 ;
		help_lever_msg <-"prélevement de la commune au prorata du linéaire construit : "+int(100*added_cost_percentage)+"% du prix de construction";
		player_msg <- "Les autorites reorientent leur politique : vos actions vous coutent plus cher que prevu";	
		}
}

species lever_raise_dike parent: cost_lever
{
	float indicator -> {my_commune.length_dike_raised / my_commune.length_dikes_t0};
	string progression_bar -> {""+my_commune.length_dike_raised+ " m. / "+threshold+" * "+ my_commune.length_dikes_t0+" m. à t0"};
	init
		{
		lever_type <- "Rehausse Digue";
		profile_name<-"batisseur";
		threshold <- 0.2;
		added_cost_percentage <- 0.25 ;
		help_lever_msg <-"prélevement de la commune au prorata du linéaire réhaussé : "+int(100*added_cost_percentage)+"% du prix de réhaussement";
		player_msg <- "Les autorites reorientent leur politique : vos actions vous coutent plus cher que prevu";
		}
}

species lever_repair_dike parent: cost_lever
{
	float indicator -> {my_commune.length_dike_repaired / my_commune.length_dikes_t0};
	bool should_be_activated -> {indicator > threshold and (my_commune.length_dike_created != 0 or my_commune.length_dike_raised != 0)};
	string progression_bar -> {""+my_commune.length_dike_repaired+ " m. / "+threshold+" * "+ my_commune.length_dikes_t0+" m. à t0"};
	
	init
		{
		lever_type <- "Renove Digue";
		profile_name<-"batisseur";
		threshold <- 0.2;
		added_cost_percentage <- 0.25 ;
		help_lever_msg <-"prélevement de la commune au prorata du linéaire rénové : "+int(100*added_cost_percentage)+"% du prix de rénovation ; si a aussi construit ou réhaussé";
		player_msg <- "Les coûts dans les BTP augmentent considérablement";
		}
}


species lever_AUorUi_inCoastBorderArea parent: delay_lever
{
	string progression_bar -> {""+indicator + " actions / "+ int(threshold) + " max"};
	int indicator -> {my_commune.count_AUorUi_inCoastBorderArea};
	
	init
		{
		lever_type <- "Const/Densi non adapt en ZL";
		profile_name<-"batisseur";
		rounds_delay_added <- 2;
		threshold <- 2;
		help_lever_msg <-"Retard de "+rounds_delay_added+" tours";
		player_msg <- "Un renforcement de la loi Littoral retarde vos projets";	
		}
		
	string info_of_next_activated_lever 
	{
		switch activation_queue[0].act_done.command 
		{
			match ACTION_MODIFY_LAND_COVER_AU {return "Construction: +"+rounds_delay_added+ " tours";}
			match ACTION_MODIFY_LAND_COVER_Ui {return "Densification: +"+ rounds_delay_added+ " tours";}
		} 
	}
}


species lever_AUorUi_inRiskArea parent: cost_lever
{
	string progression_bar -> {""+indicator + " actions / "+ int(threshold) + " max"};
	int indicator -> {my_commune.count_AUorUi_inRiskArea};
	
	init
		{
		lever_type <- "Const/Densi en ZI";
		profile_name<-"batisseur";
		threshold <- 1;
		added_cost_percentage <- 0.5 ;
		help_lever_msg <-"prélevement de la commune à hauteur de "+int(100*added_cost_percentage)+"% du coût de construction";
		player_msg <- "Les coûts dans les BTP augmentent considérablement";	
		}
		
	string info_of_next_activated_lever 
	{
		switch activation_queue[0].act_done.command 
		{
			match ACTION_MODIFY_LAND_COVER_AU {return "-"+ int(activation_queue[0].act_done.cost * added_cost_percentage) +" By sur la prochaine construction";}
			match ACTION_MODIFY_LAND_COVER_Ui {return "-"+ int(activation_queue[0].act_done.cost * added_cost_percentage) +" By sur la prochaine densification";}
		} 
	}
}

species lever_ganivelle parent: cost_lever
{
	string progression_bar -> {""+my_commune.length_ganivelle_created+ " m. / "+threshold+" * "+ my_commune.length_dunes_t0+" m. dunes"};
	int indicator -> {my_commune.length_ganivelle_created / my_commune.length_dunes_t0};
	
	init
		{
		lever_type <- "Construit Ganivelle";
		profile_name<-"défense douce";
		threshold <- 0.1;
		added_cost_percentage <- -0.25 ;
		help_lever_msg <-"Versement à la commune à hauteur de "+int(100*added_cost_percentage)+"% du coût de ganivelle/m";
		player_msg <- "Le gouvernement encourage les pratiques vertueuses de gestion intégrée des risques";
		}
}

species lever_Us_outCoastBorderOrRiskArea parent: cost_lever
{
	string progression_bar -> {""+indicator + " actions / "+ int(threshold) + " max"};
	int indicator -> {my_commune.count_Us_outCoastBorderOrRiskArea};
	int rounds_delay_added <- 0; //    -2;    ANNULE POUR L INSTANT CAR INCOHERENT
	
	init
		{
		lever_type <- "Hab Adap hors ZL et ZI";
		profile_name<-"défense douce";
		threshold <- 2;
		added_cost_percentage <- -0.25 ;
		help_lever_msg <-"Versement à la commune à hauteur de "+int(100*added_cost_percentage)+"% du coût d'adaptation"; // ET avance de "+rounds_delay_added+" tours le dossier" ;
		player_msg <- "Le gouvernement encourage les pratiques vertueuses de gestion intégrée des risques";
		}
	
	string info_of_next_activated_lever 
	{
		return "+"+ abs(int(activation_queue[0].act_done.cost * added_cost_percentage)) +" By pour la prochaine adaptation";
	}
	
	action apply_lever(activated_lever lev)
	{
		lev.applied <- true;
		lev.lever_explanation <- player_msg;
		lev.added_cost <- int(lev.act_done.cost * added_cost_percentage);
		lev.nb_rounds_delay <- rounds_delay_added;
		
		ask world {do send_message_lever(lev) ;}
		
		last_lever_amount <-lev.added_cost;
		activation_label_L1 <- "Dernier versement : "+(-1*last_lever_amount)+ ' By';
		activation_label_L2 <- 'Total versé : '+string((-1*tot_lever_amont()))+' By';
		
		ask world {do record_leader_activity(myself.lever_type+" déclenché à ", myself.my_commune.commune_name, myself.help_lever_msg + " : "+lev.added_cost+"Ny : "+lev.nb_rounds_delay+" tours"+"("+lev.act_done+")");}
			
	}
}

species lever_Us_inCoastBorderArea parent: cost_lever
{
	string progression_bar -> {""+my_commune.count_Us_inCoastBorderArea + " actions / " + int(threshold) +" max"};
	int indicator -> {my_commune.count_Us_inCoastBorderArea };
	
	init
		{
		lever_type <- "Hab Adap en ZL";
		profile_name<-"défense douce";
		threshold <- 2;
		added_cost_percentage <- -0.5 ;
		help_lever_msg <-"Versement à la commune à hauteur de "+int(100*added_cost_percentage)+"% du coût d'adaptation";
		player_msg <- "L'Etat encourage les stratégies de réduction de la vulnérabilité";
		}
		
	string info_of_next_activated_lever 
	{
		return "+"+ abs(int(activation_queue[0].act_done.cost * added_cost_percentage)) +" By pour la prochaine adaptation";
	}		
}

species lever_Us_inRiskArea parent: cost_lever
{
	string progression_bar -> {""+my_commune.count_Us_inRiskArea + " actions / " + int(threshold) +" max"};
	int indicator -> {my_commune.count_Us_inRiskArea };
	
	init
		{
		lever_type <- "Hab Adap en ZI";
		profile_name<-"défense douce";
		threshold <- 2;
		added_cost_percentage <- -0.5 ;
		help_lever_msg <-"Versement à la commune à hauteur de "+int(100*added_cost_percentage)+"% du coût d'adaptation";
		player_msg <- "L'Etat encourage les stratégies de réduction de la vulnérabilité";
		}

	string info_of_next_activated_lever 
	{
		return "+"+ abs(int(activation_queue[0].act_done.cost * added_cost_percentage)) +" By pour la prochaine adaptation";
	}		
}

species lever_inland_dike parent: delay_lever
{

	float indicator -> {my_commune.length_inland_dike / my_commune.length_dikes_t0};
	string progression_bar -> {""+my_commune.length_inland_dike+ " m. / "+threshold+" * "+ my_commune.length_dikes_t0+" m. digues à t0"};
	
	
	init
		{
		lever_type <- "Const Rétrodigue";
		profile_name<-"défense douce";
		rounds_delay_added <- -1;
		threshold <- 0.01;
		help_lever_msg <-"Avance de "+abs(rounds_delay_added)+" tour"+(abs(rounds_delay_added)>1?"s":"");
		player_msg <- "Des aides existent de la part du gouvernement pour renforcer la gestion intégrée des risques";	
		}
		
	string info_of_next_activated_lever 
	{
		return "Rétrodigue ("+int(activation_queue[0].act_done.length_def_cote) + " m.): -"+abs(rounds_delay_added)+ " tours";
	}
}


species cost_lever_if_no_associatedActionA_for_N_rounds_with_impacted_on_actionB parent: cost_lever 
{
	int nb_rounds_before_activation;
	int nb_activations <-0;
	string box_title -> {lever_type +' ('+nb_activations+')'};
	bool should_be_activated -> { (nb_rounds_before_activation  <0) and !empty(listOfImpactedAction)};
	list<action_done> listOfImpactedAction;
	
	action register (action_done act_done)
	{
		add act_done to: associated_actions;
		nb_rounds_before_activation <- threshold;	
	}	

	action check_activation_at_new_round
	{
		if round > 1
		{
			nb_rounds_before_activation <- nb_rounds_before_activation - 1;
			do checkActivation_andImpactOnFirstElementOf(listOfImpactedAction);
		}
	}
	
	string progression_bar -> {""+int(threshold-nb_rounds_before_activation) + " tours / "+int(threshold)+" max"};
	
	action apply_lever(activated_lever lev)
	{
		lev.applied <- true;
		lev.lever_explanation <- player_msg;
		lev.added_cost <- int(lev.act_done.cost * added_cost_percentage);
		
		ask world {do send_message_lever(lev) ;}
		
		last_lever_amount <-lev.added_cost;
		activation_label_L1 <- "Dernier "+(last_lever_amount>=0?"prélevement":"versement")+" : "+abs(last_lever_amount)+ ' By.';
		activation_label_L2 <- "Total "+(last_lever_amount>=0?"prélevé":"versé")+" : "+string(abs(tot_lever_amont()))+' By';
		
		nb_rounds_before_activation <- threshold;
		nb_activations <- nb_activations +1;
		
		ask world {do record_leader_activity(myself.lever_type+" déclenché à ", myself.my_commune.commune_name, myself.help_lever_msg + " : "+(lev.added_cost)+"By"+"("+lev.act_done+")");}
	}
}

species lever_no_action_on_dike parent: cost_lever_if_no_associatedActionA_for_N_rounds_with_impacted_on_actionB
{
	list<action_done> listOfImpactedAction -> {my_commune.actions_install_ganivelle()};
	init
		{
			profile_name<-"retrait";
			threshold <- 2; // tours
			nb_rounds_before_activation <- threshold;
			added_cost_percentage <- -0.5 ;
			player_msg <- "Le gouvernement encourage les pratiques vertueuses de gestion intégrée des risques";
		}
		
	string info_of_next_activated_lever 
	{
		return "Dernière ganivelle -" + abs(int(activation_queue[0].act_done.cost * added_cost_percentage)) + ' By';
	}	
}


//species cost_lever_with_impact_on_existing_ganivelle parent: cost_lever // c'est un cost lever dont le déclenchement est associé à une action à définir mais dont l'impact est sur des installation de ganivelles déjà existantes 
//{
//	string box_title -> {lever_type +' ('+length(associated_actions)+')'};
//	bool should_be_activated -> {(indicator > threshold )and !empty(my_commune.actions_install_ganivelle())};
//	init
//		{
//		help_lever_msg <-"Versement à la commune à hauteur de "+int(100*added_cost_percentage)+"% du coût de Ganivelle/m";
//		}
//		
//	string info_of_next_activated_lever 
//	{
//		return "+" + abs(int(activation_queue[0].act_done.cost * added_cost_percentage)) + ' By pour la dernière construction de ganivelle';
//	}
//		
//	action check_activation_at_new_round
//	{
//		do checkActivation_andImpactOnFirstElementOf(my_commune.actions_install_ganivelle());
//	}
//}

//species cost_lever_with_impact_on_existing_ganivelle_DEJA_RENSEIGNE parent: cost_lever_with_impact_on_existing_ganivelle
//{
//	string progression_bar -> {"Depuis "+indicator+" tours / " + int(threshold) +" max"};
//	int indicator -> {round- (empty(associated_actions)? // Nb de tours depuis la dernière création de digue
//									0:
//									(associated_actions sort_by(-each.command_round))[0].command_round)}; //command_round_of_last_dike_creation
//	init
//		{
//		profile_name<-"retrait";
//		threshold <- 2; // tours
//		added_cost_percentage <- -0.5 ;
//		player_msg <- "Le gouvernement encourage les pratiques vertueuses de gestion intégrée des risques";
//		}	
//}

species lever_no_dike_creation parent: lever_no_action_on_dike
{
	init
		{
			lever_type <- "Pas Const Digue";
			help_lever_msg <-"Durant "+threshold+" tours consécutifs le joueur ne contruit pas de digue.\nVersement à la commune à hauteur de "+int(100*added_cost_percentage)+"% du coût de Ganivelle/m";
		}	
}

species lever_no_dike_raise parent: lever_no_action_on_dike
{
	init
		{
		lever_type <- "Pas réhausse Digue";
		help_lever_msg <-"Durant "+threshold+" tours consécutifs le joueur ne réhausse pas de digue.\nVersement à la commune à hauteur de "+int(100*added_cost_percentage)+"% du coût de Ganivelle/m";
		}
}

species lever_no_dike_repair parent: lever_no_action_on_dike
{
	init
		{
		lever_type <- "Pas rénove Digue";
		help_lever_msg <-"Durant "+threshold+" tours consécutifs le joueur ne rénove pas de digue.\nVersement à la commune à hauteur de "+int(100*added_cost_percentage)+"% du coût de Ganivelle/m";
		}
}

species lever_AtoN_inCoastBorderOrRiskArea parent: cost_lever
{
	string progression_bar -> {""+my_commune.count_AtoN_inCoastBorderOrRiskArea + " actions / " + int(threshold) +" max"};
	bool should_be_activated -> {indicator > threshold and !empty(my_commune.actions_densification_outCoastBorderAndRiskArea())};
	int indicator -> {my_commune.count_AtoN_inCoastBorderOrRiskArea };
	
	init
		{
		lever_type <- "Agr vers Nat ds ZL/ZI";
		profile_name<-"retrait";
		threshold <- 2;
		added_cost_percentage <- -0.5 ;
		help_lever_msg <-"Versement à la commune à hauteur de "+int(100*added_cost_percentage)+"% du coût d'une densification préalablement réalisée hors ZL et ZI";
		player_msg <- "Le gouvernement encourage les pratiques vertueuses de gestion intégrée des risques";
		}

	string info_of_next_activated_lever 
	{
		return "+" + abs(int(activation_queue[0].act_done.cost * added_cost_percentage)) + ' By sur la dernière densification hors ZL&ZI';
	}	
}

species lever_densification_outCoastBorderAndRiskArea parent: cost_lever
{
	string progression_bar -> {""+my_commune.count_densification_outCoastBorderAndRiskArea + " actions / " + int(threshold) +" max"};
	int indicator -> {my_commune.count_densification_outCoastBorderAndRiskArea };
	
	init
		{
		lever_type <- "Dens Hab hors ZI&ZL";
		profile_name<-"retrait";
		threshold <- 2;
		added_cost_percentage <- -0.25 ;
		help_lever_msg <-"Versement à la commune à hauteur de "+int(100*added_cost_percentage)+"% du coût de densification";
		player_msg <- "Le gouvernement encourage les pratiques vertueuses de gestion intégrée des risques";
		}
	
	string info_of_next_activated_lever 
	{
		return "+" + abs(int(activation_queue[0].act_done.cost * added_cost_percentage)) + ' By sur la dernière densification hors ZL&ZI';
	}			
}

species lever_expropriation parent: cost_lever
{
	string progression_bar -> {""+my_commune.count_expropriation + " expropriation / " + int(threshold) +" max"};
	int indicator -> {my_commune.count_expropriation };
	
	init
		{
		lever_type <- "Exproprie";
		profile_name<-"retrait";
		threshold <- 1;
		added_cost_percentage <- -0.25 ;
		help_lever_msg <-"Versement à la commune à hauteur de "+int(100*added_cost_percentage)+"% du coût d'expropriation";
		player_msg <- "Une aide spéciale est versée aux communes engagées dans une stratégie de recul stratégique";
		}	
		
	string info_of_next_activated_lever 
	{
		return "+" + abs(int(activation_queue[0].act_done.cost * added_cost_percentage)) + ' By sur la dernière expropriation';
	}		
}

species lever_destroy_dike parent: cost_lever
{
	float indicator -> {my_commune.length_dike_destroyed / my_commune.length_dikes_t0};
	bool should_be_activated -> {indicator > threshold and !empty(my_commune.actions_expropriation())};
	string progression_bar -> {""+my_commune.length_dike_destroyed+ " m. / "+threshold+" * "+ my_commune.length_dikes_t0+" m. à t0"};
	
	init
		{
		lever_type <- "Démantelle Digues";
		profile_name<-"retrait";
		threshold <- 0.01;
		added_cost_percentage <- -0.5 ;
		help_lever_msg <-"Versement à la commune à hauteur de "+int(100*added_cost_percentage)+"% du coût de démantellement ; si a aussi exproprié";
		player_msg <- "Une aide spéciale est versée aux communes engagées dans une stratégie de recul stratégique";	
		}
		
	string info_of_next_activated_lever 
	{
		return "+" + abs(int(activation_queue[0].act_done.cost * added_cost_percentage)) + ' By sur le dernier démantellement';
	}	
}

///////////////////////////////////////


species network_leader skills:[network]
{
	init
	{
		do connect to: SERVER with_name:GAME_LEADER;
		
		map<string, unknown> msg <-[]; 
		put ASK_INDICATORS_T0 key: LEADER_COMMAND in: msg;
		ask world {do send_message_from_leader(msg);}
		map<string, unknown> msg <-[]; //LEADER_COMMAND::RETARDER,DELAY::duree, ACTION_ID::act_dn.id];
		put ASK_NUM_ROUND key: LEADER_COMMAND in: msg;
		ask world {do send_message_from_leader(msg);}
		map<string, unknown> msg <-[]; 
		put "RETREIVE_ACTION_DONE" key: LEADER_COMMAND in: msg;
		ask world {do send_message_from_leader(msg);}
	}
	
	
	reflex wait_message
	{
		
		loop while:has_more_message()
		{
			message msg <- fetch_message();
			string m_sender <- msg.sender;
			map<string, string> m_contents <- msg.contents;
			string cmd <- m_contents[OBSERVER_MESSAGE_COMMAND];
			string data <- m_contents[OBSERVER_MESSAGE_COMMAND]; // Q à NM -> Pourquoi cette ligne ? C'est bizarre non ?
			switch(cmd)
			{
				match UPDATE_ACTION_DONE { do update_action(m_contents); }
				match NUM_ROUND
					{	round<-int(m_contents['num tour']);
						//ask world { do write_profile; }
						write "--- Tour "+round+" commence ---";
						ask all_levers {do check_activation_at_new_round();}
						ask world{do save_leader_records;}
					}
				match INDICATORS_T0
					{ //write m_contents;
						ask commune where (each.commune_name = m_contents['commune_name']) 
						{ 	length_dikes_t0 <- float (m_contents['length_dikes_t0']);
							length_dunes_t0 <- float (m_contents['length_dunes_t0']);
							count_UA_urban_t0 <- int (m_contents['count_UA_urban_t0']);
							count_UA_UandAU_inCoastBorderArea_t0 <- int (m_contents['count_UA_UandAU_inCoastBorderArea_t0']);
							count_UA_urban_infloodRiskArea_t0 <- int (m_contents['count_UA_urban_infloodRiskArea_t0']);
							count_UA_urban_dense_infloodRiskArea_t0 <- int (m_contents['count_UA_urban_dense_infloodRiskArea_t0']);
							count_UA_urban_dense_inCoastBorderArea_t0<- int (m_contents['count_UA_urban_dense_inCoastBorderArea_t0']);
							count_UA_A_t0 <- int (m_contents['count_UA_A_t0']);
							count_UA_N_t0 <- int (m_contents['count_UA_N_t0']);
							count_UA_AU_t0 <- int (m_contents['count_UA_AU_t0']);
							count_UA_U_t0 <- int (m_contents['count_UA_U_t0']);		
						}
					}
			}
			
		}	
	}
	
	action update_action(map<string,string> msg)
	{
		string m_id <- (msg at "id");
		list<action_done> act_done <- action_done where(each.id = (msg at "id"));
		//write "action correspondant à id '"+m_id+"' : " +act_done;
		
		if(act_done = nil or length(act_done) = 0)
		// Il s'agit d'une nouvelle action commandé par un joueur
		// Lors de l'arrivée d'une nouvelle action venant d'être commandé, les indicateurs sont mis à jour et les seuils de déclenchement de leviers sont testés
		{
			create action_done number:1
			{
				location <- any_location_in(polygon([{0,0}, {20,0},{20,100},{0,100},{0,0}]));
				do init_from_map(msg);
				ask world
				{
					do add_action_done_to_profile(myself,round);	
				}
				ask commune first_with (each.commune_name = commune_name) {
					do update_indicators_and_register_action_done (myself);
				}
			}
			
		}
		else
		// Il s'agit d'une mise à jour d'une action qui avait été préalablement commandé par un joueur
		{
			ask first(act_done) 
			{
				do init_from_map(msg);
			}
		}
	}
	
}



experiment lead_the_game
{
	float minimum_cycle_duration <- 0.5;
	output
	{
//		display commune_control
//		{
//			species commune aspect:base;
//			event [mouse_down] action: button_commune;
//		}
//		
//		display action_control
//		{
//			species action_button aspect:base;
//			event [mouse_down] action: button_action;
//		}
//		display alive_action_commune
//		{
//			graphics "agile" position:{0,0} 
//			{
//				draw rectangle(20#m,100#m) color:#gray at:{10#m,50#m};
//				draw "A traiter" color:#white at:{5#m,10#m} size:12#px;
//				draw rectangle(40#m,100#m) color:#yellow at:{40#m,50#m};
//				draw "Tour "+string(round) color:#black font: font("Arial", 16 , #bold) at:{35#m,3#m};
//				draw "Encours" color:#black at:{35#m,10#m};
//				draw rectangle(40#m,100#m) color:#green at:{80#m,50#m};
//				draw "Achevé" color:#white at:{75#m,10#m};
//			}
//			species action_done aspect:base;
//			event [mouse_down] action: button_action_done;
//			event mouse_move action: button_action_move;
//			
//		}
		display levers 
		{
			graphics "Tour" {
				draw ("Tour : "+round)  at:{55, 8.3} font: font("Arial", 20 , #bold) color:#black ;
			}
			species lever_create_dike aspect:base;
			species lever_AUorUi_inCoastBorderArea aspect: base;
			species lever_AUorUi_inRiskArea aspect: base;
			species lever_raise_dike aspect: base;
			species lever_repair_dike aspect: base;
			species lever_ganivelle aspect: base;
			species lever_Us_outCoastBorderOrRiskArea aspect: base;
			species lever_Us_inCoastBorderArea aspect:base;
			species lever_Us_inRiskArea aspect:base;
			species lever_inland_dike aspect: base;
			species lever_no_dike_creation aspect: base;
			species lever_no_dike_raise aspect: base;
			species lever_no_dike_repair aspect: base;
			species lever_AtoN_inCoastBorderOrRiskArea aspect: base;
			species lever_densification_outCoastBorderAndRiskArea aspect: base;
			species lever_expropriation aspect: base;
			species lever_destroy_dike aspect: base;
			
			species commune_action_button aspect: base;
			event [mouse_down] action: user_click;
			//event mouse_move action: action_move_infobulle;
			
			graphics "infobulle levier" transparency:0.4
			{
				if(explored_lever != nil and MOUSE_LOC !=nil)
				{
					geometry rec <- rectangle(20,0.7);
					//draw rec at:MOUSE_LOC color:#black;
					draw explored_lever.texte_infobulle()  at: (MOUSE_LOC /*-{9.8,0}*/) font: font("Arial", 12 , #bold) color: #red;
				}
			}
		}
	}

}