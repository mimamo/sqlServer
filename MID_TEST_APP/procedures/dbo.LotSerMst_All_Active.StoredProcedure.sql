USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[LotSerMst_All_Active]    Script Date: 12/21/2015 15:49:24 ******/
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
