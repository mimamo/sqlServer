USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[SlsPrcHdr_PriceCat1]    Script Date: 12/21/2015 15:43:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.SlsPrcHdr_PriceCat1    Script Date: 4/17/98 10:58:19 AM ******/
/****** Object:  Stored Procedure dbo.SlsPrcHdr_PriceCat1    Script Date: 4/16/98 7:41:53 PM ******/
Create Proc [dbo].[SlsPrcHdr_PriceCat1] @parm1 varchar (2), @parm2 varchar (30), @parm3 varchar (30), @parm4 Varchar(4), @parm5 varchar(1) as
     Select * from SlsPrc where PriceCat = @parm1 and SelectFld1 = @parm2 and
	SelectFld2 = @parm3 and CuryID = @parm4 and DiscPrcTyp LIKE @parm5
	order by PriceCat, SelectFld1, SelectFld2, DiscPrcTyp,CuryID
GO
