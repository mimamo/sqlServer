USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xpaAged]    Script Date: 12/21/2015 13:57:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[xpaAged]
	@RI_ID int

AS

DELETE FROM xwrk_AgedTwo
WHERE RI_ID = @RI_ID
GO
