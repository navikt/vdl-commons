with

dim_tid as (
  select * from {{ ref('stg_dvh__dim_tid') }}
)

,virkedager as (
  select
     pk_dim_tid
    ,dato
  from dim_tid
  where
    dim_nivaa = 1 and
    virkedag_flagg = 1
)

,fridager as (
  select
     pk_dim_tid
    ,dato
  from
    dim_tid
  where
    dim_nivaa = 1 and
    virkedag_flagg = 0
)

,neste_virkedag_for_fridager as (
    select
        fridager.pk_dim_tid
        ,fridager.dato
        ,virkedager.dato as neste_virkedag
        ,(row_number()
          over(
            partition by fridager.dato
            order by fridager.dato, virkedager.dato
        )) as rekkefolge
    from fridager
    left join virkedager on
        -- Tror aldri det kan være mer en 5 fridager etter hverandre men legger til 2 for sikkerhetsskyld
        virkedager.dato between fridager.dato and fridager.dato + 7
    order by fridager.dato
)

,fjern_dubletter as (
    select * from neste_virkedag_for_fridager
    where rekkefolge = 1
)


,final as (
  select
    coalesce(
       neste_virkedag
      ,dim_tid.dato
    ) as neste_virkedag
    ,dim_tid.*
  from dim_tid
  left join fjern_dubletter on
    dim_tid.pk_dim_tid = fjern_dubletter.pk_dim_tid
  order by dim_tid.pk_dim_tid
)

select * from final
