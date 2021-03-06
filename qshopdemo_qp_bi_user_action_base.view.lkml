#File uploaded: Mon Apr 09 14:05:48 GMT 2018
view: qshopdemo_qp_bi_user_action_base {

 #version 1.1
 sql_table_name:  [qubit-client-37403:qshopdemo.qp_bi_user_action] ;;
 
  dimension: view_id {
    type: string
    sql: ${TABLE}.view_id ;;
    hidden: yes
    primary_key: yes
  }

  dimension: context_session_number {
    type: number
    sql: ${TABLE}.context_sessionNumber ;;
    label: "Session Number"
    group_label: "View Meta Data"
    description: "Session number of the visitor, in a lifetime. QP fields: context_sessionNumber"
  }

  dimension: context_view_number {
    type: number
    sql: ${TABLE}.context_viewNumber ;;
    label: "View Number"
    group_label: "View Meta Data"
    description: "View number of the visitor, in a lifetime. QP fields: context_viewNumber"
  }

  dimension: context_id {
    type: string
    sql: ${TABLE}.context_id ;;
    label: "Visitor ID"
    group_label: "Visitor"
    description: "ID unique to the visitor, created in browser. QP fields: context_id"
  }

  dimension_group: time_data_points {
    label: "Time Data Points"
    type: time
    timeframes:  [time, hour_of_day, date, day_of_week, week, week_of_year, month, month_name, quarter_of_year, year]
    sql: ${TABLE}.property_event_ts ;;
    group_label: "Time Data Points"
    description: "Timestamp of the user action. QP fields: property_event_ts"
  }

  dimension: type {
    type: string
    sql: ${TABLE}.type ;;
    label: "Subtype"
    description: "Action type. QP fields: type"
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
    label: "Action Name"
    description: "Action name. QP fields: name"
  }

  dimension: meta_type {
    type: string
    sql: ${TABLE}.meta_type ;;
    label: "Action Meta Type"
    description: "Action meta type. QP fields: meta_type"
  }

  dimension: voucher_label {
    type: string
    sql: ${TABLE}.voucher_label ;;
    label: "Voucher Label"
    description: "Voucher Label"
  }

  dimension: user_interaction_type {
    type: string
    sql: ${TABLE}.user_interaction_type ;;
    label: "User Interaction Type"
    description: "User interaction type. QP fields: user_interaction_type"
  }

  measure: total_visitor_views {
    type: number
    sql: COUNT(DISTINCT ${TABLE}.view_id, 1000000) ;;
    group_label: "Visitor"
    description: "Number of unique views. QP fields: context_viewNumber, context_id"
  }

}
