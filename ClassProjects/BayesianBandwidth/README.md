# 🕵🏽‍♀️ Estimating Distribution of Points Scored in the NBA via Bayesian and Kernel Methods.

## 📃 Table of Contents

- [🕵🏽‍♀️ Estimating Distribution of Points Scored in the NBA via Bayesian and Kernel Methods.](#️-estimating-distribution-of-points-scored-in-the-nba-via-bayesian-and-kernel-methods)
  - [📃 Table of Contents](#-table-of-contents)
  - [🚀 Overview](#-overview)
  - [💻 Data](#-data)
  - [📑 Methods](#-methods)
  - [📊 Results](#-results)
  - [💬 Discussion](#-discussion)
  - [🔧 Tools](#-tools)
  - [🔗 Links](#-links)
  - [📚 References](#-references)


## 🚀 Overview

This class project is originally the final project of my graduate course (MA578: Bayesian Statistics) at Boston University.  My goal was to model complex distributions of NBA points scored using Bayesian and Kernel methods, followed by an assessment of the results.  I have since then updated my work by creating a Shiny dashboard that allows flexibility in choosing hyperparameters and timeframes, resulting in a clearer picture of the results.

## 💻 Data

This analytics project uses publicly available NBA dataset `team_season.txt` containing season-level team performances from the league's inception to 2004 from the website https://www.basketball-reference.com/.  Each row represents a team in a specific season, and their key information such as wins, points scored, rebounds, and other metrics.  The focus of this project is on the **Points Per Game (PPG)** metric, calculated as the total points scored in the season `o_pts` divided by the number of games played `won + lost`.

## 📑 Methods

My main objective is estimating the distribution of **PPG** of each team in each season for a given timeframe.  Traditional parametric methods for the estimation requires making assumptions on the shape of the distribution, which may not hold in practice.  For example, assuming a normal distribution would not hold when examining the first 2 NBA decades `1946 - 1965` (**Figure 1**), as the distribution is clearly bimodal.

**Figure 1.** Histogram of **PPG** from 1946 - 1965. [^1]

![1946-1965 Histogram](Visuals/Figure1-1946_1965_Histogram.png)

[^1]: Screenshot is from my custom [Shiny Dashboard](https://catalyzeanalytics.shinyapps.io/Bayesian-KDE-ab-Slider/) made for this project, you can change the parameters and watch the output change.

Instead, I used a nonparametric density estimation, which fits a smooth curve based solely on the data.  My method of choice is the well-known Kernel Density Estimation (KDE), which fits a Kernel function using the data within a neighborhood of $x$.

That is, we estimate $f(x)$, the true distribution of $x$ with:

![f_hat](https://latex.codecogs.com/png.image?\bg_white\dpi{120}\hat{f}_h(x)=\frac{1}{nh}\sum_{i=1}^nK\left(\frac{X_i-x}{h}\right))

The KDE method is heavily influenced by the choice of the bandwidth $h$: too large and the estimate misses important features and creates bias, yet if it's too small the curve overfits to the noise and makes a poor estimate.  Many authors in literature have contrived methods for selecting an appropriate $h$, this project follows a Bayesian approach as described in (Gangopadhyay, 2002)[^[I]^](#ref1). 

Where $\vec{X} = (X_1, X_2, \dots, X_n)$




## 📊 Results

## 💬 Discussion

## 🔧 Tools
![R](https://img.shields.io/badge/R-276DC3?style=flat&logo=r&logoColor=white)
![RStudio](https://img.shields.io/badge/RStudio-276DC3?style=flat&logo=r&logoColor=white)
![Shiny](https://tinyurl.com/ShinyShields)
![Visual Studio Code](https://custom-icon-badges.demolab.com/badge/Visual%20Studio%20Code-0078d7.svg?logo=vsc&logoColor=white)
![LaTeX](https://img.shields.io/badge/LaTeX-008080?style=flat&logo=latex&logoColor=white)


## 🔗 Links
[Shiny App: Bayesian KDE Slider](https://catalyzeanalytics.shinyapps.io/Bayesian-KDE-ab-Slider/)

## 📚 References
<a name="ref1"></a>
[I] [Gangopadhyay, A., & Cheung, K. (2002). Bayesian approach to the choice of smoothing parameter in kernel density estimation. *Journal of nonparametric statistics*, 14(6), 655-664.](https://www.tandfonline.com/doi/abs/10.1080/10485250215320)
