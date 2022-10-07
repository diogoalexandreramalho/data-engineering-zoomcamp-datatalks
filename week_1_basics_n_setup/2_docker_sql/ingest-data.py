#!/usr/bin/env python
# coding: utf-8

import os
import argparse

from time import time

import pandas as pd
from sqlalchemy import create_engine


def main(params):
    user = params.user
    password = params.password
    host = params.host
    port = params.port
    db = params.db
    table_name = params.table_name
    url = params.url
    parquet_name = 'output.parquet'
    csv_name = 'output.csv'
    

    # download the csv
    os.system(f'wget {url} -O {parquet_name}')
    
    engine = create_engine(f'postgresql://{user}:{password}@{host}:{port}/{db}')
    

    df_parquet = pd.read_parquet(parquet_name)
    df_parquet.to_csv(csv_name)
    df_iter = pd.read_csv(csv_name, iterator=True, chunksize=100000)

    df = next(df_iter)
    df = df.drop(columns=['Unnamed: 0'])

    df.tpep_pickup_datetime = pd.to_datetime(df.tpep_pickup_datetime)
    df.tpep_dropoff_datetime = pd.to_datetime(df.tpep_dropoff_datetime)

    df.head(n=0).to_sql(name=table_name, con=engine, if_exists='replace')
    
    df.to_sql(name=table_name, con=engine, if_exists='append')

    while True:
        t_start = time()
        
        df = next(df_iter)
        df = df.drop(columns=['Unnamed: 0'])
        
        # Changes dtype from TEXT to TIMESTAMP
        df.tpep_pickup_datetime = pd.to_datetime(df.tpep_pickup_datetime)
        df.tpep_dropoff_datetime = pd.to_datetime(df.tpep_dropoff_datetime)
        
        # Adds rows to postgres db in 100k chunks
        df.to_sql(name=table_name, con=engine, if_exists='append')
        
        t_end = time()
        duration = t_end - t_start
        
        print(f"inserted another chunk... took {duration:.3f} seconds")



if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Ingest CSV data to Postgres')

    parser.add_argument('--user', help='user name for postgres')
    parser.add_argument('--password', help='password for postgres')
    parser.add_argument('--host', help='host for postgres')
    parser.add_argument('--port', help='port for postgres')
    parser.add_argument('--db', help='database name for postgres')
    parser.add_argument('--table_name', help='name of the table where we will write the results to')
    parser.add_argument('--url', help='url of the csv file')

    args = parser.parse_args()
    
    main(args)