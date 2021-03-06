#File uploaded: Mon Apr 09 14:05:48 GMT 2018
view: qshopdemo_qp_bi_experience_z_meta_data_base {
 #the reason we have a `z` in name is because
  derived_table: {
    
    sql:
    SELECT
      STRING(experienceId) experienceId,
      DATE(MAX(experience_last_paused_at)) experience_last_paused_at,
      DATE(MIN(experience_first_published_at)) experience_first_published_at
    FROM (
      SELECT
        *,
        MIN(iteration_published_at) OVER (PARTITION BY experienceId) AS experience_first_published_at,
        STRING(DATE(iteration_paused_at)) iteration_paused_at_date,
        STRING(DATE(iteration_published_at)) iteration_published_at_date,
        TIMESTAMP_TO_MSEC(TIMESTAMP(iteration_paused_at)) AS iteration_paused_at_unix_ts,
        MAX(iteration_paused_at) OVER (PARTITION BY experienceId) AS experience_last_paused_at
      FROM (
        SELECT
          COALESCE(iteration_published_at_first,iteration_started_at,iteration_created_at,iteration_upadted_at) AS iteration_published_at,
          *
        FROM (
          SELECT
            experienceId AS experienceId,
            variationMasterId AS variationMasterId,
            iterationId AS iterationId,
            MAX(experienceName) AS experienceName,
            MAX(variationName) AS variationName,
            MAX(iterationName) AS iterationName,
            TIMESTAMP(MIN(CASE
                  WHEN iterationUpdatedAt > COALESCE(iterationStartedAt, MSEC_TO_TIMESTAMP(0)) AND iterationPausedAt IS NULL THEN iterationUpdatedAt
                  WHEN iterationPausedAt > COALESCE(iterationStartedAt, MSEC_TO_TIMESTAMP(0))
                AND iterationPausedAt > COALESCE(iterationPublishedAt, MSEC_TO_TIMESTAMP(0))
                AND iterationPausedAt > COALESCE(iterationResumedAt, MSEC_TO_TIMESTAMP(0)) THEN iterationPausedAt
                  ELSE TIMESTAMP('2030-01-01 00:00:00 UTC') END)) AS iteration_paused_at,
            MIN(iterationPublishedAt) AS iteration_published_at_first,
            MIN(iterationStartedAt) AS iteration_started_at,
            MIN(iterationCreatedAt) AS iteration_created_at,
            MIN(iterationUpdatedAt) AS iteration_upadted_at
          FROM
            TABLE_QUERY([qubit-client-37403:qshopdemo],'REGEXP_MATCH(table_id, r"aux_experience_iteration_variation_v01$")')
          GROUP BY
            1,
            2,
            3) AS experience_metadata ) AS experience_metadata_1
      WHERE
        (experienceId IS NOT NULL
          AND CAST(experienceId AS STRING) != 'undefined'
          AND variationMasterId IS NOT NULL
          AND CAST(variationMasterId AS STRING) != 'undefined'
          AND iterationId IS NOT NULL
          AND CAST(iterationId AS STRING) != 'undefined' ))
    GROUP BY
      1
    ;;}


      dimension: experience_id {
        type: string
        sql: STRING(${TABLE}.experienceId) ;;
        hidden: yes
      }

      
      dimension: experience_name {
        type: string
        sql: ${TABLE}.experienceName ;;
        hidden: yes
      }
      
      dimension: current_experience_status {
        view_label: "Experiences"
        type: string
        sql: IF(${TABLE}.experience_last_paused_at <= CURRENT_DATE() , "Paused" , "Active") ;;
        label: "Current Experience Status "
        description: "Status of the experience as of today"
        group_label: "Experience"

      }
      dimension: experience_first_published_at {
          view_label: "Experiences"
          type: date
          sql: TIMESTAMP(${TABLE}.experience_first_published_at) ;;
          group_label: "Experience"
          description: "Date the first iteration of experience was published"
        }

     dimension: experience_last_paused_at {
         view_label: "Experiences"
         type: date
         sql: TIMESTAMP(${TABLE}.experience_last_paused_at) ;;
         group_label: "Experience"
         description: "Most recent date experience was paused"
       }

    }
    