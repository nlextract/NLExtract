-- test de functies onder db/script/geocode

-- geef 1 adres dichtst bij punt
select * from nlx_adres_voor_xy(272580, 569748);

-- geef  adressen dichtst bij punt binnen straal met max
select * from nlx_adressen_voor_xy(272580, 569748,100000,5);
