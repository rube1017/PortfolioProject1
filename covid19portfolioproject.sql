/*

Covid 19 Data Exploration 
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

select * from coviddeaths
where continent is not null
    
--select * from covidvaccination


*/
-- selecting the data needed

select location,date,total_cases,new_cases,total_deaths,population
from coviddeaths
where continent is not null
order by 1,2

-- Looking at Total Cases vs Total Death 
-- Shows the likelihood of Death if covid 19 is contracted in India(By using the like operator)

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as Death_Rate
from coviddeaths
where location like 'i%a' and continent is not null
order by 1,2

--From the above query we can see a likelihood of 3.38 in India if covid is contracted on'11th november 2021'

--Looking at Total Cases vs Population
--Shows the percentage of Population of India that got Covid-19


select location,date,total_cases,population,(total_cases/population)*100 as Infection_Rate 
from coviddeaths
where location like 'i%a' and continent is not null
order by 1,2



--Checking for Country with the Highest Infection_rate 


select location,max(total_cases) as Highestcasescount,population,max(total_cases/population)*100 as Infection_Rate 
from coviddeaths
where continent is not null
group by location,population
order by Infection_Rate  desc

--With the help of above query we were able to find out that 'Montenegro' is the country with the most infection_rate 


--Showing Countries with the Highest Death rate per Population

select location,MAX(CAST(total_deaths as int)) as Totaldeathcount,population ,MAX(total_deaths/population) as Mortality_Rate
from coviddeaths
where continent is not null
group by location,population
order by Totaldeathcount desc

--The above query provides the country with highest mortality rate

-- Breaking down by Continents

-- Showing Continets with highest death count per population
 
select continent,MAX(CAST(total_deaths as int)) as Totaldeathcount
from coviddeaths
where continent is not null
group by continent
order by Totaldeathcount desc

-- GLOBAL NUMBERS

-- we have used CAST() as the data present in new death is of charcter type and we cant perform aggregate functions on them

select date,SUM(new_cases) as total_cases,SUM(Cast(new_deaths as int)) as total_deaths,SUM(Cast(new_deaths as int))/SUM(new_cases)*100 as death_percentage
from [dbo].[coviddeaths]
-- location like 'i%a'
where continent is not null
Group by date
order by 1,2

-- To check the overall cases and death Globally

select SUM(new_cases) as total_cases,SUM(Cast(new_deaths as int)) as total_deaths,SUM(Cast(new_deaths as int))/SUM(new_cases)*100 as death_percentage
from [dbo].[coviddeaths]
-- location like 'i%a'
where continent is not null
--Group by date
order by 1,2


--LOOKING AT TOTAL POPULATION VS VACCINATIONS


select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations ,
SUM(CAST(vac.new_vaccinations as bigint )) over (partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
from coviddeaths dea
join covidvaccination vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2,3


-- To see the percentage of people vaccinated we are using a CTE

with popvsvac (continent,location,date,population,new_vaccinations,rollingpeoplevaccinated)
as 
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations ,
SUM(CAST(vac.new_vaccinations as bigint )) over (partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
from coviddeaths dea
join covidvaccination vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
)
Select *, max(RollingPeopleVaccinated/Population)*100 as percentagevaccinated
From PopvsVac

/*
To check the total percentage vaccinated upto 4th november 2021 use the below code

Select location, max(RollingPeopleVaccinated/Population)*100 as percentagevaccinated
From PopvsVac
group by location

*/


--Creating view to store data for later visualization


create view
percentagepopulationvaccinated as

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations ,
SUM(CAST(vac.new_vaccinations as bigint )) over (partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
from coviddeaths dea
join covidvaccination vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
