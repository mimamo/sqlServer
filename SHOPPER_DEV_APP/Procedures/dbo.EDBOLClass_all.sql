USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDBOLClass_all]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDBOLClass_all]
 @parm1 varchar( 20 )
AS
 SELECT *
 FROM EDBOLClass
 WHERE BOLClass LIKE @parm1
 ORDER BY BOLClass
GO
