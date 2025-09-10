-- to explore the data and find trends or patterns or anything interesting like outliers

-- normally when you start the EDA process you have some idea of what you're looking for

-- with this info we are just going to look around and see what we find!

use world_layoff;
select * from layoffs_staging;

select MAX(total_laid_off)
from layoffs_staging;

-- Looking at Percentage to see how big these layoffs were

select MAX(percentage_laid_off),MIN(percentage_laid_off)
from layoffs_staging
where percentage_laid_off is NOT NULL;

-- Which companies had 1 which is basically 100 percent of they company laid off
select * from layoffs_staging
where percentage_laid_off = 1;
-- these are mostly startups it looks like who all went out of business during this time

-- if we order by funcs_raised_millions we can see how big some of these companies were
select * from layoffs_staging
where percentage_laid_off = 1
order by funds_raised_millions DESC;
-- Britishvolt raised 2400 millions and went out off business

-- Companies with the biggest single Layoff

select company,total_laid_off
from layoffs_staging
order by total_laid_off desc
limit 5;
-- that just on single day

-- Companies with the most Total Layoffs
select company,SUM(total_laid_off)
from layoffs_staging
group by company
order by 2 desc
limit 10;

-- by location
select location,SUM(total_laid_off)
from layoffs_staging
group by location
order by 2 desc
limit 10;

-- this it total in the past 3 years or in the dataset

select country,SUM(total_laid_off)
from layoffs_staging
group by country
order by 2 desc;

select YEAR(date),SUM(total_laid_off)
from layoffs_staging
group by YEAR(date)
order by 1 desc;

-- by industry
select industry,SUM(total_laid_off)
from layoffs_staging
group by industry
order by 2 desc;

select stage,SUM(total_laid_off)
from layoffs_staging
group by stage
order by 2 desc;

-- Earlier we looked at Companies with the most Layoffs. Now let's look at that per year. 

WITH company_year AS(
select company, YEAR(date) as years,SUM(total_laid_off) AS sum_total
from layoffs_staging
GROUP BY company,years),

Company_Rank AS(
select company,years,sum_total,dense_rank() over(partition by years order by sum_total DESC) AS Ranking
from company_year
)

select company,years,sum_total,Ranking
from Company_Rank
where Ranking <= 3 AND years is NOT NULL
-- where years is NOT NULL
order by years DESC,sum_total DESC;

select * from layoffs_staging limit 5;


SELECT SUBSTRING('2022-11-17',6,10);

-- Rolling Total of Layoffs Per Month

select SUBSTRING(date,6,10) as dates,SUM(total_laid_off) as total_laid_off
from layoffs_staging
where date is not null
group by dates
order by dates;

WITH date_cte as(
select SUBSTRING(date,6,10) as dates,SUM(total_laid_off) as total_laid_off
from layoffs_staging
where date is not null
group by dates
order by dates
)
select dates, SUM(total_laid_off) OVER(ORDER BY dates) as rolling_total_layoffs
from date_cte
order by dates;











