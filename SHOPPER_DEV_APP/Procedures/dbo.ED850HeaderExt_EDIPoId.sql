USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850HeaderExt_EDIPoId]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ED850HeaderExt_EDIPoId]
 @parm1 varchar( 10 )
AS
 SELECT *
 FROM ED850HeaderExt
 WHERE EDIPoId LIKE @parm1
 ORDER BY EDIPoId
GO
