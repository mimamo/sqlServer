USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[LotSerMst_All_Active]    Script Date: 12/21/2015 13:35:46 ******/
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
