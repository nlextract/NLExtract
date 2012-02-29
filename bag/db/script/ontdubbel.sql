--
-- Verwijder dubbele records uit tabellen
--
-- In sommige BAG extracten zitten wplicate records. Met deze SQL
-- statements verwijdren we ze
--
-- Zie http://www.postgresonline.com/journal/archives/22-Deleting-Duplicate-Records-in-a-Table.html
-- voor basis methode om te verwijderen
--

-- DROP FUNCTION bag_ontdubbel_tabel(text);

-- No String concat function in PG < 9.0
-- Zie : http://stackoverflow.com/questions/43870/how-to-concatenate-strings-of-a-string-field-in-a-postgresql-group-by-query
CREATE OR REPLACE FUNCTION commacat(t1 text, t2 text) RETURNS text AS $$
  DECLARE
  BEGIN
    IF t2 IS NULL OR t2 = '' THEN
      RETURN t1;
    ELSE
      RETURN t1 || ', ' || t2;
    END IF;
  END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION bag_ontdubbel_tabel(tabel text, relatie text) RETURNS integer AS
$BODY$
 DECLARE
 BEGIN
  EXECUTE 'DELETE FROM '
      || quote_ident(tabel)
      || ' WHERE gid NOT IN'
      || ' (SELECT MAX(t.gid)'
      || '   FROM '
      || quote_ident(tabel)
      || ' AS t GROUP BY '
      || commacat('t.identificatie,t.aanduidingrecordinactief,t.aanduidingrecordcorrectie,t.begindatumtijdvakgeldigheid', relatie)
      || ')';

  RETURN 0;
END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE;

select bag_ontdubbel_tabel('ligplaats', NULL);
select bag_ontdubbel_tabel('standplaats', NULL);
select bag_ontdubbel_tabel('verblijfsobject', NULL);
select bag_ontdubbel_tabel('pand', NULL);
select bag_ontdubbel_tabel('woonplaats', NULL);
select bag_ontdubbel_tabel('nummeraanduiding', NULL);
select bag_ontdubbel_tabel('openbareruimte', NULL);

select bag_ontdubbel_tabel('verblijfsobjectpand','gerelateerdpand');
select bag_ontdubbel_tabel('verblijfsobjectgebruiksdoel', 'gebruiksdoelverblijfsobject');
select bag_ontdubbel_tabel('adresseerbaarobjectnevenadres', 'nevenadres');
