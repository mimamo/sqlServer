USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CARecur_all]    Script Date: 12/16/2015 15:55:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.CARecur_all    Script Date: 4/7/98 12:49:20 PM ******/
Create Proc [dbo].[CARecur_all] @parm1 varchar ( 10), @parm2 varchar ( 10) as
    select * from CARecur
     where CpnyID like @parm1
     and RecurId like @parm2
    order by RecurId
GO
