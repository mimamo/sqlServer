USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xpaBI903]    Script Date: 12/16/2015 15:55:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[xpaBI903](
@RI_ID int
)

AS

BEGIN
DELETE FROM xwrk_BI903
WHERE RI_ID = @RI_ID
END
GO
