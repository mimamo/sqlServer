USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850SDQ_EdiPoId]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ED850SDQ_EdiPoId]
 @parm1 varchar( 10 )
AS
 SELECT *
 FROM ED850SDQ
 WHERE EdiPoId LIKE @parm1
 ORDER BY EdiPoId
GO
