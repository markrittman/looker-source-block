#File uploaded: Tue Jan 30 23:40:53 GMT 2018
view: qshopdemo_qp_bi_segment_base {

 #version 1.1
 derived_table: {
   sql: select meta_recordDate, qp_bi_view_name, ts, property_event_ts, view_id, meta_ts, meta_serverTs, meta_trackingId, context_id, context_viewNumber, context_sessionNumber, context_conversionNumber, segment_rows, segment.segmentId as segmentId, segment.segmentName as segmentName
from  `qubit-client-37403.qshopdemo__v2.livetap_segment`
left join unnest(segment) as segment ;;
 }

  dimension: segment_id {
    type: string
    sql: ${TABLE}.segmentId ;;
    description: "ID unique to the segment. QP fields: segmentId"
  }

  dimension: segment_name {
    type: string
    sql: ${TABLE}.segmentName ;;
    description: "The name of segment. QP fields: segmentName"
  }


  dimension: visitor_id {
    type: string
    sql: ${TABLE}.context_id ;;
    hidden: yes
  }

  dimension: context_viewNumber {
    hidden: yes
    type: string
    sql: ${TABLE}.context_viewNumber ;;
  }

  dimension: view_id {
    type: string
    primary_key: yes
    sql: ${TABLE}.view_id ;;
    hidden: yes
  }

  measure: segment_visitors {
    type: number
    sql: COUNT(DISTINCT IF(${TABLE}.segmentId IS NOT NULL,${TABLE}.context_id,NULL))  ;;
    description: "Count of unique visitor_ids. If above 1.000.000, the result is approximated. Only for views labeled with any non-null segment_id. QP fields: context_id"
  }

  measure: distinct_segments {
    type: number
    sql: COUNT(DISTINCT ${TABLE}.segmentId) ;;
    description: "Count of unique segment_ids. If above 1.000.000, the result is approximated. QP fields: segmenId"
  }

  measure: visitor_conversion_rate {
    type: number
    sql: SAFE_DIVIDE(${segment_converters},COUNT(DISTINCT ${TABLE}.context_id)) ;;
    value_format_name: percent_2
    description: "Share of unique visitors on views that are labeled with any non-null transaction_id in all visitors. For counting, when figures are above 1.000.000, the result is approximated. Only for views labeled with any non-null segment_id. QP fields: transaction_id, context_id"
  }

  measure: segment_views {
    type: number
    sql: COUNT(DISTINCT ${TABLE}.view_id);;
    description: "Count of unique combinations of a visitor_id and a view_number. If above 1.000.000, the result is approximated. Only for views labeled with any non-null segment_id. QP fields: context_id, context_viewNumber"
  }

  measure: transaction_total {
    type: sum_distinct
    sql_distinct_key: ${qshopdemo_qp_bi_transaction_v01.transaction_id} ;;
    sql: CASE WHEN ${TABLE}.segmentId IS NOT NULL THEN ${qshopdemo_qp_bi_transaction_v01.transaction_total} END ;;
    value_format_name: decimal_0
    description: "Sum of transaction_total. Only for views labeled with any non-null segment_id. QP fields: basket_total_baseValue, segmentId"
  }

  measure: transactions {
    type: number
    sql: COUNT(DISTINCT CASE WHEN ${TABLE}.segmentId IS NOT NULL THEN ${qshopdemo_qp_bi_transaction_v01.transaction_id} END) ;;
    description: "Count of unique transaction_ids (always exact count). Only for views labeled with any non-null segment_id. QP fields: transaction_id, segmentId"
  }

  measure: segment_converters {
    type: number
    sql: COUNT(DISTINCT IF(${qshopdemo_qp_bi_transaction_v01.transaction_id} IS NOT NULL,${TABLE}.context_id,NULL)) ;;
    description: "Count of unique visitor_ids on views labeled with any non-null segment_id. If above 1.000.000, the result is approximated. QP fields: context_id, transaction_id"
  }

  measure: revenue_per_visitor {
    type: number
    sql: SAFE_DIVIDE(${qshopdemo_qp_bi_segment_v01.transaction_total},${qshopdemo_qp_bi_segment_v01.segment_visitors}) ;;
    value_format_name: decimal_2
    description: "Sum of transaction_total divided by count of unique visitor_ids. If count of visitor_ids is above 1.000.000, the result is approximated. Only for views labeled with any non-null segment_id. QP fields: basket_total_baseValue, context_id"
  }

}
