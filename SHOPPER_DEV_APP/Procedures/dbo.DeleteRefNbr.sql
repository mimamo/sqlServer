USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DeleteRefNbr]    Script Date: 12/16/2015 15:55:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[DeleteRefNbr] @parm1 Varchar(10) as

delete r from refnbr r, ardoc d where r.refnbr = d.refnbr and d.batnbr = @parm1
GO
