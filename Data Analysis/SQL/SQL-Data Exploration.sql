/*
Case 1: Verify that the query selects all data from the CovidDeaths table where continent is not null and orders it by the third and fourth columns.
- **Description**: Selects all data from the `CovidDeaths` table where continent is not null and orders it by the third and fourth columns.
*/

SELECT *
FROM PortfolioProjects.CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 3, 4;

/*
Case 2: Verify that the query selects specific columns from the CovidDeaths table where continent is not null and orders it by the first and second columns.
- **Description**: Selects specific columns from the `CovidDeaths` table where continent is not null and orders it by the first and second columns.
*/

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProjects.CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1, 2;

/*
Case 3: Verify that the query calculates the death percentage by dividing total_deaths by total_cases and multiplying by 100, and selects Location, date, total_cases, total_deaths, and the calculated DeathPercentage for locations containing 'states' in their name, where continent is not null, and orders it by the first and second columns.
- **Description**: Calculates the death percentage by dividing total_deaths by total_cases and multiplying by 100, and selects specific columns for locations containing 'states' in their name, where continent is not null, and orders it by the first and second columns.
*/

SELECT Location, date, total_cases, total_deaths, (total_deaths / total_cases) * 100 AS DeathPercentage
FROM PortfolioProjects.CovidDeaths
WHERE location LIKE '%states%' AND continent IS NOT NULL
ORDER BY 1, 2;

/*
Case 4: Verify that the query calculates the percentage of population infected with Covid by dividing total_cases by population and multiplying by 100, and selects Location, date, Population, total_cases, and the calculated PercentPopulationInfected, and orders it by the first and second columns.
- **Description**: Calculates the percentage of population infected with Covid by dividing total_cases by population and multiplying by 100, and selects specific columns, and orders it by the first and second columns.
*/

SELECT Location, date, Population, total_cases, (total_cases / population) * 100 AS PercentPopulationInfected
FROM PortfolioProjects.CovidDeaths
ORDER BY 1, 2;

/*
Case 5: Verify that the query selects Location, Population, the maximum total_cases as HighestInfectionCount, and the maximum percentage of population infected as PercentPopulationInfected, groups it by Location and Population, and orders it by PercentPopulationInfected in descending order.
- **Description**: Selects Location, Population, the maximum total_cases as HighestInfectionCount, and the maximum percentage of population infected as PercentPopulationInfected, groups it by Location and Population, and orders it by PercentPopulationInfected in descending order.
*/

SELECT Location, Population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases / population)) * 100 AS PercentPopulationInfected
FROM PortfolioProjects.CovidDeaths
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC;

/*
Case 6: Verify that the query selects Location, the maximum total_deaths as TotalDeathCount, groups it by Location, and orders it by TotalDeathCount in descending order.
- **Description**: Selects Location, the maximum total_deaths as TotalDeathCount, groups it by Location, and orders it by TotalDeathCount in descending order.
*/

SELECT Location, MAX(CAST(Total_deaths AS INT)) AS TotalDeathCount
FROM PortfolioProjects.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY Location
ORDER BY TotalDeathCount DESC;

/*
Case 7: Verify that the query selects continent, the maximum total_deaths as TotalDeathCount, groups it by continent, and orders it by TotalDeathCount in descending order.
- **Description**: Selects continent, the maximum total_deaths as TotalDeathCount, groups it by continent, and orders it by TotalDeathCount in descending order.
*/

SELECT continent, MAX(CAST(Total_deaths AS INT)) AS TotalDeathCount
FROM PortfolioProjects.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC;

/*
Case 8: Verify that the query selects the sum of new_cases as total_cases, the sum of new_deaths as total_deaths, and the death percentage by dividing the sum of new_deaths by the sum of new_cases and multiplying by 100, where continent is not null, and orders it by the first and second columns.
- **Description**: Selects the sum of new_cases as total_cases, the sum of new_deaths as total_deaths, and the death percentage, where continent is not null, and orders it by the first and second columns.
*/

SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS INT)) AS total_deaths, SUM(CAST(new_deaths AS INT)) / SUM(New_Cases) * 100 AS DeathPercentage
FROM PortfolioProjects.CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1, 2;

/*
Case 9: Verify that the query calculates the percentage of population that has received at least one Covid vaccine by dividing RollingPeopleVaccinated by population and multiplying by 100, and selects dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, and the calculated RollingPeopleVaccinated, and orders it by the second and third columns.
- **Description**: Calculates the percentage of population that has received at least one Covid vaccine, selects specific columns, and orders it by the second and third columns.
*/

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated
FROM PortfolioProjects.CovidDeaths dea
JOIN PortfolioProjects.CovidVaccinations vac ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2, 3;

/*
Case 10: Verify that the query calculates the percentage of population that has received at least one Covid vaccine by dividing RollingPeopleVaccinated by population and multiplying by 100, using a CTE named PopvsVac, and selects all columns from the PopvsVac CTE, and the calculated percentage of population vaccinated, and orders it by all columns.
- **Description**: Calculates the percentage of population that has received at least one Covid vaccine using a Common Table Expression (CTE), selects all columns from the CTE, and orders it by all columns.
*/

WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
AS
(
    SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated
    FROM PortfolioProjects.CovidDeaths dea
    JOIN PortfolioProjects.CovidVaccinations vac ON dea.location = vac.location AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL
)
SELECT *, (RollingPeopleVaccinated / Population) * 100
FROM PopvsVac;

/*
Case 11: Verify that the query calculates the percentage of population that has received at least one Covid vaccine by dividing RollingPeopleVaccinated by population and multiplying by 100, using a temporary table named #PercentPopulationVaccinated, inserts data into the #PercentPopulationVaccinated temp table, and selects all columns from the temp table, and the calculated percentage of population vaccinated, and orders it by all columns.
- **Description**: Calculates the percentage of population that has received at least one Covid vaccine using a temporary table, inserts data into the temporary table, and selects all columns from the temporary table, and orders it by all columns.
*/

DROP TABLE IF EXISTS #PercentPopulationVaccinated;
CREATE TABLE #PercentPopulationVaccinated
(
    Continent NVARCHAR(255),
    Location NVARCHAR(255),
    Date DATETIME,
    Population NUMERIC,
    New_vaccinations NUMERIC,
    RollingPeopleVaccinated NUMERIC
);

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated
FROM PortfolioProjects.CovidDeaths dea
JOIN PortfolioProjects.CovidVaccinations vac ON dea.location = vac.location AND dea.date = vac.date;

SELECT *, (RollingPeopleVaccinated / Population) * 100
FROM #PercentPopulationVaccinated;

/*
Case 12: Verify that the view named PercentPopulationVaccinated is created to store the data from the previous query.
- **Description**: Creates a view named PercentPopulationVaccinated to store the data from a previous query.
*/

CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated
FROM PortfolioProject.CovidDeaths dea
JOIN PortfolioProjects.CovidVaccinations vac ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;

/* Case 13:
- **Description**: Selects the top 10 countries with the highest total deaths from Covid, along with their respective total deaths, and orders them by total deaths in descending order.
*/

SELECT TOP 10 Location, Total_deaths
FROM PortfolioProjects.CovidDeaths
WHERE continent IS NOT NULL
ORDER BY Total_deaths DESC;


/* Case 14:
- **Description**: Calculates the average number of new cases per day for each country, selects the country name and the average number of new cases, and orders them by the average number of new cases in descending order.
*/

SELECT Location, AVG(New_cases) AS AverageNewCasesPerDay
FROM PortfolioProjects.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY Location
ORDER BY AverageNewCasesPerDay DESC;


/* Case 15:
- **Description**: Selects the total number of deaths and the total population for each continent, calculates the death rate per 100,000 people, and orders the results by death rate in descending order.
*/

SELECT continent, SUM(CAST(Total_deaths AS INT)) AS TotalDeaths, SUM(Population) AS TotalPopulation,
       (SUM(CAST(Total_deaths AS INT)) / SUM(Population)) * 100000 AS DeathRatePer100000
FROM PortfolioProjects.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY DeathRatePer100000 DESC;


/* Case 16:
- **Description**: Selects the dates with the highest number of new cases globally, along with the total number of new cases reported on those dates.*/
*/

SELECT Date, SUM(New_cases) AS TotalNewCases
FROM PortfolioProjects.CovidDeaths
GROUP BY Date
ORDER BY TotalNewCases DESC;


/* Case 17:
- **Description**: Calculates the percentage change in the number of deaths compared to the previous day for each country, selects the country name, date, and percentage change in deaths, and orders them by percentage change in descending order.
*/

SELECT Location, Date, 
       (CAST(Total_deaths AS FLOAT) - LAG(CAST(Total_deaths AS FLOAT), 1, 0) OVER(PARTITION BY Location ORDER BY Date)) / 
       LAG(CAST(Total_deaths AS FLOAT), 1, 0) OVER(PARTITION BY Location ORDER BY Date) * 100 AS PercentChangeInDeaths
FROM PortfolioProjects.CovidDeaths
WHERE continent IS NOT NULL
ORDER BY PercentChangeInDeaths DESC;


/* Case 18:
- **Description**: Selects the countries where the number of new cases has been decreasing continuously for at least 7 days, along with the dates and the number of days the trend has been observed.
*/

WITH DecreasingTrend AS (
    SELECT Location, Date, 
           ROW_NUMBER() OVER (PARTITION BY Location ORDER BY Date) - 
           ROW_NUMBER() OVER (PARTITION BY Location, New_cases ORDER BY Date) AS GroupNumber
    FROM PortfolioProjects.CovidDeaths
)
SELECT Location, MIN(Date) AS StartDate, MAX(Date) AS EndDate, COUNT(*) AS NumberOfDaysDecreasing
FROM DecreasingTrend
GROUP BY Location, GroupNumber
HAVING COUNT(*) >= 7;


/* Case 19:
- **Description**: Calculates the moving average of new cases over a 7-day period for each country, selects the country name, date, and the moving average of new cases.
*/

SELECT Location, Date, 
       AVG(New_cases) OVER (PARTITION BY Location ORDER BY Date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS SevenDayMovingAverage
FROM PortfolioProjects.CovidDeaths
WHERE continent IS NOT NULL;


/* Case 20:
- **Description**: Calculates the percentage of the population that has been fully vaccinated by dividing total vaccinations by population, selects the country name, date, total vaccinations, population, and the percentage of population fully vaccinated.
*/

SELECT dea.Location, dea.Date, vac.Total_vaccinations, dea.Population,
       (vac.Total_vaccinations / dea.Population) * 100 AS PercentageFullyVaccinated
FROM PortfolioProjects.CovidDeaths dea
JOIN PortfolioProjects.CovidVaccinations vac ON dea.Location = vac.Location AND dea.Date = vac.Date
WHERE dea.continent IS NOT NULL;


/* Case 21:
- **Description**: Selects the countries where the number of new cases has been zero for at least 7 consecutive days, along with the dates and the number of days the trend has been observed.
*/

WITH ZeroCasesTrend AS (
    SELECT Location, Date, 
           ROW_NUMBER() OVER (PARTITION BY Location ORDER BY Date) - 
           ROW_NUMBER() OVER (PARTITION BY Location, New_cases ORDER BY Date) AS GroupNumber
    FROM PortfolioProjects.CovidDeaths
    WHERE continent IS NOT NULL AND New_cases = 0
)
SELECT Location, MIN(Date) AS StartDate, MAX(Date) AS EndDate, COUNT(*) AS NumberOfDaysZeroCases
FROM ZeroCasesTrend
GROUP BY Location, GroupNumber
HAVING COUNT(*) >= 7;


/* Case 22:
- **Description**: Calculates the percentage change in the number of new cases compared to the same day in the previous week for each country, selects the country name, date, and percentage change in new cases.
*/

SELECT Location, Date,
       (New_cases - LAG(New_cases, 7) OVER (PARTITION BY Location ORDER BY Date)) / LAG(New_cases, 7) OVER (PARTITION BY Location ORDER BY Date) * 100 AS PercentChangeInCases
FROM PortfolioProjects.CovidDeaths
WHERE continent IS NOT NULL;


/* Case 23:
- **Description**: Selects the top 10 countries with the highest percentage increase in deaths compared to the previous week, along with the percentage increase and the date.
*/

SELECT TOP 10 Location, Date,
       (Total_deaths - LAG(Total_deaths, 7) OVER (PARTITION BY Location ORDER BY Date)) / LAG(Total_deaths, 7) OVER (PARTITION BY Location ORDER