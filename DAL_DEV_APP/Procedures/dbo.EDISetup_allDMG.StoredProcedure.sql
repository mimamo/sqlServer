USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDISetup_allDMG]    Script Date: 12/21/2015 13:35:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.EDISetup_all    Script Date: 5/28/99 1:17:42 PM ******/
CREATE PROCEDURE [dbo].[EDISetup_allDMG]
 @parm1 varchar( 2 )
AS
 SELECT *
 FROM EDISetup
 WHERE SetupID LIKE @parm1
 ORDER BY SetupID
GO
