# 🧠 Boston Process Approach (BPA) Errors Data Curation 

Curated a comprehensive dataset of categorized errors made by the participants on Framingham Heart Study’s Neuropsychological Exams (following the BPA guidelines).  Collaborated with researchers to define error types, their derivation algorithms, as well as cleaning and curation steps to process raw datasets.  


---

## 📌 Objectives

- Curated a centralized dataset of BPA errors from raw neuropsychological assessments data
- Generate derived error variables suitable for statistical modeling
- Coded dynamic SAS program capable of updating the output dataset with new entries
- Documented the final dataset and the coding process through coding manual and programming protocol


---
## 🔧 Data Cleaning & Feature Engineering
---

## 🛠️ Tools Used

- **SAS 9.4**
  - `PROC SQL`, `DATA step`, `multi-dimensional ARRAY`, `MERGE`, `DO loops`, `functions`, `logical operators`
- Windows SAS environments
- Excel

---

## 🔢 Example Output Variable 

```sas
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

	⋮
 
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

	⋮ 

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

⋮ 

data namesfirst;
	set AnalyticErrorIndexes;
	rename
	⋮ 
	attention_14 = DSB_LN
	⋮ 
	;
run;

data bpa22mod.QualErrorNoCollapse;
	set namesfirst;
	label
	⋮ 
	DSB_LN = "Digit Span: Backward— Longest digit span with all correct numbers, regardless of sequence."
	⋮ 
	;
run;
```
[👨‍💻 View Code Snippet](codes/CodeSnippet.sas)

---

## 🔗 Related links

- [🌐FHS-BAP Errors Data Webpage with Coding Manual](https://fhsbap.bu.edu/docs_main/qualitative_errors_in_neuropsychological_exams)
- [💻Programming Protocol](https://www.bu.edu/fhs/share/protocols/vr_npqerror_2021_a_1468s_protocol1.pdf)
- 🎓Published Articles
	- [Gurnani et al., 2023](https://doi.org/10.1093/arclin/acad067.009)
	- [Ferretti et al., 2024](https://doi.org/10.1002/alz.13500)
