USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850LDesc_EdiPoId]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ED850LDesc_EdiPoId]
 @parm1 varchar( 10 )
AS
 SELECT *
 FROM ED850LDesc
 WHERE EdiPoId LIKE @parm1
 ORDER BY EdiPoId
GO
