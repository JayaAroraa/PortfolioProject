/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/

Select * 
from PortfolioProject..CovidDeaths
where continent is not null
order by 3, 4
	

-- Select Data to be used

Select Location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
where continent is not null
order by 1, 2
	

-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in our country
	
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location like 'india'
and continent is not null
order by 1, 2
	

-- Total Cases vs Population
-- Shows what percentage of population infected with Covid
	
Select Location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
--where location like 'india'
order by 1, 2
	

-- Countries with Highest Infection Rate compared to Population
	
Select Location, population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
--where location like 'india'
group by Location, population
order by PercentPopulationInfected desc
	

-- Countries with Highest Death Count per Population
	
Select Location, Max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
--where location like 'india'
Where continent is not null
Group by Location
Order by TotalDeathCount desc


-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null 
Group by continent
order by TotalDeathCount desc
	

-- GLOBAL NUMBERS
	
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
--where location like 'india'
Where continent is not null
--Group by date
Order by 1, 2

	
-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine
	
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccianted
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	on dea.location=vac.location
	and dea.date=vac.date
	where dea.continent is not null
	order by 2, 3

-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, date, Population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location,
	dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	on dea.location=vac.location
	and dea.date=vac.date
	where dea.continent is not null
	--order by 2, 3
	)
        Select *, (RollingPeopleVaccinated/population)*100
	from Popvsvac


-- Using Temp Table to perform Calculation on Partition By in previous query
	
Drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated 
(
Continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location,
dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	on dea.location=vac.location
	and dea.date=vac.date
--where dea.continent is not null
--order by 2, 3

Select *, (RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated


-- Creating View to store data for later visualizations
	
Create view PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location,
dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null


Select * from PercentPopulationVaccinated
	
