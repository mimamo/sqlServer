USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[APAdjustd_Delete]    Script Date: 12/21/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APAdjustd_Delete    Script Date: 4/7/98 12:19:54 PM ******/
Create Procedure [dbo].[APAdjustd_Delete] @parm1 varchar ( 255), @parm2 varchar ( 255) as
Delete from APAdjust where APAdjust.AdjdRefNbr = @parm1 and
APAdjust.AdjdDocType = @parm2
GO
