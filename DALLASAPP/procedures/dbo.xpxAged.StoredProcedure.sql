USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[xpxAged]    Script Date: 12/21/2015 13:45:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[xpxAged]
	@RI_ID int

AS

DELETE FROM xwrk_AgedTwox
WHERE RI_ID = @RI_ID
GO
