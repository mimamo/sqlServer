USE [SHOPPERAPP]
GO
/****** Object:  View [dbo].[vt_Altara_kc_UNPostedPrevEst]    Script Date: 12/21/2015 16:12:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vt_Altara_kc_UNPostedPrevEst]
AS
	Select PJPROJEX.PROJECT,  PJREVCAT.REVID, PJREVCAT.PJT_ENTITY,sum(PJREVCAT.Amount) Amount,Sum(PJREVCAT.Units) Units 
	from PJREVCAT,PJPROJEX  where
	--PJPROJEX.PROJECT = Project entered by the user 
	PJREVCAT.PROJECT = PJPROJEX.PROJECT
	and PJREVCAT.REVID = PJPROJEX.pm_id25 --Only posted items will have a value in pm_id25
	group by PJPROJEX.PROJECT, PJREVCAT.REVID, PJREVCAT.PJT_ENTITY
	--Paramters past in PJPROJEX.PROJECT = Project entered by the user and Revision ID type in by user has no barring
GO
