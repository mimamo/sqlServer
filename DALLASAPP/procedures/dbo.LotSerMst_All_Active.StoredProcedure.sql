USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[LotSerMst_All_Active]    Script Date: 12/21/2015 13:44:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[LotSerMst_All_Active]
AS
	Select *
	from LotSerMst
	where status = 'A'
GO
