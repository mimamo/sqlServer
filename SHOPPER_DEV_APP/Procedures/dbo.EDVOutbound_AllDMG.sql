USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDVOutbound_AllDMG]    Script Date: 12/16/2015 15:55:22 ******/
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
