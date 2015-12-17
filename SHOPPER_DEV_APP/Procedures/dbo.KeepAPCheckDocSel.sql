USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[KeepAPCheckDocSel]    Script Date: 12/16/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.KeepAPCheckDocSel    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[KeepAPCheckDocSel] @parm1 varchar ( 10), @parm2 varchar ( 10) As
        Select * From APDoc Where
                BatNbr = @parm1 and
                RefNbr = @parm2 and
                Status = 'T' and
                Acct <> '' and
                Sub <> '' and
                DocType Not In ('MC', 'SC')
         Order By BatNbr, RefNbr
GO
