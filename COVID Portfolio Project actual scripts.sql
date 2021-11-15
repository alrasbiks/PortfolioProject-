/****** Script for Portfolio Project by Khalid Al Rasbi ******/

-- select table covid death
select *
from PortfolioProject..CovidDeaths$
where continent is not null
order by 1,2

--simple of covid death data in this project 
select location, date,total_cases,new_cases, total_deaths,population
from PortfolioProject..CovidDeaths$
order by 1,2

-- to know the precentage of death in any country f.q Oman 
select location, date,total_cases,new_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
from PortfolioProject..CovidDeaths$
where location like '%Oman%'
order by 1,2

--to Know the presentage of Covid cases in any country f.q Oman
select location, date,total_cases,population, (total_cases/population)*100 as case_percentage
from PortfolioProject..CovidDeaths$
where location like '%Oman%'
order by 1,2

--to answer which country has the highest death count per poulation up to the data date
select location, Max(Cast(total_deaths as int)) as HighestInfectionCount, Max(total_cases/population)*100 as PercentagePopulationIfected
from PortfolioProject..CovidDeaths$
where continent is not null
Group by Location
order by PercentagePopulationIfected desc

--here sort data by continent using location
select location, Max(Cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths$
where continent is null
Group by location
order by TotalDeathCount desc
--diffrent sort to show the highest death per population using the contient
select continent, Max(Cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths$
where continent is not null
Group by continent
order by TotalDeathCount desc


--show total cases and total death in the world up to the data date
select Sum(new_cases) as Total_Cases, Sum(cast(new_deaths as int)) as Total_Deaths, Sum(new_cases) / Sum(cast(new_deaths as int)) as Death__Precentage
from PortfolioProject..CovidDeaths$
where continent is not null
order by 1,2

--select vaccination table 
Select *
from PortfolioProject..CovidVaccination$

--join two table
--finding total population vs vaccinations
--needs to covert data new vaccinations from varcahr to numeric 
Select dea.continent, dea.location, vac.date, dea.population,vac.new_vaccinations
,SUM(Convert(numeric,vac.new_vaccinations)) Over (Partition by dea.location Order by dea.location, dea.Date) as RolingPeopleVaccinated
from PortfolioProject..CovidVaccination$ vac
Join PortfolioProject..CovidDeaths$ dea
	On dea.location = vac.location
	And dea.date = vac.date
where dea.continent is not null

--using CTE
with PopvsVac (continent, location, date, population, new_vaccination, RolingPeopleVaccinated)
as
(
Select dea.continent, dea.location, vac.date, dea.population,vac.new_vaccinations
,SUM(Convert(numeric,vac.new_vaccinations)) Over (Partition by dea.location Order by dea.location, dea.Date) as RolingPeopleVaccinated
from PortfolioProject..CovidVaccination$ vac
Join PortfolioProject..CovidDeaths$ dea
	On dea.location = vac.location
	And dea.date = vac.date
where dea.continent is not null
)
select *, (RolingPeopleVaccinated/population)*100 as PrecentageVaccination
From PopvsVac

--create view here to data visualizations 

Create View PrecentPoulationVaccinated as 
Select dea.continent, dea.location, vac.date, dea.population,vac.new_vaccinations
,SUM(Convert(numeric,vac.new_vaccinations)) Over (Partition by dea.location Order by dea.location, dea.Date) as RolingPeopleVaccinated
from PortfolioProject..CovidVaccination$ vac
Join PortfolioProject..CovidDeaths$ dea
	On dea.location = vac.location
	And dea.date = vac.date
where dea.continent is not null
Select *
from PrecentPoulationVaccinated

--create second view
Create View globaltobalcases as
select Sum(new_cases) as Total_Cases, Sum(cast(new_deaths as int)) as Total_Deaths, Sum(new_cases) / Sum(cast(new_deaths as int)) as Death__Precentage
from PortfolioProject..CovidDeaths$
where continent is not null
Select * 
from globaltobalcases

--create thrid view 
Create View hightesdeathsrate as
select continent, Max(Cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths$
where continent is not null
Group by continent
Select *
from hightesdeathsrate