USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED810Header_all]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ED810Header_all]
 @parm1 varchar( 10 )
AS
 SELECT *
 FROM ED810Header
 WHERE EDIInvId LIKE @parm1
 ORDER BY EDIInvId
GO
