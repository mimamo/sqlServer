USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pp08050Payments]    Script Date: 12/16/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create proc [dbo].[pp08050Payments]
   @parm1 varchar (10),
   @parm2 varchar (10),
   @parm3 varchar (2),
   @parm4 varchar (15) as

   Select * from ardoc
   where batnbr = @parm1 and
         refnbr = @parm2 and
         doctype = @parm3 and
         custid like @parm4
   order by batnbr, refnbr
GO
