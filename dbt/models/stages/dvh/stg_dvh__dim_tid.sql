with 

src as (
  select * from {{source('dvh','csv__dim_tid')}}
),

nullify as (
  {% set column_names = dbt_utils.star(from=source('dvh', 'csv__dim_tid')).split(",") %}

  select
    {% for column in column_names %}
      nullif({{ column }}, '') as {{ column }}
      {% if not loop.last %},{% endif %}
    {% endfor %}
  from src
),

cast_types as (
  select 
    pk_dim_tid::number as pk_dim_tid,
    to_date(dato,'yyyymmdd hh24:mi:ss') as dato,
    dag_nr::number as dag_nr,
    ukedag_navn::varchar(200) as ukedag_navn,
    dag_i_uke::number as dag_i_uke,
    dag_i_maaned::number as dag_i_maaned,
    siste_i_maaned_flagg::number as siste_i_maaned_flagg,
    uke::number as uke,
    uke_sak::number as uke_sak,
    uke_sak_lorfre::number as uke_sak_lorfre,
    aar_uke::number as aar_uke,
    aar_uke_sak::number as aar_uke_sak,
    aar_uke_sak_lorfre::number as aar_uke_sak_lorfre,
    aar_uke_besk::varchar(200) as aar_uke_besk,
    aar_uke_sak_besk::varchar(200) as aar_uke_sak_besk,
    aar_uke_sak_lorfre_besk::varchar(200) as aar_uke_sak_lorfre_besk,
    maaned::number as maaned,
    maaned_navn::varchar(200) as maaned_navn,
    aar_maaned::number as aar_maaned,
    aar_maaned_besk_kort::varchar(200) as aar_maaned_besk_kort,
    aar_maaned_besk::varchar(200) as aar_maaned_besk,
    kvartal::number as kvartal,
    kvartal_besk::varchar(200) as kvartal_besk,
    aar_kvartal::number as aar_kvartal,
    aar_halvaar_besk_kort::varchar(200) as aar_kvartal_besk_kort,
    aar_kvartal_besk::varchar(200) as aar_kvartal_besk,
    tertial::number as tertial,
    aar_tertial::number as aar_tertial,
    aar_tertial_besk_kort::varchar(200) as aar_tertial_besk_kort,
    aar_tertial_besk::varchar(200) as aar_tertial_besk,
    halvaar::number as halvaar,
    aar_halvaar::number as aar_halvaar,
    aar_halvaar_besk_kort::varchar(200) as aar_halvaar_besk_kort,
    aar_halvaar_besk::varchar(200) as aar_halvaar_besk,
    aar::number as aar,
    juli_juni_besk_kort::varchar(200) as juli_juni_besk_kort,
    juli_juni_besk::varchar(200) as juli_juni_besk,
    stat_siste_i_maaned_flagg::number as stat_siste_i_maaned_flagg,
    stat_maaned::number as stat_maaned,
    stat_maaned_navn::varchar(200) as stat_maaned_navn,
    stat_aar_maaned::number as stat_aar_maaned,
    stat_aar_maaned_besk_kort::varchar(200) as stat_aar_maaned_besk_kort,
    stat_aar_maaned_besk::varchar(200) as stat_aar_maaned_besk,
    stat_aar::number as stat_aar,
    fem_aar_gruppe_besk::varchar(200) as fem_aar_gruppe_besk,
    ti_aar_gruppe_besk::varchar(200) as ti_aar_gruppe_besk,
    hundre_aar_gruppe_besk::varchar(200) as hundre_aar_gruppe_besk,
    virkedag_flagg::number as virkedag_flagg,
    virkedag_antall::number as virkedag_antall,
    virkedag_sak_antall::number as virkedag_sak_antall,
    virkedag_besk::varchar(200) as virkedag_besk,
    relativ_dag::number as relativ_dag,
    relativ_dag_besk::varchar(200) as relativ_dag_besk,
    relativ_uke::number as relativ_uke,
    relativ_uke_besk::varchar(200) as relativ_uke_besk,
    relativ_maaned::number as relativ_maaned,
    relativ_maaned_besk::varchar(200) as relativ_maaned_besk,
    relativ_kvartal::number as relativ_kvartal,
    relativ_kvartal_besk::varchar(200) as relativ_kvartal_besk,
    relativ_tertial::number as relativ_tertial,
    relativ_tertial_besk::varchar(200) as relativ_tertial_besk,
    relativ_halvaar::number as relativ_halvaar,
    relativ_halvaar_besk::varchar(200) as relativ_halvaar_besk,
    relativ_aar::number as relativ_aar,
    relativ_aar_besk::varchar(200) as relativ_aar_besk,
    hittil_i_relativt_aar::number as hittil_i_relativt_aar,
    hittil_i_relativ_aar_maaned::number as hittil_i_relativ_aar_maaned,
    dim_nivaa::number as dim_nivaa,
    to_date(forste_dato_i_perioden,'yyyymmdd hh24:mi:ss') as forste_dato_i_perioden,
    to_date(siste_dato_i_perioden,'yyyymmdd hh24:mi:ss') as siste_dato_i_perioden
  from nullify
),

final as (
  select * from cast_types
)

select * from final
