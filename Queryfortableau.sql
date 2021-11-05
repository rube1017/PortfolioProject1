/*
Link For Tableau Dashboard - https://public.tableau.com/app/profile/reuben1088/viz/Covid-19Dashboard_16360902556660/Dashboard1

Queries used for Tableau Project
*/



-- 1. Text Chart

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null 
--Group By date
order by 1,2



-- 2. Bar Graph

-- We take these out as they are not inluded in the above queries and want to stay consistent


Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is null 
and location not in ('World', 'European Union', 'International','Upper middle income','High income','Lower middle income','Low income')
Group by location
order by TotalDeathCount desc


-- 3. Map

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Group by Location, Population
order by PercentPopulationInfected desc


-- 4.Time Series Graph


Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Group by Location, Population, date
order by PercentPopulationInfected desc


--5 Pie chart

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is null 
and location  in ('Upper middle income','High income','Lower middle income','Low income')
Group by location
order by TotalDeathCount desc
