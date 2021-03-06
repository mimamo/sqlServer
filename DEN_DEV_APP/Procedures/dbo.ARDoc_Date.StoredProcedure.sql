USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_Date]    Script Date: 12/21/2015 14:05:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARDoc_Date    Script Date: 4/7/98 12:49:19 PM ******/
create Proc [dbo].[ARDoc_Date] @parm1 varchar ( 10), @parm2 varchar(10), @parm3 varchar ( 24), @parm4 smalldatetime as
  Select * from ardoc
  Where cpnyid = @parm1 and bankacct =  @parm2 and banksub = @parm3
  and (status = 'O' or status = 'C')
   and DocDate = @parm4
  Order by  refnbr
GO
