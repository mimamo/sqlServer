USE [DEN_TEST_APP]
GO
/****** Object:  View [dbo].[vp_ActiveAcctSub]    Script Date: 12/21/2015 14:10:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[vp_ActiveAcctSub]
As
	SELECT	* 
	FROM	vs_AcctSub
	Where	Active = 1
GO
