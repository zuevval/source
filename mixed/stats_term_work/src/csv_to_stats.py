import csv
import re
from collections import defaultdict
from pprint import pprint
from typing import List


def read_regions() -> defaultdict:
    subregions = defaultdict(list)
    with open(r'..\data\WHO_subregions.csv') as csvfile:
        csvreader = csv.reader(csvfile)
        for row in csvreader:
            subregions[row[0]] = [line.strip() for line in row[1].strip().split(',')]
    return subregions


def read_gdp() -> defaultdict:
    gdp = defaultdict(float)
    with open(r'..\data\gdp_by_country.csv') as csvfile:
        csvreader = csv.reader(csvfile)
        for row in csvreader:
            value = row[1].strip()
            gdp[row[0]] = float(re.sub("\$(\w+|\w+.\w+) (million|billion|trillion)", "\\1", value))
            if 'billion' in value:
                gdp[row[0]] *= 1e+3
            elif 'trillion' in value:
                gdp[row[0]] *= 1e+6
    return gdp


def print_csv_to_file(dict_data: List[dict], csv_columns: List[str], csv_filename: str):
    try:
        with open(csv_filename, 'w') as csvfile:
            writer = csv.DictWriter(csvfile, fieldnames=csv_columns)
            writer.writeheader()
            for data in dict_data:
                writer.writerow(data)
    except IOError:
        print("I/O error")


def write_gdp(regions_gdp: defaultdict, other_countries: defaultdict):
    region_key, gdp_key = 'region', 'GDP, millions of dollars'
    csv_columns = [region_key, gdp_key]
    dict_data = []
    for region, gdp in regions_gdp.items():
        dict_data.append({region_key: region, gdp_key: gdp})
    csv_file = "../data/postprocessed/gdp_by_region_incomplete.csv"
    print_csv_to_file(dict_data, csv_columns, csv_file)

    country_key = "country"
    csv_columns = [country_key, gdp_key]
    dict_data = []
    for country, gdp in other_countries.items():
        dict_data.append({country_key: country, gdp_key: gdp})
    csv_file = "../data/postprocessed/other_countries_gdp.csv"
    print_csv_to_file(dict_data, csv_columns, csv_file)



def group_gdp_by_region():
    other_countries = dict()
    regions = read_regions()
    countries_gdp = read_gdp()
    regions_gdp = defaultdict(float)

    for country, gdp in countries_gdp.items():
        distributed = False
        for reg, countries_list in regions.items():
            if country in countries_list:
                distributed = True
                regions_gdp[reg] += gdp
        if not distributed:
            other_countries[country] = gdp
    pprint(other_countries)
    return regions_gdp, other_countries


if __name__ == '__main__':
    write_gdp(*group_gdp_by_region())
