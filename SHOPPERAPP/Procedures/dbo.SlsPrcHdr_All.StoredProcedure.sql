USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[SlsPrcHdr_All]    Script Date: 12/21/2015 16:13:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.SlsPrcHdr_All    Script Date: 4/17/98 10:58:19 AM ******/
/****** Object:  Stored Procedure dbo.SlsPrcHdr_All    Script Date: 4/16/98 7:41:53 PM ******/
Create Proc [dbo].[SlsPrcHdr_All] @parm1 varchar ( 2), @parm2 varchar ( 1) as
		Select * from SlsPrc where PriceCat = @parm1 and DiscPrcTyp Like @parm2
			Order by PriceCat, DiscPrcTyp, SelectFld1, SelectFld2, DiscPrcMthd
GO
