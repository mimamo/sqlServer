USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xpaPA939]    Script Date: 12/16/2015 15:55:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[xpaPA939] (
@RI_ID int
)

AS

BEGIN
DELETE FROM xwrk_PA939_Main
WHERE RI_ID = @RI_ID
END

BEGIN
DELETE FROM xwrk_PA939_Buckets
WHERE RI_ID = @RI_ID
END
GO
