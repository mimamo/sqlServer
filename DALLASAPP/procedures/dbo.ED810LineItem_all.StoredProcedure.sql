USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[ED810LineItem_all]    Script Date: 12/21/2015 13:44:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ED810LineItem_all]
 @parm1 varchar( 10 ),
 @parm2min smallint, @parm2max smallint
AS
 SELECT *
 FROM ED810LineItem
 WHERE EDIInvId LIKE @parm1
    AND LineNbr BETWEEN @parm2min AND @parm2max
 ORDER BY EDIInvId,
    LineNbr
GO
