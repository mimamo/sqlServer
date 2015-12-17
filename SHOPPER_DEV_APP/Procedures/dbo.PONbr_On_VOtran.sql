USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PONbr_On_VOtran]    Script Date: 12/16/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PONbr_On_VOtran    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[PONbr_On_VOtran]    @parm1 varchar(10), @parm3 varchar(10) As
select batnbr, refnbr from APtran Where PONbr = @parm1 and RefNBr <> @parm3
and rlsed = 0  and trantype in ('AD', 'VO')
GO
