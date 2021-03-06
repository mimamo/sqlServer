USE [DENVERAPP]
GO
/****** Object:  View [dbo].[vt_Altara_kc_Actual]    Script Date: 12/21/2015 15:42:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vt_Altara_kc_Actual]
AS 
select pjptdsum.Project,pjptdsum.pjt_entity,sum(act_amount)Amt_Actual,  Sum(act_Units) Units_Actual from pjptdsum,pjacct
where  pjptdsum.acct = pjacct.acct
	and (acct_group_cd = 'WP' or acct_group_cd = 'WA')
GROUP BY Project,pjt_entity
GO
