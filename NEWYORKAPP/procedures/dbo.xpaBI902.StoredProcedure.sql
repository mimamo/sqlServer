USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[xpaBI902]    Script Date: 12/21/2015 16:01:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[xpaBI902](
@RI_ID int
)

AS

BEGIN
DELETE FROM xwrk_BI902
WHERE RI_ID = @RI_ID
END
GO
