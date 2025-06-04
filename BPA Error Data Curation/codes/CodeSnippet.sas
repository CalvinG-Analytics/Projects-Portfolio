
*Attention;

*NOTE: Longest Correct Sequence/Numbers requires all previous Sequence/Numbers to be Correct as well;

data attention;
	set alldata;
	array att attention_1 - attention_14;
	array dsf{14} ds07_02-ds07_15 ;
	array dsb{14} ds08_02-ds08_15 ;
	array bd{6} bl35_07 bl35_13 bl36_06 bl36_12 bl37_06 bl37_12;

	array nds_f{7} nds07_1 - nds07_7;
	array nds_f2{7} nds07_2_1 - nds07_2_7;
	array nds_b{7} nds08_1 - nds08_7;
	array nds_b2{7} nds08_2_1 - nds08_2_7;

	nm1 = 0; nm2 = 0; nm12 = 0;

	do i = 1 to 14;
		att{i} = 0;
	end;

	do i = 1 to 14;
		nm1 = nm1 + (dsf{i} not in (. , 8, 88));
		nm2 = nm2 + (dsb{i} not in (. , 8, 88));
		attention_1 = attention_1 + (dsf{i} = 1);
		attention_2 = attention_2 + (dsb{i} = 1);
	end;

	?
 
	*attention_14;
	k = 0; l = 2; y = .;
	do i = 1 to 13 by 2;
		j = (i + 1) / 2;
		if dsb{i} in (1,2) or dsb{i+1} in (1,2) then nds_b2{j} = 1;
		else if dsb{i} in (., 8, 88) and dsb{i+1} in (., 8, 88) then nds_b2{j} = .;
		else nds_b2{j} = 0;
	end;

	do until (k = 1);
		if nds_b2{l} = 1 then l = l + 1;
		else k = 1;
		if l = 8 then k = 1;
	end;

	if l > 2 then y = l;

	if y = . then do;
		k = 0; l = 3; 
		do until (k = 1);
			if nds_b{l} = 1 then l = l + 1;
			else k = 1;
			if l = 8 then k = 1;
		end;

		if l > 3 then y = l;
	end;

	if y = . then do;
		k = 0; l = 4; 
		do until (k = 1);
			if nds_b2{l} = 1 then l = l + 1;
			else k = 1;
			if l = 8 then k = 1;
		end;

		if l > 4 then y = l;
	end;

	if nds_b2{1} = 0 and nds_b2{2} in (.,0) then y = 0;
	else if nds_b2{1} = 1 and nds_b2{2} in (.,0) then y = 2;
	else if nds_b2{1} = . and nds_b2{2} in (0) then y = 1;
	else if nds_b2{1} = . and nds_b2{2} in (.) and nds_b2{3} in (0) then y = 1;

	attention_14 = y;

	? 

	if nm2 = 0 then do;
		attention_2 = .;
		attention_4 = .;
		attention_14 = .;
	end;


	if ds08_01 = 1 then do;
		if att{2} = . then att{2} = 0;
		if att{4} = . then att{4} = 0;
		if att{14} = . then att{14} = 0;
	end;

	if bl35_01 = 1 and att{12} = . then att{12} = 0;

	keep attention_1 - attention_14;
run;

? 

data namesfirst;
	set AnalyticErrorIndexes;
	rename
	? 
	attention_14 = DSB_LN
	? 
	;
run;

data bpa22mod.QualErrorNoCollapse;
	set namesfirst;
	label
	? 
	DSB_LN = "Digit Span: Backward— Longest digit span with all correct numbers, regardless of sequence."
	? 
	;
run;
