USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SelectAPTempCheck]    Script Date: 12/21/2015 13:35:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.SelectAPTempCheck    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[SelectAPTempCheck] @parm1 varchar ( 10), @parm2 varchar ( 10) As
        Select * From APDoc Where
                BatNbr = @parm1 and
                RefNbr = @parm2 and
		    DocType = "VC"
GO
