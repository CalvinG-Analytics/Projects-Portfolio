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

My main objective is estimating the distribution of **PPG** of each team in each season for a given timeframe.  Traditional parametric methods for the estimation requires making assumptions on the shape of the distribution, which may not hold in practice.  For example, assuming a Gaussian distribution would not hold when examining the first 2 NBA decades `1946 - 1965` (**Figure 1**), as the distribution is clearly bimodal.

**Figure 1.** Histogram of **PPG** from 1946 - 1965. [^1]

![1946-1965 Histogram](Visuals/Figure1-1946_1965_Histogram.png)

[^1]: Screenshot is from my custom [Shiny Dashboard](https://catalyzeanalytics.shinyapps.io/Bayesian-KDE-ab-Slider/) made for this project, you can change the parameters and watch the output change.

Instead, I used a nonparametric density estimation, which fits a smooth curve based solely on the data.  My method of choice is the well-known Kernel Density Estimation (KDE), which fits a Kernel function using the data within a neighborhood of $x$.

That is, we estimate $f(x)$, the true distribution of $x$ with:

$$
\hat{f}(x | h, \vec{X}) = \frac{1}{n h} \sum_{i=1}^{n} K\left( \frac{x - X_i}{h} \right)^2
$$

Where $\vec{X} = (X_1, X_2, \dots, X_n)$

The KDE method is heavily influenced by the choice of the bandwidth $h$: too large and the estimate misses important features and creates bias, yet if it's too small the curve overfits to the noise and makes a poor estimate.  Many authors in literature have contrived methods for selecting an appropriate $h$, this project follows a Bayesian approach as described in (Gangopadhyay, 2002)[<sup>[I]</sup>](#ref1). 

The Bayesian approach uses Bayes' Rule to construct a posterior distribution based on a prior distribution and the likelihood function of observed data.

**The Bayes Rule**

$P(A|B) = \frac{P(B|A)  P(A)}{P(B)}$

**Posterior Distribution Formula**

$\pi(h|x,\vec{X}) = \frac{L(\vec{X} | h, x)  \pi(h)}{\int{L(\vec{X} | h, x ) \pi(h) dh}}$


If we use a **Gaussian Kernel** in the KDE

$K(u) = \frac{1}{\sqrt{2\pi}} \exp({\frac{-u^2}{2}})$

The resulting KDE resembles a Gaussian likelihood centered at $x$:

$$
\hat{f}(x | h, \vec{X}) = L(\vec{X} | h, x) = \frac{1}{\sqrt{2\pi} n h} \sum_{i=1}^{n} \exp\left( -\frac{1}{2} \left( \frac{x - X_i}{h} \right)^2 \right)
$$

The bandwidth $h$ acts as the standard deviation parameter of a Gaussian distribution, therefore it has the Inverse-Gamma conjugate prior: $\pi(h) \sim IG(\alpha, \beta)$.  As such, the estimated posterior distribution of $h$ has a closed-form solution:

$$
\hat{\pi}(h \mid x, \vec{X}) =
\frac{
\sum_{l=1}^n ( \frac{1}{h^{2\alpha+2}} ) \exp \{ -\frac{1}{h^2} ( \frac{(X_i - x)^2}{2} + \frac{1}{\beta} ) \}
}{
\sum_{l=1}^n ( \frac{\Gamma(\alpha + 1/2)}{2} )
( \frac{(X_i - x)^2}{2} + \frac{1}{\beta} )^{-\alpha - 1/2}
}
$$

<!-- $$
\hat{\pi}\left(h \mid x, \vec{X}\right)=\frac{\sum_{l=1}^n\left(1 / h^{2 \alpha+2}\right) \exp \left\{-\left(1 / h^2\right)\left(\left(X_i-x\right)^2 / 2+1 / \beta\right)\right\}}{\sum_{l=1}^n(\Gamma(\alpha+1 / 2) / 2)\left\{\left(X_i-x\right)^2 / 2+1 / \beta\right\}^{-\alpha-1 / 2}}
$$ -->

Hence. the best bandwidth $h^*$ is the posterior mean:

$$
h^*(x) = E\left[h \mid x, \vec{X}\right]= \frac{\Gamma(\alpha)}{\sqrt{2 \beta} \Gamma(\alpha+1 / 2)} \frac{\sum_{i=1}^n\left\{1 /\left(\beta\left(X_i-x\right)^2+2\right)\right\}^x}{\sum_{i=1}^n\left\{1 /\left(\beta\left(X_i-x\right)^2+2\right)\right\}^{\alpha+1 / 2}}
$$

The derivation steps are written out in (Gangopadhyay, 2002)[<sup>[I]</sup>](#ref1). 

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
