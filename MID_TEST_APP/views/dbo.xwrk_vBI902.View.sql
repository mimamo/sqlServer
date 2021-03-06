USE [MID_TEST_APP]
GO
/****** Object:  View [dbo].[xwrk_vBI902]    Script Date: 12/21/2015 14:27:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xwrk_vBI902]
AS
SELECT * FROM xwrk_BI902 where (bill_status <> 'B' or Acct = 'prebill') and ri_id = (select max(ri_id) from xwrk_bi902)
UNION 
SELECT 
	ID
	,(Select max(RI_ID) from XWrk_BI902) as RI_ID
	,UserID
	,RunDate
	,RunTime
	,TerminalNum
	,Status_pa
	,Project_billwith
	,Hold_status
	,Acct
	,Source_Trx_Date
	,Amount
	,Project
	,Pjt_Entity
	,Project_Desc
	,Sort_num
	,PM_ID01
	,Code_id
	,Descr
	,End_Date
	,LI_Type
	,Name
	,Draft_Num
	,Acct_Group_cd
	,Bill_Status
FROM xwrk_BI902_2
GO
