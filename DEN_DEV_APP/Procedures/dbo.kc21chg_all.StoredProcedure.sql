USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[kc21chg_all]    Script Date: 12/21/2015 14:06:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[kc21chg_all] @parm1  varchar (8) as
select * from kc21chg where 
keyid = @parm1 
order by keyid, gridorder
GO
