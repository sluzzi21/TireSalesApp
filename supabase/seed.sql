-- Insert sample tire data
insert into public.tires (
    brand,
    model,
    width,
    ratio,
    diameter,
    price,
    category,
    description,
    storage_location1,
    storage_location2,
    storage_location3,
    quantity
) values
    ('Michelin', 'Pilot Sport 4S', '245', '40', '18', 299.99, 'Performance', 'High-performance summer tire', 'Rack A', 'Row 1', 'Shelf 1', 10),
    ('Continental', 'ExtremeContact DWS06', '225', '45', '17', 189.99, 'All Season', 'Ultra-high performance all-season tire', 'Rack B', 'Row 2', 'Shelf 1', 8),
    ('Bridgestone', 'Blizzak WS90', '205', '55', '16', 159.99, 'Winter', 'Winter performance tire', 'Rack C', 'Row 1', 'Shelf 2', 15),
    ('Pirelli', 'P Zero', '275', '35', '19', 349.99, 'Performance', 'Ultra-high performance summer tire', 'Rack A', 'Row 2', 'Shelf 2', 6),
    ('Goodyear', 'Eagle F1', '255', '40', '18', 279.99, 'Performance', 'Asymmetric performance tire', 'Rack B', 'Row 1', 'Shelf 3', 12);
