USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Venditem_Invt_Vend_Fscyr]    Script Date: 12/21/2015 13:35:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Venditem_Invt_Vend_Fscyr                                 ******/
Create proc [dbo].[Venditem_Invt_Vend_Fscyr] @parm1 varchar(30), @parm2 varchar(4), @parm3 varchar(15) as
	select * from VendItem where
		InvtID = @parm1 and
		Fiscyr = @parm2 and
		VendID like @parm3
	order by InvtID,VendID,FiscYr
GO
