USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xpb01896]    Script Date: 12/21/2015 13:57:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[xpb01896](
@RI_ID int
)

AS

DELETE FROM xwrk_BI902
WHERE RI_ID = @RI_ID

DELETE FROM xwrk_WIPRecon
WHERE RI_ID = @RI_ID

BEGIN
EXEC xpbBI902 @RI_ID 
END

BEGIN
EXEC xpbWIP @RI_ID
END
GO
