USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xpaPA929]    Script Date: 12/16/2015 15:55:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[xpaPA929] (
@RI_ID int
)

AS

DELETE FROM xwrk_PA929
WHERE RI_ID = @RI_ID
GO
