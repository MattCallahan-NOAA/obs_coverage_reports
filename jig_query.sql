with jig as (
select species_name, fmp_area,  sum(weight_posted) jig_catch_mt 
from council.comprehensive_blend_ca
where agency_gear_code = 'JIG'
and year >=2018
group by species_name, fmp_area),
tot as (select species_name, fmp_area,  sum(weight_posted) all_catch 
from council.comprehensive_blend_ca
where year >=2018
group by species_name, fmp_area)
select jig.species_name, jig.fmp_area, round(jig.jig_catch_mt,2) jig_catch_mt, round(tot.all_catch,2) all_catch, round(jig.jig_catch_mt/tot.all_catch, 2) propprtion_jig
from jig
left join tot on jig.species_name=tot.species_name and jig.fmp_area=tot.fmp_area
order by jig.jig_catch_mt desc;

