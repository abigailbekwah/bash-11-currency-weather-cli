# bash-11-currency-weather-cli

Bash-11-Currency-Weather-CLI is a command-line project designed for freelancers in Cameroon who receive payments in foreign currencies.

It provides two tools:
-fx.sh: Converts currencies using live exchange rates.
-meteo.sh: Retrieves current weather information for any supported city.
The project helps users check exchange rates and weather conditions before planning their day.

## Problem Statement​

Freelancers in Cameroon who receive payments in foreign currencies need a simple way to check exchange rates and access weather information.
This project provides two Bash command-line tools to address these needs.

## 📌 Project Goals​

- Modular Architecture: Use a shared utility library (lib.sh) to avoid code repetition between fx.sh and meteo.sh.
- Error Handling: Use a central die() helper function to display errors and return appropriate exit codes.
- Network Reliability: Handle connection failures, timeouts, and empty API responses.
- Input Validation: Validate user arguments and reject invalid inputs.
- JSON Processing: Use jq to extract and process API data.
- Arithmetic Processing: Use awk for currency conversion calculations.

## Tech Stack

- Bash: Main scripting language.
- curl: Sends HTTP requests to weather and currency APIs.
- jq: Parses and extracts data from JSON responses.
- awk: Performs currency conversion calculations.
- Git: Tracks changes in the project.
- GitHub: Hosts the project repository.

## screenshots

![alt text](<asset/images/Screenshot From 2026-11-23 13-36-04.png>)

![alt text](<asset/images/Screenshot From 2026-11-23 13-35-28.png>)

## Features

- Currency Conversion: Convert currencies using live exchange rates.
- Weather Information: Retrieve current weather conditions for different cities.
- Shared Library: Reuse common functions through lib.sh.
- Input Validation: Reject invalid command-line arguments.
- Error Handling: Display meaningful error messages and appropriate exit codes.
- Network Handling: Handle connection failures and empty API responses.

## installation and setup

- curl
- jq
- awk

Make the Scripts Executabl

- chmod +x fx.sh meteo.sh lib.sh

clone the repositor

git clone https://github.com/abigailbekwah/bash-11-currency-weather-cli.git

cd bash-11-currency-weather-cli

The currency converter accepts three arguments:

./fx.sh < AMOUNT > < FROM_CURRENCY > < TO_CURRENCY >

Example:

./fx.sh 100 USD XAF

Example output:

100 USD = 60062.62 XAF   (rate 600.626227)

The weather reporter accepts a city name as an optional argument.

./meteo.sh < CITY >

Example:

./meteo.sh Bamenda

Example output:

Bamenda: 27°C, Sunny, humidity 34%

If no city is provided, the script uses METEO_CITY if configured, or defaults to Yaounde.  

## Challenges Faced

- Understanding how to structure and organize Bash scripts.
- Handling API requests and processing JSON responses.
- Implementing input validation and error handling.
- Debugging syntax errors and testing scripts using the terminal.
- Learning how to use Git and GitHub to manage project changes.

## 📚 what i learnt

- How to write and organize Bash scripts.
- How to make HTTP requests using curl.
- How to parse JSON responses using jq.
- How to perform currency calculations using awk.
- How to validate user input and handle errors.
- How to debug scripts using ShellCheck.
- How to use Git and GitHub for version control.

## Author​

Bekwah Abigail Becky

Junior bash developer

👨🏽‍💻 Email: <abigailbekwah@gmail.com>​

🌍 Based in Cameroon | Open to remote opportunities
