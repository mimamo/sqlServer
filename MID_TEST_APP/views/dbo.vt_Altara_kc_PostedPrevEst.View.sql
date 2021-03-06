USE [MID_TEST_APP]
GO
/****** Object:  View [dbo].[vt_Altara_kc_PostedPrevEst]    Script Date: 12/21/2015 14:27:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vt_Altara_kc_PostedPrevEst]
AS

	Select PJREVHDR.PROJECT, PJREVHDR.revid, PJREVCAT.PJT_ENTITY, sum(PJREVCAT.Amount) Amount,Sum(PJREVCAT.Units) Units 
	from PJREVCAT,PJREVHDR  where
	--PJREVHDR.PROJECT  = Project past in
	--PJREVHDR.revid  = task past in
	PJREVCAT.PROJECT = PJREVHDR.PROJECT 
	and PJREVCAT.REVID = PJREVHDR.rh_id05 
	group by PJREVHDR.PROJECT, PJREVHDR.revid, PJREVCAT.PJT_ENTITY
--paramter passed in will be 
--PJREVHDR.PROJECT = Project entered by the user
--PJREVHDR.REVID  =  Revision ID entered by the user
GO
