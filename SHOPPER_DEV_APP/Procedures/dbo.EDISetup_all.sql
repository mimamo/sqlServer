USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDISetup_all]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDISetup_all]
 @parm1 varchar( 2 )
AS
 SELECT *
 FROM EDISetup
 WHERE SetupID LIKE @parm1
 ORDER BY SetupID
GO
