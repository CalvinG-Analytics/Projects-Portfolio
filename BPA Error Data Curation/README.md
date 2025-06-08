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

This section demonstrates a sample derived variable (DSB_LN), the step-by-step approach to its derivation and documentation, as well as a simple analysis using the derived variable. 

### Motivation



[👨‍💻 View Code Snippet](codes/CodeSnippet.sas)

### Paired t-test result

| μ<sub>LN</sub>   | μ<sub>Long</sub>   | μ<sub>diff</sub>    | Std Dev | t-stat  | p-value |
|------|------|-------|---------|----|---------|
| 5.41 | 4.83 | 0.576 | 0.866   | 70 | <.0001  |

---

## 🔗 Related links

- [🌐FHS-BAP Errors Data Webpage with Coding Manual](https://fhsbap.bu.edu/docs_main/qualitative_errors_in_neuropsychological_exams)
- [💻Programming Protocol](https://www.bu.edu/fhs/share/protocols/vr_npqerror_2021_a_1468s_protocol1.pdf)
- 🎓Published Articles
	- [Gurnani et al., 2023](https://doi.org/10.1093/arclin/acad067.009)
	- [Ferretti et al., 2024](https://doi.org/10.1002/alz.13500)
