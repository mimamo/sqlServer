USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[Addl_Cost_PO_pv]    Script Date: 12/21/2015 16:12:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[Addl_Cost_PO_pv] @parm1 varchar (15), @parm2 varchar (15), @parm3 varchar(10), @parm4 varchar(4), @parm5 varchar(10) as
select distinct PONbr, POType, Status
from vp_Addl_Cost_PV
where (vendid = @parm1 or AC_Vendid = @parm2)
and CpnyID = @parm3
and CuryID = @parm4
and PONbr like @parm5
order by ponbr
GO
