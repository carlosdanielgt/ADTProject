-- FUNCTIONS:

CREATE OR REPLACE FUNCTION cross(
	a text,
	b text)
    RETURNS text
    
AS $$
  if a == b:
    return "(" + a + ")^2"
  else:
    return "(" + a + ")*(" + b + ")"
$$ LANGUAGE 'plpython3u';

CREATE OR REPLACE FUNCTION cross(
	a uuid,
	b uuid)
    RETURNS text
    
AS $$
  if a == b:
    return "(" + a + ")^2"
  else:
    return "(" + a + ")*(" + b + ")"
$$ LANGUAGE 'plpython3u';




CREATE OR REPLACE FUNCTION plus(
	a text,
	b text)
    RETURNS text
AS $$
  plpy.info('a:', a)
  plpy.info('b:', b)
  if a != '':
    return a + '+' + b
  else:
    return b
$$  LANGUAGE 'plpython3u';

CREATE OR REPLACE AGGREGATE plus(text) (
    SFUNC = public.plus,
    STYPE = text 
);

-- create table
CREATE TABLE IF NOT EXISTS public.r
(
    ann uuid NOT NULL DEFAULT uuid_generate_v4(),
    x integer,
    y integer,
    CONSTRAINT r_pkey PRIMARY KEY (ann)
)


-- THE QUERY
SELECT X, Y, plus(jann) as ann FROM (SELECT A.X, A.Y, cross(A.ann, B.ann) as jann FROM R as A, R as B WHERE A.X = B.X) as SUB group by sub.x, sub.y;


