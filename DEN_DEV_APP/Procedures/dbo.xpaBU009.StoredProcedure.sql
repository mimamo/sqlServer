USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xpaBU009]    Script Date: 12/21/2015 14:06:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[xpaBU009] (
@RI_ID int
)

AS

BEGIN
DELETE FROM xwrk_BU009
WHERE RI_ID = @RI_ID
END
GO
