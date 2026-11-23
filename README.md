# bash-11-currency-weather-cli

Bash-11-Currency-Weather-CLI is a command-line project designed for freelancers in Cameroon who receive payments in foreign currencies.

It provides two tools:
-`fx.sh`: Converts currencies using live exchange rates.
-`meteo.sh`: Retrieves current weather information for any supported city.
The project helps users check exchange rates and weather conditions before planning their day.

## Problem_Statement​

## Problem Statement

Freelancers in Cameroon who receive payments in foreign currencies need a simple way to check exchange rates and access weather information when planning their daily activities.

This project provides two Bash command-line tools:
-`fx.sh` for currency conversion using live exchange rates.
-`meteo.sh` for retrieving current weather information for a specified city.

## 📌 Project Goals​

- **Modular Architecture:** Use a shared utility library (`lib.sh`) to avoid code repetition between `fx.sh` and `meteo.sh`.
- **Error Handling:** Use a central `die()` helper function to display errors and return appropriate exit codes.
- **Network Reliability:** Handle connection failures, timeouts, and empty API responses.
- **Input Validation:** Validate user arguments and reject invalid inputs.
- **JSON Processing:** Use `jq` to extract and process API data.
- **Arithmetic Processing:** Use `awk` for currency conversion calculations.

## Tech stack

## Tech Stack

- **Bash:** Main scripting language.
- **curl:** Sends HTTP requests to weather and currency APIs.
- **jq:** Parses and extracts data from JSON responses.
- **awk:** Performs currency conversion calculations.
- **Git:** Tracks changes in the project.
- **GitHub:** Hosts the project repository.

## screenshotlanguage: Bash (#!/usr/bin/env bash)

## currency converter

![alt text](<asset/images/Screenshot From 2026-11-23 13-36-04.png>)

## weather reporter

![alt text](<asset/images/Screenshot From 2026-11-23 13-35-28.png>)

## Features

- **Currency Conversion:** Convert currencies using live exchange rates.
- **Weather Information:** Retrieve current weather conditions for different cities.
- **Shared Library:** Reuse common functions through `lib.sh`.
- **Input Validation:** Reject invalid command-line arguments.
- **Error Handling:** Display meaningful error messages and appropriate exit codes.
- **Network Handling:** Handle connection failures and empty API responses.

## installation and setup

- curl
- jq
- awk
clone the repository

```bash
git clone https://github.com/abigailbekwah/bash-11-currency-weather-cli.git
- chmod +x fx.sh meteo.sh lib.sh
- ./fx.sh meteo.sh lib.sh
cd bash-11-currency-weather-cli
```

## Challenges Faced

- Understanding how to structure and organize Bash scripts.
- Handling API requests and processing JSON responses.
- Implementing input validation and error handling.
- Debugging syntax errors and testing scripts using the terminal.
- Learning how to use Git and GitHub to manage project changes.

## 📚 what i learnt

- How to write and organize Bash scripts.
- How to make HTTP requests using `curl`.
- How to parse JSON responses using `jq`.
- How to perform currency calculations using `awk`.
- How to validate user input and handle errors.
- How to debug scripts using ShellCheck.
- How to use Git and GitHub for version control.

## Author​

Bekwah Abigail Becky

Junior bash developer

👨🏽‍💻 Email: <abigailbekwah@gmail.com>​

🌍 Based in Cameroon | Open to remote opportunities
Was able to understand the question at a point
