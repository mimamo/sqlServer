USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PI_LotSer_Duplicate]    Script Date: 12/21/2015 13:35:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PI_LotSer_Duplicate    Script Date: 4/17/98 10:58:19 AM ******/
Create Proc [dbo].[PI_LotSer_Duplicate] @parm1 varchar(30), @Parm2 varchar(25), @parm3 varchar(10), @parm4 varchar(10) as
select * from lotsermst
where invtid = @parm1
  And lotsernbr = @parm2
  And siteid = @parm3
  And Whseloc = @parm4
GO
