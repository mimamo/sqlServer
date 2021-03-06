USE [MIDWESTAPP]
GO
/****** Object:  View [dbo].[xvr_PA920]    Script Date: 12/21/2015 15:55:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*added by RF*/
CREATE VIEW [dbo].[xvr_PA920]
AS
SELECT     PJPROJ.pm_id01, Customer.Name AS Client, PJPROJ.pm_id02, ISNULL(PJCODE.code_value_desc, '') AS Product, PJPROJ.project, 
                      PJPROJ.project_desc, PJPROJ.purchase_order_num, ISNULL(PJPTDROL.eac_amount, 0) AS Estimate_amount, ISNULL(PJACTROL.fsyear_num, 0) 
                      AS btd_fsyear_num, ISNULL(PJACTROL.amount_01, 0) AS btd_amount_01, ISNULL(PJACTROL.amount_02, 0) AS btd_amount_02, 
                      ISNULL(PJACTROL.amount_03, 0) AS btd_amount_03, ISNULL(PJACTROL.amount_04, 0) AS btd_amount_04, ISNULL(PJACTROL.amount_05, 0) 
                      AS btd_amount_05, ISNULL(PJACTROL.amount_06, 0) AS btd_amount_06, ISNULL(PJACTROL.amount_07, 0) AS btd_amount_07, 
                      ISNULL(PJACTROL.amount_08, 0) AS btd_amount_08, ISNULL(PJACTROL.amount_09, 0) AS btd_amount_09, ISNULL(PJACTROL.amount_10, 0) 
                      AS btd_amount_10, ISNULL(PJACTROL.amount_11, 0) AS btd_amount_11, ISNULL(PJACTROL.amount_12, 0) AS btd_amount_12, 
                      ISNULL(PJACTROL.amount_13, 0) AS btd_amount_13, ISNULL(PJACTROL.amount_14, 0) AS btd_amount_14, ISNULL(PJACTROL.amount_15, 0) 
                      AS btd_amount_15, ISNULL(PJACTROL.amount_bf, 0) AS btd_amount_bf, PJPROJ.start_date, PJPROJ.end_date AS on_shelf_date, 
                      PJPROJ.pm_id08 AS close_date, ISNULL(PJACTROL_1.fsyear_num, 0) AS act_fsyear_num, ISNULL(PJACTROL_1.amount_01, 0) AS act_amount_01, 
                      ISNULL(PJACTROL_1.amount_02, 0) AS act_amount_02, ISNULL(PJACTROL_1.amount_03, 0) AS act_amount_03, ISNULL(PJACTROL_1.amount_04, 0) 
                      AS act_amount_04, ISNULL(PJACTROL_1.amount_05, 0) AS act_amount_05, ISNULL(PJACTROL_1.amount_06, 0) AS act_amount_06, 
                      ISNULL(PJACTROL_1.amount_07, 0) AS act_amount_07, ISNULL(PJACTROL_1.amount_08, 0) AS act_amount_08, ISNULL(PJACTROL_1.amount_09, 0) 
                      AS act_amount_09, ISNULL(PJACTROL_1.amount_10, 0) AS act_amount_10, ISNULL(PJACTROL_1.amount_11, 0) AS act_amount_11, 
                      ISNULL(PJACTROL_1.amount_12, 0) AS act_amount_12, ISNULL(PJACTROL_1.amount_13, 0) AS act_amount_13, ISNULL(PJACTROL_1.amount_14, 0) 
                      AS act_amount_14, ISNULL(PJACTROL_1.amount_15, 0) AS act_amount_15, ISNULL(PJACTROL_1.amount_bf, 0) AS act_amount_bf, 
                      ISNULL(PJACTROL_1.acct, '') AS act_acct, ISNULL(PJACTROL.acct, '') AS btd_acct, ISNULL(PJPTDROL.acct, '') AS estimate_acct, 
                      ISNULL(PJACCT.acct_group_cd, '') AS AcctGrpCd
FROM         dbo.PJPROJ AS PJPROJ LEFT OUTER JOIN
                      dbo.Customer AS Customer ON PJPROJ.pm_id01 = Customer.CustId LEFT OUTER JOIN
                      dbo.PJCODE AS PJCODE ON PJPROJ.pm_id02 = PJCODE.code_value LEFT OUTER JOIN
                          (SELECT     acct, act_amount, act_units, com_amount, com_units, crtd_datetime, crtd_prog, crtd_user, data1, data2, data3, data4, data5, eac_amount, 
                                                   eac_units, fac_amount, fac_units, lupd_datetime, lupd_prog, lupd_user, project, rate, total_budget_amount, total_budget_units, user1, 
                                                   user2, user3, user4, tstamp
                            FROM          dbo.PJPTDROL AS PJPTDROL_1
                            WHERE      (acct IN ('ESTIMATE', 'ESTIMATE TAX'))) AS PJPTDROL ON PJPROJ.project = PJPTDROL.project LEFT OUTER JOIN
                          (SELECT     PJACTROL_2.acct, PJACTROL_2.amount_01, PJACTROL_2.amount_02, PJACTROL_2.amount_03, PJACTROL_2.amount_04, 
                                                   PJACTROL_2.amount_05, PJACTROL_2.amount_06, PJACTROL_2.amount_07, PJACTROL_2.amount_08, PJACTROL_2.amount_09, 
                                                   PJACTROL_2.amount_10, PJACTROL_2.amount_11, PJACTROL_2.amount_12, PJACTROL_2.amount_13, PJACTROL_2.amount_14, 
                                                   PJACTROL_2.amount_15, PJACTROL_2.amount_bf, PJACTROL_2.crtd_datetime, PJACTROL_2.crtd_prog, PJACTROL_2.crtd_user, 
                                                   PJACTROL_2.data1, PJACTROL_2.fsyear_num, PJACTROL_2.lupd_datetime, PJACTROL_2.lupd_prog, PJACTROL_2.lupd_user, 
                                                   PJACTROL_2.project, PJACTROL_2.units_01, PJACTROL_2.units_02, PJACTROL_2.units_03, PJACTROL_2.units_04, 
                                                   PJACTROL_2.units_05, PJACTROL_2.units_06, PJACTROL_2.units_07, PJACTROL_2.units_08, PJACTROL_2.units_09, 
                                                   PJACTROL_2.units_10, PJACTROL_2.units_11, PJACTROL_2.units_12, PJACTROL_2.units_13, PJACTROL_2.units_14, 
                                                   PJACTROL_2.units_15, PJACTROL_2.units_bf, PJACTROL_2.tstamp
                            FROM          dbo.PJACTROL AS PJACTROL_2 INNER JOIN
                                                   dbo.PJCONTRL AS PJCONTRL_1 ON PJACTROL_2.acct = PJCONTRL_1.control_data
                            WHERE      (PJCONTRL_1.control_code = 'BTD')) AS PJACTROL ON PJPROJ.project = PJACTROL.project LEFT OUTER JOIN
                      dbo.PJACTROL AS PJACTROL_1 ON PJPROJ.project = PJACTROL_1.project LEFT OUTER JOIN
                      dbo.PJACCT AS PJACCT ON PJACTROL_1.acct = PJACCT.acct AND PJACCT.acct_group_cd IN ('WP', 'WA')
GO
