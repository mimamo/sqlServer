USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850Contact_EdiPoId]    Script Date: 12/21/2015 15:36:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ED850Contact_EdiPoId]
 @parm1 varchar( 10 )
AS
 SELECT *
 FROM ED850Contact
 WHERE EdiPoId LIKE @parm1
 ORDER BY EdiPoId
GO
