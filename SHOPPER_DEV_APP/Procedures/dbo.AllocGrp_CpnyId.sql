USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[AllocGrp_CpnyId]    Script Date: 12/16/2015 15:55:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.AllocGrp_CpnyId    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc [dbo].[AllocGrp_CpnyId] @parm1 varchar ( 10) as
       Select * from AllocGrp
           where CpnyId like @parm1
           order by CpnyId
GO
