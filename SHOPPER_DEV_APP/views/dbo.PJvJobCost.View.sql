USE [SHOPPER_DEV_APP]
GO
/****** Object:  View [dbo].[PJvJobCost]    Script Date: 12/21/2015 14:33:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[PJvJobCost]
AS
SELECT     dbo.PJACTSUM.acct, dbo.PJACTSUM.amount_01, dbo.PJACTSUM.amount_02, dbo.PJACTSUM.amount_03, dbo.PJACTSUM.amount_04, 
                      dbo.PJACTSUM.amount_05, dbo.PJACTSUM.amount_06, dbo.PJACTSUM.amount_07, dbo.PJACTSUM.amount_08, dbo.PJACTSUM.amount_10, 
                      dbo.PJACTSUM.amount_09, dbo.PJACTSUM.amount_11, dbo.PJACTSUM.amount_12, dbo.PJACTSUM.amount_bf, dbo.PJACTSUM.fsyear_num, 
                      dbo.PJACTSUM.pjt_entity, dbo.PJACTSUM.project, dbo.PJREPCOL.column_nbr, dbo.PJREPCOL.report_code, dbo.PJREPCOL.desc1, 
                      dbo.PJPROJ.status_pa, dbo.PJPROJ.contract_type, dbo.PJPROJ.gl_subacct
FROM         dbo.PJACTSUM INNER JOIN
                      dbo.PJREPCOL ON dbo.PJACTSUM.acct = dbo.PJREPCOL.acct LEFT OUTER JOIN
                      dbo.PJPROJ ON dbo.PJACTSUM.project = dbo.PJPROJ.project
GO
