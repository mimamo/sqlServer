USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDVOutbound_AllDMG]    Script Date: 12/21/2015 16:07:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.EDVOutbound_All    Script Date: 5/28/99 1:17:46 PM ******/
CREATE PROCEDURE [dbo].[EDVOutbound_AllDMG]
 @parm1 varchar( 15 ),
 @parm2 varchar( 3 )
AS
 SELECT *
 FROM EDVOutbound
 WHERE VendId LIKE @parm1
    AND Trans LIKE @parm2
 ORDER BY VendId, Trans
GO
