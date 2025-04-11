-- Enable Row Level Security
alter table public.tires enable row level security;

-- Drop existing RLS policies if they exist
drop policy if exists "Allow all operations on tires" on public.tires;

-- Create updated tires table with snake_case column names
create table if not exists public.tires (
    id uuid primary key default uuid_generate_v4(),
    brand text not null,
    model text,
    width text not null,
    ratio text not null,
    diameter text not null,
    price decimal,
    category text,
    description text,
    storage_location1 text,
    storage_location2 text,
    storage_location3 text,
    quantity integer default 0,
    created_at timestamp with time zone default timezone('utc'::text, now()) not null,
    updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Create updated RLS policy
create policy "Allow all operations on tires"
    on public.tires
    for all
    using (true)
    with check (true);

-- Create trigger for updating the updated_at timestamp
create or replace function public.handle_updated_at()
returns trigger
language plpgsql
as $$
begin
    new.updated_at = timezone('utc'::text, now());
    return new;
end;
$$;

-- Create the trigger if it doesn't exist
drop trigger if exists set_tires_updated_at on public.tires;
create trigger set_tires_updated_at
    before update on public.tires
    for each row
    execute function public.handle_updated_at();

-- Grant access to authenticated and anonymous users
grant all on public.tires to authenticated;
grant all on public.tires to anon;

-- Create indexes for commonly searched fields
create index if not exists tires_brand_idx on public.tires (brand);
create index if not exists tires_model_idx on public.tires (model);
create index if not exists tires_width_idx on public.tires (width);
create index if not exists tires_ratio_idx on public.tires (ratio);
create index if not exists tires_diameter_idx on public.tires (diameter);
