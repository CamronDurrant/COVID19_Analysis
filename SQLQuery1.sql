SELECT *
FROM PortfolioProject..['covid deaths$']
WHERE continent IS NOT NULL
ORDER BY 3,4

--SELECT *
--FROM PortfolioProject..['covid vaccintiaons$']
--ORDER BY 3,4

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..['covid deaths$']
ORDER BY 1,2


--Solving how many deaths (in percentage) came out of total covid cases by dividing total_deaths with total_cases


SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortfolioProject..['covid deaths$']
WHERE Location LIKE '%Jamaica%'
AND continent IS NOT NULL
ORDER BY 1,2


--Taking a more deep dive into how total cases affected total population.


SELECT Location, date, population, total_cases, (total_cases/population)*100 AS PopulationAffectedPercentage
FROM PortfolioProject..['covid deaths$']
--WHERE Location LIKE '%Jamaica%'
ORDER BY 1,2


--understanding the countries with the highest point of infection relating to the population.


SELECT Location, population, MAX(total_cases) AS highestInfectionCount, MAX((total_cases/population))*100 AS PopulationAffectedPercentage
FROM PortfolioProject..['covid deaths$']
GROUP BY population,location
--WHERE Location LIKE '%Jamaica%'
ORDER BY PopulationAffectedPercentage DESC


--Calculating the continents with the max death count per population


SELECT continent, MAX(CAST(total_deaths AS INT)) AS TotalDeceasedCount
FROM PortfolioProject..['covid deaths$']
WHERE continent IS NOT NULL
GROUP BY continent
--WHERE Location LIKE '%Jamaica%'
ORDER BY TotalDeceasedCount DESC


--WORLDWIDE STATISTICS


SELECT SUM(new_cases) AS TotalCases, SUM(CAST(new_deaths AS INT)) AS TotalDeaths, SUM(CAST(new_deaths AS INT))/SUM(New_Cases)*100 AS DeathPercentage
FROM PortfolioProject..['covid deaths$']
--WHERE Location LIKE '%Jamaica%'
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1,2

--TOTAL POPULATION AND VACCINATIONS

WITH PopANDVac (Continent, Location, Date, Poplulation, New_Vaccinations, PeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(INT,vac.new_vaccinations)) OVER (Partition BY dea.Location ORDER BY dea.location,
dea.date) AS PeopleVaccinated
FROM ['covid deaths$'] dea
JOIN PortfolioProject..['covid vaccintiaons$'] vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3
)
SELECT *, (PeopleVaccinated/Poplulation)*100
FROM PopANDVac
