USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PIDetCost_Delete_CX]    Script Date: 12/21/2015 15:37:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PIDetCost_Delete_CX    Script Date: 10/13/2000 ******/
Create Procedure [dbo].[PIDetCost_Delete_CX]
	@PerClosed VarChar(6)
As
    Delete From PIDetCost
	From	PIHeader
	Where	PIHeader.PIID = PIDetCost.PIID
		And PIHeader.Status In ('C', 'X')
		And PIHeader.PerClosed <= @PerClosed
GO
