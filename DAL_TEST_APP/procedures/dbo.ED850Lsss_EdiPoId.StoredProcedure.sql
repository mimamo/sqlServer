USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850Lsss_EdiPoId]    Script Date: 12/21/2015 13:56:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ED850Lsss_EdiPoId]
 @parm1 varchar( 10 )
AS
 SELECT *
 FROM ED850Lsss
 WHERE EdiPoId LIKE @parm1
 ORDER BY EdiPoId
GO
