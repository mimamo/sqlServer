USE [DEN_TEST_APP]
GO
/****** Object:  View [dbo].[vt_Altara_kc_Billed]    Script Date: 12/21/2015 14:10:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vt_Altara_kc_Billed]
AS 

Select Project,pjt_entity,sum(act_amount) Amt_Billed, Sum(act_Units) Units_Billed from pjptdsum WHERE
acct = 'BILLED TO DATE'
GROUP BY Project,pjt_entity
GO
