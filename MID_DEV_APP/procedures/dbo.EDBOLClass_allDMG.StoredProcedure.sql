USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDBOLClass_allDMG]    Script Date: 12/21/2015 14:17:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.EDBOLClass_all    Script Date: 5/28/99 1:17:39 PM ******/
CREATE PROCEDURE [dbo].[EDBOLClass_allDMG]
 @parm1 varchar(20)
AS
 SELECT *
 FROM EDBOLClass
 WHERE BOLClass LIKE @parm1
 ORDER BY BOLClass
GO
