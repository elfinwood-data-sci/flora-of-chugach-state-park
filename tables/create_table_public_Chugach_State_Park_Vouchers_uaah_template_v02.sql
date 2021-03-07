-- Table: chugach_state_park_vouchers_uaah_template_v02

-- DROP TABLE chugach_state_park_vouchers_uaah_template_v02;

CREATE TABLE chugach_state_park_vouchers_uaah_template_v02
(
    project text,
family text,
scientific_name text,
collector text,
collection_number text,
month_collected text,
day_collected text,
year_collected text,
state text,
county text,
locality text,
minimum_elevation text,
elevation_unit text,
lat_degrees double precision,
n_or_s text,
lon_degrees double precision,
w_or_e text,
geodetic_datum text,
coordinate_source text,
site_description text,
specimen_notes text,
specimen_verifier text,
lat_deg_min_sec text,
long_deg_min_sec text
);

ALTER TABLE chugach_state_park_vouchers_uaah_template_v02
    OWNER to aaronwells;

COMMENT ON TABLE chugach_state_park_vouchers_uaah_template_v02
    IS 'List of 2020 voucher specimens from Chugach State Park with the new Flora of Alaska names assigned.';