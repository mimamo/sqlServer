USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJREPCOL_SPK0]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJREPCOL_SPK0]  @parm1 varchar (10)   as
select * from PJREPCOL
where report_code  =     @parm1
order by report_code,
column_nbr
GO
