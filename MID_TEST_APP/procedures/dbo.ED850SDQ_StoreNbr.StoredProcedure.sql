USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850SDQ_StoreNbr]    Script Date: 12/21/2015 15:49:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ED850SDQ_StoreNbr]
 @parm1 varchar( 17 )
AS
 SELECT *
 FROM ED850SDQ
 WHERE StoreNbr LIKE @parm1
 ORDER BY StoreNbr
GO
