USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[vendor_sall]    Script Date: 12/21/2015 14:06:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[vendor_sall] @parm1 varchar (15)  as
select * from  vendor
where vendid LIKE @parm1
order by vendid
GO
