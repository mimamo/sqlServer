USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[DeleteRefNbr]    Script Date: 12/21/2015 13:44:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[DeleteRefNbr] @parm1 Varchar(10) as

delete r from refnbr r, ardoc d where r.refnbr = d.refnbr and d.batnbr = @parm1
GO
