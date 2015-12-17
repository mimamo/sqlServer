USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PI_LotSerNbr_Tag]    Script Date: 12/16/2015 15:55:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PI_LotSerNbr_Tag    Script Date: 4/17/98 10:58:19 AM ******/
Create Proc [dbo].[PI_LotSerNbr_Tag] @Parm1 varchar(10), @Parm2 varchar(10), @Parm3 varchar(30) as
   Select * from lotsermst where siteid = @parm1
	and whseloc = @parm2 and invtid = @parm3
	order by lotsernbr
GO
