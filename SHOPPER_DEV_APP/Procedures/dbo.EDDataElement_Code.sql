USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDDataElement_Code]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDDataElement_Code]
 @parm1 varchar( 15 )
AS
 SELECT *
 FROM EDDataElement
 WHERE Code LIKE @parm1
 ORDER BY Code
GO
