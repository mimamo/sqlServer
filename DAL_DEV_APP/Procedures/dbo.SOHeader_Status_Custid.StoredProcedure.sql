USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SOHeader_Status_Custid]    Script Date: 12/21/2015 13:35:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create proc [dbo].[SOHeader_Status_Custid] @parm1 varchar ( 15), @parm2 varchar ( 10), @parm3 varchar ( 15) as
          Select * from SOHeader where custid = @parm1
          and CpnyId = @parm2
          and ordnbr like @parm3
          and Status = "O"
          order by Ordnbr
GO
