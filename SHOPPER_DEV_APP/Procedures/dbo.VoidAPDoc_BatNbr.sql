USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[VoidAPDoc_BatNbr]    Script Date: 12/16/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.VoidAPDoc_BatNbr    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[VoidAPDoc_BatNbr] @parm1 varchar ( 10) As
Update APDoc Set Status = 'V' Where
BatNbr = @parm1 and Status <> 'V'
GO
