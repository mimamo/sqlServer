USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xpaPA929]    Script Date: 12/21/2015 14:34:42 ******/
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
