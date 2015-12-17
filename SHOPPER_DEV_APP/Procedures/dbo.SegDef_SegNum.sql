USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SegDef_SegNum]    Script Date: 12/16/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.SegDef_SegNum    Script Date: 4/7/98 12:38:59 PM ******/
CREATE PROCEDURE [dbo].[SegDef_SegNum]
@Parm1 Varchar ( 15), @Parm2 Varchar ( 2), @Parm3 Varchar ( 24) AS
SELECT * FROM SegDef WHERE FieldClassName = @Parm1 And SegNumber = @Parm2 And ID Like @Parm3 ORDER BY FieldClassName, SegNumber, ID
GO
