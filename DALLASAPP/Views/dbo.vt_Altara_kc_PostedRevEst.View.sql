USE [DALLASAPP]
GO
/****** Object:  View [dbo].[vt_Altara_kc_PostedRevEst]    Script Date: 12/21/2015 13:44:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vt_Altara_kc_PostedRevEst]
AS

	Select PJREVHDR.PROJECT, PJREVHDR.revid, PJREVCAT.PJT_ENTITY, sum(PJREVCAT.Amount) Amount,Sum(PJREVCAT.Units) Units from PJREVCAT,PJREVHDR 
	where 
	PJREVCAT.PROJECT = PJREVHDR.PROJECT and
	PJREVCAT.REVID = PJREVHDR.revid 
	group by PJREVHDR.PROJECT, PJREVHDR.revid, PJREVCAT.PJT_ENTITY
GO
