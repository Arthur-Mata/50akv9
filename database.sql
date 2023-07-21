-- Table: public.peliculas

-- DROP TABLE IF EXISTS public.peliculas;

CREATE TABLE IF NOT EXISTS public.peliculas
(
    pelicula_id integer NOT NULL DEFAULT nextval('film_film_id_seq'::regclass),
    titulo character varying(255) COLLATE pg_catalog."default" NOT NULL,
    "descripción" text COLLATE pg_catalog."default",
    anio_publicacion year,
    lenguaje_id smallint NOT NULL,
    duracion_renta smallint NOT NULL DEFAULT 3,
    precio_renta numeric(4,2) NOT NULL DEFAULT 4.99,
    duracion smallint,
    costo_reemplazo numeric(5,2) NOT NULL DEFAULT 19.99,
    clasificacion mpaa_rating DEFAULT 'G'::mpaa_rating,
    ultima_actualizacion timestamp without time zone NOT NULL DEFAULT now(),
    caracteristicas_especiales text[] COLLATE pg_catalog."default",
    textocompleto tsvector NOT NULL,
    CONSTRAINT film_pkey PRIMARY KEY (pelicula_id),
    CONSTRAINT film_language_id_fkey FOREIGN KEY (lenguaje_id)
        REFERENCES public.lenguajes (lenguaje_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.peliculas
    OWNER to postgres;
-- Index: film_fulltext_idx

-- DROP INDEX IF EXISTS public.film_fulltext_idx;

CREATE INDEX IF NOT EXISTS film_fulltext_idx
    ON public.peliculas USING gist
    (textocompleto)
    TABLESPACE pg_default;
-- Index: idx_fk_language_id

-- DROP INDEX IF EXISTS public.idx_fk_language_id;

CREATE INDEX IF NOT EXISTS idx_fk_language_id
    ON public.peliculas USING btree
    (lenguaje_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_title

-- DROP INDEX IF EXISTS public.idx_title;

CREATE INDEX IF NOT EXISTS idx_title
    ON public.peliculas USING btree
    (titulo COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;

-- Trigger: last_updated

-- DROP TRIGGER IF EXISTS last_updated ON public.peliculas;

CREATE TRIGGER last_updated
    BEFORE UPDATE 
    ON public.peliculas
    FOR EACH ROW
    EXECUTE FUNCTION public.last_updated();

-- Trigger: trigger_update_tipos_cambio

-- DROP TRIGGER IF EXISTS trigger_update_tipos_cambio ON public.peliculas;

CREATE TRIGGER trigger_update_tipos_cambio
    AFTER INSERT OR UPDATE 
    ON public.peliculas
    FOR EACH ROW
    EXECUTE FUNCTION public.precio_peliculas_tipo_cambio();