# Supabase Database Management

This directory contains SQL files for managing the Supabase database schema and data.

## Structure

- `migrations/`: Contains database schema changes
  - `20250411_update_tires_table.sql`: Updates tires table to use snake_case and adds timestamps
- `seed.sql`: Contains sample data for testing

## How to Use

1. Run migrations in order using the Supabase SQL editor
2. Run seed.sql to populate test data

## Schema

### Tires Table

| Column            | Type                     | Description                |
|------------------|--------------------------|----------------------------|
| id               | uuid                     | Primary key               |
| brand            | text                     | Tire brand                |
| model            | text                     | Tire model                |
| width            | text                     | Tire width                |
| ratio            | text                     | Tire aspect ratio         |
| diameter         | text                     | Tire diameter             |
| price            | decimal                  | Tire price                |
| category         | text                     | Tire category             |
| description      | text                     | Tire description          |
| storage_location1 | text                    | Primary storage location   |
| storage_location2 | text                    | Secondary storage location |
| storage_location3 | text                    | Tertiary storage location  |
| quantity         | integer                  | Stock quantity            |
| created_at       | timestamp with time zone | Creation timestamp        |
| updated_at       | timestamp with time zone | Last update timestamp     |
