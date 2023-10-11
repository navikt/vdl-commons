{{
    config(
        materialized='table',
        cluster_by = ['dato','dim_nivaa']
    )
}}

with

dim_tid as (
  select * from {{ ref('int_dim_tid__finn_neste_virkedag') }}
),

last_year as (
  select
    pk_dim_tid,
    dateadd('year',-1,dato) as fjor_dato,
    aar_uke-100 as fjor_aar_uke,
    aar_maaned-100 as fjor_aar_maaned,
    aar_kvartal-100 as fjor_aar_kvartal,
    aar_tertial-100 as fjor_aar_tertial,
    aar_halvaar-100 as fjor_aar_halvaar,
    aar-1 as fjor_aar
  from
    dim_tid
),

tertial as (
  select
    pk_dim_tid,
    case tertial 
      when 1 then '1. tertial' 
      when 2 then '2. tertial'
      when 3 then '3. tertial'
      else 'ukjent'
    end as tertial_besk
  from
    dim_tid
),

final as (
  select
    dim_tid.*,
    last_year.fjor_dato,
    last_year.fjor_aar_uke,
    last_year.fjor_aar_maaned,
    last_year.fjor_aar_kvartal,
    last_year.fjor_aar_tertial,
    last_year.fjor_aar_halvaar,
    last_year.fjor_aar,
    tertial.tertial_besk
  from dim_tid
  left join last_year on
    dim_tid.pk_dim_tid = last_year.pk_dim_tid
  left join tertial on
    dim_tid.pk_dim_tid = tertial.pk_dim_tid
)

select * from final
