USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xpaBI904]    Script Date: 12/21/2015 13:57:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[xpaBI904](
@RI_ID int
)

AS

BEGIN
DELETE FROM xwrk_BI904
WHERE RI_ID = @RI_ID
END
GO
