Select * 
from PortfolioProject..CovidDeaths
where continent is not null
order by 3, 4

--Select * 
--from PortfolioProject..CovidVaccinations
--order by 3, 4

Select Location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
where continent is not null
order by 1, 2

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location like 'india'
and continent is not null
order by 1, 2

Select Location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
--where location like 'india'
order by 1, 2


Select Location, population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
--where location like 'india'
group by Location, population
order by PercentPopulationInfected desc

Select continent, Max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
--where location like 'india'
Where continent is not null
Group by continent
Order by TotalDeathCount desc

Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
--where location like 'india'
Where continent is not null
Group by date
Order by 1, 2


Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
--where location like 'india'
Where continent is not null
--Group by date
Order by 1, 2

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccianted
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	on dea.location=vac.location
	and dea.date=vac.date
	where dea.continent is not null
	order by 2, 3

	--USE CTE

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


	--Temp Table
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
	--order by 2,3 

	Select * from PercentPopulationVaccinated
	